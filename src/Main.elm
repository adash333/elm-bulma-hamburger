module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- （２）画面遷移のリクエストを受けたとき
        LinkClicked urlRequest ->
            case urlRequest of
                -- 内部リンクならブラウザのURLを更新する（pushUrl関数）
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                -- 外部リンクなら通常の画面遷移を行う（load関数）
                Browser.External href ->
                    ( model, Nav.load href )

        -- （３）ブラうザのアドレス欄のURLが変更されたとき
        UrlChanged url ->
            ( { model | url = url }
              -- 今回は何もしませんが、本当はここでサーバーからデータをもらうことが多い
            , Cmd.none
            )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ section [ class "hero is-primary" ]
            [ div [ class "hero-body" ]
                [ div [ class "container" ]
                    [ h1 [ class "title" ]
                        [ a [ href "/" ] [ text "Elm Bulma Hamburger" ]
                        ]
                    ]
                ]
            ]
        , section [ class "section" ]
            [ div [ class "container" ]
                [ text "The current URL is: "
                , b [] [ text (Url.toString model.url) ]
                , ul []
                    [ viewLink "/"
                    , viewLink "/about"
                    , viewLink "/contact"
                    ]
                , case model.url.path of
                    "/" ->
                        img [ src "/img/home.png" ] []

                    "/about" ->
                        img [ src "/img/jikosyoukai_man.png" ] []

                    "/contact" ->
                        img [ src "/img/mail_man.png" ] []

                    _ ->
                        div [] []
                ]
            ]
        , footer [ class "footer" ]
            [ div [ class "content has-text-centered" ]
                [ p []
                    [ a [ href "http://i-doctor.sakura.ne.jp/font/?p=38672" ] [ text "WordPressでフリーオリジナルフォント2" ]
                    ]
                ]
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
