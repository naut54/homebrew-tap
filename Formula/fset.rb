class Fset < Formula
  desc "Config CLI for reading/writing fsapp's shared JSON config file"
  homepage "https://github.com/naut54/fsapp"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.1/fset-aarch64-apple-darwin.tar.xz"
      sha256 "d6c0a4c9fcb1a3cba35b6e915ee28983de6c7a932a929d74d92a1c50a7f42f36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.1.1/fset-x86_64-apple-darwin.tar.xz"
      sha256 "e1adef69479504c525f4b2389946cd18ba01a4836faf2c22bc7acb5f210554f9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.1.1/fset-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "64dcd410021f1be0419f46b792d48aeb966478b10e0d46380808f3c4ba8197b5"
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
