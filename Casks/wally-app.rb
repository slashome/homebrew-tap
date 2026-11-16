cask "wally-app" do
  version "0.0.2"
  sha256 "490ae491d2e6b9fe9ecd16feefd59cf8ba24c9c8e9c9617968ff663d25df5113"

  url "https://github.com/slashome/wally/releases/download/v#{version}/Wally-#{version}.zip"
  name "Wally"
  desc "Menu bar app that rotates wallpapers screen by screen"
  homepage "https://github.com/slashome/wally"

  depends_on formula: "slashome/tap/wally"
  depends_on macos: :sonoma

  app "Wally.app"

  uninstall quit: "me.slashome.wally.app"

  zap trash: [
    "~/Library/Application Support/me.slashome.wally.app",
    "~/Library/Caches/me.slashome.wally.app",
    "~/Library/Preferences/me.slashome.wally.app.plist",
    "~/Library/Saved Application State/me.slashome.wally.app.savedState",
  ]

  caveats <<~EOS
    Wally.app is signed ad hoc, not notarized by Apple.
    On first launch macOS refuses to open it: open
      System Settings > Privacy & Security
    and click "Open Anyway" next to the message about Wally, then confirm.

    The app drives the wally daemon. If it is not set up yet, run:
      wally init
  EOS
end
