
default:
	make clean
	pandoc -s -o www/index.html --css style.css --template pandoc-template.html index.md
	pandoc -s -o www/2016-09-23-blog-ueber-ipfs-pinnen.html --css style.css --template pandoc-template.html posts/2016-09-23-blog-ueber-ipfs-pinnen.md
	pandoc -s -o www/impressum.html impressum.md
	cp pub.asc www/pub.asc
	cp impressum.png www/impressum.png
	cp wikipedia-tree.png www/wikipedia-tree.png
	cp style.css www/style.css
	ipfs add -r www/
	firefox http://ipfs.io/ipfs/`ipfs add --quiet -r www/ | tail -n 1` &
	du -h www/

clean:
	rm -rf www/*

publish:
	make default
	ipfs name publish `ipfs add -r -q www/ | tail -n 1`
