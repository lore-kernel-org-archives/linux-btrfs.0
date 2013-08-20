Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3HTGEt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 02:04:49 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7K64lbv001669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:04:48 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7K64g2p022243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:04:47 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7K64gHs012433
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:04:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: return btrfs error code for dev excl ops err
Date: Tue, 20 Aug 2013 14:10:54 +0800
Message-Id: <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
References: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

now threads can return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
as defined in btrfs.h for the dev excl operation error in
the FS, which means with this kernel would stop logging
(almost an user error) into the /var/log/messages

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           |   12 ++++--------
 include/uapi/linux/btrfs.h |    3 +--
 2 files changed, 5 insertions(+), 10 deletions(-)

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
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 90d7bd9..182305f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -505,8 +505,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
 			return "unable to remove the only writeable device";
 		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
-			return "add/delete/balance/replace/resize operation "\
-				"in progress";
+			return "add/delete/balance/replace/resize operation in progress";
 		default:
 			return NULL;
 	}
-- 
1.7.1

