From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 2/2] Cancel filesystem balance.
Date: Tue, 9 Nov 2010 22:52:59 +0000
Message-ID: <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
References: <cover.1289522188.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1289522188.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an ioctl for cancelling a btrfs balance operation
mid-flight. The ioctl simply sets a flag, and the operation terminates
after the current block group move has completed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/ioctl.c   |   28 ++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    3 ++-
 fs/btrfs/volumes.c |    7 ++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 67fb603..5fa7163 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -844,6 +844,7 @@ struct btrfs_block_group_cache {
 struct btrfs_balance_info {
 	u64 expected;
 	u64 completed;
+	int cancel_pending;
 };
 
 struct reloc_control;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c247985..7e38856 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2252,6 +2252,32 @@ error:
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
@@ -2289,6 +2315,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
+	case BTRFS_IOC_BALANCE_CANCEL:
+		return btrfs_ioctl_balance_cancel(root->fs_info);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b2103b2..76ae121 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -195,5 +195,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_async_vol_args)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
-				  struct btrfs_ioctl_balance_progress)
+				struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 26)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f00edc1..64b2f04 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1924,6 +1924,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	bal_info->expected = -1; /* One less than actually counted,
 				    because chunk 0 is special */
 	bal_info->completed = 0;
+	bal_info->cancel_pending = 0;
 	spin_unlock(&dev_root->fs_info->balance_info_lock);
 
 	/* step one make some room on all the devices */
@@ -1989,7 +1990,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
-	while (1) {
+	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2029,6 +2030,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
-- 
1.7.1

