import Foundation
import Combine


enum LoadingState {
    case idle, loading, success, failed(Error)
}

@MainActor // Ważne: Zapewnia, że zmiany @Published dzieją się na głównym wątku
class TrainViewModel: ObservableObject {
    
    
    
    
    @Published var connections: [TrainConnection] = []
    

    @Published var searchDate: Date = Date()
    
   
    @Published var loadingState: LoadingState = .idle
    
  
    
    
    private var requestDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
 
    private var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
  
    
    func fetchConnections() async {
        print("Rozpoczynam pobieranie...")
        loadingState = .loading
        connections = []
        

        guard let url = URL(string: "https://api.koleo.pl/v2/main/eol_connections/search") else {
            loadingState = .failed(URLError(.badURL))
            return
        }
        
      
        let dateString = requestDateFormatter.string(from: searchDate)
        
        
        let requestBody = SearchRequest(
            departure_after: dateString,
            start_id: 58487,
            end_id: 60103,
            only_direct: false
        )
        
        guard let httpBody = try? JSONEncoder().encode(requestBody) else {
            loadingState = .failed(URLError(.badServerResponse))
            return
        }

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
        
        request.setValue("2", forHTTPHeaderField: "x-koleo-version")
        request.setValue("1", forHTTPHeaderField: "accept-eol-response-version")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
    
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Błąd odpowiedzi serwera: \(response)")
                loadingState = .failed(URLError(.badServerResponse))
                return
            }
            
            
            let decodedConnections = try jsonDecoder.decode([TrainConnection].self, from: data)
            
           
            self.connections = decodedConnections
            self.loadingState = .success
            print("Pobrano \(decodedConnections.count) połączeń.")
            
        } catch {
           
            print("Błąd pobierania lub dekodowania: \(error.localizedDescription)")
            self.loadingState = .failed(error)
        }
    }
}
