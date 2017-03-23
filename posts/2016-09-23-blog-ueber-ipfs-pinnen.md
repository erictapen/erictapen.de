---
title: Diesen Blog über IPFS pinnen
---

**Hinweis**: In der Zwischenzeit hat sich mein IPNS-Link geändert. Der Blog liegt gerade unter 
```
/ipns/QmbVNTvtyTgsaAmqzegfo4XXoJ1szghFEr8ZsmNvg2M9SB/erictapen.de/
```

## Einleitendes über IPFS

Dieser Blog wird über das Inter Planetary File System ([IPFS](https:ipfs.io)) gehostet. Das bedeutet, dass die Webseite nicht auf einem zentralen Server liegt, sondern verteilt in einem Peer-to-Peer-Netzwerk. Fragt man das Netzwerk nach dieser Webseite, so bekommt man sie von dem nächsten Knoten, der sie hat. Das kann der Mensch nebenan sein oder jemand auf der anderen Seite der Welt, je nachdem welche Peers die Datei gespeichert haben.

Im IPFS-Netzwerk werden alle Dateien über einen Hash benannt. Der Hash ist eine Art Fingerabdruck der Datei, so das ein Hash nur eine bestimmte Datei benennen kann. Zum Beispiel führt der Hash 

```QmPZ9gcCEpqKTo6aq61g2nXGUhM4iCL3ewB6LDXZCtioEB```

zu einer Datei, die einige einleitende Informationen zu IPFS liefert. Ändert sich die Datei, ändert sich auch ihr Hash. Es ist unmöglich, eine andere Datei als diese untergejubelt zu bekommen, wenn man das Netzwerk nach diesem Hash fragt. 

An dem Netzwerk kann nur teilnehmen, wer einen Knoten betreibt. Da in den meisten Webbrowsern kein IPFS-Knoten enthalten ist, erfolgt der Zugriff über einen sogenannten Gateway. Um den Gateway nach dem Hash zu fragen, ruft man die Webseite 

```https://gateway.ipfs.io/ipfs/QmPZ9gcCEpqKTo6aq61g2nXGUhM4iCL3ewB6LDXZCtioEB```

auf.

Da es unpraktisch wäre, nur Dateien bezeichnen zu können, deren Inhalt sich nicht mehr ändern kann, gibt es zusätzlich das IPNS, das Inter Planetary Naming System. Dieses ermöglicht es, dynamische Links zu bereitstellen. Mein Blog ist somit unter 

```https://gateway.ipfs.io/ipns/Qmf9saZtWETq6eUgEtRHyvek1Q2m7m4ndLBQ5idym1WsRv/```

erreichbar. Man achte auf das "ipns" im Link, statt "ipfs". Dieser Link zeigt auf einen IPFS-Hash, der den aktuellen Stand meines Blogs repräsentiert. Ändert sich mein Blog, kann ich (und nur ich) diese Referenz auf den neuesten Stand bringen, so dass der Link immer auf die neueste Version meines Blogs verweisen wird.

## Installation

Um mehr Funktionen als nur das Abrufen von Dateien zu nutzen, muss man IPFS lokal installieren. Da IPFS noch in keiner mir bekannten Paketverwaltung paketiert ist, muss man sich die Binärdatei manuell runterladen. Das geht [hier](https://dist.ipfs.io/#go-ipfs). Liegt die Datei entpackt auf dem Rechner, kann man mit

```ipfs init```

den eigenen Knoten initialisieren. Damit der Knoten sich an das Netzwerk anbindet, muss zusätzlich

```ipfs daemon```

ausgeführt werden.

## Pinnen

Solange `ipfs daemon` läuft, ist der Knoten an das Netzwerk angebunden. Der Prozess, eine Datei permanent zu spiegeln und anderen Knoten des Netzwerks bereitzustellen nennt sich pinnen. Dies ist der Befehl, der meinen Blog pinnt:

```ipfs pin add /ipns/erictapen.de```

Beim pinnen muss natürlich der Daemon laufen. Solange er läuft, wird die Datei auch anderen Knoten im Netzwerk bereitgestellt. Wird der Daemon heruntergefahren und wieder gestartet, wird die Datei weiterhin bereitgestellt, weil sie lokal auf Deiner Festplatte gespeichert wurde.

## Warum der Aufwand?

IPFS unterscheidet sich stark von der bisherigen Funktion des World Wide Web und das hat seinen Grund. Der traditionelle Weg, Webseiten zu verbreiten bringt einige technische und gesellschaftliche Probleme mit sich, die ich vielleicht irgendwann einmal in einem weiteren Blogeintrag ansprechen werden. Fürs erste findet sich jedoch [hier](https://gateway.ipfs.io/ipfs/QmRaS4AZriMzw9nekub7hojTnvQYsVTDqkYG7BggQsexNt/#why) hier gute Zusammenfassung.
