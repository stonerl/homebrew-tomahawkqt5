require 'formula'

class Qca < Formula
  homepage 'http://delta.affinix.com/qca/'
  head 'svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qca'
#  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.3.tar.bz2'
  sha1 '9c868b05b81dce172c41b813de4de68554154c60'

  depends_on 'cmake' => :build
  depends_on 'qt5'

  # Fix for clang adhering strictly to standard, see http://clang.llvm.org/compatibility.html#dep_lookup_bases
  # See upstream report: https://bugs.kde.org/show_bug.cgi?id=307470
#  def patches
#    {:p3 =>
#      'http://websvn.kde.org/trunk/kdesupport/qca/src/botantools/botan/botan/secmem.h?r1=1273508&r2=1273507&pathrev=1273508&view=patch'
#    }
#  end

  def install
    qtpluginsdir = `qmake -query QT_INSTALL_PLUGINS`
    system "cmake -DQT_PLUGINS_DIR=#{qtpluginsdir}", ".", *std_cmake_args
    system "make install"
  end
end
