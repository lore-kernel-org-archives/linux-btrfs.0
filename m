Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbcGONXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 09:23:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DEEE6ACBB
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 13:23:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: hide test-only member under ifdef
Date: Fri, 15 Jul 2016 15:23:37 +0200
Message-Id: <1468589017-32511-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 2 ++
 fs/btrfs/extent-tree.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4274a7bfdaed..47ad088cfa00 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1179,8 +1179,10 @@ struct btrfs_root {
 
 	u64 highest_objectid;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	/* only used with CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled */
 	u64 alloc_bytenr;
+#endif
 
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 82b912a293ab..f043c1f972de 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8142,6 +8142,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (btrfs_test_is_dummy_root(root)) {
 		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
 					    level);
@@ -8149,6 +8150,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 			root->alloc_bytenr += blocksize;
 		return buf;
 	}
+#endif
 
 	block_rsv = use_block_rsv(trans, root, blocksize);
 	if (IS_ERR(block_rsv))
-- 
2.7.1

