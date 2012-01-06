From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 21/21] Btrfs: add balance progress reporting
Date: Fri,  6 Jan 2012 16:31:09 +0200
Message-ID: <1325860269-15013-22-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    6 ++++++
 fs/btrfs/volumes.c |   35 +++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h |    3 +++
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a83b1a5..47abfc2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3140,6 +3140,55 @@ static long btrfs_ioctl_balance_ctl(struct btrfs_root *root, int cmd)
 	return -EINVAL;
 }
 
+static long btrfs_ioctl_balance_progress(struct btrfs_root *root,
+					 void __user *arg)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ioctl_balance_args *bargs;
+	struct btrfs_balance_control *bctl;
+	int ret = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&fs_info->balance_mutex);
+	if (!(bctl = fs_info->balance_ctl)) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	bargs = kzalloc(sizeof(*bargs), GFP_NOFS);
+	if (!bargs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bargs->flags = bctl->flags;
+
+	if (atomic_read(&fs_info->balance_running))
+		bargs->state |= BTRFS_BALANCE_STATE_RUNNING;
+	if (atomic_read(&fs_info->balance_cancel_req))
+		bargs->state |= BTRFS_BALANCE_STATE_CANCEL_REQ;
+	if (atomic_read(&fs_info->balance_pause_req))
+		bargs->state |= BTRFS_BALANCE_STATE_PAUSE_REQ;
+
+	memcpy(&bargs->data, &bctl->data, sizeof(bargs->data));
+	memcpy(&bargs->meta, &bctl->meta, sizeof(bargs->meta));
+	memcpy(&bargs->sys, &bctl->sys, sizeof(bargs->sys));
+
+	spin_lock(&fs_info->balance_lock);
+	memcpy(&bargs->stat, &bctl->stat, sizeof(bargs->stat));
+	spin_unlock(&fs_info->balance_lock);
+
+	if (copy_to_user(arg, bargs, sizeof(*bargs)))
+		ret = -EFAULT;
+
+	kfree(bargs);
+out:
+	mutex_unlock(&fs_info->balance_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3220,6 +3269,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_balance(root, argp);
 	case BTRFS_IOC_BALANCE_CTL:
 		return btrfs_ioctl_balance_ctl(root, arg);
+	case BTRFS_IOC_BALANCE_PROGRESS:
+		return btrfs_ioctl_balance_progress(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index c691ef4..04f8c1b 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -142,6 +142,10 @@ struct btrfs_balance_progress {
 	__u64 completed;	/* # of chunks relocated so far */
 };
 
+#define BTRFS_BALANCE_STATE_RUNNING	(1ULL << 0)
+#define BTRFS_BALANCE_STATE_CANCEL_REQ	(1ULL << 1)
+#define BTRFS_BALANCE_STATE_PAUSE_REQ	(1ULL << 2)
+
 struct btrfs_ioctl_balance_args {
 	__u64 flags;				/* in/out */
 	__u64 state;				/* out */
@@ -321,6 +325,8 @@ struct btrfs_ioctl_logical_ino_args {
 #define BTRFS_IOC_BALANCE_V2 _IOW(BTRFS_IOCTL_MAGIC, 32, \
 				  struct btrfs_ioctl_balance_args)
 #define BTRFS_IOC_BALANCE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 34, \
+					struct btrfs_ioctl_balance_args)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d907635..d7c5c7d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2439,6 +2439,7 @@ static u64 div_factor(u64 num, int factor)
 
 static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct list_head *devices;
@@ -2454,6 +2455,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	int slot;
 	int ret;
 	int enospc_errors = 0;
+	bool counting = true;
 
 	/* step one make some room on all the devices */
 	devices = &fs_info->fs_devices->devices;
@@ -2485,12 +2487,18 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		ret = -ENOMEM;
 		goto error;
 	}
+
+	/* zero out stat counters */
+	spin_lock(&fs_info->balance_lock);
+	memset(&bctl->stat, 0, sizeof(bctl->stat));
+	spin_unlock(&fs_info->balance_lock);
+again:
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
-		if (atomic_read(&fs_info->balance_pause_req) ||
+		if ((!counting && atomic_read(&fs_info->balance_pause_req)) ||
 		    atomic_read(&fs_info->balance_cancel_req)) {
 			ret = -ECANCELED;
 			goto error;
@@ -2525,24 +2533,47 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 
 		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 
+		if (!counting) {
+			spin_lock(&fs_info->balance_lock);
+			bctl->stat.considered++;
+			spin_unlock(&fs_info->balance_lock);
+		}
+
 		ret = should_balance_chunk(chunk_root, leaf, chunk,
 					   found_key.offset);
 		btrfs_release_path(path);
 		if (!ret)
 			goto loop;
 
+		if (counting) {
+			spin_lock(&fs_info->balance_lock);
+			bctl->stat.expected++;
+			spin_unlock(&fs_info->balance_lock);
+			goto loop;
+		}
+
 		ret = btrfs_relocate_chunk(chunk_root,
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
 					   found_key.offset);
 		if (ret && ret != -ENOSPC)
 			goto error;
-		if (ret == -ENOSPC)
+		if (ret == -ENOSPC) {
 			enospc_errors++;
+		} else {
+			spin_lock(&fs_info->balance_lock);
+			bctl->stat.completed++;
+			spin_unlock(&fs_info->balance_lock);
+		}
 loop:
 		key.offset = found_key.offset - 1;
 	}
 
+	if (counting) {
+		btrfs_release_path(path);
+		counting = false;
+		goto again;
+	}
 error:
 	btrfs_free_path(path);
 	if (enospc_errors) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6271d8e..ae1d9bd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -217,6 +217,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
 
 struct btrfs_balance_args;
+struct btrfs_balance_progress;
 struct btrfs_balance_control {
 	struct btrfs_fs_info *fs_info;
 
@@ -225,6 +226,8 @@ struct btrfs_balance_control {
 	struct btrfs_balance_args sys;
 
 	u64 flags;
+
+	struct btrfs_balance_progress stat;
 };
 
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
-- 
1.7.6.3

