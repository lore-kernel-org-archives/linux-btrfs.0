Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403798AbeHPQJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:11 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA944AE66
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:39 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/8] btrfs-progs: Remove __free_extent2
Date: Thu, 16 Aug 2018 16:10:34 +0300
Message-Id: <1534425035-323-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that delayed refs have been all wired up clean up the __free_extent2
adapter function since it's no longer needed. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 6893b4c07019..1a63efdd9681 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2052,17 +2052,6 @@ void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 	update_pinned_extents(fs_info, bytenr, num_bytes, 0);
 }
 
-static int __free_extent2(struct btrfs_trans_handle *trans,
-			  struct btrfs_delayed_ref_node *node,
-			  struct btrfs_delayed_extent_op *extent_op)
-{
-
-	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
-
-	return __free_extent(trans, node->bytenr, node->num_bytes,
-			     ref->parent, ref->root, ref->level, 0, 1);
-}
-
 /*
  * remove an extent from the root, returns 0 on success
  */
@@ -4183,7 +4172,9 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		BUG_ON(!extent_op || !extent_op->update_flags);
 		ret = alloc_reserved_tree_block2(trans, node, extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
-		ret = __free_extent2(trans, node, extent_op);
+		struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
+		ret =  __free_extent(trans, node->bytenr, node->num_bytes,
+			     ref->parent, ref->root, ref->level, 0, 1);
 	} else {
 		BUG();
 	}
-- 
2.7.4
