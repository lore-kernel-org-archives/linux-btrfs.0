Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3CFLCq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 06:02:46 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH RFC] Btrfs: improve delalloc reservation
Date: Wed,  6 Mar 2013 19:01:09 +0800
Message-Id: <1362567669-16477-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we already have over commit stuff, btrfs write performance
still suffers from over reservation a lot.

NOTE:
This is just a _demonstration_ patch for people to discuss about.

We can make a delalloc buffer, sort of global_block_rsv, to improve
the over reserved situation.  Now that we cannot get or predict
the precise number of blocks we're going to consume, then the
easiest way, we just give up.  Instead, we set a buffer for delalloc
writes' various update use, including updating fs tree for file
extents and inode items and updating checksum tree for file extent
checksum.

Now pros and cons,

pros:
- we get rid of 'worst case', say the worst case needs X bytes, and
now we have 5X bytes, but we have started 10 writes, we'll have 5
writes finished without this patch because 5X is not enough for all in
the worst case, and all of 10 writes finished with this patch
respectively.

cons:
- there is a risk that we run out of space but the delalloc buffer
is not big enough to finish flushing all the writes that have been
started.

Although this is not an ideal solution, it's at least worth a shot
because of the following performance number.

Disk: HDD (size: 40G)
Test: compilebench -i 10 -m

- btrfs w/o
create dir kernel-0 222MB in 1.99 seconds (111.75 MB/s)
create dir kernel-1 222MB in 3.05 seconds (72.91 MB/s)
create dir kernel-2 222MB in 3.05 seconds (72.91 MB/s)
create dir kernel-3 222MB in 3.94 seconds (56.44 MB/s)
create dir kernel-4 222MB in 3.21 seconds (69.28 MB/s)
create dir kernel-5 222MB in 2.97 seconds (74.87 MB/s)
create dir kernel-6 222MB in 4.02 seconds (55.32 MB/s)
create dir kernel-7 222MB in 3.19 seconds (69.71 MB/s)
create dir kernel-8 222MB in 3.09 seconds (71.97 MB/s)
create dir kernel-9 222MB in 3.05 seconds (72.91 MB/s)
run complete:
==========================================================================
intial create total runs 10 avg 72.81 MB/s (user 0.40s sys 0.66s)

- btrfs w/
create dir kernel-0 222MB in 0.87 seconds (255.60 MB/s)
create dir kernel-1 222MB in 0.86 seconds (258.57 MB/s)
create dir kernel-2 222MB in 0.95 seconds (234.08 MB/s)
create dir kernel-3 222MB in 1.08 seconds (205.90 MB/s)
create dir kernel-4 222MB in 1.11 seconds (200.34 MB/s)
create dir kernel-5 222MB in 1.60 seconds (138.98 MB/s)
create dir kernel-6 222MB in 2.25 seconds (98.83 MB/s)
create dir kernel-7 222MB in 2.67 seconds (83.29 MB/s)
create dir kernel-8 222MB in 2.71 seconds (82.06 MB/s)
create dir kernel-9 222MB in 2.62 seconds (84.88 MB/s)
run complete:
==========================================================================
intial create total runs 10 avg 164.25 MB/s (user 0.40s sys 0.62s)

- ext4
create dir kernel-0 222MB in 0.81 seconds (274.54 MB/s)
create dir kernel-1 222MB in 0.78 seconds (285.10 MB/s)
create dir kernel-2 222MB in 0.80 seconds (277.97 MB/s)
create dir kernel-3 222MB in 3.00 seconds (74.12 MB/s)
create dir kernel-4 222MB in 0.89 seconds (249.86 MB/s)
create dir kernel-5 222MB in 4.40 seconds (50.54 MB/s)
create dir kernel-6 222MB in 3.24 seconds (68.63 MB/s)
create dir kernel-7 222MB in 1.26 seconds (176.49 MB/s)
create dir kernel-8 222MB in 4.39 seconds (50.65 MB/s)
create dir kernel-9 222MB in 7.67 seconds (28.99 MB/s)
run complete:
==========================================================================
intial create total runs 10 avg 153.69 MB/s (user 0.33s sys 0.44s)

So, the performance gets roughly double number.

And here is a comparison graph of the above test from compilebench+seekwatcher,
https://github.com/liubogithub/blktrace/blob/master/trace-delalloc_write.png

Any comments are WELCOME!

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h         |    8 ++++
 fs/btrfs/delayed-inode.c |   22 +++++++++++
 fs/btrfs/disk-io.c       |    3 +
 fs/btrfs/extent-tree.c   |   95 +++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 118 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d82922..8d19924 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1272,6 +1272,8 @@ struct btrfs_stripe_hash_table {
 
 #define BTRFS_STRIPE_HASH_TABLE_BITS 11
 
+#define BTRFS_DELALLOC_POOL (52428800) /* (50ULL * 1024 * 1024) */
+
 /* fs_info */
 struct reloc_control;
 struct btrfs_device;
@@ -1605,6 +1607,9 @@ struct btrfs_fs_info {
 	struct btrfs_dev_replace dev_replace;
 
 	atomic_t mutually_exclusive_operation_running;
+
+	u64 delalloc_pool;
+	spinlock_t delalloc_pool_lock;
 };
 
 /*
@@ -3127,6 +3132,9 @@ int btrfs_block_rsv_add(struct btrfs_root *root,
 			enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_check(struct btrfs_root *root,
 			  struct btrfs_block_rsv *block_rsv, int min_factor);
+int __btrfs_block_rsv_refill(struct btrfs_root *root,
+			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
+			   enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_refill(struct btrfs_root *root,
 			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
 			   enum btrfs_reserve_flush_enum flush);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0b278b1..cf43c56 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -742,7 +742,26 @@ static void btrfs_delayed_inode_release_metadata(struct btrfs_root *root,
 						struct btrfs_delayed_node *node)
 {
 	struct btrfs_block_rsv *rsv;
+	u64 to_free = 0;
 
+	spin_lock(&root->fs_info->delalloc_pool_lock);
+	if (root->fs_info->delalloc_pool < BTRFS_DELALLOC_POOL)
+		to_free = BTRFS_DELALLOC_POOL - root->fs_info->delalloc_pool; 
+	spin_unlock(&root->fs_info->delalloc_pool_lock);
+
+	if (to_free) {
+		int ret;
+		rsv = &root->fs_info->delalloc_block_rsv;
+		ret = __btrfs_block_rsv_refill(root, rsv, to_free,
+					       BTRFS_RESERVE_NO_FLUSH);
+		if (ret) {
+			spin_lock(&root->fs_info->delalloc_pool_lock);
+			root->fs_info->delalloc_pool += to_free;
+			spin_unlock(&root->fs_info->delalloc_pool_lock);
+		}
+	}
+
+#if 0
 	if (!node->bytes_reserved)
 		return;
 
@@ -752,6 +771,7 @@ static void btrfs_delayed_inode_release_metadata(struct btrfs_root *root,
 	btrfs_block_rsv_release(root, rsv,
 				node->bytes_reserved);
 	node->bytes_reserved = 0;
+#endif
 }
 
 /*
@@ -1864,10 +1884,12 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
+#if 0
 	ret = btrfs_delayed_inode_reserve_metadata(trans, root, inode,
 						   delayed_node);
 	if (ret)
 		goto release_node;
+#endif
 
 	fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
 	delayed_node->inode_dirty = 1;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02369a3..b20f3f9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2127,6 +2127,9 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
 
+	fs_info->delalloc_pool = 0;
+	spin_lock_init(&fs_info->delalloc_pool_lock);
+
 	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
 	set_nlink(fs_info->btree_inode, 1);
 	/*
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aaee2b7..f533307 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4357,6 +4357,19 @@ int btrfs_block_rsv_check(struct btrfs_root *root,
 	return ret;
 }
 
+int __btrfs_block_rsv_refill(struct btrfs_root *root,
+			   struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+			   enum btrfs_reserve_flush_enum flush)
+{
+	int ret = -ENOSPC;
+	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
+	if (!ret) {
+		block_rsv_add_bytes(block_rsv, num_bytes, 0);
+		return 0;
+	}
+	return ret;
+}
+
 int btrfs_block_rsv_refill(struct btrfs_root *root,
 			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
 			   enum btrfs_reserve_flush_enum flush)
@@ -4377,14 +4390,7 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 
 	if (!ret)
 		return 0;
-
-	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
-	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 0);
-		return 0;
-	}
-
-	return ret;
+	return __btrfs_block_rsv_refill(root, block_rsv, num_bytes, flush);
 }
 
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
@@ -4507,6 +4513,9 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
 				(u64)-1);
+	/* LIUBO for debug use */
+	block_rsv_release_bytes(fs_info, &fs_info->delalloc_block_rsv, NULL,
+				(u64)-1);
 	WARN_ON(fs_info->delalloc_block_rsv.size > 0);
 	WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
 	WARN_ON(fs_info->trans_block_rsv.size > 0);
@@ -4715,6 +4724,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve = 0;
+	u64 orig = 0;
 	u64 csum_bytes;
 	unsigned nr_extents = 0;
 	int extra_reserve = 0;
@@ -4773,13 +4783,44 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 			goto out_fail;
 	}
 
+	orig = to_reserve;
+
+	spin_lock(&root->fs_info->delalloc_pool_lock);
+	if (root->fs_info->delalloc_pool >= BTRFS_DELALLOC_POOL) {
+		to_reserve = 0;
+		goto skip_rsv;
+	}
+	to_reserve = BTRFS_DELALLOC_POOL - root->fs_info->delalloc_pool;
+	spin_unlock(&root->fs_info->delalloc_pool_lock);
+
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
+	if (ret) {
+		/* fall back to the worst case */
+		spin_lock(&root->fs_info->delalloc_pool_lock);
+		/* check again since we droppded the lock */
+		if (root->fs_info->delalloc_pool >= BTRFS_DELALLOC_POOL) {
+			ret = 0;
+			to_reserve = 0;
+			goto skip_rsv;
+		} else if (root->fs_info->delalloc_pool > orig) {
+			ret = 0;
+			to_reserve = 0;
+			root->fs_info->delalloc_pool -= orig;
+			goto skip_rsv;
+		}
+		spin_unlock(&root->fs_info->delalloc_pool_lock);
+		/* else go to cleanup work */
+	}
 	if (unlikely(ret)) {
 		if (root->fs_info->quota_enabled)
 			btrfs_qgroup_free(root, num_bytes +
 						nr_extents * root->leafsize);
 		goto out_fail;
 	}
+	spin_lock(&root->fs_info->delalloc_pool_lock);
+	root->fs_info->delalloc_pool += to_reserve;
+skip_rsv:
+	spin_unlock(&root->fs_info->delalloc_pool_lock);
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if (extra_reserve) {
@@ -4861,8 +4902,29 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 					dropped * root->leafsize);
 	}
 
+	spin_lock(&root->fs_info->delalloc_pool_lock);
+	if (root->fs_info->delalloc_pool < BTRFS_DELALLOC_POOL)
+		to_free = BTRFS_DELALLOC_POOL - root->fs_info->delalloc_pool;
+	else
+		to_free = 0;
+	spin_unlock(&root->fs_info->delalloc_pool_lock);
+
+	if (to_free) {
+		int ret;
+		ret = __btrfs_block_rsv_refill(root,
+					 &root->fs_info->delalloc_block_rsv,
+					 to_free, BTRFS_RESERVE_NO_FLUSH);
+		if (!ret) {
+			spin_lock(&root->fs_info->delalloc_pool_lock);
+			root->fs_info->delalloc_pool += to_free;
+			spin_unlock(&root->fs_info->delalloc_pool_lock);
+		}
+	}
+
+#if 0
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
+#endif
 }
 
 /**
@@ -6518,8 +6580,19 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	}
 
 	ret = block_rsv_use_bytes(block_rsv, blocksize);
-	if (!ret)
+	if (!ret) {
+		if (block_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
+			spin_lock(&root->fs_info->delalloc_pool_lock);
+			if (root->fs_info->delalloc_pool > blocksize)
+				root->fs_info->delalloc_pool -= blocksize;
+			else
+				WARN(1, "delalloc pool %llu\n",
+				     root->fs_info->delalloc_pool);
+			spin_unlock(&root->fs_info->delalloc_pool_lock);
+		}
+
 		return block_rsv;
+	}
 	if (ret && !block_rsv->failfast) {
 		if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
 			static DEFINE_RATELIMIT_STATE(_rs,
@@ -6527,7 +6600,9 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 					/*DEFAULT_RATELIMIT_BURST*/ 1);
 			if (__ratelimit(&_rs))
 				WARN(1, KERN_DEBUG
-					"btrfs: block rsv returned %d\n", ret);
+					"btrfs:(root %llu) block rsv %d returned %d\n",
+						root->root_key.objectid,
+						block_rsv->type, ret);
 		}
 		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
 					     BTRFS_RESERVE_NO_FLUSH);
-- 
1.7.7.6

