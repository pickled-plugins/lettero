module UiKit.Icons exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Svg exposing (svg, path)
import Svg.Attributes exposing (transform, viewBox, d)


logo : Html msg
logo =
    div
        [ class "icon" ]
        [ svg
            [ viewBox "0 0 320 320"
            ]
            [ path
                [ d "M124.8,248.52 L124.8,66.52 C124.8,62.786648 126.573316,59.986676 130.12,58.12 C133.666684,56.253324 137.959975,55.32 143,55.32 C148.040025,55.32 152.333316,56.253324 155.88,58.12 C159.426684,59.986676 161.2,62.786648 161.2,66.52 L161.2,228.08 L229.52,228.08 C232.880017,228.08 235.53999,229.666651 237.5,232.84 C239.46001,236.013349 240.44,239.746645 240.44,244.04 C240.44,248.333355 239.46001,252.066651 237.5,255.24 C235.53999,258.413349 232.880017,260 229.52,260 L140.76,260 C136.466645,260 132.733349,258.973344 129.56,256.92 C126.386651,254.866656 124.8,252.066684 124.8,248.52 L124.8,248.52 Z"
                , transform "translate(50 -40) rotate(19.000000)"
                ]
                []
            ]
        ]
