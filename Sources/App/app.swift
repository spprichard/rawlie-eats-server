import Vapor

extension Application {
    
}

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    
    let health = Health(status: ServerStatus.healthy)
    app.extend["health"] = health
    
    return app
}
