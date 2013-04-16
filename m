Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35830 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3DPFSM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 01:18:12 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E4FC73EE0B6
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id CD7B245DE4D
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id AE20F45DE4F
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A044B1DB8037
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 58BB31DB802F
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 2FA289F7CC5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:10 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id CDB099F7D61
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:09 +0900 (JST)
Message-Id: <201304160518.AA00024@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 Apr 2013 14:18:02 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs: remove unused argument of fixup_low_keys()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' is not used in fixup_low_keys(). So, remove it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ca9d8f1..b5eec7c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2902,8 +2902,7 @@ again:
  * higher levels
  *
  */
-static void fixup_low_keys(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
+static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
 			   struct btrfs_disk_key *key, int level)
 {
 	int i;
@@ -2951,7 +2950,7 @@ void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(root, path, &disk_key, 1);
 }
 
 /*
@@ -3687,7 +3686,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	fixup_low_keys(trans, root, path, &disk_key, 1);
+	fixup_low_keys(root, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -4047,8 +4046,7 @@ again:
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0)
-				fixup_low_keys(trans, root, path,
-					       &disk_key, 1);
+				fixup_low_keys(root, path, &disk_key, 1);
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
@@ -4367,7 +4365,7 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(trans, root, path, &disk_key, 1);
+			fixup_low_keys(root, path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(leaf, slot);
@@ -4531,7 +4529,7 @@ void setup_items_for_insert(struct btrfs_trans_handle *trans,
 
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -4642,7 +4640,7 @@ static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		fixup_low_keys(trans, root, path, &disk_key, level + 1);
+		fixup_low_keys(root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 }
@@ -4744,7 +4742,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			fixup_low_keys(trans, root, path, &disk_key, 1);
+			fixup_low_keys(root, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
-- 
1.7.12.2

