From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 07/10] Btrfs: do not bother to defrag an extent if it is a big real extent
Date: Tue, 27 Mar 2012 14:44:35 +0800
Message-ID: <1332830678-3992-8-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

$ mkfs.btrfs /dev/sdb7
$ mount /dev/sdb7 /mnt/btrfs/ -oautodefrag
$ dd if=/dev/zero of=/mnt/btrfs/foobar bs=4k count=10 oflag=direct 2>/dev/null
$ filefrag -v /mnt/btrfs/foobar
Filesystem type is: 9123683e
File size of /mnt/btrfs/foobar is 40960 (10 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0     3072              10 eof
/mnt/btrfs/foobar: 1 extent found

Now we have a big real extent [0, 40960), but autodefrag will still defrag it.

$ sync
$ filefrag -v /mnt/btrfs/foobar
Filesystem type is: 9123683e
File size of /mnt/btrfs/foobar is 40960 (10 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0     3082              10 eof
/mnt/btrfs/foobar: 1 extent found

So if we already find a big real extent, we're ok about that, just skip it.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 66a4933..7a6d15c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1126,12 +1126,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		if (!(inode->i_sb->s_flags & MS_ACTIVE))
 			break;
 
-		if (!newer_than &&
-		    !should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
-					PAGE_CACHE_SIZE,
-					extent_thresh,
-					&last_len, &skip,
-					&defrag_end)) {
+		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
+					 PAGE_CACHE_SIZE, extent_thresh,
+					 &last_len, &skip, &defrag_end)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
1.6.5.2

