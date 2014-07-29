Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3119 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246AbaG2JWi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 05:22:38 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6T9MYoD002873
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 17:22:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 12/12] Btrfs: cleanup the read failure record after write or when the inode is freeing
Date: Tue, 29 Jul 2014 17:24:10 +0800
Message-ID: <1406625850-32168-13-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com>

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
Changelog v1-v2:
- None
---
 fs/btrfs/extent_io.c | 34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  1 +
 fs/btrfs/inode.c     |  6 ++++++
 3 files changed, 41 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 31600ef..39783e7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2135,6 +2135,40 @@ out:
 	return 0;
 }
 
+/*
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
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b23c7c2..5c48eda 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -369,6 +369,7 @@ struct io_failure_record {
 	int in_validation;
 };
 
+void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
 int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e087189..56bd9c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2639,6 +2639,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	btrfs_free_io_failure_record(inode, ordered_extent->file_offset,
+				     ordered_extent->file_offset +
+				     ordered_extent->len - 1);
+
 	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags)) {
 		truncated = true;
 		logical_len = ordered_extent->truncated_len;
@@ -4723,6 +4727,8 @@ void btrfs_evict_inode(struct inode *inode)
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
+	btrfs_free_io_failure_record(inode, 0, (u64)-1);
+
 	if (root->fs_info->log_root_recovering) {
 		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				 &BTRFS_I(inode)->runtime_flags));
-- 
1.9.3

