Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730957AbeHAFQL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:11 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id F119D4B66B9F
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:40 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/7] btrfs: Remove fs_info from btrfs_del_root_ref
Date: Wed, 1 Aug 2018 11:32:28 +0800
Message-ID: <20180801033231.23166-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     | 7 +++----
 fs/btrfs/inode.c     | 8 +++-----
 fs/btrfs/root-tree.c | 9 ++++-----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9ef47a171e2f..3677082ddf4c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2988,10 +2988,9 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
 		       const char *name, int name_len);
-int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info,
-		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
-		       const char *name, int name_len);
+int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
+		       u64 ref_id, u64 dirid, u64 *sequence, const char *name,
+		       int name_len);
 int btrfs_del_root(struct btrfs_trans_handle *trans,
 		   const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59b3ea32b6de..7bf4a8d07e1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4085,7 +4085,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
@@ -4118,9 +4117,8 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_del_root_ref(trans, fs_info, objectid,
-				 root->root_key.objectid, dir_ino,
-				 &index, name, name_len);
+	ret = btrfs_del_root_ref(trans, objectid, root->root_key.objectid,
+				 dir_ino, &index, name, name_len);
 	if (ret < 0) {
 		if (ret != -ENOENT) {
 			btrfs_abort_transaction(trans, ret);
@@ -6439,7 +6437,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
 		int err;
-		err = btrfs_del_root_ref(trans, fs_info, key.objectid,
+		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 &local_index, name, name_len);
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index f7c14c454f91..52fa133ab53c 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -341,13 +341,12 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info,
-		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
-		       const char *name, int name_len)
+int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
+		       u64 ref_id, u64 dirid, u64 *sequence, const char *name,
+		       int name_len)
 
 {
-	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_path *path;
 	struct btrfs_root_ref *ref;
 	struct extent_buffer *leaf;
-- 
2.18.0



