module Root.Models exposing (..)

import RoomCreator.Models
import RoomManager.Models
import Tutorial.Models
import Router
import Root.Messages
import Game.Models
import Game.Init

type alias Model =
  { route : Router.Route
  , game : Maybe Game.Models.Model
  , roomCreator : Maybe RoomCreator.Models.Model
  , roomManager : Maybe RoomManager.Models.Model
  , tutorial : Maybe Tutorial.Models.Model
  }

maybeLiftFirstInTuple : (a, b) -> (Maybe a, b)
maybeLiftFirstInTuple (a, b) =
  (Just a, b)

setRoute : Router.Route -> Model -> (Model, Cmd Root.Messages.Msg)
setRoute route model =
  let
    (gameModel, gameCmd) =
      case route of
        Router.GamePlay roomId playerId ->
          Game.Init.init
            { roomId = roomId
            , playerId = playerId
            }
            |> maybeLiftFirstInTuple

        _ ->
          (Nothing, Cmd.none)

    (roomCreatorModel, roomCreatorCmd) =
      case route of
        Router.NewRoom ->
          (Just RoomCreator.Models.init, Cmd.none)

        _ ->
          (Nothing, Cmd.none)

    (roomManagerModel, roomManagerCmd) =
      case route of
        Router.Room roomId ->
          RoomManager.Models.init roomId
            |> maybeLiftFirstInTuple

        _ ->
          (Nothing, Cmd.none)

    (tutorialModel, tutorialCmd) =
      case route of
        Router.Tutorial ->
          (Just Tutorial.Models.init, Cmd.none)

        _ ->
          (Nothing, Cmd.none)
  in
    ( { model
          | route = route
          , game = gameModel
          , roomCreator = roomCreatorModel
          , roomManager = roomManagerModel
          , tutorial = tutorialModel
      }
    , Cmd.batch
        [ Cmd.map Root.Messages.GameMsg gameCmd
        , Cmd.map Root.Messages.RoomCreatorMsg roomCreatorCmd
        , Cmd.map Root.Messages.RoomManagerMsg roomManagerCmd
        , Cmd.map Root.Messages.TutorialMsg tutorialCmd
        ]
    )

init : Router.Route -> (Model, Cmd Root.Messages.Msg)
init route =
  setRoute route
    { route = route
    , game = Nothing
    , roomCreator = Nothing
    , roomManager = Nothing
    , tutorial = Nothing
    }

initWithRoute : Result a Router.Route -> (Model, Cmd Root.Messages.Msg)
initWithRoute result =
  Router.routeFromResult result
    |> init
