struct DummyjsonResult: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

// Модель для всего ответа с задачами
struct DummyjsonResponse: Decodable {
    let todos: [DummyjsonResult]
}
