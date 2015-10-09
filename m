Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:38813 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934791AbbJICZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:25:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992O3Ue023205
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:24:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 13/23] btrfs: extent-tree: Add new version of btrfs_check_data_free_space and btrfs_free_reserved_data_space.
Date: Fri, 9 Oct 2015 10:22:25 +0800
Message-ID: <1444357345-398-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new functions __btrfs_check_data_free_space() and
__btrfs_free_reserved_data_space() to work with new accurate qgroup
reserved space framework.

The new function will replace old btrfs_check_data_free_space() and
btrfs_free_reserved_data_space() respectively, but until all the change
is done, let's just use the new name.

Also, export internal use function btrfs_alloc_data_chunk_ondemand(), as
now qgroup reserve requires precious bytes, some operation can't get the
accurate number in advance(like fallocate).
But data space info check and data chunk allocate doesn't need to be
that accurate, and can be called at the beginning.

So export it for later operations.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Fix comment typo
  Add __btrfs_free_reserved_data_space() function, or we will leak
  reserved space at EQUOT error handle routine.
---
 fs/btrfs/ctree.h       |  3 ++
 fs/btrfs/extent-tree.c | 85 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ae86025..19450a1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3453,7 +3453,10 @@ enum btrfs_reserve_flush_enum {
 };
 
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes);
+int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
+int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
+void __btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22702bd..0cd6baa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3908,11 +3908,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	return ret;
 }
 
-/*
- * This will check the space that the inode allocates from to make sure we have
- * enough space for bytes.
- */
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
+int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -4033,19 +4029,55 @@ commit_trans:
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	ret = btrfs_qgroup_reserve(root, write_bytes);
-	if (ret)
-		goto out;
 	data_sinfo->bytes_may_use += bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
-out:
 	spin_unlock(&data_sinfo->lock);
 
 	return ret;
 }
 
 /*
+ * This will check the space that the inode allocates from to make sure we have
+ * enough space for bytes.
+ */
+int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	ret = btrfs_alloc_data_chunk_ondemand(inode, bytes);
+	if (ret < 0)
+		return ret;
+	ret = btrfs_qgroup_reserve(root, write_bytes);
+	return ret;
+}
+
+/*
+ * New check_data_free_space() with ability for precious data reservation
+ * Will replace old btrfs_check_data_free_space(), but for patch split,
+ * add a new function first and then replace it.
+ */
+int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	/* align the range */
+	len = round_up(start + len, root->sectorsize) -
+	      round_down(start, root->sectorsize);
+	start = round_down(start, root->sectorsize);
+
+	ret = btrfs_alloc_data_chunk_ondemand(inode, len);
+	if (ret < 0)
+		return ret;
+
+	/* Use new btrfs_qgroup_reserve_data to reserve precious data space */
+	ret = btrfs_qgroup_reserve_data(inode, start, len);
+	return ret;
+}
+
+/*
  * Called if we need to clear a data reservation for this inode.
  */
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
@@ -4065,6 +4097,41 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	spin_unlock(&data_sinfo->lock);
 }
 
+/*
+ * Called if we need to clear a data reservation for this inode
+ * Normally in a error case.
+ *
+ * This one will handle the per-indoe data rsv map for accurate reserved
+ * space framework.
+ */
+void __btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_space_info *data_sinfo;
+
+	/* Make sure the range is aligned to sectorsize */
+	len = round_up(start + len, root->sectorsize) -
+	      round_down(start, root->sectorsize);
+	start = round_down(start, root->sectorsize);
+
+	/*
+	 * Free any reserved qgroup data space first
+	 * As it will alloc memory, we can't do it with data sinfo
+	 * spinlock hold.
+	 */
+	btrfs_qgroup_free_data(inode, start, len);
+
+	data_sinfo = root->fs_info->data_sinfo;
+	spin_lock(&data_sinfo->lock);
+	if (WARN_ON(data_sinfo->bytes_may_use < len))
+		data_sinfo->bytes_may_use = 0;
+	else
+		data_sinfo->bytes_may_use -= len;
+	trace_btrfs_space_reservation(root->fs_info, "space_info",
+				      data_sinfo->flags, len, 0);
+	spin_unlock(&data_sinfo->lock);
+}
+
 static void force_metadata_allocation(struct btrfs_fs_info *info)
 {
 	struct list_head *head = &info->space_info;
-- 
2.6.1

