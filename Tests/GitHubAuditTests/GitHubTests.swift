// Copyright © 2022 Brian Drelling. All rights reserved.

import GoatHerb
import XCTest

// TODO: Add alerting for new forks?
final class GitHubAuditTests: XCTestCase, RepositoryValidating {
    let gitHub = GitHub(logger: .init(label: "GitHubAuditTests"))

    // NOTE: This test is disabled until/unless the unauthenticated rate limit starts failing.
    // /// Ensures that we have a high enough rate limit to perform whatever our audit entails.
    // /// If this test fails, it most likely implies that `GITHUB_ACCESS_TOKEN` is not provided as an environment variable.
    // func testRateLimit() async throws {
    //     let rateLimit = try await gitHub.getRateLimit()
    //     XCTAssertGreaterThanOrEqual(rateLimit.rate.limit, 1000)
    // }

    func testAllRepositoriesAreSynchronized() async throws {
        let personalRepositories = try await self.gitHub.getRepositories(user: "bdrelling")
        let kippleRepositories = try await self.gitHub.getRepositories(org: "swift-kipple")

        let repositories = personalRepositories + kippleRepositories

        try self.validate(repositories)
    }
}
