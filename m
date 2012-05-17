Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab2EQL44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 07:56:56 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4HBuqgZ005902
	for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 19:56:52 +0800
Message-ID: <4FB4E72B.7020104@cn.fujitsu.com>
Date: Thu, 17 May 2012 19:55:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] Btrfs: stop defrag the files automatically when doin
 readonly remount or umount
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we remount the fs to be readonly or umount it, we should not continue
defraging the files, it is because
- the auto defragment will introduce lots of dirty pages, it breaks the rule
  of a readonly file system.
- it make the time of remount/umount become longer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   12 +++++++-----
 fs/btrfs/file.c    |    3 ++-
 fs/btrfs/super.c   |    5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..9a571f7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1529,6 +1529,9 @@ static int cleaner_kthread(void *arg)
 	do {
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 
+		if (!down_read_trylock(&root->fs_info->sb->s_umount))
+			goto skip;
+
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
@@ -1536,7 +1539,8 @@ static int cleaner_kthread(void *arg)
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 			btrfs_run_defrag_inodes(root->fs_info);
 		}
-
+		up_read(&root->fs_info->sb->s_umount);
+skip:
 		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
@@ -3049,13 +3053,11 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_scrub_cancel(root);
 
-	/* wait for any defraggers to finish */
-	wait_event(fs_info->transaction_wait,
-		   (atomic_read(&fs_info->defrag_running) == 0));
-
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_run_defrag_inodes(fs_info);
 
+	BUG_ON(atomic_read(&fs_info->defrag_running));
+
 	/*
 	 * Here come 2 situations when btrfs is broken to flip readonly:
 	 *
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d83260d..23364c1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -230,7 +230,8 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 		first_ino = defrag->ino + 1;
 		rb_erase(&defrag->rb_node, &fs_info->defrag_inodes);
 
-		if (btrfs_fs_closing(fs_info))
+		if (btrfs_fs_closing(fs_info) ||
+		    (fs_info->sb->s_flags & MS_RDONLY))
 			goto next_free;
 
 		spin_unlock(&fs_info->defrag_inodes_lock);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 84571d7..7deb00e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1151,6 +1151,11 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		ret = btrfs_commit_super(root);
 		if (ret)
 			goto restore;
+
+		/* clear out the rbtree of defraggable inodes */
+		btrfs_run_defrag_inodes(fs_info);
+
+		BUG_ON(atomic_read(&fs_info->defrag_running));
 	} else {
 		if (fs_info->fs_devices->rw_devices == 0)
 			ret = -EACCES;
-- 
1.7.6.5
