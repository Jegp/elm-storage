# Elm storage

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

## Installation instructions
To install this package, the simplest way is to follow these three steps:

1. Clone the repository onto your own harddrive and place it as a subfolder to
   your project.
2. Modify your ``elm-package.json`` in the project you would like to use the
   ``elm-storage`` project. You have to modify it to include the source files
   from this repository. You can do this by adding the source folder of the
   ``elm-storage`` project into the list of source files. Since this project
   contains native JavaScript, you will also have to include a line setting
   ``"native-modules": true``. Your ``elm-package.json`` should now contain
   something like the following:
   ````elm
   "source-directories": [
       ".",
       "browser-storage/src"
   ],
   "native-modules": true,
   ````
3. In your Elm script, import Storage with a line looking like this:
   ``import Storage exposing(set, get, Storage(SessionStorage))``

   You will of course have to modify this to include the type of storage you
   would like to work with.

Documentation can be found at https://jegp.github.io/elm-storage and I included
more elaborate examples in [Example.elm](https://github.com/Jegp/elm-storage/blob/master/Example.elm)

### Why is this not a package on ``package.elm-lang.org``?
Two reasons: First of all, this package contains native JavaScript, and the
elm package repository does not allow modules with native code in them.
Second, the community is working on a new (and, I have to admit, better) way
of working with browser storage: https://github.com/elm-lang/persistent-cache.
I actually contacted the developers about this package, but they politely
refused any help. So for now we have no choice but to wait until they release
the package for the public.

Until then this implementation has proven to be stable.

## Credits
This module was inspired by the elm-storage module by
[TheSeamau5](https://github.com/TheSeamau5/elm-storage). This implementation
does not rely on external libraries.

Licensed under BSD3.
