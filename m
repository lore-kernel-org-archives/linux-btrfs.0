From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 20/21] Btrfs: get rid of btrfs_balance() function
Date: Tue, 23 Aug 2011 23:02:01 +0300
Message-ID: <1314129722-31601-21-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Remove btrfs_balance().  The old balancing ioctl now uses restriper
infrastructure, just w/o using any filters.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |   38 +++++++++++++++++-
 fs/btrfs/volumes.c |  115 ++++-----------------------------------------------
 fs/btrfs/volumes.h |    1 -
 3 files changed, 46 insertions(+), 108 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cb2f420..4f29149 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2864,6 +2864,42 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
+static long btrfs_ioctl_balance(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct restripe_control *rctl;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	mutex_lock(&fs_info->restripe_mutex);
+	if (fs_info->restripe_ctl) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
+
+	rctl = kzalloc(sizeof(*rctl), GFP_NOFS);
+	if (!rctl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rctl->fs_info = fs_info;
+	/* relocate everything - no filters */
+	rctl->flags |= BTRFS_RESTRIPE_TYPE_MASK;
+
+	ret = btrfs_restripe(rctl, 0);
+
+	/* rctl freed in unset_restripe_control */
+out:
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
 static long btrfs_ioctl_restripe(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_restripe_args *rargs;
@@ -2974,7 +3010,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_DEV_INFO:
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
-		return btrfs_balance(root->fs_info->dev_root);
+		return btrfs_ioctl_balance(root);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d8958e2..ead4996 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2045,112 +2045,6 @@ error:
 	return ret;
 }
 
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	do_div(num, 10);
-	return num;
-}
-
-int btrfs_balance(struct btrfs_root *dev_root)
-{
-	int ret;
-	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
-	struct btrfs_device *device;
-	u64 old_size;
-	u64 size_to_free;
-	struct btrfs_path *path;
-	struct btrfs_key key;
-	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_key found_key;
-
-	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	mutex_lock(&dev_root->fs_info->volume_mutex);
-	dev_root = dev_root->fs_info->dev_root;
-
-	/* step one make some room on all the devices */
-	list_for_each_entry(device, devices, dev_list) {
-		old_size = device->total_bytes;
-		size_to_free = div_factor(old_size, 1);
-		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);
-		if (!device->writeable ||
-		    device->total_bytes - device->bytes_used > size_to_free)
-			continue;
-
-		ret = btrfs_shrink_device(device, old_size - size_to_free);
-		if (ret == -ENOSPC)
-			break;
-		BUG_ON(ret);
-
-		trans = btrfs_start_transaction(dev_root, 0);
-		BUG_ON(IS_ERR(trans));
-
-		ret = btrfs_grow_device(trans, device, old_size);
-		BUG_ON(ret);
-
-		btrfs_end_transaction(trans, dev_root);
-	}
-
-	/* step two, relocate all the chunks */
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto error;
-	}
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.offset = (u64)-1;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-
-	while (1) {
-		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
-		if (ret < 0)
-			goto error;
-
-		/*
-		 * this shouldn't happen, it means the last relocate
-		 * failed
-		 */
-		if (ret == 0)
-			break;
-
-		ret = btrfs_previous_item(chunk_root, path, 0,
-					  BTRFS_CHUNK_ITEM_KEY);
-		if (ret)
-			break;
-
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-				      path->slots[0]);
-		if (found_key.objectid != key.objectid)
-			break;
-
-		/* chunk zero is special */
-		if (found_key.offset == 0)
-			break;
-
-		btrfs_release_path(path);
-		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
-					   found_key.objectid,
-					   found_key.offset);
-		if (ret && ret != -ENOSPC)
-			goto error;
-		key.offset = found_key.offset - 1;
-	}
-	ret = 0;
-error:
-	btrfs_free_path(path);
-	mutex_unlock(&dev_root->fs_info->volume_mutex);
-	return ret;
-}
-
 static int insert_restripe_item(struct btrfs_root *root,
 				struct restripe_control *rctl)
 {
@@ -2500,6 +2394,15 @@ static int should_restripe_chunk(struct btrfs_root *root,
 	return 1;
 }
 
+static u64 div_factor(u64 num, int factor)
+{
+	if (factor == 10)
+		return num;
+	num *= factor;
+	do_div(num, 10);
+	return num;
+}
+
 static int __btrfs_restripe(struct btrfs_root *dev_root)
 {
 	struct list_head *devices;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c0652c9..20da71f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -258,7 +258,6 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
-int btrfs_balance(struct btrfs_root *dev_root);
 int btrfs_restripe(struct restripe_control *rctl, int resume);
 int btrfs_recover_restripe(struct btrfs_root *tree_root);
 int btrfs_cancel_restripe(struct btrfs_fs_info *fs_info);
-- 
1.7.5.4

