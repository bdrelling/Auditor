#!/bin/bash

# Run only our GitHubAuditTests target.
# This method leverages XCTest and GoatHerb to audit GitHub.
swift test --filter GitHubAuditTests
