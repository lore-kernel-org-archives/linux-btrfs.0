From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 18/21] Btrfs: allow for pausing restriper
Date: Fri,  6 Jan 2012 16:31:06 +0200
Message-ID: <1325860269-15013-19-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Implement an ioctl for pausing restriper.  This pauses the relocation,
but balance is still considered to be "in progress": balance item is
not deleted, other volume operations cannot be started, etc.  If paused
in the middle of profile changing operation we will continue making
allocations with the target profile.

Add a hook to close_ctree() to pause restriper and free it's data
structures on unmount.  (It's safe to unmount when restriper is in
"paused" state, we will resume with the same parameters on the next
mount)

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    4 ++++
 fs/btrfs/disk-io.c |    6 ++++++
 fs/btrfs/ioctl.c   |   23 ++++++++++++++++++++++-
 fs/btrfs/ioctl.h   |    4 ++++
 fs/btrfs/volumes.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h |    1 +
 6 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 99eb2bc..1afda75 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1214,7 +1214,10 @@ struct btrfs_fs_info {
 	/* restriper state */
 	spinlock_t balance_lock;
 	struct mutex balance_mutex;
+	atomic_t balance_running;
+	atomic_t balance_pause_req;
 	struct btrfs_balance_control *balance_ctl;
+	wait_queue_head_t balance_wait_q;
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
@@ -2658,6 +2661,7 @@ static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 }
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
+	kfree(fs_info->balance_ctl);
 	kfree(fs_info->delayed_root);
 	kfree(fs_info->extent_root);
 	kfree(fs_info->tree_root);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eb7a11a..8ce8374 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2004,7 +2004,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	spin_lock_init(&fs_info->balance_lock);
 	mutex_init(&fs_info->balance_mutex);
+	atomic_set(&fs_info->balance_running, 0);
+	atomic_set(&fs_info->balance_pause_req, 0);
 	fs_info->balance_ctl = NULL;
+	init_waitqueue_head(&fs_info->balance_wait_q);
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
@@ -2980,6 +2983,9 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
+	/* pause restriper - we want to resume on mount */
+	btrfs_pause_balance(root->fs_info);
+
 	btrfs_scrub_cancel(root);
 
 	/* wait for any defraggers to finish */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e20d0cb..7830fae 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3081,6 +3081,11 @@ static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
+	if (fs_info->balance_ctl) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
+
 	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
 	if (!bctl) {
 		ret = -ENOMEM;
@@ -3108,7 +3113,8 @@ static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
 
 	ret = btrfs_balance(bctl, 0);
 	/*
-	 * bctl is freed in __cancel_balance
+	 * bctl is freed in __cancel_balance or in free_fs_info if
+	 * restriper was paused all the way until unmount
 	 */
 	kfree(bargs);
 out:
@@ -3117,6 +3123,19 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_balance_ctl(struct btrfs_root *root, int cmd)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case BTRFS_BALANCE_CTL_PAUSE:
+		return btrfs_pause_balance(root->fs_info);
+	}
+
+	return -EINVAL;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3195,6 +3214,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_progress(root, argp);
 	case BTRFS_IOC_BALANCE_V2:
 		return btrfs_ioctl_balance(root, argp);
+	case BTRFS_IOC_BALANCE_CTL:
+		return btrfs_ioctl_balance_ctl(root, arg);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 0ca8059..f069138 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -109,6 +109,9 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+/* balance control ioctl modes */
+#define BTRFS_BALANCE_CTL_PAUSE		1
+
 /*
  * this is packed, because it should be exactly the same as its disk
  * byte order counterpart (struct btrfs_disk_balance_args)
@@ -315,6 +318,7 @@ struct btrfs_ioctl_logical_ino_args {
 			       struct btrfs_ioctl_fs_info_args)
 #define BTRFS_IOC_BALANCE_V2 _IOW(BTRFS_IOCTL_MAGIC, 32, \
 				  struct btrfs_ioctl_balance_args)
+#define BTRFS_IOC_BALANCE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c50a0af..9d15819 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2490,6 +2490,11 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
+		if (atomic_read(&fs_info->balance_pause_req)) {
+			ret = -ECANCELED;
+			goto error;
+		}
+
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2549,6 +2554,11 @@ error:
 	return ret;
 }
 
+static inline int balance_need_close(struct btrfs_fs_info *fs_info)
+{
+	return atomic_read(&fs_info->balance_pause_req) == 0;
+}
+
 static void __cancel_balance(struct btrfs_fs_info *fs_info)
 {
 	int ret;
@@ -2567,9 +2577,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
 	u64 allowed;
 	int ret;
 
-	if (btrfs_fs_closing(fs_info)) {
+	if (btrfs_fs_closing(fs_info) ||
+	    atomic_read(&fs_info->balance_pause_req)) {
 		ret = -EINVAL;
 		goto out;
+	}
 
 	/*
 	 * In case of mixed groups both data and meta should be picked,
@@ -2670,13 +2682,20 @@ do_balance:
 		spin_unlock(&fs_info->balance_lock);
 	}
 
+	atomic_inc(&fs_info->balance_running);
 	mutex_unlock(&fs_info->balance_mutex);
 
 	ret = __btrfs_balance(fs_info);
 
 	mutex_lock(&fs_info->balance_mutex);
+	atomic_dec(&fs_info->balance_running);
 
-	__cancel_balance(fs_info);
+	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
+	    balance_need_close(fs_info)) {
+		__cancel_balance(fs_info);
+	}
+
+	wake_up(&fs_info->balance_wait_q);
 
 	return ret;
 out:
@@ -2770,6 +2789,35 @@ out:
 	return ret;
 }
 
+int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+
+	mutex_lock(&fs_info->balance_mutex);
+	if (!fs_info->balance_ctl) {
+		mutex_unlock(&fs_info->balance_mutex);
+		return -ENOTCONN;
+	}
+
+	if (atomic_read(&fs_info->balance_running)) {
+		atomic_inc(&fs_info->balance_pause_req);
+		mutex_unlock(&fs_info->balance_mutex);
+
+		wait_event(fs_info->balance_wait_q,
+			   atomic_read(&fs_info->balance_running) == 0);
+
+		mutex_lock(&fs_info->balance_mutex);
+		/* we are good with balance_ctl ripped off from under us */
+		BUG_ON(atomic_read(&fs_info->balance_running));
+		atomic_dec(&fs_info->balance_pause_req);
+	} else {
+		ret = -ENOTCONN;
+	}
+
+	mutex_unlock(&fs_info->balance_mutex);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bcaddd4..2f74695 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -271,6 +271,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *rctl, int resume);
 int btrfs_recover_balance(struct btrfs_root *tree_root);
+int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.6.3

