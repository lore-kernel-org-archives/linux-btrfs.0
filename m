Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54508 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab2INRrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 13:47:19 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id VYzfhNXHQBVt5iSD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 11:47:19 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove unused write cache pages hook
Date: Fri, 14 Sep 2012 13:52:44 -0400
Message-ID: <1347645164-6126-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btree inode has it's own write cache pages so we can remove this write
cache pages hook as it's not used.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   47 -----------------------------------------------
 1 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5d3f813..2c18a4e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3347,52 +3347,6 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
-int btree_lock_page_hook(struct page *page, void *data,
-				void (*flush_fn)(void *))
-{
-	struct inode *inode = page->mapping->host;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_buffer *eb;
-
-	/*
-	 * We culled this eb but the page is still hanging out on the mapping,
-	 * carry on.
-	 */
-	if (!PagePrivate(page))
-		goto out;
-
-	eb = (struct extent_buffer *)page->private;
-	if (!eb) {
-		WARN_ON(1);
-		goto out;
-	}
-	if (page != eb->pages[0])
-		goto out;
-
-	if (!btrfs_try_tree_write_lock(eb)) {
-		flush_fn(data);
-		btrfs_tree_lock(eb);
-	}
-	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-
-	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		if (root->fs_info->dirty_metadata_bytes >= eb->len)
-			root->fs_info->dirty_metadata_bytes -= eb->len;
-		else
-			WARN_ON(1);
-		spin_unlock(&root->fs_info->delalloc_lock);
-	}
-
-	btrfs_tree_unlock(eb);
-out:
-	if (!trylock_page(page)) {
-		flush_fn(data);
-		lock_page(page);
-	}
-	return 0;
-}
-
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 			      int read_only)
 {
@@ -3787,7 +3741,6 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 }
 
 static struct extent_io_ops btree_extent_io_ops = {
-	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
-- 
1.7.7.6

