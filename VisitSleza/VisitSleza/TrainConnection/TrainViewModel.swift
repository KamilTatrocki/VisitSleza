import Foundation
import Combine // Potrzebne dla ObservableObject

// Enum dla czytelnego zarządzania stanem ładowania
enum LoadingState {
    case idle, loading, success, failed(Error)
}

@MainActor // Ważne: Zapewnia, że zmiany @Published dzieją się na głównym wątku
class TrainViewModel: ObservableObject {
    
    // --- STAN (Obserwowany przez View) ---
    
    // Lista wyników
    @Published var connections: [TrainConnection] = []
    
    // Data i godzina wybrana przez użytkownika
    @Published var searchDate: Date = Date()
    
    // Stan ładowania (bezczynny, ładuje, sukces, błąd)
    @Published var loadingState: LoadingState = .idle
    
    // --- PRYWATNE WŁAŚCIWOŚCI ---
    
    // Formatter do tworzenia daty w formacie wymaganym przez API
    private var requestDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ustaw na UTC lub wg wymagań API
        return formatter
    }()
    
    // Dekoder JSON skonfigurowany do obsługi dat ISO8601
    private var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // API zwraca daty w standardzie ISO8601 (np. "2025-11-06T04:33:00+01:00")
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // --- LOGIKA BIZNESOWA (Funkcje) ---
    
    func fetchConnections() async {
        print("Rozpoczynam pobieranie...")
        loadingState = .loading
        connections = [] // Czyścimy stare wyniki
        
        // 1. Ustawienie adresu URL
        guard let url = URL(string: "https://api.koleo.pl/v2/main/eol_connections/search") else {
            loadingState = .failed(URLError(.badURL))
            return
        }
        
        // 2. Przygotowanie body zapytania
        let dateString = requestDateFormatter.string(from: searchDate)
        
        // Używamy Twoich ID stacji
        let requestBody = SearchRequest(
            departure_after: dateString,
            start_id: 58487,
            end_id: 60103,
            only_direct: false
        )
        
        guard let httpBody = try? JSONEncoder().encode(requestBody) else {
            loadingState = .failed(URLError(.badServerResponse)) // Trochę na wyrost, ale pasuje
            return
        }

        // 3. Stworzenie URLRequest (metoda POST, nagłówki, body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
        // Dodanie wszystkich wymaganych nagłówków
        request.setValue("2", forHTTPHeaderField: "x-koleo-version")
        request.setValue("1", forHTTPHeaderField: "accept-eol-response-version")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        // 4. Wykonanie zapytania
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Sprawdzenie kodu odpowiedzi HTTP
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Błąd odpowiedzi serwera: \(response)")
                loadingState = .failed(URLError(.badServerResponse))
                return
            }
            
            // 5. Dekodowanie danych
            let decodedConnections = try jsonDecoder.decode([TrainConnection].self, from: data)
            
            // 6. Aktualizacja stanu
            self.connections = decodedConnections
            self.loadingState = .success
            print("Pobrano \(decodedConnections.count) połączeń.")
            
        } catch {
            // 7. Obsługa błędów
            print("Błąd pobierania lub dekodowania: \(error.localizedDescription)")
            self.loadingState = .failed(error)
        }
    }
}
