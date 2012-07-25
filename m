Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab2GYF7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 01:59:44 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6P5xWH3005253
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:59:43 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6 v3][RFC] Btrfs: async helper for state merge
Date: Wed, 25 Jul 2012 13:58:42 +0800
Message-Id: <1343195922-31405-7-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the second part of parallel endios for read.

Here we use an async helper thread to process batched merges, so we
eventually get endio for read to avoid acquiring or holding any
write locks of extent state tree.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     |    1 +
 fs/btrfs/disk-io.c   |    6 +++++
 fs/btrfs/extent_io.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/super.c     |    1 +
 4 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..b500495 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1203,6 +1203,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers submit_workers;
 	struct btrfs_workers caching_workers;
 	struct btrfs_workers readahead_workers;
+	struct btrfs_workers es_merge_workers;
 
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1a5d5bf..434f82c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2214,6 +2214,9 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->es_merge_workers, "esmerge",
+			   fs_info->thread_pool_size,
+			   &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -2244,6 +2247,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
+	ret |= btrfs_start_workers(&fs_info->es_merge_workers);
 	if (ret) {
 		ret = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2544,6 +2548,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_stop_workers(&fs_info->es_merge_workers);
 fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
@@ -3149,6 +3154,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_stop_workers(&fs_info->es_merge_workers);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d91821b..262efb8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -552,16 +552,34 @@ static int test_merge_state(struct extent_io_tree *tree,
 	return 0;
 }
 
-static void process_merge_state(struct extent_io_tree *tree, u64 start)
+struct async_merge_state {
+	struct extent_io_tree *tree;
+	u64 start;
+	struct btrfs_work work;
+};
+
+static void process_merge_state(struct btrfs_work *work)
 {
+	struct async_merge_state *async = NULL;
+	struct extent_io_tree *tree = NULL;
 	struct extent_state *state = NULL;
 	struct rb_node *node = NULL;
+	struct btrfs_fs_info *fs_info = NULL;
+	u64 start;
+
+	async = container_of(work, struct async_merge_state, work);
+	BUG_ON(!async);
+	tree = async->tree;
+	start = async->start;
 
 	if (!tree || start == (u64)-1) {
 		WARN_ON(1);
+		kfree(async);
 		return;
 	}
 
+	fs_info = BTRFS_I(tree->mapping->host)->root->fs_info;
+
 	write_lock(&tree->lock);
 	node = tree_search(tree, start);
 	if (!node)
@@ -574,6 +592,31 @@ static void process_merge_state(struct extent_io_tree *tree, u64 start)
 	spin_unlock(&state->lock);
 out:
 	write_unlock(&tree->lock);
+
+	WARN_ON(!tree->mapping->host);
+	if (tree->mapping->host)
+		iput(tree->mapping->host);
+	kfree(async);
+}
+
+static int btrfs_async_merge_state(struct extent_io_tree *tree,
+				   u64 start, gfp_t mask)
+{
+	struct async_merge_state *async;
+	struct btrfs_fs_info *fs_info
+			 = BTRFS_I(tree->mapping->host)->root->fs_info;
+
+	async = kzalloc(sizeof(*async), mask);
+	if (!async)
+		return -ENOMEM;
+	igrab(tree->mapping->host);
+	async->tree = tree;
+	async->start = start;
+	async->work.func = process_merge_state;
+	async->work.flags = 0;
+	btrfs_queue_worker(&fs_info->es_merge_workers, &async->work);
+
+	return 0;
 }
 
 enum extent_lock_type {
@@ -808,7 +851,7 @@ out:
 		if (orig_bits & EXTENT_NOMERGE)
 			return merge;
 		else
-			process_merge_state(tree, orig_start);
+			btrfs_async_merge_state(tree, orig_start, mask);
 	}
 
 	return 0;
@@ -1156,7 +1199,7 @@ out:
 	if (prealloc)
 		free_extent_state(prealloc);
 	if (merge)
-		process_merge_state(tree, orig_start);
+		btrfs_async_merge_state(tree, orig_start, mask);
 
 	return err;
 
@@ -2703,7 +2746,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	} while (bvec <= bvec_end);
 
 	if (merge && tree && range_start < (u64)-1)
-		process_merge_state(tree, range_start);
+		btrfs_async_merge_state(tree, range_start, GFP_ATOMIC);
 
 	bio_put(bio);
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e239915..57f05b9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1134,6 +1134,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
+	btrfs_set_max_workers(&fs_info->es_merge_workers, new_pool_size);
 }
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
-- 
1.6.5.2

