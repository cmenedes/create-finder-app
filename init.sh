#!/bin/sh

# todo
  # add dependencies/scripts/config to package.json
  # insert sample data
  # inject code for js and tests
  # add .gitignore, webmanifest, index.html


# insert config files (babel, webpack, deploy)
echo -e "module.exports = require('nyc-build-helper').config.defaultWebpackConfig(__dirname)" > webpack.config.js
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
}" > babel.config.js

echo -e "require('nyc-build-helper').deploy(__dirname)" > deploy.js

# create dir structure
    # __tests__
        # - app.test.js
        # - decorations.test.js
        # - facility-style.test.js
        # - jest-setup.js
        # - jquery.mock.js
    # src
        # css
            # - appname.css
            # - appname.theme.css
        # data
            # location.csv / location.geojson
        # img
        # js
            # - App.js
            # - decorations.js
            # - facility-style.js
            # - index.js
    # babel.config.js
    # deploy.js
    # webpack.config.js

# src structure
mkdir -p {src,__tests__}
mkdir -p src/{css,data,js,img}
touch src/index.html
touch src/manifest.webmanifest

# create css files based off package.json app name
APP_NAME=$(cat package.json | grep -i name | awk '{ print $2 }' | sed -e 's/,$//' -e 's/^"//' -e 's/"$//')
touch src/css/$APP_NAME.css
touch src/css/$APP_NAME.theme.css

# __tests__ structure

# jest setup
echo -e "require('jest-canvas-mock')
global.fetch = require('jest-fetch-mock')
global.$ = require('./jquery.mock').default" > __tests__/jest-setup.js

# jquery mock setup
echo -e 'import $ from '"'"'jquery'"'"'

$.originalFunctions = {
  width: $.fn.width,
  height: $.fn.height,
  proxy: $.proxy,
  ajax: $.ajax,
  getScript: $.getScript
}

$.resetMocks = () => {
  $.fn.slideUp = jest.fn().mockImplementation((arg0, arg1) => {
    const instances = $.mocks.slideUp.mock.instances
    instances[instances.length - 1].hide()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.slideDown = jest.fn().mockImplementation((arg0, arg1) => {
    const instances = $.mocks.slideDown.mock.instances
    instances[instances.length - 1].show()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.slideToggle = jest.fn().mockImplementation((arg0, arg1)  => {
    const instances = $.mocks.slideToggle.mock.instances
    const hidden = instances[instances.length - 1].css('"'"'display'"'"') === '"'"'none'"'"'
    instances[instances.length - 1][hidden ? '"'"'show'"'"' : '"'"'hide'"'"']()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.fadeIn = jest.fn().mockImplementation((arg0, arg1)  => {
    const instances = $.mocks.fadeIn.mock.instances
    instances[instances.length - 1].show()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.fadeOut = jest.fn().mockImplementation((arg0, arg1)  => {
    const instances = $.mocks.fadeOut.mock.instances
    instances[instances.length - 1].hide()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.fadeToggle = jest.fn().mockImplementation((arg0, arg1)  => {
    const instances = $.mocks.fadeToggle.mock.instances
    const hidden = instances[instances.length - 1].css('"'"'display'"'"') === '"'"'none'"'"'
    instances[instances.length - 1][hidden ? '"'"'show'"'"' : '"'"'hide'"'"']()
    if (typeof arg0 === '"'"'function'"'"') arg0()
    else if (typeof arg1 === '"'"'function'"'"') arg1()
  })

  $.fn.resize = jest.fn()

  $.fn.width = jest.fn().mockImplementation(width => {
    const instances = $.mocks.width.mock.instances
    const instance = instances[instances.length - 1]
    if (typeof width === '"'"'number'"'"') {
      instance.data('"'"'width'"'"', width)
      return instance
    } else {
      width = instance.data('"'"'width'"'"')
      return typeof width === '"'"'number'"'"' ? width : $.originalFunctions.width.call(instance)
    }
  })

  $.fn.height = jest.fn().mockImplementation(height => {
    const instances = $.mocks.height.mock.instances
    const instance = instances[instances.length - 1]
    if (typeof height === '"'"'number'"'"') {
      instance.data('"'"'height'"'"', height)
      return instance
    } else {
      height = instance.data('"'"'height'"'"')
      return typeof height === '"'"'number'"'"' ? height : $.originalFunctions.height.call(instance)
    }
  })

  $.fn.select = jest.fn()
  
  $.proxy = jest.fn()
  $.proxy.returnedValues = []
  $.proxy.mockImplementation((fn, scope) => {
    const result = $.originalFunctions.proxy(fn, scope)
    $.proxy.returnedValues.push(result)
    return result
  })

  $.ajax = jest.fn()
  $.ajax.testData = {error: false, response: {}}
  $.ajax.mockImplementation(args => {
    if (!$.ajax.testData.error) {
      args.success($.ajax.testData.response)
    } else {
      args.error($.ajax.testData.error)
    }
  })

  $.getScript = jest.fn()
  $.getScript.result = {text: '"'"''"'"', Ops_status: 200, xhr: {}}
  $.getScript.mockImplementation((url, success) => {
    const idx = url.indexOf('"'"'callback'"'"')
    if (idx > -1) {
      let cb = url.substr(idx).split('"'"'='"'"')[1]
      cb = cb.split('"'"'&'"'"')[0]
      eval(`${cb}()`)
    }
    if (success) success($.getScript.result.text, $.getScript.result.Ops_status, $.getScript.result.xhr)
  })

  $.mocks = {
    slideDown: $.fn.slideDown,
    slideUp: $.fn.slideUp,
    slideToggle: $.fn.slideToggle,
    fadeIn: $.fn.fadeIn,
    fadeOut: $.fn.fadeOut,
    fadeToggle: $.fn.fadeToggle,
    resize: $.fn.resize,
    width: $.fn.width,
    height: $.fn.height,
    select: $.fn.select,
    proxy: $.proxy,
    ajax: $.ajax,
    getScript: $.getScript
  }
}

export default $
' > __tests__/jquery.mock.js

# create test files
touch __tests__/{index,App,decorations,facility-style}.test.js

# js structure
touch src/js/{index,App,decorations,facility-style}.js

# index.js
echo -e "import App from './App'

new App()
" > src/js/index.js

# App.js
echo -e "/**
 * @module $APP_NAME/App
 */

import $ from 'jquery'
import FinderApp from 'nyc-lib/nyc/ol/FinderApp'
import decorations from './decorations'
import CsvPoint from 'nyc-lib/nyc/ol/format/CsvPoint'
import facilityStyle from './facility-style'

class App extends FinderApp {
	/**
	 * @desc Create an instance of App
	 * @public
	 * @constructor
	 */
	constructor() {
    super({
			title: 'Finder App Title',
      splashOptions: {
        message: 'splash message',
			  buttonText: ['Screen reader instructions', 'View map']
      },
			facilityTabTitle: 'Locations', //title for facilities list (optional)
      facilityUrl: 'locations.csv', //can be from a local file or a hosted url (ex: ArcGIS Online/OpenData)
      facilityFormat: new CsvPoint({
				x: 'x',
				y: 'y',
				dataProjection: 'EPSG:2263'
			}), // depends on the data you have
			facilityStyle: facilityStyle.style, //custom style function for facility (optional)
			facilitySearch: { displayField: 'search_label', nameField: 'search_name' }, //these are values set in the decorations based on fields in data
      filterTabTitle: 'Filters', // title for filters (optional)
      filterChoiceOptions: [{
				title: 'Filter Title',
				choices: [
					{name: 'choice-name', values: ['choice-value'], label: 'choice-label', checked: true},
					{name: 'choice-name', values: ['choice-value'], label: 'choice-label', checked: true},
					{name: 'choice-name', values: ['choice-value'], label: 'choice-label', checked: true}
          ]
        }],
			geoclientUrl: GEOCLIENT_URL, //insert nyc-lib example url here, will be replaced by value in your .env
			directionsUrl: DIRECTIONS_URL, //insert nyc-lib example url here, will be replaced by value in your .env
      defaultDirectionsMode: 'Walking', //The mode for Google directions
      mouseWheelZoom: true, //allow mouse wheel map zooming
      highlightStyle: facilityStyle.highLightStyle, //custom highlight function for facility (optional)
    })
  }
}

export default App
" > src/js/App.js

# decorations.js
echo -e '/**
 * @module '"$APP_NAME"'/decorations
 */

const decorations = {
  extendFeature() {
    this.set(
      '"'"'search_label'"'"',
      `<b><span class="srch-lbl-lg">${this.getName()}</span></b><br><span class="srch-lbl-sm">${this.getAddress1()}</span>`
    )
  },
  getName() {
    // REQURIED -- return field in data that represents name of the facility. ex: return this.get('site_name')
  },
  getAddress1() {
    // REQURIED -- return field in data that represents address line 1. ex: return this.get('address_1')
  },
  getCityStateZip() {
    //REQURIED -- return concatenated string of city/borough, state, and zip. ex: return this.getCity() + ', NY ' + this.get('zip')
  }
}

export default decorations
' > src/js/decorations.js