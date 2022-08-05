import Foundation
import TSCBasic
import Logging

public struct Runner {
    public init() {
        LoggingSystem.bootstrap(StreamLogHandler.standardError)
    }

    public func run(packageDirectory: URL) async throws {
        let package = try Package(packageDirectory: packageDirectory)
        let generator = ProjectGenerator(outputDirectory: package.buildDirectory)

        let generationResult = try generator.generate(for: package)
        let compiler = Compiler<ProcessExecutor>(package: package, projectPath: generationResult.projectPath)
        try await compiler.build()
    }
}