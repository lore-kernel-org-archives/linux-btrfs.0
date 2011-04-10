From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 2/8] btrfs: Cancel filesystem balance
Date: Sun, 10 Apr 2011 22:06:05 +0100
Message-ID: <1302469571-12605-3-git-send-email-hugo@carfax.org.uk>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an ioctl for cancelling a btrfs balance operation
mid-flight. The ioctl simply sets a flag, and the operation terminates
after the current block group move has completed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/ioctl.c   |   28 ++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |    7 ++++++-
 4 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 17c7ecc..1d26cfd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -868,6 +868,7 @@ struct btrfs_block_group_cache {
 struct btrfs_balance_info {
 	u32 expected;
 	u32 completed;
+	int cancel_pending;
 };
 
 struct reloc_control;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a8fbb07..aef6329 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2407,6 +2407,32 @@ error:
 	return ret;
 }
 
+/*
+ * Cancel a running balance operation
+ */
+long btrfs_ioctl_balance_cancel(struct btrfs_fs_info *fs_info)
+{
+	int err = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	spin_lock(&fs_info->balance_info_lock);
+	if (!fs_info->balance_info) {
+		err = -EINVAL;
+		goto error;
+	}
+	if (fs_info->balance_info->cancel_pending) {
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
@@ -2448,6 +2474,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
+	case BTRFS_IOC_BALANCE_CANCEL:
+		return btrfs_ioctl_balance_cancel(root->fs_info);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 7c37c6b..2c49add 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -210,4 +210,5 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 				  struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bb2ffed..cf019af 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2064,6 +2064,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	bal_info->expected = -1; /* One less than actually counted,
 				    because chunk 0 is special */
 	bal_info->completed = 0;
+	bal_info->cancel_pending = 0;
 	spin_unlock(&dev_root->fs_info->balance_info_lock);
 
 	/* step one make some room on all the devices */
@@ -2124,7 +2125,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
-	while (1) {
+	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2164,6 +2165,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		       bal_info->completed, bal_info->expected);
 	}
 	ret = 0;
+	if (bal_info->cancel_pending) {
+		printk(KERN_INFO "btrfs: balance cancelled\n");
+		ret = -EINTR;
+	}
 error:
 	btrfs_free_path(path);
 	spin_lock(&dev_root->fs_info->balance_info_lock);
-- 
1.7.2.5

