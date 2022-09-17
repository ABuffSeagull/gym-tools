module Main exposing (Msg, main)

import Browser
import Element exposing (..)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes


main : Program () Int Msg
main =
    Browser.sandbox { init = 0, update = update, view = view }


type alias Model =
    Int


type Msg
    = OnInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInput numString ->
            numString
                |> String.toInt
                |> Maybe.withDefault 0


view : Model -> Html Msg
view model =
    layoutWith
        { options = [ focusStyle { backgroundColor = Nothing, shadow = Nothing, borderColor = Just (rgb255 0x69 0x99 0x5D) } ] }
        [ Bg.color (rgb255 0x39 0x46 0x48), Font.color (rgb 1 1 1) ]
    <|
        column [ centerX, height fill, width (maximum 375 fill), paddingXY 12 50, spacing 15 ]
            [ row [ centerY, width fill, spacing 10, paddingXY 15 0, scrollbarX ] <|
                List.map viewPlate (calculatePlates model)
            , Input.text
                [ centerY
                , htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
                , Bg.color (rgba 0 0 0 0)
                , Border.width 3
                , Border.dashed
                , Border.rounded 10
                ]
                { onChange = OnInput
                , text = String.fromInt model
                , placeholder = Nothing
                , label = Input.labelAbove [ paddingXY 0 10 ] (text "Weight")
                }

            {- , row [ width fill, spacing 20, alignBottom ]
               [ Input.button [ centerX, paddingXY 25 15 ] { onPress = Nothing, label = text "Weights" }
               , Input.button [ centerX, paddingXY 25 15 ] { onPress = Nothing, label = text "Sets" }
               ]
            -}
            ]


type Plate
    = Full -- 45
    | Half -- 25
    | Quarter -- 10
    | Side -- 5
    | Snack -- 2.5


viewPlate : Plate -> Element Msg
viewPlate plate =
    let
        ( bgColor, numString ) =
            case plate of
                Full ->
                    ( rgb255 0xBB 0x34 0x2F, "45" )

                Half ->
                    ( rgb255 0xF4 0x9D 0x37, "25" )

                Quarter ->
                    ( rgb255 0x25 0x5C 0x99, "10" )

                Side ->
                    ( rgb255 0x1C 0x7C 0x54, "5" )

                Snack ->
                    ( rgb255 0x02 0x02 0x02, "2.5" )
    in
    el
        [ width (maximum 60 fill)
        , centerX
        , paddingXY 15 45
        , Bg.color bgColor
        , Font.center
        ]
        (text numString)


weightTuples : List ( Plate, Int )
weightTuples =
    [ ( Full, 90 ), ( Half, 50 ), ( Quarter, 20 ), ( Side, 10 ), ( Snack, 5 ) ]


calculatePlates : Int -> List Plate
calculatePlates weight =
    List.foldl skimOffWeight ( weight - 45, [] ) weightTuples
        |> Tuple.second
        |> List.reverse


skimOffWeight : ( Plate, Int ) -> ( Int, List Plate ) -> ( Int, List Plate )
skimOffWeight ( plate, weight ) ( currentWeight, weightsSoFar ) =
    let
        times : Int
        times =
            currentWeight // weight
    in
    ( currentWeight - (times * weight), List.repeat times plate ++ weightsSoFar )
