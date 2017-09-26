Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36009 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964856AbdIZUkM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 16:40:12 -0400
Received: by mail-qk0-f193.google.com with SMTP id i14so7580011qke.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 13:40:11 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] btrfs: fix send ioctl on 32bit with 64bit kernel
Date: Tue, 26 Sep 2017 16:40:09 -0400
Message-Id: <1506458409-2428-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We pass in a pointer in our send arg struct, this means the struct size doesn't
match with 32bit user space and 64bit kernel space.  Fix this by adding a compat
mode and doing the appropriate conversion.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ioctl.c           |  6 +++++-
 fs/btrfs/send.c            | 34 ++++++++++++++++++++++++++++------
 fs/btrfs/send.h            |  2 +-
 include/uapi/linux/btrfs.h | 13 +++++++++++++
 4 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 050d2d9c5533..9169d67e49b9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5594,7 +5594,11 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_received_subvol_32(file, argp);
 #endif
 	case BTRFS_IOC_SEND:
-		return btrfs_ioctl_send(file, argp);
+		return btrfs_ioctl_send(file, argp, false);
+#ifdef CONFIG_64BIT
+	case BTRFS_IOC_SEND_32:
+		return btrfs_ioctl_send(file, argp, true);
+#endif
 	case BTRFS_IOC_GET_DEV_STATS:
 		return btrfs_ioctl_get_dev_stats(fs_info, argp);
 	case BTRFS_IOC_QUOTA_CTL:
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 32b043ef8ac9..2041cac1875a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -26,6 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
+#include <linux/compat.h>
 
 #include "send.h"
 #include "backref.h"
@@ -6365,7 +6366,7 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 	spin_unlock(&root->root_item_lock);
 }
 
-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
+long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_, bool compat)
 {
 	int ret = 0;
 	struct btrfs_root *send_root = BTRFS_I(file_inode(mnt_file))->root;
@@ -6407,11 +6408,32 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
-	arg = memdup_user(arg_, sizeof(*arg));
-	if (IS_ERR(arg)) {
-		ret = PTR_ERR(arg);
-		arg = NULL;
-		goto out;
+	if (compat) {
+		struct btrfs_ioctl_send_args_32 args32;
+		ret = copy_from_user(&args32, arg_, sizeof(args32));
+		if (ret) {
+			btrfs_err(fs_info, "args32 copy failed\n");
+			goto out;
+		}
+		arg = kzalloc(sizeof(*arg), GFP_KERNEL);
+		if (!arg) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		arg->send_fd = args32.send_fd;
+		arg->clone_sources_count = args32.clone_sources_count;
+		arg->clone_sources = compat_ptr(args32.clone_sources);
+		arg->parent_root = args32.parent_root;
+		arg->flags = args32.flags;
+		memcpy(arg->reserved, args32.reserved,
+		       sizeof(args32.reserved));
+	} else {
+		arg = memdup_user(arg_, sizeof(*arg));
+		if (IS_ERR(arg)) {
+			ret = PTR_ERR(arg);
+			arg = NULL;
+			goto out;
+		}
 	}
 
 	/*
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 02e00166c4da..d45d2471c4b6 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -130,5 +130,5 @@ enum {
 #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
 
 #ifdef __KERNEL__
-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+long btrfs_ioctl_send(struct file *mnt_file, void __user *arg, bool compat);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 378230c163d5..50b201222cfc 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -719,6 +719,19 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 };
 
+#ifdef CONFIG_64BIT
+struct btrfs_ioctl_send_args_32 {
+	__s64 send_fd;			/* in */
+	__u64 clone_sources_count;	/* in */
+	__u32 clone_sources;		/* in */
+	__u64 parent_root;		/* in */
+	__u64 flags;			/* in */
+	__u64 reserved[4];		/* in */
+} __attribute__ ((__packed__));
+#define BTRFS_IOC_SEND_32 _IOW(BTRFS_IOCTL_MAGIC, 38, \
+			       struct btrfs_ioctl_send_args_32)
+#endif
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
-- 
2.7.4

