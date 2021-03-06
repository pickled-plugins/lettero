module RoomManager.Update exposing (..)

import Json.Decode as JD
import Models.Room as Room
import RoomManager.Messages exposing (Msg(..))
import RoomManager.Models exposing (Model, Stage(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveRoom roomString ->
            let
                room =
                    JD.decodeString Room.itemDecoder roomString
                        |> Result.toMaybe
            in
                { model | room = room, stage = Base }
                    ! []

        Navigate str ->
            model ! []
