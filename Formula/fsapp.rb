class Fsapp < Formula
  desc "Operational CLI for copy/mv/sync/watch/compress, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "dfa4232ccdf052263c8824cc46420db9d1248397997d1740584f0651a3533d79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "44ba33d1d6e9455ba9e410a7f5dd315365a5c94da732133245e033aec2f1eb71"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ce235f01fc11b24392ff1f4e10e183f3c397727aebf227ebbbc2ff9f4e8f0ec4"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "fsapp" if OS.mac? && Hardware::CPU.arm?
    bin.install "fsapp" if OS.mac? && Hardware::CPU.intel?
    bin.install "fsapp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
