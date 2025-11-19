class Gamenetworkingsockets < Formula
  desc "Valve's transport-layer networking library with NAT traversal"
  homepage "https://github.com/ValveSoftware/GameNetworkingSockets"
  url "https://github.com/ValveSoftware/GameNetworkingSockets/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "1cfb2bf79c51a08ae4e8b7ff5e9c1266b43cfff6f53ecd3e7bc5e3fcb2a22503"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"
  depends_on "protobuf"

  def install
    # 🚨 Turn off Homebrew compiler shims
    ENV["HOMEBREW_NO_SHIMS"] = "1"

    # 🚨 Force unfiltered system compiler
    ENV["CC"] = "/usr/bin/clang"
    ENV["CXX"] = "/usr/bin/clang++"

    # 🚨 Force correct flags
    ENV["CXXFLAGS"] = "-std=c++17 -stdlib=libc++"
    ENV["SDKROOT"] = MacOS.sdk_path_if_needed

    args = %W[
      -GNinja
      -DCMAKE_BUILD_TYPE=Release
      -DUSE_CRYPTO=OpenSSL
      -DBUILD_TESTS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TOOLS=OFF
      -DENABLE_ICE=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DProtobuf_PROTOC_EXECUTABLE=#{Formula["protobuf"].opt_bin}/protoc
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install Dir["build/lib/cmake/GameNetworkingSockets"]
  end
end
