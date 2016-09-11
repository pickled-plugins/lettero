module Update exposing (..)

import Json.Decode exposing (decodeString)
import Result

import Messages exposing (Msg(..))
import Models exposing (Model)
import Helpers exposing (setOwnGuess, getOwnGuess)
import Commands exposing (sendPlayerStatusUpdate, getRandomAngle)
import Room.Decoders exposing (roomDecoder)
import Constants exposing (tickDuration)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ReceiveRoomState roomState ->
      let
        newRoom = decodeString roomDecoder roomState
          |> Result.toMaybe
        didRoundChange = (Maybe.map (.round) model.room) /= (Maybe.map (.round) newRoom)
        newTime = if didRoundChange then 0 else model.time
        cmd = case model.room of
          Just room ->
            if didRoundChange
              then
                getRandomAngle ()
              else
                Cmd.none
          Nothing ->
            getRandomAngle ()
      in
        ( { model | room = newRoom, time = newTime }
        , cmd
        )
    ReceiveRandomAngle angle ->
      ( { model | angle = angle }
      , Cmd.none
      )
    Guess guess ->
      let
        canGuess = (getOwnGuess model) /= Just 0
        newModel = if canGuess then (setOwnGuess guess model) else model
        command  = if canGuess then (sendPlayerStatusUpdate newModel) else Cmd.none
      in
        (newModel, command)
    Tick tick ->
      ({ model | time = model.time + tickDuration }, Cmd.none)
