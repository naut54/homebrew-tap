class Fset < Formula
  desc "Config CLI for reading/writing fsapp's shared JSON config file"
  homepage "https://github.com/naut54/fsapp"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fset-aarch64-apple-darwin.tar.xz"
      sha256 "8bcf5aa042fb56579c5c1c6e1b5aaf80152684b72542436ab85da26b13983c78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fset-x86_64-apple-darwin.tar.xz"
      sha256 "96bd72c5ae01f4d6e234d1e58db87376455e2fc2fe15f75e254cfc964e6eb5a0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.1.0/fset-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8953cecb4590b5a952624e7b3420c86ec01bd54a47bd343d265a08e459f24d19"
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
    bin.install "fset" if OS.mac? && Hardware::CPU.arm?
    bin.install "fset" if OS.mac? && Hardware::CPU.intel?
    bin.install "fset" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
