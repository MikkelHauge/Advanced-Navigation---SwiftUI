enum PushDestination: Hashable {
    case gameDetails(id: GameID)
    case studioDetails(id: StudioID)
    case gameList(GameListType)
}
