From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix return value check of extent_io_ops
Date: Thu, 16 Feb 2012 10:11:40 +0900
Message-ID: <201202160111.AA00043@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the check on the return value of extent_io_ops.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent_io.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fcf77e1..a84621f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2154,9 +2154,10 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		 "this_mirror=%d, num_copies=%d, in_validation=%d\n", read_mode,
 		 failrec->this_mirror, num_copies, failrec->in_validation);
 
-	tree->ops->submit_bio_hook(inode, read_mode, bio, failrec->this_mirror,
-					failrec->bio_flags, 0);
-	return 0;
+	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
+					 failrec->this_mirror,
+					 failrec->bio_flags, 0);
+	return ret;
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
@@ -2779,9 +2780,12 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 				delalloc_start = delalloc_end + 1;
 				continue;
 			}
-			tree->ops->fill_delalloc(inode, page, delalloc_start,
-						 delalloc_end, &page_started,
-						 &nr_written);
+			ret = tree->ops->fill_delalloc(inode, page,
+						       delalloc_start,
+						       delalloc_end,
+						       &page_started,
+						       &nr_written);
+			BUG_ON(ret);
 			/*
 			 * delalloc_end is already one less than the total
 			 * length, so we don't subtract one from

