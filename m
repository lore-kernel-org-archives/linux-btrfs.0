Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaARE7Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 23:59:16 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 1/4] Btrfs: fix wrong send_in_progress accounting
Date: Sat, 18 Jan 2014 12:58:00 +0800
Message-Id: <1390021080-30788-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda8
 # mount /dev/sda8 /mnt
 # btrfs sub snapshot -r /mnt /mnt/snap1
 # btrfs sub snapshot -r /mnt /mnt/snap2
 # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
 # dmesg

The problem is that we will sort clone roots(include @send_root), it
might push @send_root before thus @send_root's @send_in_progress will
be decreased twice.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
changelog
v2->v3:
	add comments as david addressed.
v1->v2:
	use right root to check
---
 fs/btrfs/send.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bff0b1a..83b6bdb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4752,6 +4752,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
 	int clone_sources_to_rollback = 0;
+	int sort_clone_roots = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4942,6 +4943,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	sort(sctx->clone_roots, sctx->clone_roots_cnt,
 			sizeof(*sctx->clone_roots), __clone_root_cmp_sort,
 			NULL);
+	sort_clone_roots = 1;
 
 	ret = send_subvol(sctx);
 	if (ret < 0)
@@ -4957,11 +4959,22 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 out:
-	for (i = 0; sctx && i < clone_sources_to_rollback; i++)
-		btrfs_root_dec_send_in_progress(sctx->clone_roots[i].root);
+	if (sort_clone_roots) {
+		for (i = 0; i < sctx->clone_roots_cnt; i++)
+			btrfs_root_dec_send_in_progress(
+					sctx->clone_roots[i].root);
+	} else {
+		for (i = 0; sctx && i < clone_sources_to_rollback; i++)
+			btrfs_root_dec_send_in_progress(
+					sctx->clone_roots[i].root);
+		/*
+		 * if we fail to add @send_root in clone roots, we still
+		 * need to decrease @send_in_progress count here.
+		 */
+		btrfs_root_dec_send_in_progress(send_root);
+	}
 	if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
 		btrfs_root_dec_send_in_progress(sctx->parent_root);
-	btrfs_root_dec_send_in_progress(send_root);
 
 	kfree(arg);
 	vfree(clone_sources_tmp);
-- 
1.8.3.1

