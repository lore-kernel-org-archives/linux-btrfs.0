Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2FSO6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 10:58:24 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com,
        chris.mason@fusionio.com
Subject: [PATCH] Btrfs: fix dio write vs buffered read race
Date: Tue, 19 Jun 2012 10:58:09 -0400
Message-Id: <1340117889-28697-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao pointed out there's a problem with mixing dio writes and buffered
reads.  If the read happens between us invalidating the page range and
actually locking the extent we can bring in pages into page cache.  Then
once the write finishes if somebody tries to read again it will just find
uptodate pages and we'll read stale data.  So we need to lock the extent and
check for uptodate bits in the range.  If there are uptodate bits we need to
unlock and invalidate again.  This will keep this race from happening since
we will hold the extent locked until we create the ordered extent, and then
teh read side always waits for ordered extents.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d8c45d..9b631eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6360,12 +6360,32 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		 */
 		ordered = btrfs_lookup_ordered_range(inode, lockstart,
 						     lockend - lockstart + 1);
-		if (!ordered)
+
+		/*
+		 * We need to make sure there are no buffered pages in this
+		 * range either, we could have raced between the invalidate in
+		 * generic_file_direct_write and locking the extent.  The
+		 * invalidate needs to happen so that reads after a write do not
+		 * get stale data.
+		 */
+		if (!ordered && (!writing ||
+		    !test_range_bit(&BTRFS_I(inode)->io_tree,
+				    lockstart, lockend, EXTENT_UPTODATE, 0,
+				    cached_state)))
 			break;
+
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				     &cached_state, GFP_NOFS);
-		btrfs_start_ordered_extent(inode, ordered, 1);
-		btrfs_put_ordered_extent(ordered);
+
+		if (ordered) {
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+		} else {
+			invalidate_mapping_pages(file->f_mapping,
+						 lockstart >> PAGE_CACHE_SHIFT,
+						 lockend >> PAGE_CACHE_SHIFT);
+		}
+
 		cond_resched();
 	}
 
-- 
1.7.7.6

