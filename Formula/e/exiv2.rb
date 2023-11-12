class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "3078651f995cb6313b1041f07f4dd1bf0e9e4d394d6e2adc6e92ad0b621291fa"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df28a8d73ace94bf7eec6870222375b91d567fd210a863dac0d6935fc92d4cbd"
    sha256 cellar: :any,                 arm64_ventura:  "b8bf182b90d97afa7440cd1614a51b48c6a1a3b43ac7d5c4ac6013ab80fb1137"
    sha256 cellar: :any,                 arm64_monterey: "333f89f2cf93031046718a29a228050d431272e818fe1d89687c3e1981b23884"
    sha256 cellar: :any,                 arm64_big_sur:  "151aeb245e05e2e0a8f46da4979d0233a5820aea34e22fe191913f5499c259db"
    sha256 cellar: :any,                 sonoma:         "30083e09e6cd35bca0141e3efcee36b4b599ceefeae1b9b71b3a6e9c846cbbe0"
    sha256 cellar: :any,                 ventura:        "22a09bf8a504f1ec3c19c4e7e52c47615c37412a8acdd4ec13dddac767f54b79"
    sha256 cellar: :any,                 monterey:       "80c73e17a8d67741cf13b02959f1fcbe09c64126c469c465a8fa101907c22b9c"
    sha256 cellar: :any,                 big_sur:        "878bfea27f1f04e01bbeca7203f26a7732cece76cfebf6d1a2b6a71fade9d13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7613f59e7848995120cf631b90509f45628195a9c18882464594a791f311dd2"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "gettext"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      ..
    ]

    system "cmake", "-G", "Unix Makefiles", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
