fs = require("fs");
var extension =
  process.platform === "darwin" &&
  require("./build/Release/getIconForFile.node");

module.exports = async function (path, ret) {
  var syncResult;

  if (typeof ret !== "function") {
    size = ret;
    console.error("second argument must be a function");
    return false;
  }

  if (extension) {
    if (typeof path !== "string") path = String(path);

    extension(path, ret);

    return true;
  } else if (!syncResult) ret();
};
