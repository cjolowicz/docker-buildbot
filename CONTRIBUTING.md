# Contributing

## Building the Docker image

Building the Docker image requires [GNU
make](https://www.gnu.org/software/make/).

Here is a list of available targets:

| Target       | Description                         |
| ---          | ---                                 |
| `make build` | Build the image.                    |
| `make push`  | Upload the image to Docker Hub.     |
| `make pull`  | Download the image from Docker Hub. |
| `make login` | Log into Docker Hub.                |

Pass `NAMESPACE` to prefix the image with a Docker Hub namespace. The default is
`DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks for
`DOCKER_USERNAME` and `DOCKER_PASSWORD`.

## Upgrading upstream

```sh
scripts/upgrade.sh $version # 2.0.0
git push
```

## Releasing

```sh
$EDITOR CHANGELOG.md
scripts/release.sh
git push --all --follow-tags
github-release $version
```

See [github-release](https://github.com/cjolowicz/scripts/blob/master/github/github-release.sh).
