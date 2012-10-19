Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51493 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2JSJvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 05:51:54 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH 2/4] Btrfs: reorder tree mod log operations in deleting a pointer
Date: Fri, 19 Oct 2012 17:50:53 +0800
Message-Id: <1350640255-3760-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
References: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we don't use MOD_LOG_KEY_REMOVE_WHILE_MOVING to add nritems
during rewinding, we should insert a MOD_LOG_KEY_REMOVE operation first.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2858c2f..bbea4fb 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4569,6 +4569,12 @@ static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	u32 nritems;
 	int ret;
 
+	if (tree_mod_log && level) {
+		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
+					      MOD_LOG_KEY_REMOVE);
+		BUG_ON(ret < 0);
+	}
+
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
 		if (tree_mod_log && level)
@@ -4579,10 +4585,6 @@ static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      sizeof(struct btrfs_key_ptr) *
 			      (nritems - slot - 1));
-	} else if (tree_mod_log && level) {
-		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
-					      MOD_LOG_KEY_REMOVE);
-		BUG_ON(ret < 0);
 	}
 
 	nritems--;
-- 
1.7.7.6

