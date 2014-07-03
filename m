Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755959AbaGCKUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s63AKl9g013563
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 18:20:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 6/9] Btrfs: cleanup the read failure record after write or when the inode is freeing
Date: Thu, 3 Jul 2014 18:22:10 +0800
Message-ID: <1404382933-26672-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the data is written successfully, we should cleanup the read failure record
in that range because
- If we set data COW for the file, the range that the failure record pointed to is
  mapped to a new place, so it is invalid.
- If we set no data COW for the file, and if there is no error during writting,
  the corrupted data is corrected, so the failure record can be removed. And if
  some errors happen on the mirrors, we also needn't worry about it because the
  failure record will be recreated if we read the same place again.

Sometimes, we may fail to correct the data, so the failure records will be left
in the tree, we need free them when we free the inode or the memory leak happens.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  1 +
 fs/btrfs/inode.c     |  6 ++++++
 3 files changed, 41 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3a64354..d67bb4f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2003,6 +2003,40 @@ static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
 }
 
 /*
+ * Can be called when
+ * - hold extent lock
+ * - under ordered extent
+ * - the inode is freeing
+ */
+void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
+{
+	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
+	struct io_failure_record *failrec;
+	struct extent_state *state, *next;
+
+	if (RB_EMPTY_ROOT(&failure_tree->state))
+		return;
+
+	spin_lock(&failure_tree->lock);
+	state = find_first_extent_bit_state(failure_tree, start, EXTENT_DIRTY);
+	while (state) {
+		if (state->start > end)
+			break;
+
+		ASSERT(state->end <= end);
+
+		next = next_state(state);
+
+		failrec = (struct io_failure_record *)state->private;
+		free_extent_state(state);
+		kfree(failrec);
+
+		state = next;
+	}
+	spin_unlock(&failure_tree->lock);
+}
+
+/*
  * this bypasses the standard btrfs submit functions deliberately, as
  * the standard behavior is to write all copies in a raid setup. here we only
  * want to write the one bad copy. so we do the mapping for ourselves and issue
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ccc264e..d06780b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -347,6 +347,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15902eb..b431c58 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2670,6 +2670,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	btrfs_free_io_failure_record(inode, ordered_extent->file_offset,
+				     ordered_extent->file_offset +
+				     ordered_extent->len - 1);
+
 	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags)) {
 		truncated = true;
 		logical_len = ordered_extent->truncated_len;
@@ -4745,6 +4749,8 @@ void btrfs_evict_inode(struct inode *inode)
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
+	btrfs_free_io_failure_record(inode, 0, (u64)-1);
+
 	if (root->fs_info->log_root_recovering) {
 		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				 &BTRFS_I(inode)->runtime_flags));
-- 
1.9.3

