Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51291 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3F0PeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 11:34:08 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6F11C9A0368
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 09:34:08 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id JHFJx50Dp8dbBCxq (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 09:34:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup orphaned root orphan item
Date: Thu, 27 Jun 2013 11:34:05 -0400
Message-ID: <1372347245-2847-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a weird problem were my root item had been deleted but the orphan item had
not.  This isn't necessarily a problem, but it keeps the file system from being
mounted.  To fix this we just need to axe the orphan item if we can't find the
fs root when we're putting them altogether.  With this patch I was able to
successfully mount my file system.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/root-tree.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 723a531..5ff08ca 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -228,6 +228,10 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 	struct btrfs_root *root;
 	int err = 0;
 	int ret;
+	bool can_recover = true;
+
+	if (tree_root->fs_info->sb->s_flags & MS_RDONLY)
+		can_recover = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -268,9 +272,32 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 		key.offset++;
 
 		root = btrfs_read_fs_root(tree_root, &root_key);
-		if (IS_ERR(root)) {
-			err = PTR_ERR(root);
+		err = PTR_ERR(root);
+		if (err && err != -ENOENT) {
 			break;
+		} else if (err == -ENOENT) {
+			struct btrfs_trans_handle *trans;
+
+			btrfs_release_path(path);
+
+			trans = btrfs_join_transaction(tree_root);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
+				btrfs_error(tree_root->fs_info, err,
+					    "Failed to start trans to delete "
+					    "orphan item");
+				break;
+			}
+			err = btrfs_del_orphan_item(trans, tree_root,
+						    root_key.objectid);
+			btrfs_end_transaction(trans, tree_root);
+			if (err) {
+				btrfs_error(tree_root->fs_info, err,
+					    "Failed to delete root orphan "
+					    "item");
+				break;
+			}
+			continue;
 		}
 
 		if (btrfs_root_refs(&root->root_item) == 0) {
-- 
1.7.7.6

