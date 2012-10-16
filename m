Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37756 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2JPFox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 01:44:53 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3A7173EE0AE
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 14:44:52 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 22F1345DE4F
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 14:44:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0A82345DE4E
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 14:44:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id ECD481DB802F
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 14:44:51 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A5F361DB8037
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 14:44:51 +0900 (JST)
Message-Id: <201210160544.AA00015@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 Oct 2012 14:44:21 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: fix memory leak in btrfs_quota_enable()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should free quota_root before returning from the error
handling code.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/qgroup.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5039686..5776506 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -790,8 +790,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out_free_root;
+	}
 
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_STATUS_KEY;
@@ -800,7 +802,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*ptr));
 	if (ret)
-		goto out;
+		goto out_free_path;
 
 	leaf = path->nodes[0];
 	ptr = btrfs_item_ptr(leaf, path->slots[0],
@@ -818,8 +820,15 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	fs_info->quota_root = quota_root;
 	fs_info->pending_quota_state = 1;
 	spin_unlock(&fs_info->qgroup_lock);
-out:
+out_free_path:
 	btrfs_free_path(path);
+out_free_root:
+	if (ret) {
+		free_extent_buffer(quota_root->node);
+		free_extent_buffer(quota_root->commit_root);
+		kfree(quota_root);
+	}
+out:
 	return ret;
 }
 
-- 
1.7.12.2

