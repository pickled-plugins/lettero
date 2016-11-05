module RoomCreator.Models exposing (..)

import String

import Models.Room as Room

type Status
  = Startup
  | RoomCreateEditing
  | RoomCreateProcessing
  | RoomCreateSuccess
  | RoomCreateError

type alias Model =
  { roomId : String
  , playerIds : List String
  , room : Maybe Room.Room
  , status : Status
  }

init : Model
init =
  { roomId = ""
  , playerIds = [ "", "" ]
  , room = Nothing
  , status = Startup
  }

getDummy : String -> Model
getDummy s =
  init


-- Helpers

canSubmit : Model -> Bool
canSubmit {roomId, playerIds} =
  (
    String.length roomId > 0
  ) &&
  (
    playerIds
      |> List.map ((\i -> i > 0) << String.length)
      |> List.all identity
  )

stringifyCreateRoomRequest : Model -> String
stringifyCreateRoomRequest {roomId, playerIds} =
  ("{\"roomId\": \"" ++ roomId ++ "\", \"playerIds\": " ++ (toString playerIds) ++ "}")