# gbf-wiki-opengraph
[![Synchronize](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/scheduled.yaml/badge.svg)](https://github.com/FabulousCupcake/gbf-wiki-opengraph/actions/workflows/scheduled.yaml)

This repository enables gbf.wiki to use fancy opengraph images on weapon, character (tba), and summon (tba) pages.

## Technical Details
The image is generated using Puppeteer, so HTML/CSS can be used to put things into the image with ease.

The HTML/CSS bits are split in two parts:
- The HTML is generated with Mediawiki, hidden in each page _(see links section below for the template)_
  - This allows the use of information available in Mediawiki without having to mess with Mediawiki API or Cargo API
  - This also avoids the need to resolve image URLs, allows use of the existing templates, etc.
- The stylesheet is included in this repository

The generated images are uploaded to a Cloudflare R2 Public Bucket, exposed at `https://cdn.gbf.wiki`. Example [here][example].

## Automation
To prevent the images from being outdated when the pages are modified or new pages are added, a system is required
to automatically detect these changes and update the images.

This is mostly done within this repository with GitHub Actions. The workflow can be found [here][workflow].

It runs daily and pulls the last modification dates from Cargo to generate the list of changed pages.
It then runs Puppeteer to generate the new image, uploads it to R2, and updates the known modification date in the repo.

## Links
https://gbf.wiki/Template:Weapon  
https://gbf.wiki/Template:Weapon/OpengraphImage  
https://gbf.wiki/User:FabulousCupcake/common.css  

[example]: https://cdn.gbf.wiki/Lord_of_Flames.webp
[workflow]: https://github.com/FabulousCupcake/gbf-wiki-opengraph/blob/master/.github/workflows/scheduled.yaml
