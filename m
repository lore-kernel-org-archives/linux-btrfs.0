Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53610 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2FVSYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 14:24:17 -0400
Received: by wibhq12 with SMTP id hq12so959490wib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 11:24:16 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 1/2] Btrfs: restore restriper state on all mounts
Date: Fri, 22 Jun 2012 21:24:12 +0300
Message-Id: <1340389453-21439-2-git-send-email-idryomov@gmail.com>
In-Reply-To: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
References: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix a bug that triggered asserts in btrfs_balance() in both normal and
resume modes -- restriper state was not properly restored on read-only
mounts.  This factors out resuming code from btrfs_restore_balance(),
which is now also called earlier in the mount sequence to avoid the
problem of some early writes getting the old profile.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |   15 ++++++++++-----
 fs/btrfs/volumes.c |   39 +++++++++++++++++++--------------------
 fs/btrfs/volumes.h |    2 +-
 3 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 77872da..dae7cd6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2354,17 +2354,22 @@ retry_root_backup:
 				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
 	if (ret)
 		goto recovery_tree_root;
-
 	csum_root->track_dirty = 1;
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
+	ret = btrfs_recover_balance(fs_info);
+	if (ret) {
+		printk(KERN_WARNING "btrfs: failed to recover balance\n");
+		goto fail_tree_roots;
+	}
+
 	ret = btrfs_init_dev_stats(fs_info);
 	if (ret) {
 		printk(KERN_ERR "btrfs: failed to init dev_stats: %d\n",
 		       ret);
-		goto fail_block_groups;
+		goto fail_balance_ctl;
 	}
 
 	ret = btrfs_init_space_info(fs_info);
@@ -2492,9 +2497,6 @@ retry_root_backup:
 			err = btrfs_orphan_cleanup(fs_info->tree_root);
 		up_read(&fs_info->cleanup_work_sem);
 
-		if (!err)
-			err = btrfs_recover_balance(fs_info->tree_root);
-
 		if (err) {
 			close_ctree(tree_root);
 			return err;
@@ -2518,6 +2520,9 @@ fail_cleaner:
 fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 
+fail_balance_ctl:
+	kfree(fs_info->balance_ctl);
+
 fail_tree_roots:
 	free_root_pointers(fs_info, 1);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8a3d259..f7649b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2867,9 +2867,8 @@ static int balance_kthread(void *data)
 	return ret;
 }
 
-int btrfs_recover_balance(struct btrfs_root *tree_root)
+int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 {
-	struct task_struct *tsk;
 	struct btrfs_balance_control *bctl;
 	struct btrfs_balance_item *item;
 	struct btrfs_disk_balance_args disk_bargs;
@@ -2882,29 +2881,30 @@ int btrfs_recover_balance(struct btrfs_root *tree_root)
 	if (!path)
 		return -ENOMEM;
 
-	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
-	if (!bctl) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	key.objectid = BTRFS_BALANCE_OBJECTID;
 	key.type = BTRFS_BALANCE_ITEM_KEY;
 	key.offset = 0;
 
-	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
 	if (ret < 0)
-		goto out_bctl;
+		goto out;
 	if (ret > 0) { /* ret = -ENOENT; */
 		ret = 0;
-		goto out_bctl;
+		goto out;
+	}
+
+	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
+	if (!bctl) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
 
-	bctl->fs_info = tree_root->fs_info;
-	bctl->flags = btrfs_balance_flags(leaf, item) | BTRFS_BALANCE_RESUME;
+	bctl->fs_info = fs_info;
+	bctl->flags = btrfs_balance_flags(leaf, item);
+	bctl->flags |= BTRFS_BALANCE_RESUME;
 
 	btrfs_balance_data(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
@@ -2913,14 +2913,13 @@ int btrfs_recover_balance(struct btrfs_root *tree_root)
 	btrfs_balance_sys(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
 
-	tsk = kthread_run(balance_kthread, bctl, "btrfs-balance");
-	if (IS_ERR(tsk))
-		ret = PTR_ERR(tsk);
-	else
-		goto out;
+	mutex_lock(&fs_info->volume_mutex);
+	mutex_lock(&fs_info->balance_mutex);
 
-out_bctl:
-	kfree(bctl);
+	set_balance_control(bctl);
+
+	mutex_unlock(&fs_info->balance_mutex);
+	mutex_unlock(&fs_info->volume_mutex);
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 74366f2..e1b1a64 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,7 +281,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
-int btrfs_recover_balance(struct btrfs_root *tree_root);
+int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-- 
1.7.9.1

