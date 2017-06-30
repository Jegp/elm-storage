/**
 * Native JavaScript code for JavaScript cookie or session storage.
 * @author Jens Egholm <jensegholm@protonmail.com>
 */

// Define cookie object
// Thanks to: https://developer.mozilla.org/en-US/docs/Web/API/Storage/LocalStorage

var cookieStorage = new (function () {
  var aKeys = [], oStorage = {};
  Object.defineProperty(oStorage, "getItem", {
    value: function (sKey) { return sKey ? this[sKey] : null; },
    writable: false,
    configurable: false,
    enumerable: false
  });
  Object.defineProperty(oStorage, "key", {
    value: function (nKeyId) { return aKeys[nKeyId]; },
    writable: false,
    configurable: false,
    enumerable: false
  });
  Object.defineProperty(oStorage, "setItem", {
    value: function (sKey, sValue) {
      if(!sKey) { return; }
      document.cookie = escape(sKey) + "=" + escape(sValue) + "; expires=Tue, 19 Jan 2038 03:14:07 GMT; path=/";
    },
    writable: false,
    configurable: false,
    enumerable: false
  });
  Object.defineProperty(oStorage, "length", {
    get: function () { return aKeys.length; },
    configurable: false,
    enumerable: false
  });
  Object.defineProperty(oStorage, "removeItem", {
    value: function (sKey) {
      if(!sKey) { return; }
      document.cookie = escape(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
    },
    writable: false,
    configurable: false,
    enumerable: false
  });
  this.get = function () {
    var iThisIndx;
    for (var sKey in oStorage) {
      iThisIndx = aKeys.indexOf(sKey);
      if (iThisIndx === -1) { oStorage.setItem(sKey, oStorage[sKey]); }
      else { aKeys.splice(iThisIndx, 1); }
      delete oStorage[sKey];
    }
    for (aKeys; aKeys.length > 0; aKeys.splice(0, 1)) { oStorage.removeItem(aKeys[0]); }
    for (var aCouple, iKey, nIdx = 0, aCouples = document.cookie.split(/\s*;\s*/); nIdx < aCouples.length; nIdx++) {
      aCouple = aCouples[nIdx].split(/\s*=\s*/);
      if (aCouple.length > 1) {
        oStorage[iKey = unescape(aCouple[0])] = unescape(aCouple[1]);
        aKeys.push(iKey);
      }
    }
    return oStorage;
  };
  this.configurable = false;
  this.enumerable = true;
})();

//
// Define native storage object
//
var _jegp$elm_storage$Native_Storage = function () {

  var COOKIE = "cookie";
  var LOCAL_STORAGE = "localStorage";
  var SESSION_STORAGE = "sessionStorage";

  var Task = _elm_lang$core$Native_Scheduler;

  // Retrieves a storage from the window object. If it fails, default to cookies
  var getStorage = function(storage) {
    if (window.hasOwnProperty(storage)) {
      return window[storage];
    } else {
      return cookieStorage.get();
    }
  }

  // Execute a task (continuation) using a given storage
  var taskOnStorage = function(storageName, continuation) {
      var storage = getStorage(storageName);
      return Task.nativeBinding(function (callback) {
        try {
          callback(continuation(storage));
        } catch(error) {
          callback(Task.fail("Error: " + error));
        }
      });
  };

  var contains = function(storageName) {
    return function(key) {
      return taskOnStorage(storageName, function(storage) {
        return Task.succeed(storage.hasOwnProperty(key));
      });
    }
  };

  var get = function(storageName) {
    return function(key) {
      return taskOnStorage(storageName, function(storage) {
        var result = storage.getItem(key)
        if (result) {
          return Task.succeed(result)
        } else {
          return Task.fail("No element with key '" + key + "'")
        }
      });
    }
  };

  var remove = function(storageName) {
    return function(key) {
      return taskOnStorage(storageName, function(storage) {
        storage.removeItem(key);
        return Task.succeed();
      });
    }
  };

  var set = function(storageName) {
    return function(key, value) {
      return taskOnStorage(storageName, function(storage) {
        storage.setItem(key, value);
        return Task.succeed();
      });
    }
  };

  return {
    // Contains
    cookieContains: contains(COOKIE),
    localStorageContains: contains(LOCAL_STORAGE),
    sessionStorageContains: contains(SESSION_STORAGE),
    // Get
    cookieGet: get(COOKIE),
    localStorageGet: get(LOCAL_STORAGE),
    sessionStorageGet: get(SESSION_STORAGE),
    // Remove
    cookieRemove: remove(COOKIE),
    localStorageRemove: remove(LOCAL_STORAGE),
    sessionStorageRemove: remove(SESSION_STORAGE),
    // Set
    cookieSet: F2(set(COOKIE)),
    localStorageSet: F2(set(LOCAL_STORAGE)),
    sessionStorageSet: F2(set(SESSION_STORAGE))
  };

}();
