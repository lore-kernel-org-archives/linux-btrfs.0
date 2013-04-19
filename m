Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:40642 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030746Ab3DSPlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:41:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp4) (RZmta 31.27 OK)
	with ESMTP id 600dd1p3JEL4tT for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:41:06 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: maintain subvolume items in the UUID tree
Date: Fri, 19 Apr 2013 17:41:05 +0200
Message-Id: <a1d5f4c0cad1e70800a8b678df684f03c8251cf9.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a new subvolume or snapshot is created, a new UUID item is added
to the UUID tree. Such items are removed when the subvolume is deleted.
The ioctl to set the received subvolume UUID is also touched and will
now also add this received UUID into the UUID tree together with the
ID of the subvolume. The latter is also done when read-only snapshots
are created which inherit all the send/receive information from the
parent subvolume.

User mode programs use the BTRFS_IOC_TREE_SEARCH ioctl to search and
read in the UUID tree.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c       | 65 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/transaction.c | 21 +++++++++++++++-
 2 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d0af96a..9bd423e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -57,6 +57,8 @@
 #include "send.h"
 #include "dev-replace.h"
 
+static char empty_uuid[BTRFS_UUID_SIZE] = {0};
+
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
 {
@@ -396,7 +398,7 @@ static noinline int create_subvol(struct inode *dir,
 	 * of create_snapshot().
 	 */
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       7, &qgroup_reserved);
+					       8, &qgroup_reserved);
 	if (ret)
 		return ret;
 
@@ -518,9 +520,13 @@ static noinline int create_subvol(struct inode *dir,
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 btrfs_ino(dir), index, name, namelen);
-
 	BUG_ON(ret);
 
+	ret = btrfs_insert_uuid_subvol_item(trans, root->fs_info->uuid_root,
+					    root_item.uuid, objectid);
+	if (ret)
+		btrfs_abort_transaction(trans, root, ret);
+
 fail:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
@@ -567,9 +573,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	 * 1 - root item
 	 * 2 - root ref/backref
 	 * 1 - root of snapshot
+	 * 1 - UUID item
 	 */
 	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
-					&pending_snapshot->block_rsv, 7,
+					&pending_snapshot->block_rsv, 8,
 					&pending_snapshot->qgroup_reserved);
 	if (ret)
 		goto out;
@@ -580,7 +587,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	pending_snapshot->dir = dir;
 	pending_snapshot->inherit = inherit;
 
-	trans = btrfs_start_transaction(root, 0);
+	trans = btrfs_start_transaction(root->fs_info->extent_root, 8);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto fail;
@@ -2207,6 +2214,28 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			goto out_end_trans;
 		}
 	}
+
+	ret = btrfs_del_uuid_subvol_item(trans, root->fs_info->uuid_root,
+					 dest->root_item.uuid,
+					 dest->root_key.objectid);
+	if (ret && ret != -ENOENT) {
+		btrfs_abort_transaction(trans, root, ret);
+		err = ret;
+		goto out_end_trans;
+	}
+	if (memcmp(dest->root_item.received_uuid, empty_uuid,
+		   BTRFS_UUID_SIZE)) {
+		ret = btrfs_del_uuid_received_subvol_item(trans,
+				root->fs_info->uuid_root,
+				dest->root_item.received_uuid,
+				dest->root_key.objectid);
+		if (ret && ret != -ENOENT) {
+			btrfs_abort_transaction(trans, root, ret);
+			err = ret;
+			goto out_end_trans;
+		}
+	}
+
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
@@ -2418,7 +2447,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
 	char *s_uuid = NULL;
-	char empty_uuid[BTRFS_UUID_SIZE] = {0};
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3896,6 +3924,7 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	struct btrfs_trans_handle *trans;
 	struct timespec ct = CURRENT_TIME;
 	int ret = 0;
+	int received_uuid_changed;
 
 	ret = mnt_want_write_file(file);
 	if (ret < 0)
@@ -3925,7 +3954,7 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 3);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
@@ -3936,6 +3965,14 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	sa->rtime.sec = ct.tv_sec;
 	sa->rtime.nsec = ct.tv_nsec;
 
+	received_uuid_changed = memcmp(root_item->received_uuid, sa->uuid,
+				       BTRFS_UUID_SIZE);
+	if (received_uuid_changed &&
+	    memcmp(root_item->received_uuid, empty_uuid, BTRFS_UUID_SIZE))
+		btrfs_del_uuid_received_subvol_item(trans,
+						    root->fs_info->uuid_root,
+						    root_item->received_uuid,
+						    root->root_key.objectid);
 	memcpy(root_item->received_uuid, sa->uuid, BTRFS_UUID_SIZE);
 	btrfs_set_root_stransid(root_item, sa->stransid);
 	btrfs_set_root_rtransid(root_item, sa->rtransid);
@@ -3948,13 +3985,21 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 				&root->root_key, &root->root_item);
 	if (ret < 0) {
 		btrfs_end_transaction(trans, root);
-		trans = NULL;
 		goto out;
-	} else {
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret < 0)
+	}
+	if (received_uuid_changed &&
+	    memcmp(sa->uuid, empty_uuid, BTRFS_UUID_SIZE)) {
+		ret = btrfs_insert_uuid_received_subvol_item(
+			trans, root->fs_info->uuid_root, sa->uuid,
+			root->root_key.objectid);
+		if (ret < 0 && ret != -EEXIST) {
+			btrfs_abort_transaction(trans, root, ret);
 			goto out;
+		}
 	}
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret < 0)
+		goto out;
 
 	ret = copy_to_user(arg, sa, sizeof(*sa));
 	if (ret)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 94cbd10..dadbdca 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -34,6 +34,8 @@
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
+static char empty_uuid[BTRFS_UUID_SIZE] = {0};
+
 void put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
@@ -1264,8 +1266,25 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 					 dentry->d_name.len * 2);
 	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode_fallback(trans, parent_root, parent_inode);
-	if (ret)
+	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
+	ret = btrfs_insert_uuid_subvol_item(trans, fs_info->uuid_root,
+					    new_uuid.b, objectid);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
+	if (memcmp(new_root_item->received_uuid, empty_uuid, BTRFS_UUID_SIZE)) {
+		ret = btrfs_insert_uuid_received_subvol_item(
+			trans, fs_info->uuid_root, new_root_item->received_uuid,
+			objectid);
+		if (ret && ret != -EEXIST) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto fail;
+		}
+	}
 fail:
 	pending->error = ret;
 dir_item_existed:
-- 
1.8.2.1

