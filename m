Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32404 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab3FFD2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 23:28:18 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: kylegates@hotmail.com, Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] Btrfs: fix broken nocow after balance
Date: Thu, 6 Jun 2013 11:28:03 +0800
Message-Id: <1370489283-4870-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance will create reloc_root for each fs root, and it's going to
record last_snapshot to filter shared blocks.  The side effect of
setting last_snapshot is to break nocow attributes of files.

Since the extents are not shared by the relocation tree after the balance,
we can recover the old last_snapshot safely if no one snapshoted the
source tree. We fix the above problem by this way.

Reported-by: Kyle Gates <kylegates@hotmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 395b820..934ffe6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1305,6 +1305,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *eb;
 	struct btrfs_root_item *root_item;
 	struct btrfs_key root_key;
+	u64 last_snap = 0;
 	int ret;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
@@ -1320,6 +1321,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 				      BTRFS_TREE_RELOC_OBJECTID);
 		BUG_ON(ret);
 
+		last_snap = btrfs_root_last_snapshot(&root->root_item);
 		btrfs_set_root_last_snapshot(&root->root_item,
 					     trans->transid - 1);
 	} else {
@@ -1345,6 +1347,12 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		memset(&root_item->drop_progress, 0,
 		       sizeof(struct btrfs_disk_key));
 		root_item->drop_level = 0;
+		/*
+		 * abuse rtransid, it is safe because it is impossible to
+		 * receive data into a relocation tree.
+		 */
+		btrfs_set_root_rtransid(root_item, last_snap);
+		btrfs_set_root_otransid(root_item, trans->transid);
 	}
 
 	btrfs_tree_unlock(eb);
@@ -2273,8 +2281,12 @@ void free_reloc_roots(struct list_head *list)
 static noinline_for_stack
 int merge_reloc_roots(struct reloc_control *rc)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
+	u64 last_snap;
+	u64 otransid;
+	u64 objectid;
 	LIST_HEAD(reloc_roots);
 	int found = 0;
 	int ret = 0;
@@ -2308,12 +2320,44 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
+
+		/*
+		 * we keep the old last snapshod transid in rtranid when we
+		 * created the relocation tree.
+		 */
+		last_snap = btrfs_root_rtransid(&reloc_root->root_item);
+		otransid = btrfs_root_otransid(&reloc_root->root_item);
+		objectid = reloc_root->root_key.offset;
+
 		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
 		if (ret < 0) {
 			if (list_empty(&reloc_root->root_list))
 				list_add_tail(&reloc_root->root_list,
 					      &reloc_roots);
 			goto out;
+		} else if (!ret) {
+			/*
+			 * recover the last snapshot tranid to avoid
+			 * the space balance break NOCOW.
+			 */
+			root = read_fs_root(rc->extent_root->fs_info,
+					    objectid);
+			if (IS_ERR(root))
+				continue;
+
+			if (btrfs_root_refs(&root->root_item) == 0)
+				continue;
+
+			trans = btrfs_join_transaction(root);
+			BUG_ON(IS_ERR(trans));
+
+			/* Check if the fs/file tree was snapshoted or not. */
+			if (btrfs_root_last_snapshot(&root->root_item) ==
+			    otransid - 1)
+				btrfs_set_root_last_snapshot(&root->root_item,
+							     last_snap);
+				
+			btrfs_end_transaction(trans, root);
 		}
 	}
 
-- 
1.8.1.4

