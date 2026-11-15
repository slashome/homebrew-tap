class Wally < Formula
  desc "Rotates your wallpapers, screen by screen, from a small daemon"
  homepage "https://github.com/slashome/wally"
  url "https://github.com/slashome/wally/releases/download/v0.0.1/wally-v0.0.1-universal-apple-darwin.tar.gz"
  sha256 "26cb4c73fd4fa82f5f83237038c2ca496e585fd45c3bbc8da36419ff4a5eb9b5"
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
