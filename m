From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 16/21] Btrfs: allow for cancelling restriper
Date: Tue, 23 Aug 2011 23:01:57 +0300
Message-ID: <1314129722-31601-17-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Implement an ioctl for cancelling restriper.  Currently we wait until
relocation of the current block group is finished, in future this can be
done by triggering a commit.  Restripe item is deleted and no memory
about the interrupted restripe is kept.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    2 +
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |   20 +++++++++++++++++
 fs/btrfs/ioctl.h   |    3 ++
 fs/btrfs/volumes.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.h |    7 ++++++
 6 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b524034..8e764d9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1165,6 +1165,8 @@ struct btrfs_fs_info {
 	spinlock_t restripe_lock;
 	struct mutex restripe_mutex;
 	struct restripe_control *restripe_ctl;
+	unsigned long restripe_state;
+	wait_queue_head_t restripe_wait;
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b3950f2..662a6e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1703,6 +1703,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->restripe_lock);
 	mutex_init(&fs_info->restripe_mutex);
 	fs_info->restripe_ctl = NULL;
+	fs_info->restripe_state = 0;
+	init_waitqueue_head(&fs_info->restripe_wait);
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f371edd..d8bdb67 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2878,6 +2878,10 @@ static long btrfs_ioctl_restripe(struct btrfs_root *root, void __user *arg)
 		return -EROFS;
 
 	mutex_lock(&fs_info->restripe_mutex);
+	if (fs_info->restripe_ctl) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
 
 	rargs = memdup_user(arg, sizeof(*rargs));
 	if (IS_ERR(rargs)) {
@@ -2908,6 +2912,20 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_restripe_ctl(struct btrfs_root *root,
+				     int cmd)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case BTRFS_RESTRIPE_CTL_CANCEL:
+		return btrfs_cancel_restripe(root->fs_info);
+	}
+
+	return -EINVAL;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2982,6 +3000,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_progress(root, argp);
 	case BTRFS_IOC_RESTRIPE:
 		return btrfs_ioctl_restripe(root, argp);
+	case BTRFS_IOC_RESTRIPE_CTL:
+		return btrfs_ioctl_restripe_ctl(root, arg);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 798f1d4..4f6ead5 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -109,6 +109,8 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+#define BTRFS_RESTRIPE_CTL_CANCEL	1
+
 struct btrfs_restripe_args {
 	__u64 profiles;
 	__u64 usage;
@@ -285,4 +287,5 @@ struct btrfs_ioctl_space_args {
 			       struct btrfs_ioctl_fs_info_args)
 #define BTRFS_IOC_RESTRIPE _IOW(BTRFS_IOCTL_MAGIC, 32, \
 				struct btrfs_ioctl_restripe_args)
+#define BTRFS_IOC_RESTRIPE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4490124..cd43368 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2553,6 +2553,13 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
+		struct btrfs_fs_info *fs_info = dev_root->fs_info;
+
+		if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state)) {
+			ret = -ECANCELED;
+			goto error;
+		}
+
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2715,16 +2722,25 @@ do_restripe:
 	set_restripe_control(rctl, resume);
 	mutex_unlock(&fs_info->volume_mutex);
 
+	set_bit(RESTRIPE_RUNNING, &fs_info->restripe_state);
+	mutex_unlock(&fs_info->restripe_mutex);
+
 	err = __btrfs_restripe(fs_info->dev_root);
 
-	mutex_lock(&fs_info->volume_mutex);
+	mutex_lock(&fs_info->restripe_mutex);
+	clear_bit(RESTRIPE_RUNNING, &fs_info->restripe_state);
 
-	unset_restripe_control(fs_info);
-	ret = del_restripe_item(fs_info->tree_root);
-	BUG_ON(ret);
+	if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state)) {
+		mutex_lock(&fs_info->volume_mutex);
 
-	mutex_unlock(&fs_info->volume_mutex);
+		unset_restripe_control(fs_info);
+		ret = del_restripe_item(fs_info->tree_root);
+		BUG_ON(ret);
+
+		mutex_unlock(&fs_info->volume_mutex);
+	}
 
+	wake_up(&fs_info->restripe_wait);
 	return err;
 
 out:
@@ -2807,6 +2823,41 @@ out:
 	return ret;
 }
 
+int btrfs_cancel_restripe(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+
+	mutex_lock(&fs_info->restripe_mutex);
+	if (!fs_info->restripe_ctl) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	if (test_bit(RESTRIPE_RUNNING, &fs_info->restripe_state)) {
+		set_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state);
+		while (test_bit(RESTRIPE_RUNNING, &fs_info->restripe_state)) {
+			mutex_unlock(&fs_info->restripe_mutex);
+			wait_event(fs_info->restripe_wait,
+				   !test_bit(RESTRIPE_RUNNING,
+					     &fs_info->restripe_state));
+			mutex_lock(&fs_info->restripe_mutex);
+		}
+		clear_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state);
+	} else {
+		mutex_lock(&fs_info->volume_mutex);
+
+		unset_restripe_control(fs_info);
+		ret = del_restripe_item(fs_info->tree_root);
+		BUG_ON(ret);
+
+		mutex_unlock(&fs_info->volume_mutex);
+	}
+
+out:
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6fcb4a5..dd1fa7f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -199,6 +199,12 @@ struct map_lookup {
 #define BTRFS_RESTRIPE_ARGS_CONVERT	(1ULL << 8)
 #define BTRFS_RESTRIPE_ARGS_SOFT	(1ULL << 9)
 
+/*
+ * Restripe state bits
+ */
+#define RESTRIPE_RUNNING	0
+#define RESTRIPE_CANCEL_REQ	1
+
 struct btrfs_restripe_args;
 struct restripe_control {
 	struct btrfs_fs_info *fs_info;
@@ -254,6 +260,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
 int btrfs_restripe(struct restripe_control *rctl, int resume);
 int btrfs_recover_restripe(struct btrfs_root *tree_root);
+int btrfs_cancel_restripe(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.5.4

