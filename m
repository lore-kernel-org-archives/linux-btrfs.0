From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix possible ENOSPC problems with truncate
Date: Tue, 13 Oct 2009 14:45:53 -0400
Message-ID: <20091013184552.GA21998@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There's a problem where we don't do any space reservation for truncates, which
can cause you to OOPs because you will be allowed to go off in the weeds a bit
since we don't account for the delalloc bytes that are created as a result of
the truncate.  This patch fixes the problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/inode.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2720bcc..f08ee0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3031,12 +3031,22 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 
 	if ((offset & (blocksize - 1)) == 0)
 		goto out;
+	ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
+	if (ret)
+		goto out;
+
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	if (ret)
+		goto out;
 
 	ret = -ENOMEM;
 again:
 	page = grab_cache_page(mapping, index);
-	if (!page)
+	if (!page) {
+		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
+		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 		goto out;
+	}
 
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
@@ -3069,6 +3079,10 @@ again:
 		goto again;
 	}
 
+	clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  GFP_NOFS);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
 	if (ret) {
 		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
@@ -3087,6 +3101,9 @@ again:
 	unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 
 out_unlock:
+	if (ret)
+		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
+	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -3110,7 +3127,9 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	if (size <= hole_start)
 		return 0;
 
-	btrfs_truncate_page(inode->i_mapping, inode->i_size);
+	err = btrfs_truncate_page(inode->i_mapping, inode->i_size);
+	if (err)
+		return err;
 
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
@@ -5005,7 +5024,9 @@ static void btrfs_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	btrfs_truncate_page(inode->i_mapping, inode->i_size);
+	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
+	if (ret)
+		return;
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
-- 
1.5.4.3

