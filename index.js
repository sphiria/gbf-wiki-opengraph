#!/usr/bin/env node

const fs = require("fs");
const puppeteer = require('puppeteer');

const render = async (page, pageName) => {
  const url = `https://gbf.wiki/${pageName}`;
  await page.goto(url);
  await page.addStyleTag({ path: 'style.css' });

  await page.waitForSelector('.opengraph-image', { timeout: 2000 });
  const element = await page.$('.opengraph-image');

  await page.waitForNetworkIdle();
  await element.screenshot({
    path: `dist/${pageName}.webp`,
    omitBackground: true,
    type: "webp",
  });
};

const main = async () => {
  // We expect stdin to contain the list of page names split by linebreak
  const stdin = fs.readFileSync(0).toString();
  const pages = stdin
    .split("\n")
    .filter(x => x)
    .map(x => x.replace("&amp;", "&"))
    .map(x => x.replace(" ", "_"));

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
      continue;
    }

    console.log("✅");
  }

  // Exit
  await browser.close();
}

main();