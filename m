Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22173 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932325AbbJMCUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 22:20:42 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9D2K1QL012662
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 10:20:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 21/21] btrfs: qgroup: Check if qgroup reserved space leaked
Date: Tue, 13 Oct 2015 10:20:27 +0800
Message-Id: <1444702827-18169-22-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add check at btrfs_destroy_inode() time to detect qgroup reserved space
leak.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Separate from old btrfs_qgroup_free_data_rsv_map().
---
 fs/btrfs/inode.c  |  1 +
 fs/btrfs/qgroup.c | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h |  1 +
 3 files changed, 34 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 39c9191..15d6ee0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9054,6 +9054,7 @@ void btrfs_destroy_inode(struct inode *inode)
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
+	btrfs_qgroup_check_reserved_leak(inode);
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b3b485a..f452c85 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2640,3 +2640,35 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
 	qgroup_free(root, num_bytes);
 }
+
+/*
+ * Check qgroup reserved space leaking, normally at destory inode
+ * time
+ */
+void btrfs_qgroup_check_reserved_leak(struct inode *inode)
+{
+	struct extent_changeset changeset;
+	struct ulist_node *unode;
+	struct ulist_iterator iter;
+	int ret;
+
+	changeset.bytes_changed = 0;
+	changeset.range_changed = ulist_alloc(GFP_NOFS);
+	if (WARN_ON(!changeset.range_changed))
+		return;
+
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
+			EXTENT_QGROUP_RESERVED, GFP_NOFS, &changeset);
+
+	WARN_ON(ret < 0);
+	if (WARN_ON(changeset.bytes_changed)) {
+		ULIST_ITER_INIT(&iter);
+		while ((unode = ulist_next(changeset.range_changed, &iter))) {
+			btrfs_warn(BTRFS_I(inode)->root->fs_info,
+				"leaking qgroup reserved space, ino: %lu, start: %llu, end: %llu",
+				inode->i_ino, unode->val, unode->aux);
+		}
+		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
+	}
+	ulist_free(changeset.range_changed);
+}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 686b60f..ecb2c14 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -105,4 +105,5 @@ int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes);
 void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes);
+void btrfs_qgroup_check_reserved_leak(struct inode *inode);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.6.1

