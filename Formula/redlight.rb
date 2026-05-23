class Redlight < Formula
  desc "USB multi-device sync daemon (macOS + Linux). No cloud, no phone app"
  homepage "https://github.com/slashome/redlight"
  url "https://github.com/slashome/redlight/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "aa5e0f8db094621ba94c56156fd98b8282eb5f065d13a723b53bf9f37bf6f5e2"
  license "MIT"
  head "https://github.com/slashome/redlight.git", branch: "main"

  depends_on "rust" => :build
  depends_on "libmtp"

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  service do
    run [opt_bin/"rl", "daemon"]
    keep_alive true
    log_path var/"log/redlight.log"
    error_log_path var/"log/redlight.log"
  end

  def caveats
    <<~EOS
      Phone-bridge prerequisites are not pulled in automatically.
      Install only what you need:

        - MTP (most Android phones in default USB mode):
            brew install --cask macfuse
          then build jmtpfs from source (no homebrew formula on macOS):
            https://github.com/dechamps/jmtpfs

        - ADB (Android phones in USB-debugging mode):
            brew install --cask android-platform-tools

      First-time setup, in this order:
        1. rl init                       # write the config skeleton + host entry
        2. rl device|item|bind add …     # declare what to sync where
        3. brew services start redlight  # auto-start daemon at login

      Logs:  #{var}/log/redlight.log
      Config: ~/.config/redlight/
      State: ~/.local/state/redlight/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rl --version")
  end
end
