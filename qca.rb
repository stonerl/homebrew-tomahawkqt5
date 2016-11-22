require "formula"

class Qca < Formula
  version "2.1.0.3"
  homepage "http://delta.affinix.com/qca/"
  url "http://ftp.uni-kl.de/pub/linux/kde/stable/qca-qt5/#{version}/src/qca-qt5-#{version}.tar.xz"
  sha256 "ab0170696a8ff87588d38a72d36d0b4b42db9080c991d1a40ceb3f8311d289f9"
  head "git://anongit.kde.org/qca.git"

  option "with-api-docs", "Build API documentation"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "qt5"

  # Plugins (QCA needs at least one plugin to do anything useful)
  depends_on "openssl" # qca-ossl
  depends_on "botan" => :optional # qca-botan
  depends_on "libgcrypt" => :optional # qca-gcrypt
  depends_on "gnupg" => :optional # qca-gnupg
  depends_on "nss" => :optional # qca-nss
  depends_on "pkcs11-helper" => :optional # qca-pkcs11

  if build.with? "api-docs"
    depends_on "graphviz" => :build
    depends_on "doxygen" => [:build, "with-dot"]
  end

  # Fixes build with Qt 5.5 by adding a missing include (already fixed in HEAD).
  patch do
    url "http://quickgit.kde.org/?p=qca.git&a=commitdiff&h=7207e6285e932044cd66d49d0dc484666cfb0092&o=plain"
    sha256 "b3ab2eb010f4a16f85349e4b858d0ee17a84ba2927311b79aeeff1bb2465cd3d"
  end

  def install
    args = std_cmake_args
    args << "-DQT4_BUILD=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DOSX_FRAMEWORK=OFF"

    # Plugins (qca-ossl, qca-cyrus-sasl, qca-logger, qca-softstore always built)
    args << "-DWITH_botan_PLUGIN=#{build.with?("botan") ? "YES" : "NO"}"
    args << "-DWITH_gcrypt_PLUGIN=#{build.with?("libgcrypt") ? "YES" : "NO"}"
    args << "-DWITH_gnupg_PLUGIN=#{build.with?("gnupg") ? "YES" : "NO"}"
    args << "-DWITH_nss_PLUGIN=#{build.with?("nss") ? "YES" : "NO"}"
    args << "-DWITH_pkcs11_PLUGIN=#{build.with?("pkcs11-helper") ? "YES" : "NO"}"

    system "cmake", ".", *args
    system "make", "install"

    if build.with? "api-docs"
      system "make", "doc"
      doc.install "apidocs/html"
    end
  end

  test do
    system "#{bin}/qcatool", "--noprompt", "--newpass=",
                             "key", "make", "rsa", "2048", "test.key"
  end
end
