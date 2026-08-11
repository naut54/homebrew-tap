class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.4.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "beb23850df02f889cbec05ce6e8636cfab7b6ac6a442c9695889c124c6a908a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.4.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "c2dd3fb93eabff1930f338be321abc9cd5d93b0728a54e30a9df6766880c8cba"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.4.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "926913938a053ef6adbd80b57131edb7a1ab1776c665ee4a1dddaed604271a39"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fsapp", "fset"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fsapp", "fset"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fsapp", "fset"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
