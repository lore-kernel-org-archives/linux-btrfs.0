Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:65299 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756148AbbJIChf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:37:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992aXIn023987
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:36:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 23/23] btrfs: qgroup: Avoid calling btrfs_free_reserved_data_space in clear_bit_hook
Date: Fri, 9 Oct 2015 10:34:55 +0800
Message-ID: <1444358095-3575-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In clear_bit_hook, qgroup reserved data is already handled quite well,
either released by finish_ordered_io or invalidatepage.

So calling btrfs_qgroup_free_data() here is completely meaningless, and
since btrfs_qgroup_free_data() may sleep to allocate memory, it will
cause lockdep warning.

This patch will add a new function
btrfs_free_reserved_data_space_noquota() for clear_bit_hook() to cease
the lockdep warning.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 28 ++++++++++++++++++----------
 fs/btrfs/inode.c       |  4 ++--
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f20b901..3970426 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3455,6 +3455,8 @@ enum btrfs_reserve_flush_enum {
 int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
 int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
+void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
+					    u64 len);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 765f7e0..af221eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4070,10 +4070,12 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
  * Called if we need to clear a data reservation for this inode
  * Normally in a error case.
  *
- * This one will handle the per-indoe data rsv map for accurate reserved
- * space framework.
+ * This one will *NOT* use accurate qgroup reserved space API, just for case
+ * which we can't sleep and is sure it won't affect qgroup reserved space.
+ * Like clear_bit_hook().
  */
-void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
+void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
+					    u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_space_info *data_sinfo;
@@ -4083,13 +4085,6 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
 	      round_down(start, root->sectorsize);
 	start = round_down(start, root->sectorsize);
 
-	/*
-	 * Free any reserved qgroup data space first
-	 * As it will alloc memory, we can't do it with data sinfo
-	 * spinlock hold.
-	 */
-	btrfs_qgroup_free_data(inode, start, len);
-
 	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
 	if (WARN_ON(data_sinfo->bytes_may_use < len))
@@ -4101,6 +4096,19 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
 	spin_unlock(&data_sinfo->lock);
 }
 
+/*
+ * Called if we need to clear a data reservation for this inode
+ * Normally in a error case.
+ *
+ * This one will handle the per-indoe data rsv map for accurate reserved
+ * space framework.
+ */
+void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
+{
+	btrfs_free_reserved_data_space_noquota(inode, start, len);
+	btrfs_qgroup_free_data(inode, start, len);
+}
+
 static void force_metadata_allocation(struct btrfs_fs_info *info)
 {
 	struct list_head *head = &info->space_info;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85b06d1..bd3935c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1773,8 +1773,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
 		    && do_list && !(state->state & EXTENT_NORESERVE))
-			btrfs_free_reserved_data_space(inode, state->start,
-						       len);
+			btrfs_free_reserved_data_space_noquota(inode,
+					state->start, len);
 
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
 				     root->fs_info->delalloc_batch);
-- 
2.6.1

