Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031039AbaLLRgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 12:36:07 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2C88AABC6
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 17:36:06 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/9] btrfs: sink blocksize parameter to tree_block_processed
Date: Fri, 12 Dec 2014 18:36:05 +0100
Message-Id: <7476dfdaade5b373db4679555706546bd5b4bd6c.1418404754.git.dsterba@suse.cz>
In-Reply-To: <cover.1418404754.git.dsterba@suse.cz>
References: <cover.1418404754.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cb5d4462ebb4..d83085381bcc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2855,9 +2855,10 @@ static void update_processed_blocks(struct reloc_control *rc,
 	}
 }
 
-static int tree_block_processed(u64 bytenr, u32 blocksize,
-				struct reloc_control *rc)
+static int tree_block_processed(u64 bytenr, struct reloc_control *rc)
 {
+	u32 blocksize = rc->extent_root->nodesize;
+
 	if (test_range_bit(&rc->processed_blocks, bytenr,
 			   bytenr + blocksize - 1, EXTENT_DIRTY, 1, NULL))
 		return 1;
@@ -3352,7 +3353,7 @@ static int __add_tree_block(struct reloc_control *rc,
 	bool skinny = btrfs_fs_incompat(rc->extent_root->fs_info,
 					SKINNY_METADATA);
 
-	if (tree_block_processed(bytenr, blocksize, rc))
+	if (tree_block_processed(bytenr, rc))
 		return 0;
 
 	if (tree_search(blocks, bytenr))
@@ -3610,7 +3611,7 @@ static int find_data_references(struct reloc_control *rc,
 		if (added)
 			goto next;
 
-		if (!tree_block_processed(leaf->start, leaf->len, rc)) {
+		if (!tree_block_processed(leaf->start, rc)) {
 			block = kmalloc(sizeof(*block), GFP_NOFS);
 			if (!block) {
 				err = -ENOMEM;
-- 
2.1.3

