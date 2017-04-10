default:
	pandoc -s -o index.html --css style.css --template pandoc-template.html index.md
	pandoc -s -o posts/2016-09-23-blog-ueber-ipfs-pinnen.html --css ../style.css --template pandoc-template.html posts/2016-09-23-blog-ueber-ipfs-pinnen.md
	pandoc -s -o posts/2017-03-18-mailcap.html --css ../style.css --template pandoc-template.html posts/2017-03-18-mailcap.md
	pandoc -s -o posts/2017-04-11-gnupg-fetch-missing-key-ids.html --css ../style.css --template pandoc-template.html posts/2017-04-11-gnupg-fetch-missing-key-ids.md
	pandoc -s -o impressum.html impressum.md

publish:
	make default
	ipfs name publish `ipfs add -r -q ../ | tail -n 1`
