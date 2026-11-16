class Wally < Formula
  desc "Rotates your wallpapers, screen by screen, from a small daemon"
  homepage "https://github.com/slashome/wally"
  url "https://github.com/slashome/wally/releases/download/v0.0.2/wally-v0.0.2-universal-apple-darwin.tar.gz"
  sha256 "3ed8448c089f3efa35370679826f02e3f089991f3385cd3d4be383aaae4a651b"
  license "MIT"

  head do
    url "https://github.com/slashome/wally.git", branch: "main"
    depends_on "rust" => :build
  end

  depends_on :macos

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: ".")
    else
      bin.install "wally"
    end
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
