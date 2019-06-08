# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.8.2-1] - 2019-06-08
### Changed
- Upgrade to buildbot 1.8.2

## [1.8.1-2] - 2019-06-08
### Changed
- Extend and improve documentation.

#### Configuration
- Pull worker images by default.
- Support `WORKERNAME` and `WORKERPASS` environment variables.
- Halt build on failure.
- Do not require git.
- Refactoring:
  - Remove redundant entry in BuildmasterConfig.
  - Blacken buildbot/master.cfg.
  - Refactor buildbot/master.cfg.
  - Fix E722 (do not use bare 'except').
  - Avoid redefinition of 'worker' in master.cfg.
  - Name build steps.

#### Docker image
- Expose ports 8010 and 9989.
- Declare `/var/lib/buildbot` as volume.
- Store configuration file in image. (The image now also works as a stand-alone
  container, which can be fired up using `docker run` without further options.)
- Do not require /var/run/docker.sock.
- Create master.cfg symlink at build-time. (Allow invoking buildbot without
  using the entrypoint. Previously, this was not possible because buildbot did
  not find its configuration file.)

#### Docker Swarm
- Expose port 9989.
- Support fish shell in `buildbot-env.sh` script.

#### Docker Compose
- Expose port 9989 on the host.

#### CI
- Determine correct branch name.
- Use shell script.

#### Makefile
- Add target for CI.
- Determine correct branch name.
- Use branch to tag cache image and upload always.
- Only pull the tag used for the build cache.
- Add `LATEST` variable to control tagging.
- Refactoring:
  - Merge Makefile.sub into Makefile.
  - Rename `IMAGE` to `CACHE`.
  - Simplify definition of `CACHE`.
  - Simplify push target.
  - Simplify build target.
  - Minor cleanup.

### Added
- Add script for CI.
- Add script for upgrading the upstream package.
- Add script for releasing this image.

### Removed
- Remove `contrib` directory. These files defined general-purpose Docker stacks
  which are not specific to buildbot.
- Remove `buildbot-worker-example` image. We don't need it anymore because the
  build no longer requires git.
- Remove `pull` target from Makefile.

## [1.8.1-1] - 2019-04-05
### Changed
- Upgrade to buildbot 1.8.1

## 1.8.0-1 - 2019-04-03
### Added
- Initial version: buildbot 1.8.0

[Unreleased]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.2-1...HEAD
[1.8.2-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-2...v1.8.2-1
[1.8.1-2]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.1-1...v1.8.1-2
[1.8.1-1]: https://github.com/cjolowicz/docker-buildbot/compare/v1.8.0-1...v1.8.1-1
