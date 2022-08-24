import Foundation
import ScipioKit
import ArgumentParser
import Logging

extension Scipio {
    struct Create: AsyncParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Create XCFramework for a single package."
        )

        @Argument(help: "Path indicates a package directory.",
                  completion: .directory)
        var packageDirectory: URL = URL(fileURLWithPath: ".")

        @OptionGroup var buildOptions: BuildOptionGroup
        @OptionGroup var globalOptions: GlobalOptionGroup

        mutating func run() async throws {
            LoggingSystem.bootstrap()

            let runner = Runner(mode: .createPackage,
                                options: .init(
                                    buildConfiguration: buildOptions.buildConfiguration,
                                    isSimulatorSupported: buildOptions.supportSimulators,
                                    isDebugSymbolsEmbedded: buildOptions.embedDebugSymbols,
                                    isCacheEnabled: false,
                                    verbose: globalOptions.verbose)
            )

            try await runner.run(packageDirectory: packageDirectory,
                                 frameworkOutputDir: buildOptions.outputDirectory)
        }
    }
}