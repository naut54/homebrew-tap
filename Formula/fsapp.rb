class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress/analyze/remove, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.8.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "30a5c88bdc2afc825219bff567724906702022b3b2ad26f47e4aa1f722c3b3a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.8.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "03cb2bdd7b6b69d7cd666f652f547e2783faf3e2ab45864fcd185626fde1e8db"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.8.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b6fb45b7de86af14489533defdee2aa44e6c522bc0995aab7e655a6ea98fe56f"
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
