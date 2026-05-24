class Redlight < Formula
  desc "USB multi-device sync daemon (macOS + Linux). No cloud, no phone app"
  homepage "https://github.com/slashome/redlight"
  url "https://github.com/slashome/redlight/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "6d9255da7c6f1d40a893b933215c23a28cb4131224e6befea75185bd7449b73f"
  license "MIT"
  head "https://github.com/slashome/redlight.git", branch: "main"

  depends_on "rust" => :build
  # libmtp is *not* a depends_on yet: v0.0.x shells out to jmtpfs rather
  # than linking libmtp directly. The dep returns when the libmtp-direct
  # bridge lands in v0.1.0 (see PLAN.md Phase 2.7).

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
      External drives (bridge = "fs") need no prerequisites.

      Android phones in v0.0.x use ADB only on macOS — MTP via jmtpfs +
      macFUSE was too fragile to ship; libmtp-direct comes with v0.1.0.
      To sync an Android phone:
        1. enable USB debugging on the phone
        2. brew install --cask android-platform-tools
        3. declare the device with --bridge adb

      First-time setup:
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
