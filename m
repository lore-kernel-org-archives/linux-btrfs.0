From: "Michael Niederle" <mniederle@gmx.at>
Subject: severe hardlink bug
Date: Sun, 24 Jan 2010 01:51:38 +0100
Message-ID: <20100124015138.092c4959@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs with a kernel 2.6.32.2 (builtin) as the root file system of a
Gentoo Linux installation.

While attempting to install the plt-scheme package a strange error about link
counts occurred ([Error 31] Too many Links).

I was able to create a simple scenario to reproduce the error:

Create an empty directory and run the following script within the directory:

#!/bin/bash

echo "abc" >.tab-snip-class_scrbl.dep._portage_merge_.9766
for x in $(seq 80)
do echo $x; ln .tab-snip-class_scrbl.dep._portage_merge_.9766 \
.tab-snip-class_scrbl.dep._portage_merge_.9766.$x; done


(The names are taken from the original Gentoo package.)

When I run this script the first 66 links are created properly. All further
link creations fail:

...
63
64
65
66
67
ln: creating hard link to `.tab-snip-class_scrbl.dep._portage_merge_.9766': Too
many links 68
ln: creating hard link to `.tab-snip-class_scrbl.dep._portage_merge_.9766': Too
many links 69
ln: creating hard link to `.tab-snip-class_scrbl.dep._portage_merge_.9766': Too
many links 70
ln: creating hard link to `.tab-snip-class_scrbl.dep._portage_merge_.9766': Too
many links
...


I was able to reproduce the bug independently on two different machines.

During earlier tests I determined that filename length has an effect as well as
the link count.

Greetings, Michael
