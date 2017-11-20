Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42113 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbdKTUZC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:25:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35749AB02
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:25:01 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: remove dead code from btrfs_get_extent
Date: Mon, 20 Nov 2017 13:24:49 -0700
Message-Id: <20171120202449.22947-4-enadolski@suse.com>
In-Reply-To: <20171120202449.22947-1-enadolski@suse.com>
References: <20171120202449.22947-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to new_inline logic, the create == 0 is always true at this
point in the code, so the create != 0 branch can be removed.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
---
 fs/btrfs/inode.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b6d5d94..0d4a066 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6957,7 +6957,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	struct btrfs_trans_handle *trans = NULL;
 	const bool new_inline = !page || create;
 
-again:
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, start, len);
 	if (em)
@@ -7098,7 +7097,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		em->orig_block_len = em->len;
 		em->orig_start = em->start;
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
-		if (create == 0 && !PageUptodate(page)) {
+		if (!PageUptodate(page)) {
 			if (btrfs_file_extent_compression(leaf, item) !=
 			    BTRFS_COMPRESS_NONE) {
 				ret = uncompress_inline(path, page, pg_offset,
@@ -7119,25 +7118,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 				kunmap(page);
 			}
 			flush_dcache_page(page);
-		} else if (create && PageUptodate(page)) {
-			BUG();
-			if (!trans) {
-				kunmap(page);
-				free_extent_map(em);
-				em = NULL;
-
-				btrfs_release_path(path);
-				trans = btrfs_join_transaction(root);
-
-				if (IS_ERR(trans))
-					return ERR_CAST(trans);
-				goto again;
-			}
-			map = kmap(page);
-			write_extent_buffer(leaf, map + pg_offset, ptr,
-					    copy_size);
-			kunmap(page);
-			btrfs_mark_buffer_dirty(leaf);
 		}
 		set_extent_uptodate(io_tree, em->start,
 				    extent_map_end(em) - 1, NULL, GFP_NOFS);
-- 
2.10.2

