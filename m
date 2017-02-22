Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3040 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750890AbdBVFHq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:07:46 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <bo.li.liu@oracle.com>
Subject: [PATCH v3 1/2] btrfs: ordered-extent: Introduce new bit to skip releasing metadata
Date: Wed, 22 Feb 2017 13:07:13 +0800
Message-ID: <20170222050714.25457-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new bit, BTRFS_ORDERED_SKIP_META for ordered extent to
allow btrfs_finish_ordered_io() to skip releasing metadata.

There are two sources for fill_delalloc() to release metadata:
1) extent_clear_unlock_delalloc()
   When EXTENT_DO_ACCOUNTING control bit is going to be cleared, we will
   free metadata.
2) btrfs_finish_ordered_io()
   When one ordered extent is going to finish, we always free its
   metadata.

This behavior is OK if and only if all ordered extents can finish
without problem.
When we need to manually finish ordered extent, such behavior can lead
to double releasing metadata, causing outstanding extents assert.

So this patch introduce BTRFS_ORDERED_SKIP_META bit to allow us skip
releasing metadata and allow extent_clear_unlock_delalloc() to handle
them all.

This provides the basis for later ordered extent deadlock fix.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Newly introduced, split from v2 patch.
---
 fs/btrfs/inode.c        | 5 +++--
 fs/btrfs/ordered-data.c | 8 +++++++-
 fs/btrfs/ordered-data.h | 8 +++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a063721..92a7c3051b94 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3008,7 +3008,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
-	if (root != fs_info->tree_root)
+	if (root != fs_info->tree_root &&
+	    !test_bit(BTRFS_ORDERED_SKIP_META, &ordered_extent->flags))
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans)
 		btrfs_end_transaction(trans);
@@ -8200,7 +8201,7 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
 						   ordered_bytes,
-						   uptodate);
+						   uptodate, false);
 	if (!ret)
 		goto out_test;
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 041c3326d109..69372b0eb37a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -298,10 +298,14 @@ void btrfs_add_ordered_sum(struct inode *inode,
  *
  * file_offset is updated to one byte past the range that is recorded as
  * complete.  This allows you to walk forward in the file.
+ *
+ * If @skip_meta is true, we are in error handle routine to cleanup all
+ * ordered extents submitted in fill_delalloc().
  */
 int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
-				   u64 *file_offset, u64 io_size, int uptodate)
+				   u64 *file_offset, u64 io_size, bool uptodate,
+				   bool skip_meta)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ordered_inode_tree *tree;
@@ -344,6 +348,8 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 	entry->bytes_left -= to_dec;
 	if (!uptodate)
 		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
+	if (skip_meta)
+		set_bit(BTRFS_ORDERED_SKIP_META, &entry->flags);
 
 	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 5f2b0ca28705..b6efcfcd1da6 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -75,6 +75,12 @@ struct btrfs_ordered_sum {
 				 * in the logging code. */
 #define BTRFS_ORDERED_PENDING 11 /* We are waiting for this ordered extent to
 				  * complete in the current transaction. */
+/*
+ * This ordered extent is going to be cleaned up in error handle routine,
+ * no need to free metadata, as it's handled by extent_clear_unlock_delalloc()
+ */
+#define BTRFS_ORDERED_SKIP_META 12
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
@@ -169,7 +175,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
 				   u64 *file_offset, u64 io_size,
-				   int uptodate);
+				   bool uptodate, bool skip_meta);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
-- 
2.11.1



