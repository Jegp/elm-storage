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

## Credits
This module was inspired by the elm-storage module by
[TheSeamau5](https://github.com/TheSeamau5/elm-storage). This implementation
does not rely on external libraries.

Licensed under BSD3.
