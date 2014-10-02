Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbaJBQwi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 876D6AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:37 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] btrfs: inline code of reada_tree_block and remove it
Date: Thu,  2 Oct 2014 18:52:37 +0200
Message-Id: <453848a05ff984cb3665bad5c7e0024e8cfe87a5.1412265712.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265712.git.dsterba@suse.cz>
References: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's trivial with a single user. And remove one pointless BUG_ON.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 16cb2b4a9620..d7506325b024 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2857,15 +2857,6 @@ static int get_tree_block_key(struct reloc_control *rc,
 	return 0;
 }
 
-static int reada_tree_block(struct reloc_control *rc,
-			    struct tree_block *block)
-{
-	BUG_ON(block->key_ready);
-	readahead_tree_block(rc->extent_root, block->bytenr,
-			block->key.objectid);
-	return 0;
-}
-
 /*
  * helper function to relocate a tree block
  */
@@ -2945,7 +2936,8 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	while (rb_node) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
 		if (!block->key_ready)
-			reada_tree_block(rc, block);
+			readahead_tree_block(rc->extent_root, block->bytenr,
+					block->key.objectid);
 		rb_node = rb_next(rb_node);
 	}
 
-- 
1.8.4.5

