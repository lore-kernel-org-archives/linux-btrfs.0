Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403798AbeHPQJJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:09 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2FB6DAE67
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/8] btrfs-progs: Add alloc_reserved_tree_block2 function
Date: Thu, 16 Aug 2018 16:10:29 +0300
Message-Id: <1534425035-323-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple adapter function to convert the delayed-refs structures
to the current arguments of alloc_reserved_tree_block.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 extent-tree.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index 34409e600087..f7b59f84bf3d 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2687,6 +2687,30 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
+				      struct btrfs_delayed_ref_node *node,
+				      struct btrfs_delayed_extent_op *extent_op)
+{
+
+	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
+	struct btrfs_key ins;
+	bool skinny_metadata = btrfs_fs_incompat(trans->fs_info, SKINNY_METADATA);
+
+	ins.objectid = node->bytenr;
+	if (skinny_metadata) {
+		ins.offset = ref->level;
+		ins.type = BTRFS_METADATA_ITEM_KEY;
+	} else {
+		ins.offset = node->num_bytes;
+		ins.type = BTRFS_EXTENT_ITEM_KEY;
+	}
+
+	return alloc_reserved_tree_block(trans, ref->root, trans->transid,
+					 extent_op->flags_to_set,
+					 &extent_op->key, ref->level, &ins);
+
+}
+
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     u64 root_objectid, u64 generation,
 				     u64 flags, struct btrfs_disk_key *key,
-- 
2.7.4
