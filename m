Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaDOOls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:41:48 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: protect snapshots from deleting during send
Date: Tue, 15 Apr 2014 16:41:44 +0200
Message-Id: <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
In-Reply-To: <cover.1397572052.git.dsterba@suse.cz>
References: <cover.1397572052.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch "Btrfs: fix protection between send and root deletion"
(18f687d538449373c37c) does not actually prevent to delete the snapshot
and just takes care during background cleaning, but this seems rather
user unfriendly, this patch implements the idea presented in

http://www.spinics.net/lists/linux-btrfs/msg30813.html

- add an internal root_item flag to denote a dead root
- check if the send_in_progress is set and refuse to delete, otherwise
  set the flag and proceed
- check the flag in send similar to the btrfs_root_readonly checks, for
  all involved roots

The root lookup in send via btrfs_read_fs_root_no_name will check if the
root is really dead or not. If it is, ENOENT, aborted send. If it's
alive, it's protected by send_in_progress, send can continue.

CC: Miao Xie <miaox@cn.fujitsu.com>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |   11 +++++++++++
 fs/btrfs/ioctl.c |   30 ++++++++++++++++++++++++++++++
 fs/btrfs/send.c  |   14 ++++++++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c1a42ca519f..abe3eac6426b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -754,6 +754,12 @@ struct btrfs_dir_item {
 
 #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
 
+/*
+ * Internal in-memory flag that a subvolume has been marked for deletion but
+ * still visible as a directory
+ */
+#define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
+
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
 	__le64 generation;
@@ -2749,6 +2755,11 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
 
+static inline bool btrfs_root_dead(struct btrfs_root *root)
+{
+	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_DEAD)) != 0;
+}
+
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
 		   tree_root, 64);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a6d8efa46bfe..a385d88bd8d5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2147,6 +2147,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv block_rsv;
+	u64 root_flags;
 	u64 qgroup_reserved;
 	int namelen;
 	int ret;
@@ -2168,6 +2169,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	if (err)
 		goto out;
 
+
 	err = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
 	if (err == -EINTR)
 		goto out_drop_write;
@@ -2229,6 +2231,27 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	}
 
 	mutex_lock(&inode->i_mutex);
+
+	/*
+	 * Don't allow to delete a subvolume with send in progress. This is
+	 * inside the i_mutex so the error handling that has to drop the bit
+	 * again is not run concurrently.
+	 */
+	spin_lock(&dest->root_item_lock);
+	root_flags = btrfs_root_flags(&root->root_item);
+	if (root->send_in_progress == 0) {
+		btrfs_set_root_flags(&root->root_item,
+				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
+		spin_unlock(&dest->root_item_lock);
+	} else {
+		spin_unlock(&dest->root_item_lock);
+		btrfs_warn(root->fs_info,
+			"Attempt to delete subvolume %llu during send",
+			root->root_key.objectid);
+		err = -EPERM;
+		goto out_dput;
+	}
+
 	err = d_invalidate(dentry);
 	if (err)
 		goto out_unlock;
@@ -2317,6 +2340,13 @@ out_release:
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
 out_unlock:
+	if (err) {
+		spin_lock(&dest->root_item_lock);
+		root_flags = btrfs_root_flags(&root->root_item);
+		btrfs_set_root_flags(&root->root_item,
+				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
+		spin_unlock(&dest->root_item_lock);
+	}
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
 		shrink_dcache_sb(root->fs_info->sb);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9dde9717c1b9..80ec4fdc0b40 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5263,7 +5263,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	/*
 	 * The subvolume must remain read-only during send, protect against
-	 * making it RW.
+	 * making it RW. This also protects against deletion.
 	 */
 	spin_lock(&send_root->root_item_lock);
 	send_root->send_in_progress++;
@@ -5284,6 +5284,15 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
+	/*
+	 * Unlikely but possible, if the subvolume is marked for deletion but
+	 * is slow to remove the directory entry, send can still be started
+	 */
+	if (btrfs_root_dead(sctx->parent_root)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	arg = memdup_user(arg_, sizeof(*arg));
 	if (IS_ERR(arg)) {
 		ret = PTR_ERR(arg);
@@ -5411,7 +5420,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 		spin_lock(&sctx->parent_root->root_item_lock);
 		sctx->parent_root->send_in_progress++;
-		if (!btrfs_root_readonly(sctx->parent_root)) {
+		if (!btrfs_root_readonly(sctx->parent_root) ||
+				btrfs_root_dead(sctx->parent_root)) {
 			spin_unlock(&sctx->parent_root->root_item_lock);
 			srcu_read_unlock(&fs_info->subvol_srcu, index);
 			ret = -EPERM;
-- 
1.7.9

