From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 21/21] Btrfs: add restripe progress reporting
Date: Tue, 23 Aug 2011 23:02:02 +0300
Message-ID: <1314129722-31601-22-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    2 ++
 fs/btrfs/volumes.c |   40 ++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.h |    3 +++
 4 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4f29149..a342544 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2966,6 +2966,49 @@ static long btrfs_ioctl_restripe_ctl(struct btrfs_root *root,
 	return -EINVAL;
 }
 
+static long btrfs_ioctl_restripe_progress(struct btrfs_root *root,
+					  void __user *arg)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ioctl_restripe_args *rargs;
+	struct restripe_control *rctl;
+	int ret = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&fs_info->restripe_mutex);
+	if (!(rctl = fs_info->restripe_ctl)) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	rargs = kzalloc(sizeof(*rargs), GFP_NOFS);
+	if (!rargs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rargs->flags = rctl->flags;
+	rargs->state = fs_info->restripe_state;
+
+	memcpy(&rargs->data, &rctl->data, sizeof(rargs->data));
+	memcpy(&rargs->sys, &rctl->sys, sizeof(rargs->sys));
+	memcpy(&rargs->meta, &rctl->meta, sizeof(rargs->meta));
+
+	spin_lock(&fs_info->restripe_lock);
+	memcpy(&rargs->stat, &rctl->stat, sizeof(rargs->stat));
+	spin_unlock(&fs_info->restripe_lock);
+
+	if (copy_to_user(arg, rargs, sizeof(*rargs)))
+		ret = -EFAULT;
+
+	kfree(rargs);
+out:
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3042,6 +3085,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_restripe(root, argp);
 	case BTRFS_IOC_RESTRIPE_CTL:
 		return btrfs_ioctl_restripe_ctl(root, arg);
+	case BTRFS_IOC_RESTRIPE_PROGRESS:
+		return btrfs_ioctl_restripe_progress(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 365d06c..2154816 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -290,4 +290,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_RESTRIPE _IOW(BTRFS_IOCTL_MAGIC, 32, \
 				struct btrfs_ioctl_restripe_args)
 #define BTRFS_IOC_RESTRIPE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
+#define BTRFS_IOC_RESTRIPE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 34, \
+				struct btrfs_ioctl_restripe_args)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ead4996..9a248b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2187,8 +2187,10 @@ static void set_restripe_control(struct restripe_control *rctl, int update)
 
 	spin_lock(&fs_info->restripe_lock);
 	fs_info->restripe_ctl = rctl;
-	if (update)
+	if (update) {
 		update_restripe_args(rctl);
+		memset(&rctl->stat, 0, sizeof(rctl->stat));
+	}
 	spin_unlock(&fs_info->restripe_lock);
 }
 
@@ -2419,6 +2421,7 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 	int slot;
 	int ret;
 	int enospc_errors = 0;
+	bool counting_only = true;
 
 	/* step one make some room on all the devices */
 	devices = &dev_root->fs_info->fs_devices->devices;
@@ -2451,12 +2454,14 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 		goto error;
 	}
 
+again:
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
 		struct btrfs_fs_info *fs_info = dev_root->fs_info;
+		struct restripe_control *rctl = fs_info->restripe_ctl;
 
 		if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state) ||
 		    test_bit(RESTRIPE_PAUSE_REQ, &fs_info->restripe_state)) {
@@ -2493,25 +2498,48 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 
 		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 
-		if (!should_restripe_chunk(chunk_root, leaf, chunk,
-					   found_key.offset)) {
-			btrfs_release_path(path);
-			goto loop;
+		if (!counting_only) {
+			spin_lock(&fs_info->restripe_lock);
+			rctl->stat.considered++;
+			spin_unlock(&fs_info->restripe_lock);
 		}
 
+		ret = should_restripe_chunk(chunk_root, leaf, chunk,
+					    found_key.offset);
 		btrfs_release_path(path);
+		if (!ret)
+			goto loop;
+
+		if (counting_only) {
+			spin_lock(&fs_info->restripe_lock);
+			rctl->stat.expected++;
+			spin_unlock(&fs_info->restripe_lock);
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
+			spin_lock(&fs_info->restripe_lock);
+			rctl->stat.completed++;
+			spin_unlock(&fs_info->restripe_lock);
+		}
 loop:
 		key.offset = found_key.offset - 1;
 	}
 
+	if (counting_only) {
+		btrfs_release_path(path);
+		counting_only = false;
+		goto again;
+	}
+
 error:
 	btrfs_free_path(path);
 	if (enospc_errors) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 20da71f..5ca3b3b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -207,6 +207,7 @@ struct map_lookup {
 #define RESTRIPE_PAUSE_REQ	2
 
 struct btrfs_restripe_args;
+struct btrfs_restripe_progress;
 struct restripe_control {
 	struct btrfs_fs_info *fs_info;
 	u64 flags;
@@ -214,6 +215,8 @@ struct restripe_control {
 	struct btrfs_restripe_args data;
 	struct btrfs_restripe_args sys;
 	struct btrfs_restripe_args meta;
+
+	struct btrfs_restripe_progress stat;
 };
 
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
-- 
1.7.5.4

