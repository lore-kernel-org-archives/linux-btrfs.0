Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:47480 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756313AbbJICNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:13:55 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992D2VZ022442
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:13:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/23] btrfs: qgroup: Implement data_rsv_map init/free functions
Date: Fri, 9 Oct 2015 10:11:24 +0800
Message-ID: <1444356684-30162-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New functions btrfs_qgroup_init/free_data_rsv_map() to init/free data
reserve map.

Data reserve map is used to mark which range already holds reserved
space, to avoid current reserved space leak.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add reserved space leaking check at free_data_rsv_map time
---
 fs/btrfs/btrfs_inode.h |  2 ++
 fs/btrfs/inode.c       | 10 ++++++
 fs/btrfs/qgroup.c      | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h      |  3 ++
 4 files changed, 99 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6d799b8..c2da3a9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -197,6 +197,8 @@ struct btrfs_inode {
 
 	/* qgroup dirty map for data space reserve */
 	struct btrfs_qgroup_data_rsv_map *qgroup_rsv_map;
+	/* lock to ensure rsv_map will only be initialized once */
+	spinlock_t qgroup_init_lock;
 };
 
 extern unsigned char btrfs_filetype_table[];
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7e439b..79ad301 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8940,6 +8940,14 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	RB_CLEAR_NODE(&ei->rb_node);
 
+	/*
+	 * Init qgroup info to empty, as they will be initialized at write
+	 * time.
+	 * This behavior is needed for enable quota later case.
+	 */
+	spin_lock_init(&ei->qgroup_init_lock);
+	ei->qgroup_rsv_map = NULL;
+
 	return inode;
 }
 
@@ -8997,6 +9005,8 @@ void btrfs_destroy_inode(struct inode *inode)
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
+	/* free and check data rsv map */
+	btrfs_qgroup_free_data_rsv_map(inode);
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 607ace8..c275312 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2539,3 +2539,87 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 		btrfs_queue_work(fs_info->qgroup_rescan_workers,
 				 &fs_info->qgroup_rescan_work);
 }
+
+/*
+ * Init data_rsv_map for a given inode.
+ *
+ * This is needed at write time as quota can be disabled and then enabled
+ */
+int btrfs_qgroup_init_data_rsv_map(struct inode *inode)
+{
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	struct btrfs_root *root = binode->root;
+	struct btrfs_qgroup_data_rsv_map *dirty_map;
+
+	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid))
+		return 0;
+
+	spin_lock(&binode->qgroup_init_lock);
+	/* Quick route for init */
+	if (likely(binode->qgroup_rsv_map))
+		goto out;
+	spin_unlock(&binode->qgroup_init_lock);
+
+	/*
+	 * Slow allocation route
+	 *
+	 * TODO: Use kmem_cache to speedup allocation
+	 */
+	dirty_map = kmalloc(sizeof(*dirty_map), GFP_NOFS);
+	if (!dirty_map)
+		return -ENOMEM;
+
+	dirty_map->reserved = 0;
+	dirty_map->root = RB_ROOT;
+	spin_lock_init(&dirty_map->lock);
+
+	/* Lock again to ensure no one has already init it before */
+	spin_lock(&binode->qgroup_init_lock);
+	if (binode->qgroup_rsv_map) {
+		spin_unlock(&binode->qgroup_init_lock);
+		kfree(dirty_map);
+		return 0;
+	}
+	binode->qgroup_rsv_map = dirty_map;
+out:
+	spin_unlock(&binode->qgroup_init_lock);
+	return 0;
+}
+
+void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
+{
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	struct btrfs_root *root = binode->root;
+	struct btrfs_qgroup_data_rsv_map *dirty_map = binode->qgroup_rsv_map;
+	struct rb_node *node;
+
+	/*
+	 * this function is called at inode destroy routine, so no concurrency
+	 * will happen, no need to get the lock.
+	 */
+	if (!dirty_map)
+		return;
+
+	/* insanity check */
+	WARN_ON(!is_fstree(root->objectid));
+
+	/* Reserve map should be empty, or we are leaking */
+	WARN_ON(dirty_map->reserved);
+
+	btrfs_qgroup_free(root, dirty_map->reserved);
+	spin_lock(&dirty_map->lock);
+	while ((node = rb_first(&dirty_map->root)) != NULL) {
+		struct data_rsv_range *range;
+
+		range = rb_entry(node, struct data_rsv_range, node);
+		btrfs_warn(root->fs_info,
+			   "leaking reserved range, root: %llu, ino: %lu, start: %llu, len: %llu\n",
+			   root->objectid, inode->i_ino, range->start,
+			   range->len);
+		rb_erase(node, &dirty_map->root);
+		kfree(range);
+	}
+	spin_unlock(&dirty_map->lock);
+	kfree(dirty_map);
+	binode->qgroup_rsv_map = NULL;
+}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 2f863a4..c87b7dc 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -84,4 +84,7 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 			       u64 rfer, u64 excl);
 #endif
 
+/* for qgroup reserve */
+int btrfs_qgroup_init_data_rsv_map(struct inode *inode);
+void btrfs_qgroup_free_data_rsv_map(struct inode *inode);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.6.1

