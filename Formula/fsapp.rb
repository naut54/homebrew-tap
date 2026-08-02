class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.2.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "37a4eea4d4472b8a886e87a35c9e8a51652fba446e16aef32968564ac1ad40c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.2.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "092e9b2310f10afb736944f821645a7eac4cce71c62920ed1860f770f1f7bcc0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.2.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0f11e46173b52cc1d91e0ae1ac824b53bfad4b15145982c3146048d7f71bbbf3"
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
    bin.install "fsapp", "fset" if OS.mac? && Hardware::CPU.arm?
    bin.install "fsapp", "fset" if OS.mac? && Hardware::CPU.intel?
    bin.install "fsapp", "fset" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
