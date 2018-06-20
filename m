Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbeFTMtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:25 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF1BDAE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 18/34] btrfs: Remove fs_info from run_delayed_data_ref
Date: Wed, 20 Jun 2018 15:49:00 +0300
Message-Id: <1529498956-4241-19-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction from where
fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b72a6d7d84c3..edc1c98c3556 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2255,7 +2255,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 }
 
 static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_ref_node *node,
 				struct btrfs_delayed_extent_op *extent_op,
 				int insert_reserved)
@@ -2272,7 +2271,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 
 	ref = btrfs_delayed_node_to_data_ref(node);
-	trace_run_delayed_data_ref(fs_info, node, ref, node->action);
+	trace_run_delayed_data_ref(trans->fs_info, node, ref, node->action);
 
 	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
 		parent = ref->parent;
@@ -2471,7 +2470,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 					   insert_reserved);
 	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		 node->type == BTRFS_SHARED_DATA_REF_KEY)
-		ret = run_delayed_data_ref(trans, fs_info, node, extent_op,
+		ret = run_delayed_data_ref(trans, node, extent_op,
 					   insert_reserved);
 	else
 		BUG();
-- 
2.7.4

