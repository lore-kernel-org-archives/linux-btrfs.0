From: Kyungmin Park <kmpark@infradead.org>
Subject: Question: Build btrfs filesystem from specific directory.
Date: Sat, 12 Jun 2010 11:20:11 +0900
Message-ID: <AANLkTimbW5pNGsFxRZYRRjY0Ke-Wyb4aaBkUZgilVMlR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I'm not sure it's correct mailing list. but I can't find a btrfs-progs
mailing list.

I'm founding the solution to build btrfs filesystem image from
specific directory.
it's common concept at mobile build environment.
e.g., ubifs and cramfs support this feature.

In case of ubifs
-r, -d, --root=DIR       build file system from directory DIR
In case of cramfs
dirname    root of the filesystem to be compressed

But btrfs doesn't support it.
usage: mkfs.btrfs [options] dev [ dev ... ]
options:
         -A --alloc-start the offset to start the FS
         -b --byte-count total number of bytes in the FS
         -d --data data profile, raid0, raid1, raid10 or single
         -l --leafsize size of btree leaves
         -L --label set a label
         -m --metadata metadata profile, values like data profile
         -n --nodesize size of btree nodes
         -s --sectorsize min block allocation
Btrfs v0.19-16-g075587c-dirty

So does it have any plan to support this feature at btrfs?

Thank you,
Kyungmin Park
