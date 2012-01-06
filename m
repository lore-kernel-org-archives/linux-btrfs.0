From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 05/21] Btrfs: add basic restriper infrastructure
Date: Fri,  6 Jan 2012 16:30:53 +0200
Message-ID: <1325860269-15013-6-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add basic restriper infrastructure: extended balancing ioctl and all
related ioctl data structures, add data structure for tracking
restriper's state to fs_info, etc.  The semantics of the old balancing
ioctl are fully preserved.

Explicitly disallow any volume operations when balance is in progress.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    6 +++
 fs/btrfs/disk-io.c |    4 ++
 fs/btrfs/ioctl.c   |  114 ++++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.h   |   43 +++++++++++++++++++
 fs/btrfs/volumes.c |  113 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   13 +++++-
 6 files changed, 252 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f8f11e..c4d98c8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -934,6 +934,7 @@ struct btrfs_block_group_cache {
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
+struct btrfs_balance_control;
 struct btrfs_delayed_root;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
@@ -1159,6 +1160,11 @@ struct btrfs_fs_info {
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
 
+	/* restriper state */
+	spinlock_t balance_lock;
+	struct mutex balance_mutex;
+	struct btrfs_balance_control *balance_ctl;
+
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ce9d0fb..190a1b2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2002,6 +2002,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->scrub_super_lock);
 	fs_info->scrub_workers_refcnt = 0;
 
+	spin_lock_init(&fs_info->balance_lock);
+	mutex_init(&fs_info->balance_mutex);
+	fs_info->balance_ctl = NULL;
+
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c04f02c..221bae0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1203,13 +1203,21 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->balance_ctl) {
+		printk(KERN_INFO "btrfs: balance in progress\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args))
-		return PTR_ERR(vol_args);
+	if (IS_ERR(vol_args)) {
+		ret = PTR_ERR(vol_args);
+		goto out;
+	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 
-	mutex_lock(&root->fs_info->volume_mutex);
 	sizestr = vol_args->name;
 	devstr = strchr(sizestr, ':');
 	if (devstr) {
@@ -1226,7 +1234,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
 		       (unsigned long long)devid);
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out_free;
 	}
 	if (!strcmp(sizestr, "max"))
 		new_size = device->bdev->bd_inode->i_size;
@@ -1241,7 +1249,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		new_size = memparse(sizestr, NULL);
 		if (new_size == 0) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out_free;
 		}
 	}
 
@@ -1250,7 +1258,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	if (mod < 0) {
 		if (new_size > old_size) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out_free;
 		}
 		new_size = old_size - new_size;
 	} else if (mod > 0) {
@@ -1259,11 +1267,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 
 	if (new_size < 256 * 1024 * 1024) {
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out_free;
 	}
 	if (new_size > device->bdev->bd_inode->i_size) {
 		ret = -EFBIG;
-		goto out_unlock;
+		goto out_free;
 	}
 
 	do_div(new_size, root->sectorsize);
@@ -1276,7 +1284,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
-			goto out_unlock;
+			goto out_free;
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
@@ -1284,9 +1292,10 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		ret = btrfs_shrink_device(device, new_size);
 	}
 
-out_unlock:
-	mutex_unlock(&root->fs_info->volume_mutex);
+out_free:
 	kfree(vol_args);
+out:
+	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
 }
 
@@ -2052,14 +2061,25 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->balance_ctl) {
+		printk(KERN_INFO "btrfs: balance in progress\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args))
-		return PTR_ERR(vol_args);
+	if (IS_ERR(vol_args)) {
+		ret = PTR_ERR(vol_args);
+		goto out;
+	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
 	kfree(vol_args);
+out:
+	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
 }
 
@@ -2074,14 +2094,25 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->balance_ctl) {
+		printk(KERN_INFO "btrfs: balance in progress\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args))
-		return PTR_ERR(vol_args);
+	if (IS_ERR(vol_args)) {
+		ret = PTR_ERR(vol_args);
+		goto out;
+	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
 	kfree(vol_args);
+out:
+	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
 }
 
@@ -3034,6 +3065,55 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ioctl_balance_args *bargs = NULL;
+	struct btrfs_balance_control *bctl;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	mutex_lock(&fs_info->volume_mutex);
+	mutex_lock(&fs_info->balance_mutex);
+
+	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
+	if (!bctl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bctl->fs_info = fs_info;
+	if (arg) {
+		bargs = memdup_user(arg, sizeof(*bargs));
+		if (IS_ERR(bargs)) {
+			kfree(bctl);
+			ret = PTR_ERR(bargs);
+			goto out;
+		}
+
+		memcpy(&bctl->data, &bargs->data, sizeof(bctl->data));
+		memcpy(&bctl->meta, &bargs->meta, sizeof(bctl->meta));
+		memcpy(&bctl->sys, &bargs->sys, sizeof(bctl->sys));
+
+		bctl->flags = bargs->flags;
+	}
+
+	ret = btrfs_balance(bctl, 0);
+	/*
+	 * bctl is freed in __cancel_balance
+	 */
+	kfree(bargs);
+out:
+	mutex_unlock(&fs_info->balance_mutex);
+	mutex_unlock(&fs_info->volume_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3078,7 +3158,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_DEV_INFO:
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
-		return btrfs_balance(root->fs_info->dev_root);
+		return btrfs_ioctl_balance(root, NULL);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
@@ -3110,6 +3190,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
+	case BTRFS_IOC_BALANCE_V2:
+		return btrfs_ioctl_balance(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 252ae99..0ca8059 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -109,6 +109,47 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+/*
+ * this is packed, because it should be exactly the same as its disk
+ * byte order counterpart (struct btrfs_disk_balance_args)
+ */
+struct btrfs_balance_args {
+	__u64 profiles;
+	__u64 usage;
+	__u64 devid;
+	__u64 pstart;
+	__u64 pend;
+	__u64 vstart;
+	__u64 vend;
+
+	__u64 target;
+
+	__u64 flags;
+
+	__u64 unused[8];
+} __attribute__ ((__packed__));
+
+/* report balance progress to userspace */
+struct btrfs_balance_progress {
+	__u64 expected;		/* estimated # of chunks that will be
+				 * relocated to fulfill the request */
+	__u64 considered;	/* # of chunks we have considered so far */
+	__u64 completed;	/* # of chunks relocated so far */
+};
+
+struct btrfs_ioctl_balance_args {
+	__u64 flags;				/* in/out */
+	__u64 state;				/* out */
+
+	struct btrfs_balance_args data;		/* in/out */
+	struct btrfs_balance_args meta;		/* in/out */
+	struct btrfs_balance_args sys;		/* in/out */
+
+	struct btrfs_balance_progress stat;	/* out */
+
+	__u64 unused[72];			/* pad to 1k */
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
@@ -272,6 +313,8 @@ struct btrfs_ioctl_logical_ino_args {
 				 struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 			       struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_BALANCE_V2 _IOW(BTRFS_IOCTL_MAGIC, 32, \
+				  struct btrfs_ioctl_balance_args)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d5fdee5..e8d6e78 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1282,7 +1282,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	bool clear_super = false;
 
 	mutex_lock(&uuid_mutex);
-	mutex_lock(&root->fs_info->volume_mutex);
 
 	all_avail = root->fs_info->avail_data_alloc_bits |
 		root->fs_info->avail_system_alloc_bits |
@@ -1452,7 +1451,6 @@ error_close:
 	if (bdev)
 		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
-	mutex_unlock(&root->fs_info->volume_mutex);
 	mutex_unlock(&uuid_mutex);
 	return ret;
 error_undo:
@@ -1629,7 +1627,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
-	mutex_lock(&root->fs_info->volume_mutex);
 
 	devices = &root->fs_info->fs_devices->devices;
 	/*
@@ -1757,8 +1754,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_relocate_sys_chunks(root);
 		BUG_ON(ret);
 	}
-out:
-	mutex_unlock(&root->fs_info->volume_mutex);
+
 	return ret;
 error:
 	blkdev_put(bdev, FMODE_EXCL);
@@ -1766,7 +1762,7 @@ error:
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
 	}
-	goto out;
+	return ret;
 }
 
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
@@ -2077,6 +2073,35 @@ error:
 	return ret;
 }
 
+/*
+ * Should be called with both balance and volume mutexes held to
+ * serialize other volume operations (add_dev/rm_dev/resize) with
+ * restriper.  Same goes for unset_balance_control.
+ */
+static void set_balance_control(struct btrfs_balance_control *bctl)
+{
+	struct btrfs_fs_info *fs_info = bctl->fs_info;
+
+	BUG_ON(fs_info->balance_ctl);
+
+	spin_lock(&fs_info->balance_lock);
+	fs_info->balance_ctl = bctl;
+	spin_unlock(&fs_info->balance_lock);
+}
+
+static void unset_balance_control(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+
+	BUG_ON(!fs_info->balance_ctl);
+
+	spin_lock(&fs_info->balance_lock);
+	fs_info->balance_ctl = NULL;
+	spin_unlock(&fs_info->balance_lock);
+
+	kfree(bctl);
+}
+
 static u64 div_factor(u64 num, int factor)
 {
 	if (factor == 10)
@@ -2086,29 +2111,23 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
-int btrfs_balance(struct btrfs_root *dev_root)
+static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 {
-	int ret;
-	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct list_head *devices;
 	struct btrfs_device *device;
 	u64 old_size;
 	u64 size_to_free;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
-	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
-
-	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	mutex_lock(&dev_root->fs_info->volume_mutex);
-	dev_root = dev_root->fs_info->dev_root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int enospc_errors = 0;
 
 	/* step one make some room on all the devices */
+	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
 		old_size = device->total_bytes;
 		size_to_free = div_factor(old_size, 1);
@@ -2151,12 +2170,12 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		 * failed
 		 */
 		if (ret == 0)
-			break;
+			BUG(); /* FIXME break ? */
 
 		ret = btrfs_previous_item(chunk_root, path, 0,
 					  BTRFS_CHUNK_ITEM_KEY);
 		if (ret)
-			break;
+			BUG(); /* FIXME break ? */
 
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
@@ -2174,12 +2193,58 @@ int btrfs_balance(struct btrfs_root *dev_root)
 					   found_key.offset);
 		if (ret && ret != -ENOSPC)
 			goto error;
+		if (ret == -ENOSPC)
+			enospc_errors++;
 		key.offset = found_key.offset - 1;
 	}
-	ret = 0;
+
 error:
 	btrfs_free_path(path);
-	mutex_unlock(&dev_root->fs_info->volume_mutex);
+	if (enospc_errors) {
+		printk(KERN_INFO "btrfs: %d enospc errors during balance\n",
+		       enospc_errors);
+		if (!ret)
+			ret = -ENOSPC;
+	}
+
+	return ret;
+}
+
+static void __cancel_balance(struct btrfs_fs_info *fs_info)
+{
+	unset_balance_control(fs_info);
+}
+
+/*
+ * Should be called with both balance and volume mutexes held
+ */
+int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
+{
+	struct btrfs_fs_info *fs_info = bctl->fs_info;
+	int ret;
+
+	if (btrfs_fs_closing(fs_info)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!resume)
+		set_balance_control(bctl);
+
+	mutex_unlock(&fs_info->balance_mutex);
+
+	ret = __btrfs_balance(fs_info);
+
+	mutex_lock(&fs_info->balance_mutex);
+
+	__cancel_balance(fs_info);
+
+	return ret;
+out:
+	if (resume)
+		__cancel_balance(fs_info);
+	else
+		kfree(bctl);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 78f2d4d..b9daddc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -186,6 +186,17 @@ struct map_lookup {
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+struct btrfs_balance_args;
+struct btrfs_balance_control {
+	struct btrfs_fs_info *fs_info;
+
+	struct btrfs_balance_args data;
+	struct btrfs_balance_args meta;
+	struct btrfs_balance_args sys;
+
+	u64 flags;
+};
+
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
@@ -228,7 +239,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
-int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_balance(struct btrfs_balance_control *rctl, int resume);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.6.3

