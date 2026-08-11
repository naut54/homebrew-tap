class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.3.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "b9f5748d97399f57f2da7ab010c0a68aee55806beed19d8201562734a2936bfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.3.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "c071ffee6929c51fa2d34dd90b6b67acbfe828748912a53b1d63d00042a1678c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.3.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "014b848e4f908f88909f4d03390b35852fb52edf250a93c0742255e7b2141666"
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
