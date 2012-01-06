From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 19/21] Btrfs: allow for cancelling restriper
Date: Fri,  6 Jan 2012 16:31:07 +0200
Message-ID: <1325860269-15013-20-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Implement an ioctl for cancelling restriper.  Currently we wait until
relocation of the current block group is finished, in future this can be
done by triggering a commit.  Balance item is deleted and no memory
about the interrupted balance is kept.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/ioctl.c   |    2 ++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h |    1 +
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1afda75..dfc136c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1216,6 +1216,7 @@ struct btrfs_fs_info {
 	struct mutex balance_mutex;
 	atomic_t balance_running;
 	atomic_t balance_pause_req;
+	atomic_t balance_cancel_req;
 	struct btrfs_balance_control *balance_ctl;
 	wait_queue_head_t balance_wait_q;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8ce8374..c23b82d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2006,6 +2006,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->balance_mutex);
 	atomic_set(&fs_info->balance_running, 0);
 	atomic_set(&fs_info->balance_pause_req, 0);
+	atomic_set(&fs_info->balance_cancel_req, 0);
 	fs_info->balance_ctl = NULL;
 	init_waitqueue_head(&fs_info->balance_wait_q);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7830fae..d47ff8e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3131,6 +3131,8 @@ static long btrfs_ioctl_balance_ctl(struct btrfs_root *root, int cmd)
 	switch (cmd) {
 	case BTRFS_BALANCE_CTL_PAUSE:
 		return btrfs_pause_balance(root->fs_info);
+	case BTRFS_BALANCE_CTL_CANCEL:
+		return btrfs_cancel_balance(root->fs_info);
 	}
 
 	return -EINVAL;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index f069138..33ec6d8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -111,6 +111,7 @@ struct btrfs_ioctl_fs_info_args {
 
 /* balance control ioctl modes */
 #define BTRFS_BALANCE_CTL_PAUSE		1
+#define BTRFS_BALANCE_CTL_CANCEL	2
 
 /*
  * this is packed, because it should be exactly the same as its disk
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d15819..f7248c9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2490,7 +2490,8 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
-		if (atomic_read(&fs_info->balance_pause_req)) {
+		if (atomic_read(&fs_info->balance_pause_req) ||
+		    atomic_read(&fs_info->balance_cancel_req)) {
 			ret = -ECANCELED;
 			goto error;
 		}
@@ -2556,7 +2557,10 @@ error:
 
 static inline int balance_need_close(struct btrfs_fs_info *fs_info)
 {
-	return atomic_read(&fs_info->balance_pause_req) == 0;
+	/* cancel requested || normal exit path */
+	return atomic_read(&fs_info->balance_cancel_req) ||
+		(atomic_read(&fs_info->balance_pause_req) == 0 &&
+		 atomic_read(&fs_info->balance_cancel_req) == 0);
 }
 
 static void __cancel_balance(struct btrfs_fs_info *fs_info)
@@ -2578,7 +2582,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
 	int ret;
 
 	if (btrfs_fs_closing(fs_info) ||
-	    atomic_read(&fs_info->balance_pause_req)) {
+	    atomic_read(&fs_info->balance_pause_req) ||
+	    atomic_read(&fs_info->balance_cancel_req)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2818,6 +2823,42 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
+{
+	mutex_lock(&fs_info->balance_mutex);
+	if (!fs_info->balance_ctl) {
+		mutex_unlock(&fs_info->balance_mutex);
+		return -ENOTCONN;
+	}
+
+	atomic_inc(&fs_info->balance_cancel_req);
+	/*
+	 * if we are running just wait and return, balance item is
+	 * deleted in btrfs_balance in this case
+	 */
+	if (atomic_read(&fs_info->balance_running)) {
+		mutex_unlock(&fs_info->balance_mutex);
+		wait_event(fs_info->balance_wait_q,
+			   atomic_read(&fs_info->balance_running) == 0);
+		mutex_lock(&fs_info->balance_mutex);
+	} else {
+		/* __cancel_balance needs volume_mutex */
+		mutex_unlock(&fs_info->balance_mutex);
+		mutex_lock(&fs_info->volume_mutex);
+		mutex_lock(&fs_info->balance_mutex);
+
+		if (fs_info->balance_ctl)
+			__cancel_balance(fs_info);
+
+		mutex_unlock(&fs_info->volume_mutex);
+	}
+
+	BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));
+	atomic_dec(&fs_info->balance_cancel_req);
+	mutex_unlock(&fs_info->balance_mutex);
+	return 0;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2f74695..4429efc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -272,6 +272,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *rctl, int resume);
 int btrfs_recover_balance(struct btrfs_root *tree_root);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
+int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.6.3

