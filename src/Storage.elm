module Storage exposing
  ( Storage(LocalStorage, SessionStorage, Cookie)
  , contains, get, remove, set
  )

{-| This library allows persisting data as key-value pairs via the
[Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage) object
(either [Local Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage),
[Session Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage)) or as
[cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies) in a browser.

If the local or session storage is not available, we default to simple cookie
storage. The stored values in the cookie storage have no expiration (that's
technically not correct - they expire in 2038 - but I sincerely hope you have
an AI to worry about expired cookies by then).

See [https://developer.mozilla.org/en-US/docs/Web/API/Storage] for more
information on session and local storage.

This module was inspired by the elm-storage module by
[TheSeamau5](https://github.com/TheSeamau5/elm-storage). This implementation
does not rely on external libraries.

# Storage types
The three types of storage, which tells the library where to store and retrieve
information from.
@docs Storage

# Storage functions
@docs contains, get, remove, set

-}
import Task exposing (Task)

import Native.Storage

{-| Represents the three types of storage available: ``LocalStorage`` that
saves data without any expiration date, ``SessionStorage`` that stores data
in the current session only and ``Cookie`` which uses regular Cookies to
store the data.
-}
type Storage = LocalStorage | SessionStorage | Cookie

{-| Examines whether a given key exist in the storage. Note: This method only
checks that the key is in the storage, the value may be empty.

The ``Storage`` type denotes which storage to use. If the storage does not
exists in the environment, we default to using cookies without expiration.
-}
contains : Storage -> String -> Task String Bool
contains storage =
  case storage of
    Cookie -> Native.Storage.cookieContains
    LocalStorage -> Native.Storage.localStorageContains
    SessionStorage -> Native.Storage.sessionStorageContains

{-| Gets a value stored under the given key, if it exists.

The ``Storage`` type denotes which storage to use. If the storage does not
exists in the environment, we default to using cookies without expiration.
-}
get : Storage -> String -> Task String String
get storage =
  case storage of
    Cookie -> Native.Storage.cookieGet
    LocalStorage -> Native.Storage.localStorageGet
    SessionStorage -> Native.Storage.sessionStorageGet

{-| Removes the key-value pair stored in the storage.

The ``Storage`` type denotes which storage to use. If the storage does not
exists in the environment, we default to using cookies without expiration.
-}
remove : Storage -> String -> Task String ()
remove storage =
  case storage of
    Cookie -> Native.Storage.cookieRemove
    LocalStorage -> Native.Storage.localStorageRemove
    SessionStorage -> Native.Storage.sessionStorageRemove

{-| Sets a value under a given key. The ``String`` denotes under which key and the ``Value``
is the data to store.

The ``Storage`` type denotes which storage to use. If the storage does not
exists in the environment, we default to using cookies without expiration.
-}
set : Storage -> String -> String -> Task String ()
set storage =
  case storage of
    Cookie -> Native.Storage.cookieSet
    LocalStorage -> Native.Storage.localStorageSet
    SessionStorage -> Native.Storage.sessionStorageSet
