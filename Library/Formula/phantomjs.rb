class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  head "https://github.com/ariya/phantomjs.git"

  stable do
    url "https://github.com/ariya/phantomjs/archive/2.0.0.tar.gz"
    sha256 "0a1338464ca37314037d139b3e0f7368325f5d8810628d9d9f2df9f9f535d407"

    # https://github.com/Homebrew/homebrew/issues/42249
    depends_on MinimumMacOSRequirement => :mountain_lion

    # Qt Yosemite build fix. Upstream commit/PR:
    # https://qt.gitorious.org/qt/qtbase/commit/70e442
    # https://github.com/ariya/phantomjs/pull/12934
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/480b7142c4e2ae07de6028f672695eb927a34875/phantomjs/yosemite.patch"
      sha256 "f54bd1592185f031552d3ad5c8809ff27e8f3be4f1c05c81b59bf7dbc4a59de1"
    end
  end

  bottle do
    cellar :any
    sha1 "f9dd71edb662479e0f832379368d4cd4878f940e" => :yosemite
    sha1 "817ab92d4bfcd5496cf1c59173d48976610e5f70" => :mavericks
    sha1 "887a96e55f67a3d350bc40f910926286c6cea240" => :mountain_lion
  end

  def install
    system "./build.sh", "--confirm", "--jobs", ENV.make_jobs,
      "--qt-config", "-openssl-linked"
    bin.install "bin/phantomjs"
    (share+"phantomjs").install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
