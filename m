Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdKFTcl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 445E3ABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/10] btrfs: sink get_extent parameter to extent_write_full_page
Date: Mon,  6 Nov 2017 20:30:49 +0100
Message-Id: <f898a9195c18c6df9964b7d52eb4ec2b9e689338.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 +--
 fs/btrfs/extent_io.h | 1 -
 fs/btrfs/inode.c     | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 42ecd975e074..76d1b307aeaa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4068,14 +4068,13 @@ static noinline void flush_write_bio(void *data)
 }
 
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
-			  get_extent_t *get_extent,
 			  struct writeback_control *wbc)
 {
 	int ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = get_extent,
+		.get_extent = btrfs_get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a1f74d9b8dda..b095aa787857 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -400,7 +400,6 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
-			  get_extent_t *get_extent,
 			  struct writeback_control *wbc);
 int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 			      u64 start, u64 end, int mode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f5e706c09af1..31f9552bd78a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8872,7 +8872,7 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	ret = extent_write_full_page(tree, page, btrfs_get_extent, wbc);
+	ret = extent_write_full_page(tree, page, wbc);
 	btrfs_add_delayed_iput(inode);
 	return ret;
 }
-- 
2.14.3

