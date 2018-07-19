Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730763AbeGSLsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:48:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE100AD7A
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs: drop extent_io_ops::set_range_writeback callback
Date: Thu, 19 Jul 2018 13:05:23 +0200
Message-Id: <76c3a84cb3c27b7acb188d2eb86f49243411bbe6.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data and metadata callback implementation both use the same
function. We can remove the call indirection and intermediate helper
completely.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     |  2 +-
 fs/btrfs/disk-io.c   |  1 -
 fs/btrfs/extent_io.c | 10 +---------
 fs/btrfs/extent_io.h |  1 -
 fs/btrfs/inode.c     |  5 ++---
 5 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ee1e152cb94b..9c638931b75e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3172,7 +3172,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
-void btrfs_set_range_writeback(void *private_data, u64 start, u64 end);
+void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end);
 vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 31ab764cf4e3..4e02c2ac1a96 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4528,7 +4528,6 @@ static const struct extent_io_ops btree_extent_io_ops = {
 	.submit_bio_hook = btree_submit_bio_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	.readpage_io_failed_hook = btree_io_failed_hook,
-	.set_range_writeback = btrfs_set_range_writeback,
 
 	/* optional callbacks */
 };
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55a845621f85..a427e44c6613 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1380,14 +1380,6 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	}
 }
 
-/*
- * helper function to set both pages and extents in the tree writeback
- */
-static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	tree->ops->set_range_writeback(tree->private_data, start, end);
-}
-
 /* find the first state struct with 'bits' set after 'start', and
  * return it.  tree->lock must be held.  NULL will returned if
  * nothing was found after 'start'
@@ -3416,7 +3408,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			continue;
 		}
 
-		set_range_writeback(tree, cur, cur + iosize - 1);
+		btrfs_set_range_writeback(tree, cur, cur + iosize - 1);
 		if (!PageWriteback(page)) {
 			btrfs_err(BTRFS_I(inode)->root->fs_info,
 				   "page %lu not writeback, cur %llu end %llu",
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ec7c4a2982d0..57c2c31f3170 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -102,7 +102,6 @@ struct extent_io_ops {
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-	void (*set_range_writeback)(void *private_data, u64 start, u64 end);
 
 	/*
 	 * Optional hooks, called if the pointer is not NULL
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 845621a71468..886c205b77f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10482,9 +10482,9 @@ static void btrfs_check_extent_io_range(void *private_data, const char *caller,
 	}
 }
 
-void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
+void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	struct inode *inode = private_data;
+	struct inode *inode = tree->private_data;
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;
@@ -10541,7 +10541,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
-	.set_range_writeback = btrfs_set_range_writeback,
 
 	/* optional callbacks */
 	.fill_delalloc = run_delalloc_range,
-- 
2.18.0

