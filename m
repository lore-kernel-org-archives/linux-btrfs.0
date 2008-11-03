From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] Fix call to blkdev_issue_discard
Date: Mon, 3 Nov 2008 16:29:09 +0100
Message-ID: <20081103162909.1330a013@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit 3e6053d76dcbd92b2f9f4ad5ece9bce83149523e adds a gfp_mask parameter
to blkdev_issue_discard, which breaks compilation in btrfs if BIO_RW_DISCARD
is config'ed in:

/home/diego/kernel/btrfs-unstable-standalone/extent-tree.c:1896: error:
too few arguments to function 'blkdev_issue_discard'

I added the parameter - GFP_KERNEL, which is what was the gfp_mask used
before this change.


Signed-off-by: Diego Calleja <diegocg@gmail.com>

Index: btrfs-unstable-standalone/extent-tree.c
===================================================================
--- btrfs-unstable-standalone.orig/extent-tree.c	2008-11-03 16:13:29.000000000 +0100
+++ btrfs-unstable-standalone/extent-tree.c	2008-11-03 16:18:23.000000000 +0100
@@ -1891,9 +1891,16 @@
 				map_length = num_bytes;
 
 			for (i = 0; i < multi->num_stripes; i++, stripe++) {
+			#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+				blkdev_issue_discard(stripe->dev->bdev,
+						     stripe->physical >> 9,
+						     map_length >> 9,
+						     GFP_KERNEL);
+			#else
 				blkdev_issue_discard(stripe->dev->bdev,
 						     stripe->physical >> 9,
 						     map_length >> 9);
+			#endif
 			}
 			kfree(multi);
 		}
