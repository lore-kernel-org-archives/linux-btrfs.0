Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37987 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752728Ab3KDVhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:37:01 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: fix unused variables in qgroup.c
Date: Mon,  4 Nov 2013 22:34:29 +0100
Message-Id: <1383600869-10085-10-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use otherwise unused local variables slot in update_qgroup_limit_item and
in update_qgroup_info_item, and remove unused variable ins from
btrfs_qgroup_account_ref.

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/qgroup.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..bd0b058 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -644,8 +644,7 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 
 	l = path->nodes[0];
 	slot = path->slots[0];
-	qgroup_limit = btrfs_item_ptr(l, path->slots[0],
-				      struct btrfs_qgroup_limit_item);
+	qgroup_limit = btrfs_item_ptr(l, slot, struct btrfs_qgroup_limit_item);
 	btrfs_set_qgroup_limit_flags(l, qgroup_limit, flags);
 	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, max_rfer);
 	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, max_excl);
@@ -687,8 +686,7 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 
 	l = path->nodes[0];
 	slot = path->slots[0];
-	qgroup_info = btrfs_item_ptr(l, path->slots[0],
-				 struct btrfs_qgroup_info_item);
+	qgroup_info = btrfs_item_ptr(l, slot, struct btrfs_qgroup_info_item);
 	btrfs_set_qgroup_info_generation(l, qgroup_info, trans->transid);
 	btrfs_set_qgroup_info_rfer(l, qgroup_info, qgroup->rfer);
 	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, qgroup->rfer_cmpr);
@@ -1349,7 +1347,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			     struct btrfs_delayed_ref_node *node,
 			     struct btrfs_delayed_extent_op *extent_op)
 {
-	struct btrfs_key ins;
 	struct btrfs_root *quota_root;
 	u64 ref_root;
 	struct btrfs_qgroup *qgroup;
@@ -1363,10 +1360,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!fs_info->quota_root);
 
-	ins.objectid = node->bytenr;
-	ins.offset = node->num_bytes;
-	ins.type = BTRFS_EXTENT_ITEM_KEY;
-
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		struct btrfs_delayed_tree_ref *ref;
-- 
1.7.10.4

