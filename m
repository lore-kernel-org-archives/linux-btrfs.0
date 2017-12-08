Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40451 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753371AbdLHN4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:56:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93A09AC6F
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Dec 2017 13:56:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: sink extent_write_full_page tree argument
Date: Fri,  8 Dec 2017 15:55:59 +0200
Message-Id: <1512741359-17603-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1512741359-17603-1-git-send-email-nborisov@suse.com>
References: <1512741359-17603-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree argument passed to extent_write_full_page is referenced from
the page being passed to the same function. Since we already have
enough information to get the reference, remove the function parameter.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c0b2bf65d6b0..6cd3da16f114 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4056,13 +4056,12 @@ static noinline void flush_write_bio(void *data)
 	flush_epd_write_bio(epd);
 }
 
-int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
-			  struct writeback_control *wbc)
+int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
-		.tree = tree,
+		.tree = &BTRFS_I(page->mapping->host)->io_tree,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f2cbabb2306a..db2558b0cad4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -403,8 +403,7 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  struct extent_state **cached_state);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
-int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
-			  struct writeback_control *wbc);
+int extent_write_full_page(struct page *page, struct writeback_control *wbc);
 int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode);
 int extent_writepages(struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e61d549bfc36..e79154f032e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8862,7 +8862,6 @@ int btrfs_readpage(struct file *file, struct page *page)
 
 static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct extent_io_tree *tree;
 	struct inode *inode = page->mapping->host;
 	int ret;
 
@@ -8881,8 +8880,7 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 		redirty_page_for_writepage(wbc, page);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	ret = extent_write_full_page(tree, page, wbc);
+	ret = extent_write_full_page(page, wbc);
 	btrfs_add_delayed_iput(inode);
 	return ret;
 }
-- 
2.7.4

