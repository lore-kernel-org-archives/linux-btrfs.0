Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34274 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdALOBT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:19 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so3882867wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:17 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 20/24] btrfs: Make __add_inode_ref take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:46 +0200
Message-Id: <1484229650-24554-21-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 834d90398cb4..a24983cd455c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -990,7 +990,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_path *path,
 				  struct btrfs_root *log_root,
-				  struct inode *dir, struct inode *inode,
+				  struct btrfs_inode *dir, struct btrfs_inode *inode,
 				  struct extent_buffer *eb,
 				  u64 inode_objectid, u64 parent_objectid,
 				  u64 ref_index, char *name, int namelen,
@@ -1046,12 +1046,11 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					    parent_objectid,
 					    victim_name,
 					    victim_name_len)) {
-				inc_nlink(inode);
+				inc_nlink(&inode->vfs_inode);
 				btrfs_release_path(path);
 
-				ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
-							 BTRFS_I(inode), victim_name,
-							 victim_name_len);
+				ret = btrfs_unlink_inode(trans, root, dir, inode, 
+						victim_name, victim_name_len);
 				kfree(victim_name);
 				if (ret)
 					return ret;
@@ -1113,15 +1112,14 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					    parent_objectid, victim_name,
 					    victim_name_len)) {
 				ret = -ENOENT;
-				victim_parent = read_one_inode(root,
-							       parent_objectid);
+				victim_parent = read_one_inode(root, parent_objectid);
 				if (victim_parent) {
-					inc_nlink(inode);
+					inc_nlink(&inode->vfs_inode);
 					btrfs_release_path(path);
 
 					ret = btrfs_unlink_inode(trans, root,
 								 BTRFS_I(victim_parent),
-								 BTRFS_I(inode),
+								 inode,
 								 victim_name,
 								 victim_name_len);
 					if (!ret)
@@ -1147,20 +1145,20 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	/* look for a conflicting sequence number */
-	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
+	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
 					 ref_index, name, namelen, 0);
 	if (di && !IS_ERR(di)) {
-		ret = drop_one_dir_item(trans, root, path, BTRFS_I(dir), di);
+		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;
 	}
 	btrfs_release_path(path);
 
 	/* look for a conflicing name */
-	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
+	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
-		ret = drop_one_dir_item(trans, root, path, BTRFS_I(dir), di);
+		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;
 	}
@@ -1306,7 +1304,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 			if (!search_done) {
 				ret = __add_inode_ref(trans, root, path, log,
-						      dir, inode, eb,
+						      BTRFS_I(dir), BTRFS_I(inode), eb,
 						      inode_objectid,
 						      parent_objectid,
 						      ref_index, name, namelen,
-- 
2.7.4

