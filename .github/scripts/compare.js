#!/usr/bin/env node

// Usage:
// ./compare.js <old.json> <new.json>

// This script returns the list of keys / names of items with newer timestamp.
// This script expects two JSON objects with the following schema:
// [
//   { "name": unix-timestamp },
//   ...
// ]

const JSON_OLD = require(`${process.cwd()}/${process.argv[2]}`);
const JSON_NEW = require(`${process.cwd()}/${process.argv[3]}`);

for(const key in JSON_NEW) {
  const TS_NEW = JSON_NEW[key];
  const TS_OLD = JSON_OLD[key] || 0;

  if (TS_NEW > TS_OLD) {
    console.log(key);
  }
}