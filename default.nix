with import <nixpkgs> {};
#{pkgs, stdenv, buildEnv, ...}:

stdenv.mkDerivation {
  name = "erictapen.de";

  src = ./.;
  
  buildInputs = with pkgs; [
    pandoc
  ];

  buildPhase = ''
    echo buildfase
  '';

  installPhase = ''
    echo installfase
    mkdir -p $out/posts
    pandoc -s -o $out/index.html --css style.css --template pandoc-template.html index.md

    pandoc -s -o $out/posts/2016-09-23-blog-ueber-ipfs-pinnen.html --css ../style.css --template pandoc-template.html posts/2016-09-23-blog-ueber-ipfs-pinnen.md
    pandoc -s -o $out/posts/2017-03-18-mailcap.html --css ../style.css --template pandoc-template.html posts/2017-03-18-mailcap.md
    pandoc -s -o $out/posts/2017-04-11-gnupg-fetch-missing-key-ids.html --css ../style.css --template pandoc-template.html posts/2017-04-11-gnupg-fetch-missing-key-ids.md
    pandoc -s -o $out/posts/2017-06-29-ii-on-nixos.html --css ../style.css --template pandoc-template.html posts/2017-06-29-ii-on-nixos.md
    mkdir -p $out/posts/2018-03-12-wueste-welle-praktikum/
    cp posts/2018-03-12-wueste-welle-praktikum/*.mp3 $out/posts/2018-03-12-wueste-welle-praktikum/
    pandoc -s -o $out/posts/2018-03-12-wueste-welle-praktikum/index.html --css ../../style.css --template pandoc-template.html posts/2018-03-12-wueste-welle-praktikum/wueste-welle-praktikum.md
    pandoc -s -o $out/impressum.html impressum.md
    cp pub.asc $out/pub.asc
    cp style.css $out/style.css
    cp tuebix.flf $out/tuebix.flf
    cp wikipedia-tree-alpha.png $out/wikipedia-tree-alpha.png
    cp wikipedia-tree.png $out/wikipedia-tree.png
    cp keybase.txt $out/keybase.txt
  '';
}
