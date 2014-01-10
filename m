Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46244 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaAJM5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 07:57:03 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ACuxsD019994
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 20:56:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix transaction aborted when remounting btrfs from RW to RO
Date: Fri, 10 Jan 2014 20:55:58 +0800
Message-Id: <1389358558-28276-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda8
 # mount /dev/sda8 /mnt -o flushoncommit
 # dd if=/dev/zero of=/mnt/data bs=4k count=102400 &
 # mount /dev/sda8 /mnt -o remount, ro

When remounting RW to RO, the logic is to firstly set flag
to RO and then commit transaction, however with option
flushoncommit enabled,we will do RO check within committing
transaction, so we get a transaction aborted here.

I try to fix this problem by flushing before set RO,and we
just clean flushoncommit and then reset the flag after transaction
commit, i know there is a race condition here, but i think it
is ok for that thing happen.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
This problem is found by Qu's remounting xfstest,he will
send btrfs remounting test case soon which should include
this problem's regression test.
---
 fs/btrfs/super.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e9c13fb..ff9c4a5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1302,6 +1302,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	int old_thread_pool_size = fs_info->thread_pool_size;
 	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
+	int restore_flushoncommit = 0;
 
 	btrfs_remount_prepare(fs_info);
 
@@ -1329,6 +1330,22 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		/* avoid complains from lockdep et al. */
 		up(&fs_info->uuid_tree_rescan_sem);
 
+		/*
+		 * i know this is not elegant, if flushoncommit flag
+		 * is set, we must flush before setting MS_RDONLY,
+		 * otherwise we will abort transaction commit due to
+		 * RO check.
+		 */
+		if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT)) {
+			ret = btrfs_start_delalloc_roots(fs_info, 0);
+			if (ret) {
+				sb->s_flags |= MS_RDONLY;
+				goto out;
+			}
+			btrfs_wait_ordered_roots(fs_info, -1);
+			btrfs_clear_opt(fs_info->mount_opt, FLUSHONCOMMIT);
+			restore_flushoncommit = 1;
+		}
 		sb->s_flags |= MS_RDONLY;
 
 		btrfs_dev_replace_suspend_for_unmount(fs_info);
@@ -1336,6 +1353,10 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		btrfs_pause_balance(fs_info);
 
 		ret = btrfs_commit_super(root);
+
+		/* now we can restore flushoncommit flag */
+		if (restore_flushoncommit)
+			btrfs_set_opt(fs_info->mount_opt, FLUSHONCOMMIT);
 		if (ret)
 			goto restore;
 	} else {
-- 
1.8.3.1

