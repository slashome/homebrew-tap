class Wally < Formula
  desc "Rotates your wallpapers, screen by screen, from a small daemon"
  homepage "https://github.com/slashome/wally"
  url "https://github.com/slashome/wally/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "05d035b109832bea3877a82610e774dfeb6a6fc9b86e82983ec3141a9cead0f6"
  license "MIT"
  head "https://github.com/slashome/wally.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  def caveats
    <<~EOS
      Set wally up: it looks at this Mac, then asks for your folder of
      wallpapers, the interval, and whether to start at login.
        wally init

      After `brew upgrade wally`, put the daemon on the new version:
        wally daemon restart
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wally --version")
    (testpath/"pics").mkpath
    touch testpath/"pics/dark-forest.jpg"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["XDG_STATE_HOME"] = testpath/"state"
    system bin/"wally", "settings", "source", "add", testpath/"pics"
    assert_match "dark-forest.jpg", shell_output("#{bin}/wally search forest")
  end
end
