module Models.Room exposing (..)

import Json.Decode exposing (Decoder, (:=), string, object4, int, maybe, null, bool)

import Models.Player exposing (Player, PlayerId, playersDecoder)
import Models.Guess exposing (Guess)
import Models.PlayerStatusUpdate exposing (PlayerStatusUpdate)

type alias RoomId = String

type alias Room =
  { id : RoomId
  , round : Int
  , word : String
  , players : List Player
  }


-- Helpers

areAllPlayersReady : Room -> Bool
areAllPlayersReady room =
  room.players
    |> List.map (.isReady)
    |> List.foldl (&&) True

getPlayerStatusUpdate : PlayerId -> Room -> PlayerStatusUpdate
getPlayerStatusUpdate playerId room =
  let
    player =
      room.players
        |> List.filter (\player -> player.id == playerId)
        |> List.head
    guess =
      player
        |> Maybe.map (.guess)
        |> Maybe.withDefault Nothing
    isReady =
      player
        |> Maybe.map (.isReady)
        |> Maybe.withDefault False
  in
    { roomId = room.id
    , playerId = playerId
    , round = room.round
    , guess = guess
    , isReady = isReady
    }

setGuess : Guess -> PlayerId -> Room -> Room
setGuess guess playerId room =
  let
    players =
      room.players
        |> List.map (\player -> if player.id == playerId then {player | guess = Just guess} else player)
  in
    {room | players = players}

getGuess : PlayerId -> Room -> Maybe Guess
getGuess playerId room =
  room.players
    |> List.filter (\player -> player.id == playerId)
    |> List.head
    |> Maybe.map .guess
    |> Maybe.withDefault Nothing

isGuessOk : PlayerId -> Player -> Bool
isGuessOk playerId player =
  case player.guess of
    Just guess ->
      (player.id /= playerId) && (guess.value /= 0)
    Nothing ->
      True

canGuess : PlayerId -> Room -> Bool
canGuess playerId room =
  room.players
    |> List.map (isGuessOk playerId)
    |> List.foldl (&&) True

setReady : PlayerId -> Room -> Room
setReady playerId room =
  { room |
      players =
        List.map (\player -> if (playerId == player.id) then {player | isReady = True} else player) room.players
  }

isDraw : Room -> Bool
isDraw room =
  -- TODO: Implement
  False

getWinnerId : Room -> Maybe PlayerId
getWinnerId room =
  -- TODO: Implement
  Nothing


-- Decoders

roomDecoder : Decoder Room
roomDecoder =
  object4 Room
    ("id" := string)
    ("round" := int)
    ("word" := string)
    ("players" := playersDecoder)