Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54175 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdKFTcn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 965ECABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/10] btrfs: drop get_extent from extent_page_data
Date: Mon,  6 Nov 2017 20:30:51 +0100
Message-Id: <63a76267ef99f4500d5bddc800e6d40e7bdbfdd5.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previous patches cleaned up all places where
extent_page_data::get_extent was set and it was btrfs_get_extent all the
time, so we can simply call that instead.

This also reduces size of extent_page_data by 8 bytes which has positive
effect on stack consumption on various functions on the write out path.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 76d1b307aeaa..8f1d98bc11d0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -108,8 +108,6 @@ struct tree_entry {
 struct extent_page_data {
 	struct bio *bio;
 	struct extent_io_tree *tree;
-	get_extent_t *get_extent;
-
 	/* tells writepage not to lock the state bits for this range
 	 * it still does the unlocking
 	 */
@@ -3372,7 +3370,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(BTRFS_I(inode), page, pg_offset, cur,
+		em = btrfs_get_extent(BTRFS_I(inode), page, pg_offset, cur,
 				     end - cur + 1, 1);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
@@ -4074,7 +4072,6 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = btrfs_get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
@@ -4097,7 +4094,6 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = btrfs_get_extent,
 		.extent_locked = 1,
 		.sync_io = mode == WB_SYNC_ALL,
 	};
@@ -4135,7 +4131,6 @@ int extent_writepages(struct extent_io_tree *tree,
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
-		.get_extent = btrfs_get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
-- 
2.14.3

