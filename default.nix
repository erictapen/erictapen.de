with import <nixpkgs> {};
#{pkgs, stdenv, buildEnv, ...}:

stdenv.mkDerivation {
  name = "erictapen.de";

  src = ./.;
  
  propagatedBuildInputs = with pkgs; [
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
    pandoc -s -o $out/impressum.html impressum.md
    cp pub.asc $out/pub.asc
    cp style.css $out/style.css
    cp tuebix.flf $out/tuebix.flf
    cp wikipedia-tree-alpha.png $out/wikipedia-tree-alpha.png
    cp wikipedia-tree.png $out/wikipedia-tree.png
  '';
}
