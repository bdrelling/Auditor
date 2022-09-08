// Copyright © 2022 Brian Drelling. All rights reserved.

import GoatHerb
import XCTest

protocol RepositoryValidating: XCTestCase {}

// MARK: - Extensions

extension RepositoryValidating {
    func validate(_ repositories: [Repository]) throws {
        // Ensure at least one repository is returned.
        XCTAssertGreaterThan(repositories.count, 0)

        // Validate each repository with a standard set of checks.
        try repositories.forEach(self.validate)
    }

    func validate(_ repository: Repository) throws {
        // Skip forks -- we only care about our own repositories.
        guard !repository.isFork else {
            return
        }

        // The default branch should be "main" for all repositories.
        XCTAssertEqual(repository.defaultBranch, "main", repository.name)

        // Forking and Downloads should be enabled for all repositories.
        XCTAssertEqual(repository.allowsForking, true, repository.name)
        XCTAssertEqual(repository.hasDownloads, true, repository.name)

        // Pages, Projects, and Wiki should be disabled for all repositories.
        XCTAssertEqual(repository.hasPages, false, repository.name)
        XCTAssertEqual(repository.hasProjects, false, repository.name)
        XCTAssertEqual(repository.hasWiki, false, repository.name)

        // None of my repositories should be disabled.
        // Honestly, not even sure what "disabled" implies here...
        XCTAssertFalse(repository.isDisabled, repository.name)

        // All of my non-meta public repositories should have topics.
        XCTAssertGreaterThan(repository.topics.count, 0, repository.name)

        // The remaining checks are only applicable to non-config, non-README repositories.
        guard repository.name != ".github", !repository.topics.contains("readme") else {
            // My README and config repositories should not have issues enabled.
            XCTAssertEqual(repository.hasIssues, false, repository.name)

            return
        }

        // All repositories should have a description and website.
        XCTAssertTrue(repository.description?.isEmpty == false, repository.name)
        XCTAssertTrue(repository.websiteURL?.isEmpty == false, repository.name)

        // The remaining checks are only applicable to non-archived repositories.
        guard !repository.isArchived else {
            // Archived repositories should NOT have issues enabled.
            XCTAssertEqual(repository.hasIssues, false, repository.name)

            return
        }

        // Web Commit Signoff should be required for all repositories.
        XCTAssertEqual(repository.isWebCommitSignoffRequired, true, repository.name)

        // None of my repositories should have any open issues -- they should all be addressed.
        XCTAssertEqual(repository.numberOfOpenIssues, 0, repository.name)

        // All of my repositories should have *at least* myself as a stargazer and watcher.
        XCTAssertGreaterThan(repository.numberOfStargazers, 0, repository.name)
        XCTAssertGreaterThan(repository.numberOfWatchers, 0, repository.name)

        if repository.owner.username == "swift-kipple" {
            // All non-README swift-kipple libraries should be in Swift.
            XCTAssertEqual(repository.language, "Swift", repository.name)
        }

        // Issues should be available for all unarchived, public repositories, except the "ci" repository.
        if repository.name != "ci" {
            XCTAssertEqual(repository.hasIssues, true, repository.name)
        }
    }
}
