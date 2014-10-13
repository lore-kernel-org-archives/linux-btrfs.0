Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43053 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaJMEmu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 00:42:50 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so5099551pad.5
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 21:42:50 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] Btrfs: return failure if btrfs_dev_replace_finishing() failed
Date: Mon, 13 Oct 2014 12:42:12 +0800
Message-Id: <1413175333-26095-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

device replace could fail due to another running scrub process or any
other errors btrfs_scrub_dev() may hit, but this failure doesn't get
returned to userspace.

The following steps could reproduce this issue

	mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
	mount /dev/sdb1 /mnt/btrfs
	while true; do btrfs scrub start -B /mnt/btrfs >/dev/null 2>&1; done &
	btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs
	# if this replace succeeded, do the following and repeat until
	# you see this log in dmesg
	# BTRFS: btrfs_scrub_dev(/dev/sdb2, 2, /dev/sdb3) failed -115
	#btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs

	# once you see the error log in dmesg, check return value of
	# replace
	echo $?

Introduce a new dev replace result

BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS

to catch -EINPROGRESS explicitly and return other errors directly to
userspace.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

v2:
- set result to SCRUB_INPROGRESS if btrfs_scrub_dev returned -EINPROGRESS
  and return 0 as Miao Xie suggested

 fs/btrfs/dev-replace.c     | 12 +++++++++---
 include/uapi/linux/btrfs.h |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..a141f8b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -418,9 +418,15 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 			      &dev_replace->scrub_progress, 0, 1);
 
 	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
-	WARN_ON(ret);
+	/* don't warn if EINPROGRESS, someone else might be running scrub */
+	if (ret == -EINPROGRESS) {
+		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
+		ret = 0;
+	} else {
+		WARN_ON(ret);
+	}
 
-	return 0;
+	return ret;
 
 leave:
 	dev_replace->srcdev = NULL;
@@ -538,7 +544,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
-		return 0;
+		return scrub_ret;
 	}
 
 	printk_in_rcu(KERN_INFO
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 2f47824..611e1c5 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -157,6 +157,7 @@ struct btrfs_ioctl_dev_replace_status_params {
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR			0
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED		1
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED		2
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS		3
 struct btrfs_ioctl_dev_replace_args {
 	__u64 cmd;	/* in */
 	__u64 result;	/* out */
-- 
1.8.3.1

