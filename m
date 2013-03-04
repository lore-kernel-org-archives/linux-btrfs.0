Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3CDQ1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:19 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRILl019188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:19 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRHCw009724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:18 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRHGY020426
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:17 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: build up error handling for merge_reloc_roots
Date: Tue,  5 Mar 2013 00:25:37 +0800
Message-Id: <1362414341-17306-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We first use btrfs_std_error hook to replace with BUG_ON, and we
also need to cleanup what is left, including reloc roots rbtree
and reloc roots list.
Here we use a helper function to cleanup both rbtree and list, and
since this function can also be used in the balance recover path,
we also make the change as well to keep code simple.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d9be73b..8608afb 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2240,13 +2240,28 @@ again:
 }
 
 static noinline_for_stack
+void free_reloc_roots(struct list_head *list)
+{
+	struct btrfs_root *reloc_root;
+
+	while (!list_empty(list)) {
+		reloc_root = list_entry(list->next, struct btrfs_root,
+					root_list);
+		__update_reloc_root(reloc_root, 1);
+		free_extent_buffer(reloc_root->node);
+		free_extent_buffer(reloc_root->commit_root);
+		kfree(reloc_root);
+	}
+}
+
+static noinline_for_stack
 int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
 	LIST_HEAD(reloc_roots);
 	int found = 0;
-	int ret;
+	int ret = 0;
 again:
 	root = rc->extent_root;
 
@@ -2272,20 +2287,33 @@ again:
 			BUG_ON(root->reloc_root != reloc_root);
 
 			ret = merge_reloc_root(rc, root);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
 		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			if (list_empty(&reloc_root->root_list))
+				list_add_tail(&reloc_root->root_list,
+					      &reloc_roots);
+			goto out;
+		}
 	}
 
 	if (found) {
 		found = 0;
 		goto again;
 	}
+out:
+	if (ret) {
+		btrfs_std_error(root->fs_info, ret);
+		if (!list_empty(&reloc_roots))
+			free_reloc_roots(&reloc_roots);
+	}
+
 	BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
-	return 0;
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -4266,14 +4294,9 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 out_free:
 	kfree(rc);
 out:
-	while (!list_empty(&reloc_roots)) {
-		reloc_root = list_entry(reloc_roots.next,
-					struct btrfs_root, root_list);
-		list_del(&reloc_root->root_list);
-		free_extent_buffer(reloc_root->node);
-		free_extent_buffer(reloc_root->commit_root);
-		kfree(reloc_root);
-	}
+	if (!list_empty(&reloc_roots))
+		free_reloc_roots(&reloc_roots);
+
 	btrfs_free_path(path);
 
 	if (err == 0) {
-- 
1.7.7

