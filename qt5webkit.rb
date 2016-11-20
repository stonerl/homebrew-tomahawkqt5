require "formula"

class Qt5webkit < Formula
  version "5.7.0"
  url "http://download.qt.io/community_releases/#{version.to_s.slice(0..-3)}/#{version}/qtwebkit-opensource-src-#{version}.tar.xz"
  sha256 "c7a3253cbf8e6035c54c3b08d8a9457bd82efbce71d4b363c8f753fd07bd34df"

  depends_on "qt5"

  def install
    qmake_args = ["-config", "release", "PREFIX=/"]
    system "qmake", *qmake_args
    system "make"
    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end
end
