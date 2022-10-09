#!/usr/bin/env node

const fs = require("fs");
const puppeteer = require('puppeteer');

// Suppress Fetch API Experimental Warning
// https://github.com/nodejs/node/issues/30810#issuecomment-1138834088
const suppressExperimentalWarning = () => {
  const originalEmit = process.emit;

  process.emit = function (name, data, ...args) {
    if (
      name === 'warning' &&
      typeof data === 'object' &&
      data.name === 'ExperimentalWarning'
    )
      return false

    return originalEmit.apply(process, arguments)
  }
}

// render takes Puppeteer page object and the name of the page to be rendered as image
// And somehow generates an image out of those
const render = async (page, pageName) => {
  const url = `https://gbf.wiki/${pageName}`;
  await page.goto(url);
  await page.addStyleTag({ path: 'style.css' });

  // Wait and ensure it is rendered
  await page.waitForSelector('.opengraph-image', { timeout: 5000 });
  const element = await page.$('.opengraph-image');

  // Wait until images are loaded / network is idle and screenshot
  await page.waitForNetworkIdle();
  await element.screenshot({
    path: `dist/${pageName}.webp`,
    omitBackground: true,
    type: "webp",
    quality: 95,
  });
};

// main does a  bit of args processing and initializations
const main = async () => {
  // We expect stdin to contain the list of page names split by linebreak
  const stdin = fs.readFileSync(0).toString();
  const pages = stdin
    .split("\n")
    .filter(x => x)
    .map(x => x.replaceAll("&amp;", "&"))
    .map(x => x.replaceAll(" ", "_"));

  // Initialize Puppeteer
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Process
  for await (const [index, pageName] of pages.entries()) {
    // Pretty-print progress/status
    const count = (index+1).toString().padStart(pages.length.toString().length, "0");
    const pageNamePadded = pageName.padEnd(48);
    process.stdout.write(`[${count}/${pages.length}]: ${pageNamePadded}... `);

    try {
      const timeStart = performance.now();
      await render(page, pageName);
      const timeEnd = performance.now();
      const duration = (timeEnd - timeStart).toFixed(3);
      process.stdout.write(`${duration}ms `);
    } catch (err) {
      console.log("❌");
      console.error(err);
      throw(err);
    }

    console.log("✅");
  }

  // Exit
  await browser.close();
}

suppressExperimentalWarning();
main();
