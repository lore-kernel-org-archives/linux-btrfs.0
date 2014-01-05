Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47327 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAESO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 13:14:58 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1Vzrv4-0000w4-DX
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 17:55:27 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.82)
	(envelope-from <hugo@carfax.org.uk>)
	id 1Vzrv5-0004BM-Nz
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 17:55:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Fix 32/64-bit problem with BTRFS_SET_RECEIVED_SUBVOL ioctl
Date: Sun,  5 Jan 2014 17:55:27 +0000
Message-Id: <1388944527-16041-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The structure for BTRFS_SET_RECEIVED_IOCTL packs differently on 32-bit
and 64-bit systems. This means that it is impossible to use btrfs
receive on a system with a 64-bit kernel and 32-bit userspace, because
the structure size (and hence the ioctl number) is different.

This patch adds a compatibility structure and ioctl to deal with the
above case.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da576..e186439 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -57,6 +57,32 @@
 #include "send.h"
 #include "dev-replace.h"
 
+#ifdef CONFIG_64BIT
+/* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
+ * structures are incorrect, as the timespec structure from userspace
+ * is 4 bytes too small. We define these alternatives here to teach
+ * the kernel about the 32-bit struct packing.
+ */
+struct btrfs_ioctl_timespec {
+	__u64 sec;
+	__u32 nsec;
+} ((__packed__));
+
+struct btrfs_ioctl_received_subvol_args {
+	char	uuid[BTRFS_UUID_SIZE];	/* in */
+	__u64	stransid;		/* in */
+	__u64	rtransid;		/* out */
+	struct btrfs_ioctl_timespec stime; /* in */
+	struct btrfs_ioctl_timespec rtime; /* out */
+	__u64	flags;			/* in */
+	__u64	reserved[16];		/* in */
+} ((__packed__));
+#endif
+
+#define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
+				struct btrfs_ioctl_received_subvol_args_32)
+
+
 static int btrfs_clone(struct inode *src, struct inode *inode,
 		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
 
@@ -4313,10 +4339,69 @@ static long btrfs_ioctl_quota_rescan_wait(struct file *file, void __user *arg)
 	return btrfs_qgroup_wait_for_completion(root->fs_info);
 }
 
+#ifdef CONFIG_64BIT
+static long btrfs_ioctl_set_received_subvol_32(struct file *file,
+						void __user *arg)
+{
+	struct btrfs_ioctl_received_subvol_args_32 *args32 = NULL;
+	struct btrfs_ioctl_received_subvol_args *args64 = NULL;
+	int ret = 0;
+
+	args32 = memdup_user(arg, sizeof(*args32));
+	if (IS_ERR(args32)) {
+		ret = PTR_ERR(args32);
+		args32 = NULL;
+		goto out;
+	}
+
+	args64 = malloc(sizeof(*args64));
+	if (IS_ERR(args64)) {
+		ret = PTR_ERR(args64);
+		args64 = NULL;
+		goto out;
+	}
+
+	memcpy(args64->uuid, args32->uuid, BTRFS_UUID_SIZE);
+	args64->stransid = args32->stransid;
+	args64->rtransid = args32->rtransid;
+	args64->stime.sec = args32->stime.sec;
+	args64->stime.nsec = args32->stime.nsec;
+	args64->rtime.sec = args32->rtime.sec;
+	args64->rtime.nsec = args32->rtime.nsec;
+	args64->flags = args32->flags;
+
+	ret = _btrfs_ioctl_set_received_subvol(file, args64);
+
+out:
+	kfree(args32);
+	kfree(args64);
+	return ret;
+}
+#endif
+
 static long btrfs_ioctl_set_received_subvol(struct file *file,
 					    void __user *arg)
 {
 	struct btrfs_ioctl_received_subvol_args *sa = NULL;
+	int ret = 0;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		sa = NULL;
+		goto out;
+	}
+
+	ret = _btrfs_ioctl_set_received_subvol(file, sa);
+
+out:
+	kfree(sa);
+	return ret;
+}
+
+static long _btrfs_ioctl_set_received_subvol(struct file *file,
+					    struct btrfs_ioctl_received_subvol_args *sa)
+{
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_root_item *root_item = &root->root_item;
@@ -4346,13 +4431,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 
-	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa)) {
-		ret = PTR_ERR(sa);
-		sa = NULL;
-		goto out;
-	}
-
 	/*
 	 * 1 - root item
 	 * 2 - uuid items (received uuid + subvol uuid)
@@ -4411,7 +4489,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 		ret = -EFAULT;
 
 out:
-	kfree(sa);
 	up_write(&root->fs_info->subvol_sem);
 	mnt_drop_write_file(file);
 	return ret;
@@ -4572,6 +4649,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_balance_progress(root, argp);
 	case BTRFS_IOC_SET_RECEIVED_SUBVOL:
 		return btrfs_ioctl_set_received_subvol(file, argp);
+	case BTRFS_IOC_SET_RECEIVED_SUBVOL_32:
+		return btrfs_ioctl_set_received_subvol_32(file, argp);
 	case BTRFS_IOC_SEND:
 		return btrfs_ioctl_send(file, argp);
 	case BTRFS_IOC_GET_DEV_STATS:
-- 
1.8.5.1

