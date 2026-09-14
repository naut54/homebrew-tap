class Fsapp < Formula
  desc "Operational CLI (fsapp) and config CLI (fset) for copy/mv/sync/watch/compress/analyze/remove, backed by file-engine"
  homepage "https://github.com/naut54/fsapp"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/naut54/fsapp/releases/download/v0.9.0/fsapp-aarch64-apple-darwin.tar.xz"
      sha256 "ace4c320fef19bd4256d5bd66cb927368b89af4fd764f5bec9fc04fd66bd519e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/naut54/fsapp/releases/download/v0.9.0/fsapp-x86_64-apple-darwin.tar.xz"
      sha256 "158dc9087d3800c172e309b94902bc6adf86d05c4d4ce480c5ff12067b590213"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/naut54/fsapp/releases/download/v0.9.0/fsapp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "39e22508629b66c18673ca9f087369fd7d15dff428b19d3c8d9b00d997eb0a50"
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

    generate_completions_from_executable(bin/"fsapp", "completions")
    generate_completions_from_executable(bin/"fset", "completions")

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
