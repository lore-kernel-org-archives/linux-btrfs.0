Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3DZM4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 08:56:09 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: zab@redhat.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: handle errors returned from get_tree_block_key
Date: Fri, 26 Apr 2013 14:56:04 +0200
Message-Id: <1366980964-14366-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
References: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c22ccfe..39b7b64 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2864,7 +2864,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		err = -ENOMEM;
-		goto out_path;
+		goto out_free_blocks;
 	}
 
 	rb_node = rb_first(blocks);
@@ -2878,8 +2878,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	rb_node = rb_first(blocks);
 	while (rb_node) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
-		if (!block->key_ready)
-			get_tree_block_key(rc, block);
+		if (!block->key_ready) {
+			err = get_tree_block_key(rc, block);
+			if (err)
+				goto out_free_path;
+		}
 		rb_node = rb_next(rb_node);
 	}
 
@@ -2906,8 +2909,9 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 out:
 	err = finish_pending_nodes(trans, rc, path, err);
 
+out_free_path:
 	btrfs_free_path(path);
-out_path:
+out_free_blocks:
 	free_block_list(blocks);
 	return err;
 }
-- 
1.8.2

