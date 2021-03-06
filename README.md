# Arctic Porn Vault Manager

APVault-mgr is a utility to assist in growing, weeding, and managing extremely large porn collections. Cut through your torrent backlog quickly!

![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fkermieisinthehouse%2Fapvault-mgr&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)

## Requirements
- bash
- unzip
- unrar
- 7z
- rsync

## Get Started

You need to edit the top of `apvault` to point to your collection, and review `definitions/bannedKeywords.lst` to your tastes.

## Usage

```
# Grab a copy from git
$ git clone https://github.com/kermieisinthehouse/apvault-mgr

# Ingest a path's contents into the vault, you will be prompted for a destination.
# This automatically runs lint-roller and decompression.
$ ./apvault ingest MyFavoriteCamgirl/

# Run the lint roller on a path
$ ./apvault lint-roll Downloads/

# Recursively decompress all archives in a directory
$ ./apvault decompress Photo_Archives_2009/

# Recursively move all images to a new path, keeping directory structure
$ ./apvault copy-images MyMixedMedia/ MyPhotos/
$ mv MyMixedMedia MyVideos
```

## Lint-rolling your collection
The lint roller is a powerful, configurable system for automatically cleaning your large collection of genres you don't want to collect, and screenshots and other filesystem detritus. Megapacks give you stuff you don't want? The file `definitions/bannedKeywords.lst` accepts emacs-style regexes that will be searched-and-destroyed in paths and filenames. For example, to rid your library of unwanted adult diaper content, simply adding the line `adult.?diaper` and running the lint-roller is often enough. The file `definitions/derivedContentKeywords.lst` contains regexes for items such as screenshots, thumbnails, and contact sheets. You can run the lint-roller over your existing collection, and it runs automatically over new content as it's being ingested. 

```
$ apvault lint-roll ~/myPorn
APVault: Run the lint roller on "~/myPorn"? This is a destructive action. (y/n): y
APVault: Loaded 453 banned regexes, searching and destroying matches in ~/myPorn
Lint-rolling scat-fetish-video.mp4.
Lint-rolling solo-male-video.mp4.
Lint-rolling vomit-gangbang.avi.

APVault: Pruning content-derived files...
Lint-rolling myPorn/Thumbs.db
Lint-rolling myPorn/.MACOSX
Lint-rolling myPorn/Screencaps.
Lint-rolling myPorn/Screencaps/qcpblRg5LOzhjW7tjlTD5mrnLBTlqLtb.mp4.jpg.
Lint-rolling myPorn/Screencaps/HkKoCJjwmATMVGhjoSIF2S4BS8rk7BSe.mp4.jpg.
Lint-rolling myPorn/Screencaps/UosOsp7nOycEUIQlgauZhPWNtmBxqFme.mp4.jpg.
Lint-rolling myPorn/Screencaps/0e6b14dddb465270d870801c05ae620d.mp4.jpg.
Lint-rolling myPorn/Screencaps/5ec4699a6d25aff1664b9_720p.mp4.jpg.
```

## Theory of Operation
These tools were developed to help manage a library of 7+ million items.
Ingesting a path involves decompressing all archives, deleting unwanted files (see lint-rolling above), and copying files into a vault's structure, separating photos from other files. Images are separated to keep filesystem listings small in the video directory, so that scans of other tools `(stash, ncdu, du, find)` can be performant over very large collections.

### Recommendations
For browsing your content and logical organization, I recommend AGPL-Licensed [Stash](https://github.com/stashapp/stash). 
For a filesystem to store hundreds of terabytes, I always recommend [ZFS](https://github.com/openzfs/zfs).

## Contributing
Pull requests are welcome. Make sure any changes have zero warnings from shellcheck.

## License
GPL3 Licensed.
Copyright 2020 kermie@arcticpornvault.org
