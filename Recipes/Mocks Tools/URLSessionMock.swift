import Foundation

class URLSessionMock: URLSessionProtocol {
    let data: Data
    let response: URLResponse
    
    init(data: Data, responseCode: Int) {
        self.data = data
        self.response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: responseCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
