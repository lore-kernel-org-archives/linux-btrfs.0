Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3DXQvj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 12:51:39 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F3E9FA5077
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 18:51:37 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: handle errors returned from get_tree_block_key
Date: Wed, 24 Apr 2013 18:51:34 +0200
Message-Id: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c22ccfe..e85be23 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2878,8 +2878,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	rb_node = rb_first(blocks);
 	while (rb_node) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
-		if (!block->key_ready)
-			get_tree_block_key(rc, block);
+		if (!block->key_ready) {
+			err = get_tree_block_key(rc, block);
+			if (err)
+				goto out_path;
+		}
 		rb_node = rb_next(rb_node);
 	}
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
