Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55470 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731154AbeGSLsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:48:05 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5254FACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: drop extent_io_ops::tree_fs_info callback
Date: Thu, 19 Jul 2018 13:05:18 +0200
Message-Id: <11ad794d29a2c0d4bc0b35d0b58b5f2e0bf7d937.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All implementations of the callback are trivial and do the same and
there's only user. Merge everything together.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   |  7 -------
 fs/btrfs/extent_io.c | 14 ++++----------
 fs/btrfs/extent_io.h |  1 -
 fs/btrfs/inode.c     |  7 -------
 4 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c2d1c66edc49..d6c04933abbc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4523,12 +4523,6 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-static struct btrfs_fs_info *btree_fs_info(void *private_data)
-{
-	struct inode *inode = private_data;
-	return btrfs_sb(inode->i_sb);
-}
-
 static const struct extent_io_ops btree_extent_io_ops = {
 	/* mandatory callbacks */
 	.submit_bio_hook = btree_submit_bio_hook,
@@ -4537,7 +4531,6 @@ static const struct extent_io_ops btree_extent_io_ops = {
 	.merge_bio_hook = btrfs_merge_bio_hook,
 	.readpage_io_failed_hook = btree_io_failed_hook,
 	.set_range_writeback = btrfs_set_range_writeback,
-	.tree_fs_info = btree_fs_info,
 
 	/* optional callbacks */
 };
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fea015be4ce1..f7a138278f16 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -140,14 +140,6 @@ static int add_extent_changeset(struct extent_state *state, unsigned bits,
 
 static void flush_write_bio(struct extent_page_data *epd);
 
-static inline struct btrfs_fs_info *
-tree_fs_info(struct extent_io_tree *tree)
-{
-	if (tree->ops)
-		return tree->ops->tree_fs_info(tree->private_data);
-	return NULL;
-}
-
 int __init extent_io_init(void)
 {
 	extent_state_cache = kmem_cache_create("btrfs_extent_state",
@@ -564,8 +556,10 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
 
 static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
-	btrfs_panic(tree_fs_info(tree), err,
-		    "Locking error: Extent tree was modified by another thread while locked.");
+	struct inode *inode = tree->private_data;
+
+	btrfs_panic(btrfs_sb(inode->i_sb), err,
+	"locking error: extent tree was modified by another thread while locked");
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 129fc4ab30ac..6edbe01fd09d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -105,7 +105,6 @@ struct extent_io_ops {
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-	struct btrfs_fs_info *(*tree_fs_info)(void *private_data);
 	void (*set_range_writeback)(void *private_data, u64 start, u64 end);
 
 	/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0899ab54cd06..1614551cf953 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10468,12 +10468,6 @@ static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
 	return -EAGAIN;
 }
 
-static struct btrfs_fs_info *iotree_fs_info(void *private_data)
-{
-	struct inode *inode = private_data;
-	return btrfs_sb(inode->i_sb);
-}
-
 static void btrfs_check_extent_io_range(void *private_data, const char *caller,
 					u64 start, u64 end)
 {
@@ -10548,7 +10542,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.merge_bio_hook = btrfs_merge_bio_hook,
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
-	.tree_fs_info = iotree_fs_info,
 	.set_range_writeback = btrfs_set_range_writeback,
 
 	/* optional callbacks */
-- 
2.18.0

