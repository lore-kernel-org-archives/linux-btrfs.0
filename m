Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3A2KKN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:10:13 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TAAAOY020678
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 18:10:10 +0800
Message-ID: <5107A02B.8000702@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 18:10:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 07/10] Btrfs: use percpu counter for fs_info->delalloc_bytes
References: <51079D72.7000301@cn.fujitsu.com>
In-Reply-To: <51079D72.7000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->delalloc_bytes is accessed very frequently, so use percpu
counter instead of the u64 variant for it to reduce the lock
contention.

This patch also fixed the problem that we access the variant
without the lock protection.At worst, we would not flush the
delalloc inodes, and just return ENOSPC error when we still have
some free space in the fs.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- modify the changelog and make it more clear and stringency.
---
 fs/btrfs/ctree.h       |  7 ++++---
 fs/btrfs/disk-io.c     | 18 ++++++++++++++----
 fs/btrfs/extent-tree.c |  6 ++++--
 fs/btrfs/inode.c       |  6 ++++--
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1dcbbfd..51515a3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1383,6 +1383,7 @@ struct btrfs_fs_info {
 	 */
 	struct list_head ordered_extents;
 
+	spinlock_t delalloc_lock;
 	/*
 	 * all of the inodes that have delalloc bytes.  It is possible for
 	 * this list to be empty even when there is still dirty data=ordered
@@ -1443,7 +1444,10 @@ struct btrfs_fs_info {
 
 	/* used to keep from writing metadata until there is a nice batch */
 	struct percpu_counter dirty_metadata_bytes;
+	struct percpu_counter delalloc_bytes;
 	s32 dirty_metadata_batch;
+	s32 delalloc_batch;
+
 	struct list_head dirty_cowonly_roots;
 
 	struct btrfs_fs_devices *fs_devices;
@@ -1459,9 +1463,6 @@ struct btrfs_fs_info {
 
 	struct reloc_control *reloc_ctl;
 
-	spinlock_t delalloc_lock;
-	u64 delalloc_bytes;
-
 	/* data_alloc_cluster is only used in ssd mode */
 	struct btrfs_free_cluster data_alloc_cluster;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 961ac58..29d52af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2006,10 +2006,16 @@ int open_ctree(struct super_block *sb,
 	fs_info->dirty_metadata_batch = PAGE_CACHE_SIZE *
 					(1 + ilog2(nr_cpu_ids));
 
+	ret = percpu_counter_init(&fs_info->delalloc_bytes, 0);
+	if (ret) {
+		err = ret;
+		goto fail_dirty_metadata_bytes;
+	}
+
 	fs_info->btree_inode = new_inode(sb);
 	if (!fs_info->btree_inode) {
 		err = -ENOMEM;
-		goto fail_dirty_metadata_bytes;
+		goto fail_delalloc_bytes;
 	}
 
 	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
@@ -2264,6 +2270,7 @@ int open_ctree(struct super_block *sb,
 	sectorsize = btrfs_super_sectorsize(disk_super);
 	stripesize = btrfs_super_stripesize(disk_super);
 	fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
 
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
@@ -2726,6 +2733,8 @@ fail_iput:
 
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
+fail_delalloc_bytes:
+	percpu_counter_destroy(&fs_info->delalloc_bytes);
 fail_dirty_metadata_bytes:
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 fail_bdi:
@@ -3357,9 +3366,9 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_qgroup_config(root->fs_info);
 
-	if (fs_info->delalloc_bytes) {
-		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
-		       (unsigned long long)fs_info->delalloc_bytes);
+	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
+		printk(KERN_INFO "btrfs: at unmount delalloc count %lld\n",
+		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
 	free_extent_buffer(fs_info->extent_root->node);
@@ -3407,6 +3416,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
+	percpu_counter_destroy(&fs_info->delalloc_bytes);
 	bdi_destroy(&fs_info->bdi);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ef61a4a..f4f0b1e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3724,7 +3724,8 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	space_info = block_rsv->space_info;
 
 	smp_mb();
-	delalloc_bytes = root->fs_info->delalloc_bytes;
+	delalloc_bytes = percpu_counter_sum_positive(
+						&root->fs_info->delalloc_bytes);
 	if (delalloc_bytes == 0) {
 		if (trans)
 			return;
@@ -3766,7 +3767,8 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 				break;
 		}
 		smp_mb();
-		delalloc_bytes = root->fs_info->delalloc_bytes;
+		delalloc_bytes = percpu_counter_sum_positive(
+						&root->fs_info->delalloc_bytes);
 	}
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 803be87..d98b508 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1510,7 +1510,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
-		root->fs_info->delalloc_bytes += len;
+		__percpu_counter_add(&root->fs_info->delalloc_bytes, len,
+				     root->fs_info->delalloc_batch);
 		if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
 			list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
 				      &root->fs_info->delalloc_inodes);
@@ -1551,7 +1552,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_free_reserved_data_space(inode, len);
 
 		spin_lock(&root->fs_info->delalloc_lock);
-		root->fs_info->delalloc_bytes -= len;
+		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
+				     root->fs_info->delalloc_batch);
 		BTRFS_I(inode)->delalloc_bytes -= len;
 
 		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
-- 
1.7.11.7

