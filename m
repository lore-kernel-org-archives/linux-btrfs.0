Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39334 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726960AbeHAFQM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:12 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 8AEF04B6ADE1
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:41 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/7] btrfs: Remove fs_info from btrfs_add_root_ref
Date: Wed, 1 Aug 2018 11:32:29 +0800
Message-ID: <20180801033231.23166-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 7 +++----
 fs/btrfs/inode.c       | 3 +--
 fs/btrfs/ioctl.c       | 3 +--
 fs/btrfs/root-tree.c   | 9 ++++-----
 fs/btrfs/transaction.c | 2 +-
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3677082ddf4c..c275ea258f9a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2984,10 +2984,9 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq);
 
 /* root-item.c */
-int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info,
-		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
-		       const char *name, int name_len);
+int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
+		       u64 ref_id, u64 dirid, u64 sequence, const char *name,
+		       int name_len);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence, const char *name,
 		       int name_len);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7bf4a8d07e1e..407d068d4208 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6385,7 +6385,6 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = parent_inode->root;
@@ -6401,7 +6400,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	}
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
-		ret = btrfs_add_root_ref(trans, fs_info, key.objectid,
+		ret = btrfs_add_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 index, name, name_len);
 	} else if (add_backref) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 80fe3c654612..6eaadddaca9f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -698,8 +698,7 @@ static noinline int create_subvol(struct inode *dir,
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	ret = btrfs_add_root_ref(trans, fs_info,
-				 objectid, root->root_key.objectid,
+	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 52fa133ab53c..65bda0682928 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -412,12 +412,11 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
  *
  * Will return 0, -ENOMEM, or anything from the CoW path
  */
-int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info,
-		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
-		       const char *name, int name_len)
+int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
+		       u64 ref_id, u64 dirid, u64 sequence, const char *name,
+		       int name_len)
 {
-	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_key key;
 	int ret;
 	struct btrfs_path *path;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aec208cbff00..001ed1bc2aa8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1573,7 +1573,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	/*
 	 * insert root back/forward references
 	 */
-	ret = btrfs_add_root_ref(trans, fs_info, objectid,
+	ret = btrfs_add_root_ref(trans, objectid,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(parent_inode)), index,
 				 dentry->d_name.name, dentry->d_name.len);
-- 
2.18.0



