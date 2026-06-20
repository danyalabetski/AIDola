import Foundation

final class KeysManager {
    static var shared = KeysManager()
    
    private init() {}
    
    var token: String { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJzaGFyb3ZfMTk5OUBsaXN0LnJ1Iiwicm9sZSI6IkFETUlOIiwiZXhwIjo0OTM1MjA4NjcxLCJpYXQiOjE3ODE2MDg2NzEsInR5cGUiOiJhY2Nlc3MifQ.0GRnZq1LZA__0G0tYEsPER8lQiCiX_myE6_T_nMwUmc"
    }
    
    let apphudApiKey = "app_FmCjFTwjWpcLSafxT8vCDeVffJyfFS"
    
    var userId: String {
         let key = "com.aidola.userId"

         if let savedId = UserDefaults.standard.string(forKey: key) {
             return savedId
         }

         let newId = UUID().uuidString

         UserDefaults.standard.set(newId, forKey: key)

         return newId
     }
}
