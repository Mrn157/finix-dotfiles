{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-icon-theme";
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "m4thewz";
    repo = "dracula-icons";
    rev = "9404538dd67932832557616012c3a1f083b5a1d6";
    hash = "sha256-MT6R9Lm90KqE7d01JnGA8SChrHZsNiigWCGUBZ2Tp9c=";
  };

  nativeBuildInputs = [
    jdupes
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Dracula
    cp -a * $out/share/icons/Dracula/
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ therealr5 ];
  };
}
