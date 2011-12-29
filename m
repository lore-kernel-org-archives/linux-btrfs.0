From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH 0/3] Btrfs: speed up fstrim
Date: Thu, 29 Dec 2011 17:49:01 +0800
Message-ID: <4EFC378D.7090606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(This patchset is not for merge or review, except the first patch)

By remembering which areas have been trimmed, we can speed up
fstrim significantly.

    # fstrim -v /mnt/
    /mnt/: 152772608 bytes were trimmed
    # fstrim -v /mnt/
    /mnt/: 0 bytes were trimmed

To implement this, after a free space item has been trimmed, we
mark it as trimmed before inserting it into free space cache.

(*)If we want to speed up the first fstrim after mounting the filesystem,
we have to save the trimmed flag to disk, which will break backward
compatibility, but only 3.2-rcX kernels will be affected.

That is, if you use fstrim in newest kernel with this patchset applied,
and then you mount the fs in a 3.2-rcX kernel, you may trigger a BUG_ON()
in __load_free_space_cache() sooner or later.

So, is this acceptable?

     # fstrim -v /mnt/
     /mnt/: 267714560 bytes were trimmed
     # fstrim -v /mnt/
     /mnt/: 0 bytes were trimmed
     # sync
     # umount /mnt
     # !mount
     # fstrim -v /mnt/
     /mnt/: 152240128 bytes were trimmed

Because caches for block groups smaller than 100M will not be written
to disk, we'll still have to trim them.

*See this thread for a user request for this feature:
	https://lkml.org/lkml/2011/12/1/24

