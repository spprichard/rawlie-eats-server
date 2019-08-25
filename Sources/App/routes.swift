import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let eatsController = EatController()
    
    let apiV1Group = router.grouped("api", "v1")
    
    router.get("health") { req in
        return Health(status: .healthy)
    }
    
    apiV1Group.post("eats", use: eatsController.handle)
}
