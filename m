Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbbKSKoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 05:44:09 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B7404ACBD
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 10:43:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: constify remaining structs with function pointers
Date: Thu, 19 Nov 2015 11:42:28 +0100
Message-Id: <e253ac860a8f9d3fcdfe09743611b9a39c9968c7.1447929577.git.dsterba@suse.com>
In-Reply-To: <cover.1447929577.git.dsterba@suse.com>
References: <cover.1447929577.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* struct extent_io_ops
* struct btrfs_free_space_op

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c       | 2 +-
 fs/btrfs/free-space-cache.h       | 2 +-
 fs/btrfs/inode-map.c              | 4 ++--
 fs/btrfs/inode.c                  | 4 ++--
 fs/btrfs/tests/free-space-tests.c | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 85a1f8621b51..3e9706af990d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2016,7 +2016,7 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 	return true;
 }
 
-static struct btrfs_free_space_op free_space_op = {
+static const struct btrfs_free_space_op free_space_op = {
 	.recalc_thresholds	= recalculate_thresholds,
 	.use_bitmap		= use_bitmap,
 };
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index f251865eb6f3..33178c490ace 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -37,7 +37,7 @@ struct btrfs_free_space_ctl {
 	int total_bitmaps;
 	int unit;
 	u64 start;
-	struct btrfs_free_space_op *op;
+	const struct btrfs_free_space_op *op;
 	void *private;
 	struct mutex cache_writeout_mutex;
 	struct list_head trimming_ranges;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 767a6056ac45..53014e963617 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -334,7 +334,7 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 	return true;
 }
 
-static struct btrfs_free_space_op free_ino_op = {
+static const struct btrfs_free_space_op free_ino_op = {
 	.recalc_thresholds	= recalculate_thresholds,
 	.use_bitmap		= use_bitmap,
 };
@@ -356,7 +356,7 @@ static bool pinned_use_bitmap(struct btrfs_free_space_ctl *ctl,
 	return false;
 }
 
-static struct btrfs_free_space_op pinned_free_ino_op = {
+static const struct btrfs_free_space_op pinned_free_ino_op = {
 	.recalc_thresholds	= pinned_recalc_thresholds,
 	.use_bitmap		= pinned_use_bitmap,
 };
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 994490d5fa64..bf93a6bf7ca1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -74,7 +74,7 @@ static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
 static const struct address_space_operations btrfs_symlink_aops;
 static const struct file_operations btrfs_dir_file_operations;
-static struct extent_io_ops btrfs_extent_io_ops;
+static const struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
 static struct kmem_cache *btrfs_delalloc_work_cachep;
@@ -10045,7 +10045,7 @@ static const struct file_operations btrfs_dir_file_operations = {
 	.fsync		= btrfs_sync_file,
 };
 
-static struct extent_io_ops btrfs_extent_io_ops = {
+static const struct extent_io_ops btrfs_extent_io_ops = {
 	.fill_delalloc = run_delalloc_range,
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.merge_bio_hook = btrfs_merge_bio_hook,
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 915e290896ca..a53a73e398ad 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -445,11 +445,11 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	int ret;
 	u64 offset;
 	u64 max_extent_size;
-	struct btrfs_free_space_op test_free_space_ops = {
+	const struct btrfs_free_space_op test_free_space_ops = {
 		.recalc_thresholds = cache->free_space_ctl->op->recalc_thresholds,
 		.use_bitmap = test_use_bitmap,
 	};
-	struct btrfs_free_space_op *orig_free_space_ops;
+	const struct btrfs_free_space_op *orig_free_space_ops;
 
 	test_msg("Running space stealing from bitmap to extent\n");
 
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
