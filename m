From: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] btrfs: enable discard support
Date: Wed, 14 Oct 2009 03:03:02 +0200
Message-ID: <20091014010302.GA21031@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The discard support code in btrfs currently is guarded by ifdefs for
BIO_RW_DISCARD, which is never defines as it's the name of an enum
memeber.  Just remove the useless ifdefs to actually enable the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/extent-tree.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent-tree.c	2009-10-07 11:04:18.451256181 -0400
+++ linux-2.6/fs/btrfs/extent-tree.c	2009-10-07 11:04:26.225005458 -0400
@@ -1568,19 +1568,16 @@ static int remove_extent_backref(struct 
 	return ret;
 }
 
-#ifdef BIO_RW_DISCARD
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
 			     DISCARD_FL_BARRIER);
 }
-#endif
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 				u64 num_bytes)
 {
-#ifdef BIO_RW_DISCARD
 	int ret;
 	u64 map_length = num_bytes;
 	struct btrfs_multi_bio *multi = NULL;
@@ -1604,9 +1601,6 @@ static int btrfs_discard_extent(struct b
 	}
 
 	return ret;
-#else
-	return 0;
-#endif
 }
 
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
