# Contributing

## Upgrading upstream

```shell
scripts/upgrade.sh $version # 2.0.0
git push
```

## Releasing

```shell
$EDITOR CHANGELOG.md
scripts/release.sh
git push --all --follow-tags
github-release $version
```

See [github-release](https://github.com/cjolowicz/scripts/blob/master/github/github-release.sh).
