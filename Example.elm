import Storage as Storage

import Html exposing (Html, div)
import Html.Attributes exposing(value)
import Html.Events as Events
import Task exposing (attempt)

type alias Model = { field : String, storage : Storage.Storage }

type Msg = SetField String
  | SetStorage Storage.Storage
  | Contains String
  | ContainsResult (Result String Bool)
  | Get String
  | GetResult (Result String String)
  | Remove String
  | RemoveResult (Result String ())
  | PutResult (Result String ())
  | Put String String

main : Program Never Model Msg
main = Html.program
  { init = (Model "" Storage.LocalStorage, Cmd.none)
  , update = update
  , view = view
  , subscriptions = \model -> Sub.none }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetField value -> ({model | field = value}, Cmd.none)
    SetStorage storageType -> ({model | storage = storageType}, Cmd.none)
    Put key value ->
      let
        task = Storage.set model.storage "field" value
      in
        (model, Task.attempt PutResult task)
    PutResult result -> (model, Cmd.none)
    Get key ->
      let
        task = Storage.get model.storage "field"
      in
        (model, Task.attempt GetResult task)
    GetResult result ->
      case result of
        Ok value -> ({ model | field = value}, Cmd.none)
        Err error -> (model, Cmd.none)
    Contains key ->
      let
        task = Storage.contains model.storage key
      in
        (model, Task.attempt ContainsResult task)
    ContainsResult result ->
      case result of
        _ -> (model, Cmd.none)
    Remove key ->
      let
        task = Storage.remove model.storage "field"
      in
        (model, Task.attempt RemoveResult task)
    RemoveResult result ->
      case result of
        _ -> (model, Cmd.none)

view : Model -> Html Msg
view model = div []
  [ Html.input [ Events.onInput SetField, value model.field ] []
  , Html.button [ Events.onClick (Put "field" model.field) ] [ Html.text "Store"]
  , Html.button [ Events.onClick (Get "field") ] [Html.text "Load"]
  , Html.button [ Events.onClick (Contains "field") ] [Html.text "Contains"]
  , Html.button [ Events.onClick (Remove "field") ] [Html.text "Remove key"]
  , Html.hr [] []
  , Html.button [ Events.onClick (SetStorage Storage.Cookie) ] [ Html.text "Use cookies"]
  , Html.button [ Events.onClick (SetStorage Storage.LocalStorage) ] [ Html.text "Use Local Storage"]
  , Html.button [ Events.onClick (SetStorage Storage.SessionStorage) ] [ Html.text "Use Session Storage"]
  ]
