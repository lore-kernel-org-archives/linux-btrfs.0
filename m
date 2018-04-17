Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751230AbeDQSph (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 14:45:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 53251AED3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 18:45:36 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: push relocation recovery into a helper thread
Message-ID: <0d7559af-b5ea-f725-1859-1c561984622f@suse.com>
Date: Tue, 17 Apr 2018 14:45:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a file system with many snapshots and qgroups enabled, an interrupted
balance can end up taking a long time to mount due to recovering the
relocations during mount.  It does this in the task performing the mount,
which can't be interrupted and may prevent mounting (and systems booting)
for a long time as well.  The thing is that as part of balance, this
runs in the background all the time.  This patch pushes the recovery
into a helper thread and allows the mount to continue normally.  We hold
off on resuming any paused balance operation until after the relocation
has completed, disallow any new balance operations if it's running, and
wait for it on umount and remounting read-only.

This doesn't do anything to address the relocation recovery operation
taking a long time but does allow the file system to mount.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h      |    7 +++
 fs/btrfs/disk-io.c    |    7 ++-
 fs/btrfs/relocation.c |   92 +++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/super.c      |    5 +-
 fs/btrfs/volumes.c    |    6 +++
 5 files changed, 97 insertions(+), 20 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1052,6 +1052,10 @@ struct btrfs_fs_info {
 	struct btrfs_work qgroup_rescan_work;
 	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
 
+	/* relocation recovery items */
+	bool relocation_recovery_started;
+	struct completion relocation_recovery_completion;
+
 	/* filesystem state */
 	unsigned long fs_state;
 
@@ -3671,7 +3675,8 @@ int btrfs_init_reloc_root(struct btrfs_t
 			  struct btrfs_root *root);
 int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
-int btrfs_recover_relocation(struct btrfs_root *root);
+int btrfs_recover_relocation(struct btrfs_fs_info *fs_info);
+void btrfs_wait_for_relocation_completion(struct btrfs_fs_info *fs_info);
 int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
 int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct extent_buffer *buf,
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2999,7 +2999,7 @@ retry_root_backup:
 			goto fail_qgroup;
 
 		mutex_lock(&fs_info->cleaner_mutex);
-		ret = btrfs_recover_relocation(tree_root);
+		ret = btrfs_recover_relocation(fs_info);
 		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
 			btrfs_warn(fs_info, "failed to recover relocation: %d",
@@ -3017,7 +3017,8 @@ retry_root_backup:
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
 		btrfs_warn(fs_info, "failed to read fs tree: %d", err);
-		goto fail_qgroup;
+		close_ctree(fs_info);
+		return err;
 	}
 
 	if (sb_rdonly(sb))
@@ -3778,6 +3779,8 @@ void close_ctree(struct btrfs_fs_info *f
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
+	btrfs_wait_for_relocation_completion(fs_info);
+
 	/* wait for the uuid_scan task to finish */
 	down(&fs_info->uuid_tree_rescan_sem);
 	/* avoid complains from lockdep et al., set sem back to initial state */
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/rbtree.h>
 #include <linux/slab.h>
+#include <linux/kthread.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -4492,14 +4493,61 @@ static noinline_for_stack int mark_garba
 }
 
 /*
- * recover relocation interrupted by system crash.
- *
  * this function resumes merging reloc trees with corresponding fs trees.
  * this is important for keeping the sharing of tree blocks
  */
-int btrfs_recover_relocation(struct btrfs_root *root)
+static int
+btrfs_resume_relocation(void *data)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = data;
+	struct btrfs_trans_handle *trans;
+	struct reloc_control *rc = fs_info->reloc_ctl;
+	int err, ret;
+
+	btrfs_info(fs_info, "resuming relocation");
+
+	BUG_ON(!rc);
+
+	mutex_lock(&fs_info->cleaner_mutex);
+
+	merge_reloc_roots(rc);
+
+	unset_reloc_control(rc);
+
+	trans = btrfs_join_transaction(rc->extent_root);
+	if (IS_ERR(trans))
+		err = PTR_ERR(trans);
+	else {
+		ret = btrfs_commit_transaction(trans);
+		if (ret < 0)
+			err = ret;
+	}
+
+	kfree(rc);
+
+	if (err == 0) {
+		struct btrfs_root *fs_root;
+
+		/* cleanup orphan inode in data relocation tree */
+		fs_root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
+		if (IS_ERR(fs_root))
+			err = PTR_ERR(fs_root);
+		else
+			err = btrfs_orphan_cleanup(fs_root);
+	}
+	mutex_unlock(&fs_info->cleaner_mutex);
+	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
+	complete_all(&fs_info->relocation_recovery_completion);
+	return err;
+}
+
+/*
+ * recover relocation interrupted by system crash.
+ * this function locates the relocation trees
+ */
+int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	LIST_HEAD(reloc_roots);
 	struct btrfs_key key;
 	struct btrfs_root *fs_root;
@@ -4508,9 +4556,12 @@ int btrfs_recover_relocation(struct btrf
 	struct extent_buffer *leaf;
 	struct reloc_control *rc = NULL;
 	struct btrfs_trans_handle *trans;
+	struct task_struct *tsk;
 	int ret;
 	int err = 0;
 
+	WARN_ON(!rwsem_is_locked(&fs_info->sb->s_umount));
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -4521,8 +4572,7 @@ int btrfs_recover_relocation(struct btrf
 	key.offset = (u64)-1;
 
 	while (1) {
-		ret = btrfs_search_slot(NULL, fs_info->tree_root, &key,
-					path, 0, 0);
+		ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -4540,7 +4590,7 @@ int btrfs_recover_relocation(struct btrf
 		    key.type != BTRFS_ROOT_ITEM_KEY)
 			break;
 
-		reloc_root = btrfs_read_fs_root(root, &key);
+		reloc_root = btrfs_read_fs_root(tree_root, &key);
 		if (IS_ERR(reloc_root)) {
 			err = PTR_ERR(reloc_root);
 			goto out;
@@ -4620,16 +4670,21 @@ int btrfs_recover_relocation(struct btrf
 	if (err)
 		goto out_free;
 
-	merge_reloc_roots(rc);
-
-	unset_reloc_control(rc);
-
-	trans = btrfs_join_transaction(rc->extent_root);
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+	tsk = kthread_run(btrfs_resume_relocation, fs_info,
+			  "relocation-recovery");
+	if (IS_ERR(tsk)) {
+		err = PTR_ERR(tsk);
 		goto out_free;
 	}
-	err = btrfs_commit_transaction(trans);
+
+	fs_info->relocation_recovery_started = true;
+
+	/* protected from racing with resume thread by the cleaner_mutex */
+	init_completion(&fs_info->relocation_recovery_completion);
+
+	set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
+	return 0;
+
 out_free:
 	kfree(rc);
 out:
@@ -4649,6 +4704,13 @@ out:
 	return err;
 }
 
+void
+btrfs_wait_for_relocation_completion(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->relocation_recovery_started)
+		wait_for_completion(&fs_info->relocation_recovery_completion);
+}
+
 /*
  * helper to add ordered checksum for data relocation.
  *
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1767,7 +1767,6 @@ static inline void btrfs_remount_cleanup
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	struct btrfs_root *root = fs_info->tree_root;
 	unsigned old_flags = sb->s_flags;
 	unsigned long old_opts = fs_info->mount_opt;
 	unsigned long old_compress_type = fs_info->compress_type;
@@ -1834,6 +1833,8 @@ static int btrfs_remount(struct super_bl
 		btrfs_scrub_cancel(fs_info);
 		btrfs_pause_balance(fs_info);
 
+		btrfs_wait_for_relocation_completion(fs_info);
+
 		ret = btrfs_commit_super(fs_info);
 		if (ret)
 			goto restore;
@@ -1867,7 +1868,7 @@ static int btrfs_remount(struct super_bl
 
 		/* recover relocation */
 		mutex_lock(&fs_info->cleaner_mutex);
-		ret = btrfs_recover_relocation(root);
+		ret = btrfs_recover_relocation(fs_info);
 		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret)
 			goto restore;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4034,6 +4034,12 @@ static int balance_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
+	if (fs_info->relocation_recovery_started) {
+		btrfs_info(fs_info,
+			   "waiting for relocation recovery before resuming balance");
+		wait_for_completion(&fs_info->relocation_recovery_completion);
+	}
+
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 

-- 
Jeff Mahoney
SUSE Labs
