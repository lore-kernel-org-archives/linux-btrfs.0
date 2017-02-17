Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35199 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBQOnu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:50 -0500
Received: by mail-wm0-f66.google.com with SMTP id u63so2924704wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:50 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/38] btrfs: Make btrfs_insert_dir_item take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:53 +0200
Message-Id: <1487342609-20652-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 2 +-
 fs/btrfs/dir-item.c    | 6 +++---
 fs/btrfs/inode.c       | 2 +-
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/transaction.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ad23a73ac7e7..97f84a80b479 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2982,7 +2982,7 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 			  const char *name, int name_len);
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
-			  int name_len, struct inode *dir,
+			  int name_len, struct btrfs_inode *dir,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 724504a2d7ac..34eff5d46eca 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -120,7 +120,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
  */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len,
-			  struct inode *dir, struct btrfs_key *location,
+			  struct btrfs_inode *dir, struct btrfs_key *location,
 			  u8 type, u64 index)
 {
 	int ret = 0;
@@ -133,7 +133,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	struct btrfs_disk_key disk_key;
 	u32 data_size;
 
-	key.objectid = btrfs_ino(BTRFS_I(dir));
+	key.objectid = btrfs_ino(dir);
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
 
@@ -174,7 +174,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_release_path(path);
 
 	ret2 = btrfs_insert_delayed_dir_index(trans, root->fs_info, name,
-			name_len, BTRFS_I(dir), &disk_key, type, index);
+					      name_len, dir, &disk_key, type, index);
 out_free:
 	btrfs_free_path(path);
 	if (ret)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 956df76dc235..f438257be5a0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6275,7 +6275,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_insert_dir_item(trans, root, name, name_len,
-				    parent_inode, &key,
+				    BTRFS_I(parent_inode), &key,
 				    btrfs_inode_type(inode), index);
 	if (ret == -EEXIST || ret == -EOVERFLOW)
 		goto fail_dir_item;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 717f34f977d5..952762582b3d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -587,7 +587,7 @@ static noinline int create_subvol(struct inode *dir,
 	}
 
 	ret = btrfs_insert_dir_item(trans, root,
-				    name, namelen, dir, &key,
+				    name, namelen, BTRFS_I(dir), &key,
 				    BTRFS_FT_DIR, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6b3e0fc2fe7a..294563216dd3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1644,7 +1644,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				    dentry->d_name.name, dentry->d_name.len,
-				    parent_inode, &key,
+				    BTRFS_I(parent_inode), &key,
 				    BTRFS_FT_DIR, index);
 	/* We have check then name at the beginning, so it is impossible. */
 	BUG_ON(ret == -EEXIST || ret == -EOVERFLOW);
-- 
2.7.4

