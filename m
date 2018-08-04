Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10295 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727600AbeHDPLy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:11:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id CFDC64B6ADEF
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:11:06 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs: Remove root parameter from btrfs_insert_dir_item
Date: Sat, 4 Aug 2018 21:10:57 +0800
Message-ID: <20180804131057.9967-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass the root tree of dir, we can push that down to the
function itself.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/dir-item.c    | 8 ++++----
 fs/btrfs/inode.c       | 3 +--
 fs/btrfs/ioctl.c       | 3 +--
 fs/btrfs/transaction.c | 7 +++----
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4e8a41ef683c..c49718b33558 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3020,8 +3020,7 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 /* dir-item.c */
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 			  const char *name, int name_len);
-int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, const char *name,
+int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, const char *name,
 			  int name_len, struct btrfs_inode *dir,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index a678b07fcf01..8de74d835dba 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -105,13 +105,13 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
  * to use for the second index (if one is created).
  * Will return 0 or -ENOMEM
  */
-int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
-			  *root, const char *name, int name_len,
-			  struct btrfs_inode *dir, struct btrfs_key *location,
-			  u8 type, u64 index)
+int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, const char *name,
+			  int name_len, struct btrfs_inode *dir,
+			  struct btrfs_key *location, u8 type, u64 index)
 {
 	int ret = 0;
 	int ret2 = 0;
+	struct btrfs_root *root = dir->root;
 	struct btrfs_path *path;
 	struct btrfs_dir_item *dir_item;
 	struct extent_buffer *leaf;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a86d2f4effc6..1f5842ab11cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6405,8 +6405,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = btrfs_insert_dir_item(trans, root, name, name_len,
-				    parent_inode, &key,
+	ret = btrfs_insert_dir_item(trans, name, name_len, parent_inode, &key,
 				    btrfs_inode_type(&inode->vfs_inode), index);
 	if (ret == -EEXIST || ret == -EOVERFLOW)
 		goto fail_dir_item;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d3a5d2a41e5f..eaff768cd5d4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -686,8 +686,7 @@ static noinline int create_subvol(struct inode *dir,
 		goto fail;
 	}
 
-	ret = btrfs_insert_dir_item(trans, root,
-				    name, namelen, BTRFS_I(dir), &key,
+	ret = btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &key,
 				    BTRFS_FT_DIR, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3b84f5015029..bd784d8f5215 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1613,10 +1613,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto fail;
 
-	ret = btrfs_insert_dir_item(trans, parent_root,
-				    dentry->d_name.name, dentry->d_name.len,
-				    BTRFS_I(parent_inode), &key,
-				    BTRFS_FT_DIR, index);
+	ret = btrfs_insert_dir_item(trans, dentry->d_name.name,
+				    dentry->d_name.len, BTRFS_I(parent_inode),
+				    &key, BTRFS_FT_DIR, index);
 	/* We have check then name at the beginning, so it is impossible. */
 	BUG_ON(ret == -EEXIST || ret == -EOVERFLOW);
 	if (ret) {
-- 
2.18.0



