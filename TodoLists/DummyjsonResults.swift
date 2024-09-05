struct DummyjsonResult: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct DummyjsonResponse: Decodable {
    let todos: [DummyjsonResult]
}
