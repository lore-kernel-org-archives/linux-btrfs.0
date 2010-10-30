From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 2/2] Cancel filesystem balance.
Date: Sat, 30 Oct 2010 01:07:28 +0100
Message-ID: <20101030000741.915844791@carfax.org.uk>
References: <20101030000726.286517546@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an ioctl for cancelling a btrfs balance operation
mid-flight. The ioctl simply sets a flag, and the operation terminates
after the current block group move has completed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>

---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/ioctl.c   |   25 +++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |    7 ++++++-
 4 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-mainline/fs/btrfs/ctree.h
===================================================================
--- linux-mainline.orig/fs/btrfs/ctree.h	2010-10-29 17:20:43.860460761 +0100
+++ linux-mainline/fs/btrfs/ctree.h	2010-10-29 17:24:06.622214467 +0100
@@ -806,6 +806,7 @@
 struct btrfs_balance_info {
 	u64 expected;
 	u64 completed;
+	int cancel_pending;
 };
 
 struct reloc_control;
Index: linux-mainline/fs/btrfs/ioctl.c
===================================================================
--- linux-mainline.orig/fs/btrfs/ioctl.c	2010-10-29 17:21:26.128742389 +0100
+++ linux-mainline/fs/btrfs/ioctl.c	2010-10-29 17:27:51.933043374 +0100
@@ -2016,6 +2016,29 @@
 	return ret;
 }
 
+/*
+ * Cancel a running balance operation
+ */
+long btrfs_ioctl_balance_cancel(struct btrfs_fs_info *fs_info)
+{
+	int err = 0;
+
+	spin_lock(&fs_info->balance_info_lock);
+	if(!fs_info->balance_info) {
+		err = -EINVAL;
+		goto error;
+	}
+	if(fs_info->balance_info->cancel_pending) {
+		err = -ECANCELED;
+		goto error;
+	}
+	fs_info->balance_info->cancel_pending = 1;
+
+error:
+	spin_unlock(&fs_info->balance_info_lock);
+	return err;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2051,6 +2074,8 @@
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
+	case BTRFS_IOC_BALANCE_CANCEL:
+		return btrfs_ioctl_balance_cancel(root->fs_info);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
Index: linux-mainline/fs/btrfs/ioctl.h
===================================================================
--- linux-mainline.orig/fs/btrfs/ioctl.h	2010-10-29 17:05:44.447028825 +0100
+++ linux-mainline/fs/btrfs/ioctl.h	2010-10-29 17:24:06.642213653 +0100
@@ -185,4 +185,5 @@
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 21, \
 					struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 22)
 #endif
Index: linux-mainline/fs/btrfs/volumes.c
===================================================================
--- linux-mainline.orig/fs/btrfs/volumes.c	2010-10-29 17:23:40.463279287 +0100
+++ linux-mainline/fs/btrfs/volumes.c	2010-10-29 17:24:06.652213246 +0100
@@ -1921,6 +1921,7 @@
 	bal_info->expected = -1; /* One less than actually counted,
 				    because chunk 0 is special */
 	bal_info->completed = 0;
+	bal_info->cancel_pending = 0;
 
 	/* step one make some room on all the devices */
 	list_for_each_entry(device, devices, dev_list) {
@@ -1983,7 +1984,7 @@
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
-	while (1) {
+	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2024,6 +2025,10 @@
 		       bal_info->completed, bal_info->expected);
 	}
 	ret = 0;
+	if(bal_info->cancel_pending) {
+		printk(KERN_INFO "btrfs: balance cancelled\n");
+		ret = -EINTR;
+	}
 error:
 	btrfs_free_path(path);
 	spin_lock(&dev_root->fs_info->balance_info_lock);


