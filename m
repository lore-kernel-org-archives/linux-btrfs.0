Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:37366 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdI2Toe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:34 -0400
Received: by mail-qk0-f193.google.com with SMTP id z143so402447qkb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:34 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 18/21] btrfs: fix send ioctl on 32bit with 64bit kernel
Date: Fri, 29 Sep 2017 15:44:02 -0400
Message-Id: <1506714245-23072-19-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We pass in a pointer in our send arg struct, this means the struct size doesn't
match with 32bit user space and 64bit kernel space.  Fix this by adding a compat
mode and doing the appropriate conversion.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ioctl.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/send.c  | 12 ++----------
 fs/btrfs/send.h  |  2 +-
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 398495f79c83..6a07d4e12fd2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5464,6 +5464,53 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	return ret;
 }
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+struct btrfs_ioctl_send_args_32 {
+	__s64 send_fd;			/* in */
+	__u64 clone_sources_count;	/* in */
+	compat_uptr_t clone_sources;	/* in */
+	__u64 parent_root;		/* in */
+	__u64 flags;			/* in */
+	__u64 reserved[4];		/* in */
+} __attribute__ ((__packed__));
+#define BTRFS_IOC_SEND_32 _IOW(BTRFS_IOCTL_MAGIC, 38, \
+			       struct btrfs_ioctl_send_args_32)
+#endif
+
+static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
+{
+	struct btrfs_ioctl_send_args *arg;
+	int ret;
+
+	if (compat) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+		struct btrfs_ioctl_send_args_32 args32;
+		ret = copy_from_user(&args32, argp, sizeof(args32));
+		if (ret)
+			return -EFAULT;
+		arg = kzalloc(sizeof(*arg), GFP_KERNEL);
+		if (!arg)
+			return -ENOMEM;
+		arg->send_fd = args32.send_fd;
+		arg->clone_sources_count = args32.clone_sources_count;
+		arg->clone_sources = compat_ptr(args32.clone_sources);
+		arg->parent_root = args32.parent_root;
+		arg->flags = args32.flags;
+		memcpy(arg->reserved, args32.reserved,
+		       sizeof(args32.reserved));
+#else
+		return -ENOTTY;
+#endif
+	} else {
+		arg = memdup_user(argp, sizeof(*arg));
+		if (IS_ERR(arg))
+			return PTR_ERR(arg);
+	}
+	ret = btrfs_ioctl_send(file, arg);
+	kfree(arg);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -5569,7 +5616,11 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_received_subvol_32(file, argp);
 #endif
 	case BTRFS_IOC_SEND:
-		return btrfs_ioctl_send(file, argp);
+		return _btrfs_ioctl_send(file, argp, false);
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+	case BTRFS_IOC_SEND_32:
+		return _btrfs_ioctl_send(file, argp, true);
+#endif
 	case BTRFS_IOC_GET_DEV_STATS:
 		return btrfs_ioctl_get_dev_stats(fs_info, argp);
 	case BTRFS_IOC_QUOTA_CTL:
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0746eda7231d..d9ddcdbdd2e7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -26,6 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
+#include <linux/compat.h>
 
 #include "send.h"
 #include "backref.h"
@@ -6371,13 +6372,12 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 	spin_unlock(&root->root_item_lock);
 }
 
-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
+long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 {
 	int ret = 0;
 	struct btrfs_root *send_root = BTRFS_I(file_inode(mnt_file))->root;
 	struct btrfs_fs_info *fs_info = send_root->fs_info;
 	struct btrfs_root *clone_root;
-	struct btrfs_ioctl_send_args *arg = NULL;
 	struct btrfs_key key;
 	struct send_ctx *sctx = NULL;
 	u32 i;
@@ -6413,13 +6413,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
-	arg = memdup_user(arg_, sizeof(*arg));
-	if (IS_ERR(arg)) {
-		ret = PTR_ERR(arg);
-		arg = NULL;
-		goto out;
-	}
-
 	/*
 	 * Check that we don't overflow at later allocations, we request
 	 * clone_sources_count + 1 items, and compare to unsigned long inside
@@ -6660,7 +6653,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
 		btrfs_root_dec_send_in_progress(sctx->parent_root);
 
-	kfree(arg);
 	kvfree(clone_sources_tmp);
 
 	if (sctx) {
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 02e00166c4da..3aa4bc55754f 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -130,5 +130,5 @@ enum {
 #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
 
 #ifdef __KERNEL__
-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg);
 #endif
-- 
2.7.4

