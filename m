Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:46415 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.1 OK) with ESMTP id g01bccoA6DKvk6
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 26/26] Btrfs: add support for device replace ioctls
Date: Tue,  6 Nov 2012 17:38:44 +0100
Message-Id: <c598c8e6a1c4e42a2a2348f564bcd3a7ddbedbad.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This is the commit that allows to start the device replace
procedure.

An ioctl() interface is added that supports starting and
canceling the device replace procedure, and to retrieve
the status and progress.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a93c14..914a88c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -55,6 +55,7 @@
 #include "backref.h"
 #include "rcu-string.h"
 #include "send.h"
+#include "dev-replace.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -3168,6 +3169,51 @@ static long btrfs_ioctl_get_dev_stats(struct btrfs_root *root,
 	return ret;
 }
 
+static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_dev_replace_args *p;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	p = memdup_user(arg, sizeof(*p));
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	switch (p->cmd) {
+	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
+		if (atomic_xchg(
+			&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+			pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+			ret = -EINPROGRESS;
+		} else {
+			ret = btrfs_dev_replace_start(root, p);
+			atomic_set(
+			 &root->fs_info->mutually_exclusive_operation_running,
+			 0);
+		}
+		break;
+	case BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS:
+		btrfs_dev_replace_status(root->fs_info, p);
+		ret = 0;
+		break;
+	case BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL:
+		ret = btrfs_dev_replace_cancel(root->fs_info, p);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (copy_to_user(arg, p, sizeof(*p)))
+		ret = -EFAULT;
+
+	kfree(p);
+	return ret;
+}
+
 static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 {
 	int ret = 0;
@@ -3823,6 +3869,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_create(root, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(root, argp);
+	case BTRFS_IOC_DEV_REPLACE:
+		return btrfs_ioctl_dev_replace(root, argp);
 	}
 
 	return -ENOTTY;
-- 
1.8.0

