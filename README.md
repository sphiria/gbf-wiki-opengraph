# gbf-wiki-opengraph
[![Synchronize](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/weapons.yaml/badge.svg)](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/weapons.yaml)
[![Synchronize](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/summons.yaml/badge.svg)](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/summons.yaml)

This repository enables gbf.wiki to use fancy opengraph images on weapon, character (tba), and summon pages.  
The images are tailored/optimised for embeds in Discord, hence 700x350 size.

<img width="830" alt="gbf-wiki-opengraph-preview" src="https://user-images.githubusercontent.com/25855364/194773170-4553dc17-aab4-40f4-b000-3c8307b4f856.png">


## Local Usage
```sh
# Install deps
npm ci

# Generate image
echo Lord of Flames | ./index.js

# Open image
open dist/Lord_of_Flames.webp
```

## Technical Details
The image is generated using Puppeteer, so HTML/CSS can be used to put things into the image with ease.

The contents of the image are mostly generated with Mediawiki, using the Template Sandbox feature to
hotswap the main templates to a different one that generates the 700x350 opengraph image box.

The generated images are uploaded to a Cloudflare R2 Public Bucket, exposed at `https://cdn.gbf.wiki`. Example [here][example].

## Automation
To prevent the images from being outdated when the pages are modified or new pages are added, a system is required
to automatically detect these changes and update the images.

This is mostly done within this repository with GitHub Actions. The workflow can be found [here][workflow].

It runs daily and pulls the last modification dates from Cargo to generate the list of changed pages.
It then runs Puppeteer to generate the new image, uploads it to R2, and updates the known modification date in the repo.

## Links
https://gbf.wiki/User:FabulousCupcake/og/Template:Weapon
https://gbf.wiki/User:FabulousCupcake/og/Template:Summon

[example]: https://cdn.gbf.wiki/Lord_of_Flames.webp
[workflow]: https://github.com/FabulousCupcake/gbf-wiki-opengraph/blob/master/.github/workflows/scheduled.yaml
