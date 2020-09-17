# macIconForFile [![npm version](https://badge.fury.io/js/mac-file-icon.svg)](https://npmjs.org/package/mac-file-icon)

Get the native macOS icon for a specific file extension as a PNG image buffer.

Inspired and based on:

- https://github.com/angrycoding/macIconForFile

Retrieves icon, exactly the same way as Finder does it, including QuickLook preview generation in case if it's possible. This is a ultra-stripped re-implementation of the above repo replacing deprecated code

### Installation

```bash
npm install mac-file-icon
```

### Usage

```javascript
var getIconForFile = require("osx-fileicon");
getIconForFile("/Users/", function (buffer) {
  console.info(buffer);
});
```

You can always convert Buffer into its base64 representation:

```javascript
var getIconForFile = require("mac-file-icon");
getIconForFile("/Users/", function (buffer) {
  console.info(buffer.toString("base64"));
});
```

By default, icon size is set to 500x500 for previewing.
