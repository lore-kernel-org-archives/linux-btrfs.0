Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932304AbdKFTcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7265ABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/10] btrfs: sink get_extent parameter to extent_writepages
Date: Mon,  6 Nov 2017 20:30:44 +0100
Message-Id: <4d802107d5a9bbe7b1f0c3f532b48783626fd0c4.1509996091.git.dsterba@suse.com>
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
index ea412243c68d..12305542ed2b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4131,14 +4131,13 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 
 int extent_writepages(struct extent_io_tree *tree,
 		      struct address_space *mapping,
-		      get_extent_t *get_extent,
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = get_extent,
+		.get_extent = btrfs_get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8b27af7101e..7e1b730045c5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -407,7 +407,6 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 			      int mode);
 int extent_writepages(struct extent_io_tree *tree,
 		      struct address_space *mapping,
-		      get_extent_t *get_extent,
 		      struct writeback_control *wbc);
 int btree_write_cache_pages(struct address_space *mapping,
 			    struct writeback_control *wbc);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 88cd15fc34d4..d626f209b22f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8884,7 +8884,7 @@ static int btrfs_writepages(struct address_space *mapping,
 	struct extent_io_tree *tree;
 
 	tree = &BTRFS_I(mapping->host)->io_tree;
-	return extent_writepages(tree, mapping, btrfs_get_extent, wbc);
+	return extent_writepages(tree, mapping, wbc);
 }
 
 static int
-- 
2.14.3

