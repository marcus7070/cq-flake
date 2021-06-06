{
  gccSet
  , llvm-src
  , pywrap-src
  , ocp-src
  , ocp-stubs-src
  , cadquery-src
  , occt
}: self: super: {

  clang = self.callPackage ./clang.nix {
    src = llvm-src;
    llvmPackages = gccSet.llvmPackages;
  };

  cymbal = self.callPackage ./cymbal.nix { };

  geomdl = self.callPackage ./geomdl.nix { };

  ezdxf = self.callPackage ./ezdxf.nix { };

  sphinx = self.callPackage ./sphinx.nix { };

  nptyping = self.callPackage ./nptyping.nix { };

  typish = self.callPackage ./typish.nix { };

  sphinx-autodoc-typehints = self.callPackage ./sphinx-autodoc-typehints.nix { };

  sphobjinv = self.callPackage ./sphobjinv.nix { };

  stdio-mgr = self.callPackage ./stdio-mgr.nix { };

  sphinx-issues = self.callPackage ./sphinx-issues.nix { };

  sphinxcadquery = self.callPackage ./sphinxcadquery.nix { };

  black = self.callPackage ./black.nix { };

  pybind11 = self.callPackage ./pybind11 { };

  pywrap = self.callPackage ./pywrap {
    src = pywrap-src;
    inherit (gccSet) stdenv gcc llvmPackages;
    # clang is also pinned to 6.0.1 in the clang expression
  };

  pytest-flakefinder = self.callPackage ./pytest-flakefinder.nix { };

  ocp = self.callPackage ./OCP {
    src = ocp-src;
    inherit (gccSet) stdenv gcc llvmPackages;
    opencascade-occt = occt; 
  };

  ocp-stubs = self.callPackage ./OCP/stubs.nix {
    src = ocp-stubs-src;
  };

  cadquery = self.callPackage ./cadquery.nix {
    documentation = false;
    src = cadquery-src;
  };

  cadquery_w_docs = self.callPackage ./cadquery.nix {
    documentation = true;
    src = cadquery-src;
  };

}
