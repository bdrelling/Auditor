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
        XCTAssertEqual(repository.defaultBranch, "main", "Default branch is '\(repository.defaultBranch)', expected 'main'. (\(repository.name))")

        // Forking and Downloads should be enabled for all repositories.
        XCTAssertTrue(repository.allowsForking, "Forking should be enabled for all repositories. (\(repository.name))")
        XCTAssertTrue(repository.hasDownloads, "Downloads should be enabled for all repositories. (\(repository.name))")

        // Pages, Projects, and Wiki should be disabled for all repositories.
        XCTAssertFalse(repository.hasPages, "Pages should be disabled for all repositories. (\(repository.name))")
        XCTAssertFalse(repository.hasProjects, "Projects should be disabled for all repositories. (\(repository.name))")
        XCTAssertFalse(repository.hasWiki, "Wiki should be disabled for all repositories. (\(repository.name))")

        // None of my repositories should be disabled.
        // Honestly, not even sure what "disabled" implies here...
        XCTAssertFalse(repository.isDisabled, "Repository should not be disabled. (\(repository.name))")

        // All of my non-meta public repositories should have topics.
        XCTAssertGreaterThan(repository.topics.count, 0, "No topics found. Repositories should have at least 1 topic. (\(repository.name))")

        // The remaining checks are only applicable to non-config, non-README repositories.
        guard repository.name != ".github", !repository.topics.contains("readme") else {
            // My README and config repositories should not have issues enabled.
            XCTAssertFalse(repository.hasIssues, "Issues should be disabled. (\(repository.name))")

            return
        }

        // All repositories should have a description and website.
        XCTAssertTrue(repository.description?.isEmpty == false, "Description is missing. (\(repository.name))")
        XCTAssertTrue(repository.websiteURL?.isEmpty == false, "Website URL is missing. (\(repository.name))")

        // The remaining checks are only applicable to non-archived repositories.
        guard !repository.isArchived else {
            // Archived repositories should NOT have issues enabled.
            XCTAssertFalse(repository.hasIssues, "Issues should be disabled. (\(repository.name))")

            return
        }

        // Web Commit Signoff should be required for all repositories.
        XCTAssertTrue(repository.isWebCommitSignoffRequired, "Web committ signoff should be required. (\(repository.name))")

        // None of my repositories should have any open issues -- they should all be addressed.
        XCTAssertEqual(repository.numberOfOpenIssues, 0, "\(repository.numberOfOpenIssues) issues need to be addressed. (\(repository.name))")

        // All of my repositories should have *at least* myself as a stargazer and watcher.
        XCTAssertGreaterThan(repository.numberOfStargazers, 0, "No stargazers found. You didn't star your own repository! (\(repository.name))")
        XCTAssertGreaterThan(repository.numberOfWatchers, 0, "No watchers found. You aren't watching your own repository! (\(repository.name))")

        if repository.owner.username == "swift-kipple" {
            // All non-README swift-kipple libraries should be in Swift.
            XCTAssertEqual(repository.language, "Swift", "Primary language is '\(repository.language ?? "nil")', expected Swift. (\(repository.name))")
        }

        // Issues should be available for all unarchived, public repositories, except the "ci" and "Auditor" repositories.
        if repository.name != "ci", repository.name != "Auditor" {
            XCTAssertTrue(repository.hasIssues, "Issues should be enabled. (\(repository.name))")
        }
    }
}
