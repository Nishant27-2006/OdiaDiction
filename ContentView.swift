import SwiftUI
import Foundation

struct DictionaryEntry: Codable, Identifiable {
    let id = UUID()
    let word: String
    let meaning: String
    let source: String
    let bookName: String
    let pageNo: String
    let time: String
    let grammar: String
    let derivation: String
}

class CloudKitManager: ObservableObject {
    @Published var dictionaryEntries: [DictionaryEntry] = []

    init() {
        fetchAllEntries()
    }

    func fetchAllEntries() {
        if let url = Bundle.main.url(forResource: "dictionary_entries_cleaned", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let entries = try JSONDecoder().decode([String: DictionaryEntry].self, from: data)
                self.dictionaryEntries = Array(entries.values)
            } catch {
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }
}

struct ContentView: View {
    @State private var word: String = ""
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var dictionaryEntry: DictionaryEntry? = nil
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter word", text: $word)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Button(action: searchWord) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.leading, 5)
                }
                .padding(.horizontal)
                .padding(.top, 50)

                if let entry = dictionaryEntry {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(entry.word.capitalized)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("- noun")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }

                            Divider().background(Color.blue)

                            Group {
                                Text("Meaning:")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                Text(entry.meaning)
                                    .font(.body)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Source:")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                Text(entry.source)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Book Name:")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                Text(entry.bookName)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Page No:")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                Text(entry.pageNo)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Time:")
                                    .font(.headline)
                                    .foregroundColor(.pink)
                                Text(entry.time)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Grammar:")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                                Text(entry.grammar)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)

                            Group {
                                Text("Derivation:")
                                    .font(.headline)
                                    .foregroundColor(.cyan)
                                Text(entry.derivation)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                } else if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.top, 20)
                }

                Spacer()
            }
            .navigationTitle("Dictionary Search")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemBackground))
        }
        .onAppear {
            cloudKitManager.fetchAllEntries()
        }
    }

    private func searchWord() {
        guard !word.isEmpty else {
            errorMessage = "Please enter a word."
            return
        }

        if let entry = cloudKitManager.dictionaryEntries.first(where: { $0.word.lowercased() == word.lowercased() }) {
            dictionaryEntry = entry
            errorMessage = ""
        } else {
            dictionaryEntry = nil
            errorMessage = "Word not found."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
