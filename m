Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3HUDi7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 23:38:59 -0400
From: Anand Jain <anand.jain@oracle.com>
To: jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: return btrfs error code for dev excl ops err
Date: Wed, 21 Aug 2013 11:44:48 +0800
Message-Id: <1377056688-16724-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
References: <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

now threads can return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
as defined in btrfs.h for the dev excl operation error in
the FS, which means with this kernel would stop logging
(almost an user error) into the /var/log/messages

v2: accepts Josef' comment

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 107c5f4..89f346c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1382,9 +1382,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
 		mnt_drop_write_file(file);
-		return -EINVAL;
+		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -2346,8 +2345,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		return -EINVAL;
+		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -3638,8 +3636,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 		if (atomic_xchg(
 			&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-			pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-			ret = -EINPROGRESS;
+			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		} else {
 			ret = btrfs_dev_replace_start(root, p);
 			atomic_set(
@@ -3883,8 +3880,7 @@ again:
 	} else {
 		/* this is (1) */
 		mutex_unlock(&fs_info->balance_mutex);
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		goto out;
 	}
 
-- 
1.7.1

