# slashome/homebrew-tap

Homebrew tap for [slashome](https://github.com/slashome) projects.

## Usage

```bash
brew tap slashome/tap
brew install <formula>
```

(`slashome/tap` is the brew shorthand for `slashome/homebrew-tap` — brew strips the `homebrew-` prefix automatically.)

## Available formulae

| Formula | Description |
|---|---|
| [`karaokay`](Formula/karaokay.rb) | Synchronized lyrics in your terminal, powered by MPD |
| [`redlight`](Formula/redlight.rb) | USB multi-device sync daemon (macOS + Linux). No cloud, no phone app |
| [`wally`](Formula/wally.rb) | Rotates your wallpapers, screen by screen, from a small daemon |
| [`wally-app`](Casks/wally-app.rb) (cask) | Menu bar app for wally: images per screen, next, pause, library, history |

## Releasing

See [RELEASING.md](RELEASING.md) for the bump-a-formula flow.
