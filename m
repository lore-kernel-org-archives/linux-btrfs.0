Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:40203 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346Ab3DHK4v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 06:56:51 -0400
Received: by mail-da0-f49.google.com with SMTP id t11so2531765daj.8
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2013 03:56:50 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: use tree_root to avoid edquot when disabling quota
Date: Mon,  8 Apr 2013 18:56:22 +0800
Message-Id: <1365418582-1590-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Steps to reproduce:
	mkfs.btrfs <disk>
	mount <disk> <mnt>
	btrfs quota enable <mnt>
	btrfs sub create <mnt>/subv
	btrfs qgroup limit 10K <mnt>/subv
	btrfs quota disable <mnt>/subv

It is wrong for qgroup to reserve when disabling quota,
so just use tree_root to avoid edquot when disabling quota.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..180e486 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3694,7 +3694,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	}
 
 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
-		trans = btrfs_start_transaction(root, 2);
+		trans = btrfs_start_transaction(root->fs_info->tree_root, 2);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
 			goto out;
@@ -3720,7 +3720,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		ret = -EFAULT;
 
 	if (trans) {
-		err = btrfs_commit_transaction(trans, root);
+		err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
 		if (err && !ret)
 			ret = err;
 	}
-- 
1.7.7.6

