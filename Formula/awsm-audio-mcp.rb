class AwsmAudioMcp < Formula
  desc "Native MCP server for the awsm-audio editor (WebSocket link + rmcp). Installs as the `awsm-audio-mcp` command."
  homepage "https://github.com/dakom/awsm-audio"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dakom/awsm-audio/releases/download/v0.1.0/awsm-audio-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d16670e8c6788094bea52d873f7c025942081ab476f056b3155b0867991636a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dakom/awsm-audio/releases/download/v0.1.0/awsm-audio-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "4ec66c256f751b0a774a46cc52d210f22705f21ddf63841a4c280949c42984d6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/dakom/awsm-audio/releases/download/v0.1.0/awsm-audio-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "94d31cafaa35ab2eb183db7cd72507d4f710e64e7597f4cc5a0f94612c2f94df"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "awsm-audio-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "awsm-audio-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "awsm-audio-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
