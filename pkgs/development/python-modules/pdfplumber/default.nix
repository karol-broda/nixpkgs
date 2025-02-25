{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ghostscript,
  jupyterlab,
  nbexec,
  pandas,
  pandas-stubs,
  pdfminer-six,
  pillow,
  pytest-parallel,
  pytestCheckHook,
  pythonOlder,
  types-pillow,
  wand,
}:

buildPythonPackage rec {
  pname = "pdfplumber";
  version = "0.11.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    tag = "v${version}";
    hash = "sha256-oe6lZyQKXASzG7Ho6o7mlXY+BOgVBaACebxbYD+1+x0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=pdfplumber --cov-report xml:coverage.xml --cov-report term" ""
  '';

  propagatedBuildInputs = [
    pdfminer-six
    pillow
    wand
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    ghostscript
    jupyterlab
    nbexec
    pandas
    pandas-stubs
    pytest-parallel
    pytestCheckHook
    types-pillow
  ];

  pythonImportsCheck = [ "pdfplumber" ];

  disabledTests = [
    # flaky
    "test__repr_png_"
  ];

  disabledTestPaths = [
    # Tests requires pypdfium2
    "tests/test_display.py"
    # Tests requires pypdfium2
    "tests/test_issues.py"
  ];

  meta = with lib; {
    description = "Plumb a PDF for detailed information about each char, rectangle, line, et cetera — and easily extract text and tables";
    mainProgram = "pdfplumber";
    homepage = "https://github.com/jsvine/pdfplumber";
    changelog = "https://github.com/jsvine/pdfplumber/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
