# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.3.1-2] - 2019-06-08
### Changed
- Upload cache image from branch builds.
- Use branch name to tag cache image.
- Add `LATEST` variable to control which version is tagged as `latest`. This is
  necessary when upstream provides maintenance releases for older versions.
- Refactor Makefile.

### Added
- Add script for CI.
- Add make target for CI.

### Removed
- Remove `pull` target from Makefile.

## [2.3.1-1] - 2019-06-07
### Changed
- Upgrade to buildbot 2.3.1

## [2.3.0-1] - 2019-06-07
### Changed
- Upgrade to buildbot 2.3.0

## [2.2.0-1] - 2019-06-07
### Changed
- Upgrade to buildbot 2.2.0

## [2.1.0-2] - 2019-06-07
### Added
- The image now also works as a stand-alone container, which can be fired up
  using `docker run` without further options.
- Allow invoking buildbot without using the entrypoint. Previously, this was not
  possible because buildbot did not find its configuration file.
- Extend and improve documentation.
- Support `WORKERNAME` and `WORKERPASS` environment variables.
- Support fish shell in `buildbot-env.sh` script.
- Add maintainer scripts for upgrading the upstream package, and for releasing
  this image.

### Changed
- Expose ports 8010 and 9989 in the `Dockerfile`.
- Expose port 9989 on the host.
- Declare `/var/lib/buildbot` as a volume.
- Simplify the make cruft.
- Changes in sample configuration:
  - Pull worker images by default.
  - Halt build on failure.
  - Do not require git.
  - Name build steps.
  - Code cleanup.

### Removed
- Remove the example worker image. We don't need it anymore because the build no
  longer requires git.
- Remove the contrib directory. These files defined general-purpose Docker
  stacks which are not specific to buildbot.

## [2.1.0-1] - 2019-04-05
### Changed
- Upgrade to buildbot 2.1.0

## [2.0.1-1] - 2019-04-05
### Changed
- Upgrade to buildbot 2.0.1

## [1.8.1-1] - 2019-04-05
### Changed
- Upgrade to buildbot 1.8.1

## 1.8.0-1 - 2019-04-03
### Added
- Initial version: buildbot 1.8.0

[Unreleased]: https://github.com/cjolowicz/docker-buildbot/compare/2.3.1-1...HEAD
[2.3.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.3.0-1...2.3.1-1
[2.3.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.2.0-1...2.3.0-1
[2.2.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.1.0-2...2.2.0-1
[2.1.0-2]: https://github.com/cjolowicz/docker-buildbot/compare/v2.1.0-1...2.1.0-2
[2.1.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.0.1-1...2.1.0-1
[2.0.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-1...2.0.1-1
[1.8.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.0-1...v1.8.1-1
