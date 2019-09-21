# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [2.4.1-1] - 2019-09-21
### Changed
- Upgrade to buildbot 2.4.1

## [2.4.0-1] - 2019-09-03
### Changed
- Upgrade to buildbot 2.4.0
- Move `buildbot-env.sh` to `scripts` directory.
- Rename `buildbot` directory to `docker`.

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
### Changed
- Extend and improve documentation.

#### Configuration
- Pull worker images by default.
- Support `WORKERNAME` and `WORKERPASS` environment variables.
- Halt build on failure.
- Do not require git.
- Name build steps.
- Refactoring:
  - Remove redundant entry in `BuildmasterConfig`.
  - Apply `black` code reformatter.
  - Miscellaneous refactoring.
  - Fix E722 (do not use bare `except`).
  - Avoid redefinition of `worker`.

#### Docker image
- Expose ports 8010 and 9989.
- Declare `/var/lib/buildbot` as volume.
- Store configuration file in image. (The image now also works as a stand-alone
  container, which can be fired up using `docker run` without further options.)
- Do not require `/var/run/docker.sock`.
- Create `master.cfg` symlink at build-time. (Allow invoking buildbot without
  using the entrypoint. Previously, this was not possible because buildbot did
  not find its configuration file.)

#### Docker Swarm
- Expose port 9989.
- Support fish shell in `buildbot-env.sh` script.

#### Docker Compose
- Expose port 9989 on the host.

#### Makefile
- Merge `Makefile.sub` into `Makefile`.

### Added
- Add script for upgrading the upstream package.
- Add script for releasing this image.

### Removed
- Remove `contrib` directory. (These files defined general-purpose Docker stacks
  which are not specific to buildbot.)
- Remove `buildbot-worker-example` image. (We don't need it anymore because the
  build no longer requires git.)

## [2.1.0-1] - 2019-04-05
### Changed
- Upgrade to buildbot 2.1.0

## [2.0.1-1] - 2019-04-05
### Changed
- Upgrade to buildbot 2.0.1

## [1.8.2-1] - 2019-06-08
### Changed
- Upgrade to buildbot 1.8.2

## [1.8.1-2] - 2019-06-08
_Backport from [2.1.0-2](#210-2---2019-06-07) and [2.3.1-2](#231-2---2019-06-08)_

## [1.8.1-1] - 2019-04-05
### Changed
- Upgrade to buildbot 1.8.1

## 1.8.0-1 - 2019-04-03
### Added
- Initial version: buildbot 1.8.0

[Unreleased]: https://github.com/cjolowicz/docker-buildbot/compare/v2.4.1-1...HEAD
[2.4.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.4.0-1...v2.4.1-1
[2.4.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.3.1-2...v2.4.0-1
[2.3.1-2]: https://github.com/cjolowicz/docker-buildbot/compare/v2.3.1-1...v2.3.1-2
[2.3.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.3.0-1...v2.3.1-1
[2.3.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.2.0-1...v2.3.0-1
[2.2.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.1.0-2...v2.2.0-1
[2.1.0-2]: https://github.com/cjolowicz/docker-buildbot/compare/v2.1.0-1...v2.1.0-2
[2.1.0-1]: https://github.com/cjolowicz/docker-buildbot/compare/v2.0.1-1...v2.1.0-1
[2.0.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-1...v2.0.1-1
[1.8.2-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-2...v1.8.2-1
[1.8.1-2]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-1...v1.8.1-2
[1.8.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.0-1...v1.8.1-1
