{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cups,
  rpm,
  cpio,
}:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.25";

  src = fetchurl {
    # To find the most recent version go to
    # https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr2.php
    # and retreive the download link for source package for x86 CPU
    url = "https://download3.ebz.epson.net/dsc/f/03/00/16/60/34/8e2b40dc2a02ae67c82b2c55786159f07edf3f5a/epson-inkjet-printer-escpr2-1.2.25-1.src.rpm";
    sha256 = "sha256-rhNv6Ak83KG5SmdVUyu/2UXTB0BTj4yDyKRO++9q8WY=";
  };

  unpackPhase = ''
    runHook preUnpack

    rpm2cpio $src | cpio -idmv
    tar xvf ${pname}-${version}-1.tar.gz
    cd ${pname}-${version}

    runHook postUnpack
  '';

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoreconfHook
    rpm
    cpio
  ];

  patches = [
    # Fixes "implicit declaration of function" errors
    # source of patch: https://aur.archlinux.org/packages/epson-inkjet-printer-escpr2
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/bug_x86_64.patch?h=epson-inkjet-printer-escpr2&id=575d1b959063044f233cca099caceec8e6d5c02f";
      sha256 = "sha256-G6/3oj25FUT+xv9aJ7qP5PBZWLfy+V8MCHUYucDhtzM=";
    })
  ];

  configureFlags = [
    "--with-cupsfilterdir=${builtins.placeholder "out"}/lib/cups/filter"
    "--with-cupsppddir=${builtins.placeholder "out"}/share/cups/model"
  ];

  meta = with lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ma9e
      ma27
      shawn8901
    ];
    platforms = platforms.linux;
  };
}
