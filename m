Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:19938 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeDKFTe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 01:19:34 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 09F19AC012C
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:19:29 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 3551B328749
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:19:28 +0900 (JST)
Subject: [PATCH v4 1/4] btrfs: move may_destroy_subvol() from ioctl.c to
 inode.c
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Message-ID: <7024d2e6-2d01-4579-e50c-057fb93b7f19@jp.fujitsu.com>
Date: Wed, 11 Apr 2018 14:19:25 +0900
MIME-Version: 1.0
In-Reply-To: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation work to refactor btrfs_ioctl_snap_destroy()
and to allow rmdir(2) to delete an empty subvolume.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/inode.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c | 54 ------------------------------------------------------
 3 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da308774b8a4..2dbead106aab 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3166,6 +3166,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len);
+noinline int may_destroy_subvol(struct btrfs_root *root);
 int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f53470112670..db66fa4fede6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4333,6 +4333,60 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * helper to check if the subvolume references other subvolumes
+ */
+noinline int may_destroy_subvol(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	u64 dir_id;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* Make sure this root isn't set as the default subvol */
+	dir_id = btrfs_super_root_dir(fs_info->super_copy);
+	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
+				   dir_id, "default", 7, 0);
+	if (di && !IS_ERR(di)) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+		if (key.objectid == root->root_key.objectid) {
+			ret = -EPERM;
+			btrfs_err(fs_info,
+				  "deleting default subvolume %llu is not allowed",
+				  key.objectid);
+			goto out;
+		}
+		btrfs_release_path(path);
+	}
+
+	key.objectid = root->root_key.objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	ret = 0;
+	if (path->slots[0] > 0) {
+		path->slots[0]--;
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.objectid == root->root_key.objectid &&
+		    key.type == BTRFS_ROOT_REF_KEY)
+			ret = -ENOTEMPTY;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 111ee282b777..11af9eb449ef 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1843,60 +1843,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	return ret;
 }
 
-/*
- * helper to check if the subvolume references other subvolumes
- */
-static noinline int may_destroy_subvol(struct btrfs_root *root)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_path *path;
-	struct btrfs_dir_item *di;
-	struct btrfs_key key;
-	u64 dir_id;
-	int ret;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	/* Make sure this root isn't set as the default subvol */
-	dir_id = btrfs_super_root_dir(fs_info->super_copy);
-	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
-				   dir_id, "default", 7, 0);
-	if (di && !IS_ERR(di)) {
-		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
-		if (key.objectid == root->root_key.objectid) {
-			ret = -EPERM;
-			btrfs_err(fs_info,
-				  "deleting default subvolume %llu is not allowed",
-				  key.objectid);
-			goto out;
-		}
-		btrfs_release_path(path);
-	}
-
-	key.objectid = root->root_key.objectid;
-	key.type = BTRFS_ROOT_REF_KEY;
-	key.offset = (u64)-1;
-
-	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret == 0);
-
-	ret = 0;
-	if (path->slots[0] > 0) {
-		path->slots[0]--;
-		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		if (key.objectid == root->root_key.objectid &&
-		    key.type == BTRFS_ROOT_REF_KEY)
-			ret = -ENOTEMPTY;
-	}
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
 static noinline int key_in_sk(struct btrfs_key *key,
 			      struct btrfs_ioctl_search_key *sk)
 {
-- 
2.14.3

