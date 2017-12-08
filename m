Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753331AbdLHN4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:56:02 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ADA9AB49
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Dec 2017 13:56:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: sink extent_write_locked_range tree parameter
Date: Fri,  8 Dec 2017 15:55:58 +0200
Message-Id: <1512741359-17603-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is called only from submit_compressed_extents and the
io tree being passed is always that of the inode. But we are also
passing the inode, so just move getting the io tree pointer in
extent_write_locked_range to simplify the signature.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 5 +++--
 fs/btrfs/extent_io.h | 4 ++--
 fs/btrfs/inode.c     | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 16ae832bdb5d..c0b2bf65d6b0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4073,11 +4073,12 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 	return ret;
 }
 
-int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
-			      u64 start, u64 end, int mode)
+int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
+			      int mode)
 {
 	int ret = 0;
 	struct address_space *mapping = inode->i_mapping;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
 	unsigned long nr_pages = (end - start + PAGE_SIZE) >>
 		PAGE_SHIFT;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c28f5ef88f42..f2cbabb2306a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -405,8 +405,8 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 			  struct writeback_control *wbc);
-int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
-			      u64 start, u64 end, int mode);
+int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
+			      int mode);
 int extent_writepages(struct extent_io_tree *tree,
 		      struct address_space *mapping,
 		      struct writeback_control *wbc);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 18c09cca3be7..e61d549bfc36 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -770,8 +770,8 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			 * all those pages down to the drive.
 			 */
 			if (!page_started && !ret)
-				extent_write_locked_range(io_tree,
-						  inode, async_extent->start,
+				extent_write_locked_range(inode,
+						  async_extent->start,
 						  async_extent->start +
 						  async_extent->ram_size - 1,
 						  WB_SYNC_ALL);
-- 
2.7.4

