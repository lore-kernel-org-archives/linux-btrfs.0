Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbbIBHv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:28 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t810XlIq023763
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 08:34:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 13/14] btrfs: extent-tree: Add new verions of btrfs_check_data_free_space
Date: Tue,  1 Sep 2015 08:31:53 +0800
Message-Id: <1441067515-21105-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new function __btrfs_check_data_free_space() to do precious space
reservation.

The new function will replace old btrfs_check_data_free_space(), but
until all the change is done, let's just use the new name.

Also, export internal use function btrfs_alloc_data_chunk_ondemand(), as
now qgroup reserve requires precious bytes, which can only be got in
later loop(like fallocate).
But data space info check and data chunk allocate doesn't need to be
that accurate, and can be called at the beginning.

So export it for later operations.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 50 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9ce0df1..cf5de9c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3456,6 +3456,8 @@ enum btrfs_reserve_flush_enum {
 };
 
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes);
+int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
+int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ce78410..14c4135 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3826,11 +3826,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
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
@@ -3951,19 +3947,55 @@ commit_trans:
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
+ * New check_data_free_space() with ability for precious data reserveation
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
-- 
2.5.0

