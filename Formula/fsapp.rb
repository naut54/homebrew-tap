class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress/analyze/remove, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.10.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "005ef5cebeae16f90a04a5e917530ee4a14e302fc82b5e9af2edd93a50bf638a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.10.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "37ec370ced23aa0a9028459f6f8ca55c85f513e428d31559c51ae569817d6680"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.10.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a4657c6c2ad332094636aea9b62f8c9f1ab6e9ad0fc2add6767db0f17a214688"
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
