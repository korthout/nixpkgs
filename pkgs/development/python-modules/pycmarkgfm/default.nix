{ lib, buildPythonPackage, fetchPypi, isPy27, cffi, pytest }:

buildPythonPackage rec {
  pname = "pycmarkgfm";
  version = "1.2.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qvTMXpQhC3Yx8LwbQDiELhgdkGzjirKT30N1NkXF5ps=";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  # I would gladly use pytestCheckHook, but pycmarkgfm relies on a native
  # extension (cmark.so, built through setup.py), and pytestCheckHook runs
  # pytest in an environment that does not contain this extension, which fails.
  # cmarkgfm has virtually the same build setup as this package, and uses the
  # same trick: pkgs/development/python-modules/cmarkgfm/default.nix
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/zopieux/pycmarkgfm";
    description = "Bindings to GitHub's Flavored Markdown (cmark-gfm), with enhanced support for task lists";
    changelog = "https://github.com/zopieux/pycmarkgfm/raw/v${version}/CHANGELOG.md";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zopieux ];
  };
}
