#!/bin/sh

# todo
  # add dependencies/scripts/config to package.json
  # insert sample data
  # inject code for js and tests
  # add .gitignore, webmanifest, index.html


# insert config files (babel, webpack, deploy)
echo -e "module.exports = require('nyc-build-helper').config.defaultWebpackConfig(__dirname)" >> webpack.config.js
echo -e "module.exports = {
  presets: [
    [
      '@babel/preset-env',
      {
        targets: {
          node: 'current'
        }
      }
    ]
  ]
}" >> babel.config.js

echo -e "require('nyc-build-helper').deploy(__dirname)" >> deploy.js

# create dir structure
    # __tests__
        # - app.test.js
        # - decorations.test.js
        # - facility-style.test.js
        # - jest-setup.js
    # src
        # css
            # - appname.css
            # - appname.theme.css
        # data
            # location.csv / location.geojson
        # img
        # js
            # - app.js
            # - decorations.js
            # - facility-style.js
            # - index.js

# src structure
mkdir -p {src,__tests__}
mkdir -p src/{css,data,js,img}
touch src/index.html
touch src/manifest.webmanifest

# create css files based off package.json app name
APP_NAME=$(cat package.json | grep -i name | awk '{ print $2 }' | sed -e 's/,$//' -e 's/^"//' -e 's/"$//')
touch src/css/$APP_NAME.css
touch src/css/$APP_NAME.theme.css

#__tests__ structure
echo -e "require('jest-canvas-mock')
global.fetch = require('jest-fetch-mock')" >> __tests__/jest-setup.js
touch __tests__/{app,decorations,facility-style}.test.js

# js structure
touch src/js/{app,decorations,facility-style}.js
