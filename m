Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932304AbdKFTcj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0ADEDABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/10] btrfs: sink get_extent parameter to extent_write_locked_range
Date: Mon,  6 Nov 2017 20:30:47 +0100
Message-Id: <6a01a121213eec2ed528933adfae880be40496e0.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 12305542ed2b..42ecd975e074 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4087,8 +4087,7 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 }
 
 int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
-			      u64 start, u64 end, get_extent_t *get_extent,
-			      int mode)
+			      u64 start, u64 end, int mode)
 {
 	int ret = 0;
 	struct address_space *mapping = inode->i_mapping;
@@ -4099,7 +4098,7 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = get_extent,
+		.get_extent = btrfs_get_extent,
 		.extent_locked = 1,
 		.sync_io = mode == WB_SYNC_ALL,
 	};
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7e1b730045c5..a1f74d9b8dda 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -403,8 +403,7 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent,
 			  struct writeback_control *wbc);
 int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
-			      u64 start, u64 end, get_extent_t *get_extent,
-			      int mode);
+			      u64 start, u64 end, int mode);
 int extent_writepages(struct extent_io_tree *tree,
 		      struct address_space *mapping,
 		      struct writeback_control *wbc);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d626f209b22f..f5e706c09af1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -769,7 +769,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 						  inode, async_extent->start,
 						  async_extent->start +
 						  async_extent->ram_size - 1,
-						  btrfs_get_extent,
 						  WB_SYNC_ALL);
 			else if (ret)
 				unlock_page(async_cow->locked_page);
-- 
2.14.3

