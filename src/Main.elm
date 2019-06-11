module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    , isMenuActive : Bool
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        initialModel =
            Model
                key
                url
                False
    in
    ( initialModel
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleMenu
    | ResetMenu


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

        ToggleMenu ->
            if model.isMenuActive then
                ( { model | isMenuActive = False }
                , Cmd.none
                )

            else
                ( { model | isMenuActive = True }
                , Cmd.none
                )

        ResetMenu ->
            ( { model | isMenuActive = False }
            , Cmd.none
            )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Bulma Hamburger"
    , body =
        [ nav [ attribute "aria-label" "main navigation", class "navbar is-white", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ div [ class "navbar-item" ]
                    [ text "EBH" ]
                , div
                    [ class "navbar-burger"
                    , attribute "data-target" "navMenu"
                    , onClick ToggleMenu
                    , if model.isMenuActive then
                        class "is-active"

                      else
                        class ""
                    ]
                    [ span []
                        []
                    , span []
                        []
                    , span []
                        []
                    ]
                ]
            , div
                [ class "navbar-menu"
                , id "navMenu"
                , if model.isMenuActive then
                    class "is-active"

                  else
                    class ""
                ]
                [ div [ class "navbar-end" ]
                    [ a [ class "navbar-item", href "/", onClick ResetMenu ]
                        [ text "トップ" ]
                    , a [ class "navbar-item", href "/about", onClick ResetMenu ]
                        [ text "NBHとは？" ]
                    , a [ class "navbar-item", href "/contact", onClick ResetMenu ]
                        [ text "お問い合わせ" ]
                    ]
                ]
            , text "  "
            ]
        , case model.url.path of
            "/" ->
                div [] []

            "/about" ->
                section [ class "hero is-primary is-bold" ]
                    [ div [ class "hero-body" ]
                        [ div [ class "container" ]
                            [ h1 [ class "title is-size-2" ] [ text "About" ]
                            , h2 [ class "subtitle is-size-4" ] [ text "EBHとは？" ]
                            ]
                        ]
                    ]

            "/contact" ->
                section [ class "hero is-info is-bold" ]
                    [ div [ class "hero-body" ]
                        [ div [ class "container" ]
                            [ h1 [ class "title is-size-2" ] [ text "Contact" ]
                            , h2 [ class "subtitle is-size-4" ] [ text "お問い合わせ" ]
                            ]
                        ]
                    ]

            _ ->
                div [] []
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
                    [ a [ href "http://i-doctor.sakura.ne.jp/font/?p=38815" ] [ text "WordPressでフリーオリジナルフォント2" ]
                    ]
                ]
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
