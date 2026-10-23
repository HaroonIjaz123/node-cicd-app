#!/bin/sh
set -e
node --version
npm ci
npm test
npm run build
npm run deploy -- freestyle
