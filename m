Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54153 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbeDSHqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A029AE55
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:43 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] btrfs: Remove tree argument from extent_writepages
Date: Thu, 19 Apr 2018 10:46:38 +0300
Message-Id: <1524123999-4220-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be directly referenced from the passed address_space so do that.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 5 +----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5cde345fa0b6..22688b5ffb62 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4109,14 +4109,13 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 	return ret;
 }
 
-int extent_writepages(struct extent_io_tree *tree,
-		      struct address_space *mapping,
+int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio = NULL,
-		.tree = tree,
+		.tree = &BTRFS_I(mapping->host)->io_tree,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 2f085108335d..e02bda4b85cd 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -419,8 +419,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 int extent_write_full_page(struct page *page, struct writeback_control *wbc);
 int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode);
-int extent_writepages(struct extent_io_tree *tree,
-		      struct address_space *mapping,
+int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc);
 int btree_write_cache_pages(struct address_space *mapping,
 			    struct writeback_control *wbc);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 423a6eb3165c..b4158c2b6f3e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8730,10 +8730,7 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 static int btrfs_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	struct extent_io_tree *tree;
-
-	tree = &BTRFS_I(mapping->host)->io_tree;
-	return extent_writepages(tree, mapping, wbc);
+	return extent_writepages(mapping, wbc);
 }
 
 static int
-- 
2.7.4

