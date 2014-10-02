Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbaJBQwp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 298C9AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:44 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] btrfs: remove unused parameter blocksize from btrfs_find_tree_block
Date: Thu,  2 Oct 2014 18:52:43 +0200
Message-Id: <0308af4465897c889e32754ef37bb465a1b2b872.1412265713.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265712.git.dsterba@suse.cz>
References: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c       | 12 +++++-------
 fs/btrfs/disk-io.c     |  5 ++---
 fs/btrfs/disk-io.h     |  2 +-
 fs/btrfs/extent-tree.c |  2 +-
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 302c3f955706..2fb4ab659a0f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1683,7 +1683,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		cur = btrfs_find_tree_block(root, blocknr, blocksize);
+		cur = btrfs_find_tree_block(root, blocknr);
 		if (cur)
 			uptodate = btrfs_buffer_uptodate(cur, gen, 0);
 		else
@@ -2264,7 +2264,7 @@ static void reada_for_search(struct btrfs_root *root,
 
 	search = btrfs_node_blockptr(node, slot);
 	blocksize = root->nodesize;
-	eb = btrfs_find_tree_block(root, search, blocksize);
+	eb = btrfs_find_tree_block(root, search);
 	if (eb) {
 		free_extent_buffer(eb);
 		return;
@@ -2326,7 +2326,7 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 	if (slot > 0) {
 		block1 = btrfs_node_blockptr(parent, slot - 1);
 		gen = btrfs_node_ptr_generation(parent, slot - 1);
-		eb = btrfs_find_tree_block(root, block1, blocksize);
+		eb = btrfs_find_tree_block(root, block1);
 		/*
 		 * if we get -eagain from btrfs_buffer_uptodate, we
 		 * don't want to return eagain here.  That will loop
@@ -2339,7 +2339,7 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 	if (slot + 1 < nritems) {
 		block2 = btrfs_node_blockptr(parent, slot + 1);
 		gen = btrfs_node_ptr_generation(parent, slot + 1);
-		eb = btrfs_find_tree_block(root, block2, blocksize);
+		eb = btrfs_find_tree_block(root, block2);
 		if (eb && btrfs_buffer_uptodate(eb, gen, 1) != 0)
 			block2 = 0;
 		free_extent_buffer(eb);
@@ -2450,16 +2450,14 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 {
 	u64 blocknr;
 	u64 gen;
-	u32 blocksize;
 	struct extent_buffer *b = *eb_ret;
 	struct extent_buffer *tmp;
 	int ret;
 
 	blocknr = btrfs_node_blockptr(b, slot);
 	gen = btrfs_node_ptr_generation(b, slot);
-	blocksize = root->nodesize;
 
-	tmp = btrfs_find_tree_block(root, blocknr, blocksize);
+	tmp = btrfs_find_tree_block(root, blocknr);
 	if (tmp) {
 		/* first we do an atomic uptodate check */
 		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 03c0973568ef..e0293d2fbb3a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1108,7 +1108,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 }
 
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
-					    u64 bytenr, u32 blocksize)
+					    u64 bytenr)
 {
 	return find_extent_buffer(root->fs_info, bytenr);
 }
@@ -4002,8 +4002,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 
 		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
-			eb = btrfs_find_tree_block(root, start,
-						   root->nodesize);
+			eb = btrfs_find_tree_block(root, start);
 			start += root->nodesize;
 			if (!eb)
 				continue;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 03f396144fe1..ae04daef6087 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -62,7 +62,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
-					    u64 bytenr, u32 blocksize);
+					    u64 bytenr);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 				      struct btrfs_key *location);
 int btrfs_init_fs_root(struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 178f6dbf2d7c..d9a90da93302 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7825,7 +7825,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
 	blocksize = root->nodesize;
 
-	next = btrfs_find_tree_block(root, bytenr, blocksize);
+	next = btrfs_find_tree_block(root, bytenr);
 	if (!next) {
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (!next)
-- 
1.8.4.5

