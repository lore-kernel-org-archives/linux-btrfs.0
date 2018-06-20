Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754129AbeFTMt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:28 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E586AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 29/34] btrfs: Remove fs_info from run_one_delayed_ref
Date: Wed, 20 Jun 2018 15:49:11 +0300
Message-Id: <1529498956-4241-30-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle, since it's
always valid

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 08ad7572d025..b03fe240da97 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2445,7 +2445,6 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 
 /* helper function to actually process a single delayed ref entry */
 static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_delayed_ref_node *node,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int insert_reserved)
@@ -2454,7 +2453,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (trans->aborted) {
 		if (insert_reserved)
-			btrfs_pin_extent(fs_info, node->bytenr,
+			btrfs_pin_extent(trans->fs_info, node->bytenr,
 					 node->num_bytes, 1);
 		return 0;
 	}
@@ -2731,7 +2730,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		locked_ref->extent_op = NULL;
 		spin_unlock(&locked_ref->lock);
 
-		ret = run_one_delayed_ref(trans, fs_info, ref, extent_op,
+		ret = run_one_delayed_ref(trans, ref, extent_op,
 					  must_insert_reserved);
 
 		btrfs_free_delayed_extent_op(extent_op);
-- 
2.7.4

