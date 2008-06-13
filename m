From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 5/5] btrfs-progs: Script to restructure the source as needed by patch 3
Date: Fri, 13 Jun 2008 16:09:11 -0400
Message-ID: <20080613201008.142663488@suse.com>
References: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

mkdir -p src ib
mkdir -p src/fsck src/debug src/test src/convert src/mkfs src/util

mv *.h *.h.in lib
mv btrfsck.c bit-radix.c src/fsck
mv debug-tree.c src/debug
mv hasher.c {dir,quick,random}-test.c src/test
mv convert.c src/convert
mv mkfs.c src/mkfs
mv btrfsctl.c btrfs-vol.c btrfs-show.c src/util
mv *.c lib

aclocal
libtoolize -c -f
automake --add-missing -c -f
autoconf


