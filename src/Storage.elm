module Storage exposing
  ( Storage(LocalStorage, SessionStorage, Cookie)
  , contains, get, remove, set
  )

{-| This library allows persisting data as key-value pairs via the
[Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage) object
(either [Local Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage),
[Session Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage)) or as
[cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies) in a browser.

This module implements basic persistence operations for browsers using either
[localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage),
[sessionStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage)
or plain old [cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).

If the local or session storage is not available (for older browsers), we default to simple cookie
storage. The stored values in the cookie storage have no expiration (that's
technically not correct - they expire in 2038 - but I sincerely hope you have
an AI to worry about expired cookies by then).

See [Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage) for more
information on session and local storage.

## Usage
First you need to decide which type of storage you wish to use. Use either
``LocalStorage`` for long-term storage, ``SessionStorage`` for (ta-da)
session-long storage or simple ``Cookie``s.

To retrieve elements, use the ``get`` function which (apart from the storage
type) requires a key:

    Storage.get LocalStorage "myKey"

The module uses the Elm [Task](https://guide.elm-lang.org/error_handling/task.html)
API, where each ``Task`` either fails or succeeds. So the above function
returns a task. To get the result of the execution, run it with, say,
``Task.attempt``, using a message you've defined previously:

    type Msg = ... | GetResult (Result String String)

    Storage.get LocalStorage "myKey" |> Task.attempt GetResult

Finally you need to handle the result in your ``update`` function:

    case msg of
      ...
      GetResult result ->
        case Ok value -> ...
        case Err error -> ...

For more in-depth examples, please refer to the
[example on GitHub](https://github.com/Jegp/elm-storage/blob/master/Example.elm).

## Credits
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
