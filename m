Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2F2Jtc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:49:32 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9nOag012593
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:49:28 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4 v2] Btrfs: use mnt_want_write_file instead of mnt_want_write
Date: Fri, 29 Jun 2012 17:58:48 +0800
Message-Id: <1340963929-32509-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mnt_want_write_file is faster when file has been opened for write.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 069cd85..df4c04d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3261,7 +3261,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write(file->f_path.mnt);
+	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
 
@@ -3331,7 +3331,7 @@ out_bargs:
 out:
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
-	mnt_drop_write(file->f_path.mnt);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-- 
1.6.5.2

