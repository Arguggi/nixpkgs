# Extension with Python 2 packages that is overlayed on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self; with super; {
  attrs = callPackage ../development/python2-modules/attrs { };

  bootstrapped-pip = toPythonModule (callPackage ../development/python2-modules/bootstrapped-pip { });

  cffi = callPackage ../development/python2-modules/cffi { inherit cffi; };

  configparser = callPackage ../development/python2-modules/configparser { };

  contextlib2 = callPackage ../development/python2-modules/contextlib2 { };

  coverage = callPackage ../development/python2-modules/coverage { };

  enum = callPackage ../development/python2-modules/enum { };

  filelock =  callPackage ../development/python2-modules/filelock { };

  futures = callPackage ../development/python2-modules/futures { };

  hypothesis = callPackage ../development/python2-modules/hypothesis { };

  importlib-metadata = callPackage ../development/python2-modules/importlib-metadata { };

  jinja2 = callPackage ../development/python2-modules/jinja2 { };

  markupsafe = callPackage ../development/python2-modules/markupsafe { };

  mock = callPackage ../development/python2-modules/mock { };

  more-itertools = callPackage ../development/python2-modules/more-itertools { };

  packaging = callPackage ../development/python2-modules/packaging { };

  pip = callPackage ../development/python2-modules/pip { };

  pluggy = callPackage ../development/python2-modules/pluggy { };

  pycairo = callPackage ../development/python2-modules/pycairo {
    inherit (pkgs.buildPackages) meson;
  };

  pygobject2 = callPackage ../development/python2-modules/pygobject { };

  pygtk = callPackage ../development/python2-modules/pygtk { };

  pyparsing = callPackage ../development/python2-modules/pyparsing { };

  pytest = pytest_4;

  pytest_4 = callPackage
    ../development/python2-modules/pytest {
      # hypothesis tests require pytest that causes dependency cycle
      hypothesis = self.hypothesis.override {
        doCheck = false;
      };
    };

  pytest-xdist = callPackage ../development/python2-modules/pytest-xdist { };

  recoll = disabled super.recoll;

  rivet = disabled super.rivet;

  rpm = disabled super.rpm;

  scandir = callPackage ../development/python2-modules/scandir { };

  sequoia = disabled super.sequoia;

  setuptools = callPackage ../development/python2-modules/setuptools { };

  setuptools-scm = callPackage ../development/python2-modules/setuptools-scm { };

  typing = callPackage ../development/python2-modules/typing { };

  zeek = disabled super.zeek;

  zipp = callPackage ../development/python2-modules/zipp { };

}
