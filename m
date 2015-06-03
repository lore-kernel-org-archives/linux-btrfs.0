Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbbFCOsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jun 2015 10:48:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AFC47AAD6
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 14:48:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs: explictly delete unused block groups in close_ctree and ro-remount
Date: Wed,  3 Jun 2015 10:47:53 -0400
Message-Id: <1433342874-7099-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1433342874-7099-1-git-send-email-jeffm@suse.com>
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The cleaner thread may already be sleeping by the time we enter
close_ctree.  If that's the case, we'll skip removing any unused
block groups queued for removal, even during a normal umount.
They'll be cleaned up automatically at next mount, but users
expect a umount to be a clean synchronization point, especially
when used on thin-provisioned storage with -odiscard.  We also
explicitly remove unused block groups in the ro-remount path
for the same reason.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |  9 +++++++++
 fs/btrfs/super.c   | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2ef9a4b..2e47fef 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3710,6 +3710,15 @@ void close_ctree(struct btrfs_root *root)
 	cancel_work_sync(&fs_info->async_reclaim_work);
 
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
+		/*
+		 * If the cleaner thread is stopped and there are
+		 * block groups queued for removal, the deletion will be
+		 * skipped when we quit the cleaner thread.
+		 */
+		mutex_lock(&root->fs_info->cleaner_mutex);
+		btrfs_delete_unused_bgs(root->fs_info);
+		mutex_unlock(&root->fs_info->cleaner_mutex);
+
 		ret = btrfs_commit_super(root);
 		if (ret)
 			btrfs_err(fs_info, "commit super ret %d", ret);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9e66f5e..2ccd8d4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1539,6 +1539,17 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		sb->s_flags |= MS_RDONLY;
 
+		/*
+		 * Setting MS_RDONLY will put the cleaner thread to
+		 * sleep at the next loop if it's already active.
+		 * If it's already asleep, we'll leave unused block
+		 * groups on disk until we're mounted read-write again
+		 * unless we clean them up here.
+		 */
+		mutex_lock(&root->fs_info->cleaner_mutex);
+		btrfs_delete_unused_bgs(fs_info);
+		mutex_unlock(&root->fs_info->cleaner_mutex);
+
 		btrfs_dev_replace_suspend_for_unmount(fs_info);
 		btrfs_scrub_cancel(fs_info);
 		btrfs_pause_balance(fs_info);
-- 
1.8.4.5

