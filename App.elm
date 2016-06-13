import Html exposing (Html, div, h2, text, button)
import Html.App as Html
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task

main =
  Html.program
    { init = init "waiting" "10"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { title: String
  , count: String
  }


init : String -> String -> (Model, Cmd Msg)
init title count =
  (Model title count, getData count)




-- UPDATE


type Msg
  = MoreData
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoreData ->
      (model, getData model.count)

    FetchSucceed newUrl ->
      (Model model.count newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.count]
    , div [] [text model.title]
    , button [ onClick MoreData ] [ text "Get more data!" ]
    ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


getData : String -> Cmd Msg
getData count =
  let
    url = 
      "https://getpocket.com/v3/get?consumer_key=put-key-here&count=" ++ count
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeDataUrl url)


decodeDataUrl : Json.Decoder String
decodeDataUrl =
  Json.at ["data", "given_title"] Json.string
