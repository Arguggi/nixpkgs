{ stdenv
, lib
, pandoc
, esbuild
, deno
, fetchurl
, nodePackages
, rWrapper
, rPackages
, makeWrapper
, python3
}:

stdenv.mkDerivation rec {
  pname = "quarto";
  version = "1.2.280";
  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${version}/quarto-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-mbChS3GL36ySWo2jDZGJIDZIkBJ/UDUmypJjP5HW6KE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  patches = [
    ./fix-deno-path.patch
  ];

  postPatch = ''
    # Compat for Deno >=1.26
    substituteInPlace bin/quarto.js \
      --replace 'Deno.setRaw(stdin.rid, ' 'Deno.stdin.setRaw(' \
      --replace 'Deno.setRaw(Deno.stdin.rid, ' 'Deno.stdin.setRaw('
  '';

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --prefix PATH : ${lib.makeBinPath [ deno ]} \
      --prefix QUARTO_PANDOC : ${pandoc}/bin/pandoc \
      --prefix QUARTO_ESBUILD : ${esbuild}/bin/esbuild \
      --prefix QUARTO_DART_SASS : ${nodePackages.sass}/bin/sass \
      --prefix QUARTO_R : ${rWrapper.override { packages = [ rPackages.rmarkdown]; }}/bin/R \
      --prefix QUARTO_PYTHON : ${python3.withPackages (ps: with ps; [ jupyter ipython ])}/bin/python3
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share

      rm -r bin/tools

      mv bin/* $out/bin
      mv share/* $out/share

      runHook preInstall
  '';

  meta = with lib; {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    longDescription = ''
        Quarto is an open-source scientific and technical publishing system built on Pandoc.
        Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mrtarantoga ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
  };
}
