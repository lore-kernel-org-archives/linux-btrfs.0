From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 05/21] Btrfs: add basic restriper infrastructure
Date: Tue, 23 Aug 2011 23:01:46 +0300
Message-ID: <1314129722-31601-6-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add basic restriper infrastructure: ioctl to start restripe, all
restripe ioctl data structures, add data structure for tracking
restriper's state to fs_info.  Duplicate balancing code for restriper,
btrfs_balance() will be removed when restriper is implemented.

Explicitly disallow any volume operations when restriper is running.
(previously this restriction relied on volume_mutex being held during
the execution of any volume operation)

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    5 +
 fs/btrfs/disk-io.c |    4 +
 fs/btrfs/ioctl.c   |  107 ++++++++++++++++++++++----
 fs/btrfs/ioctl.h   |   37 +++++++++
 fs/btrfs/volumes.c |  219 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h |   18 ++++
 6 files changed, 369 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b00eb8..65d7562 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -895,6 +895,7 @@ struct btrfs_block_group_cache {
 };
 
 struct reloc_control;
+struct restripe_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_delayed_root;
@@ -1116,6 +1117,10 @@ struct btrfs_fs_info {
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
 
+	spinlock_t restripe_lock;
+	struct mutex restripe_mutex;
+	struct restripe_control *restripe_ctl;
+
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 46d0412..fa2301b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1700,6 +1700,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->scrub_super_lock);
 	fs_info->scrub_workers_refcnt = 0;
 
+	spin_lock_init(&fs_info->restripe_lock);
+	mutex_init(&fs_info->restripe_mutex);
+	fs_info->restripe_ctl = NULL;
+
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..9dfc686 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1165,13 +1165,21 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->restripe_ctl) {
+		printk(KERN_INFO "btrfs: restripe in progress\n");
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
@@ -1188,7 +1196,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		printk(KERN_INFO "resizer unable to find device %llu\n",
 		       (unsigned long long)devid);
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out_free;
 	}
 	if (!strcmp(sizestr, "max"))
 		new_size = device->bdev->bd_inode->i_size;
@@ -1203,7 +1211,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		new_size = memparse(sizestr, NULL);
 		if (new_size == 0) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out_free;
 		}
 	}
 
@@ -1212,7 +1220,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	if (mod < 0) {
 		if (new_size > old_size) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out_free;
 		}
 		new_size = old_size - new_size;
 	} else if (mod > 0) {
@@ -1221,11 +1229,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 
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
@@ -1238,7 +1246,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
-			goto out_unlock;
+			goto out_free;
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
@@ -1246,9 +1254,10 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
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
 
@@ -2014,14 +2023,25 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->restripe_ctl) {
+		printk(KERN_INFO "btrfs: restripe in progress\n");
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
 
@@ -2036,14 +2056,25 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (root->fs_info->restripe_ctl) {
+		printk(KERN_INFO "btrfs: restripe in progress\n");
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
 
@@ -2833,6 +2864,50 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
+static long btrfs_ioctl_restripe(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_restripe_args *rargs;
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
+
+	rargs = memdup_user(arg, sizeof(*rargs));
+	if (IS_ERR(rargs)) {
+		ret = PTR_ERR(rargs);
+		goto out;
+	}
+
+	rctl = kzalloc(sizeof(*rctl), GFP_NOFS);
+	if (!rctl) {
+		kfree(rargs);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rctl->fs_info = fs_info;
+	rctl->flags = rargs->flags;
+
+	memcpy(&rctl->data, &rargs->data, sizeof(rctl->data));
+	memcpy(&rctl->meta, &rargs->meta, sizeof(rctl->meta));
+	memcpy(&rctl->sys, &rargs->sys, sizeof(rctl->sys));
+
+	ret = btrfs_restripe(rctl);
+
+	/* rctl freed in unset_restripe_control */
+	kfree(rargs);
+out:
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2905,6 +2980,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
+	case BTRFS_IOC_RESTRIPE:
+		return btrfs_ioctl_restripe(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..798f1d4 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -109,6 +109,41 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+struct btrfs_restripe_args {
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
+struct btrfs_restripe_progress {
+	__u64 expected;
+	__u64 considered;
+	__u64 completed;
+};
+
+struct btrfs_ioctl_restripe_args {
+	__u64 flags;
+	__u64 state;
+
+	struct btrfs_restripe_args data;
+	struct btrfs_restripe_args sys;
+	struct btrfs_restripe_args meta;
+
+	struct btrfs_restripe_progress stat;
+
+	__u64 unused[72]; /* pad to 1k */
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
@@ -248,4 +283,6 @@ struct btrfs_ioctl_space_args {
 				 struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 			       struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_RESTRIPE _IOW(BTRFS_IOCTL_MAGIC, 32, \
+				struct btrfs_ioctl_restripe_args)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index af4bf56..0e4a276 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1262,7 +1262,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	bool clear_super = false;
 
 	mutex_lock(&uuid_mutex);
-	mutex_lock(&root->fs_info->volume_mutex);
 
 	all_avail = root->fs_info->avail_data_alloc_bits |
 		root->fs_info->avail_system_alloc_bits |
@@ -1427,7 +1426,6 @@ error_close:
 	if (bdev)
 		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
-	mutex_unlock(&root->fs_info->volume_mutex);
 	mutex_unlock(&uuid_mutex);
 	return ret;
 error_undo:
@@ -1604,7 +1602,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
-	mutex_lock(&root->fs_info->volume_mutex);
 
 	devices = &root->fs_info->fs_devices->devices;
 	/*
@@ -1728,8 +1725,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_relocate_sys_chunks(root);
 		BUG_ON(ret);
 	}
-out:
-	mutex_unlock(&root->fs_info->volume_mutex);
+
 	return ret;
 error:
 	blkdev_put(bdev, FMODE_EXCL);
@@ -1737,7 +1733,7 @@ error:
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
 	}
-	goto out;
+	return ret;
 }
 
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
@@ -2155,6 +2151,217 @@ error:
 }
 
 /*
+ * Should be called with both restripe and volume mutexes held to
+ * serialize other volume operations (add_dev/rm_dev/resize) wrt
+ * restriper.  Same goes for unset_restripe_control().
+ */
+static void set_restripe_control(struct restripe_control *rctl)
+{
+	struct btrfs_fs_info *fs_info = rctl->fs_info;
+
+	spin_lock(&fs_info->restripe_lock);
+	fs_info->restripe_ctl = rctl;
+	spin_unlock(&fs_info->restripe_lock);
+}
+
+static void unset_restripe_control(struct btrfs_fs_info *fs_info)
+{
+	struct restripe_control *rctl = fs_info->restripe_ctl;
+
+	spin_lock(&fs_info->restripe_lock);
+	fs_info->restripe_ctl = NULL;
+	spin_unlock(&fs_info->restripe_lock);
+
+	kfree(rctl);
+}
+
+static int __btrfs_restripe(struct btrfs_root *dev_root)
+{
+	struct list_head *devices;
+	struct btrfs_device *device;
+	u64 old_size;
+	u64 size_to_free;
+	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int enospc_errors = 0;
+
+	/* step one make some room on all the devices */
+	devices = &dev_root->fs_info->fs_devices->devices;
+	list_for_each_entry(device, devices, dev_list) {
+		old_size = device->total_bytes;
+		size_to_free = div_factor(old_size, 1);
+		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);
+		if (!device->writeable ||
+		    device->total_bytes - device->bytes_used > size_to_free)
+			continue;
+
+		ret = btrfs_shrink_device(device, old_size - size_to_free);
+		if (ret == -ENOSPC)
+			break;
+		BUG_ON(ret);
+
+		trans = btrfs_start_transaction(dev_root, 0);
+		BUG_ON(IS_ERR(trans));
+
+		ret = btrfs_grow_device(trans, device, old_size);
+		BUG_ON(ret);
+
+		btrfs_end_transaction(trans, dev_root);
+	}
+
+	/* step two, relocate all the chunks */
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	while (1) {
+		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
+		if (ret < 0)
+			goto error;
+
+		/*
+		 * this shouldn't happen, it means the last relocate
+		 * failed
+		 */
+		if (ret == 0)
+			BUG_ON(1); /* DIS - break ? */
+
+		ret = btrfs_previous_item(chunk_root, path, 0,
+					  BTRFS_CHUNK_ITEM_KEY);
+		if (ret)
+			BUG_ON(1); /* DIS - break ? */
+
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		if (found_key.objectid != key.objectid)
+			break;
+
+		/* chunk zero is special */
+		if (found_key.offset == 0)
+			break;
+
+		btrfs_release_path(path);
+		ret = btrfs_relocate_chunk(chunk_root,
+					   chunk_root->root_key.objectid,
+					   found_key.objectid,
+					   found_key.offset);
+		if (ret && ret != -ENOSPC)
+			goto error;
+		if (ret == -ENOSPC)
+			enospc_errors++;
+		key.offset = found_key.offset - 1;
+	}
+
+error:
+	btrfs_free_path(path);
+	if (enospc_errors) {
+		printk(KERN_INFO "btrfs: restripe finished with %d enospc "
+		       "error(s)\n", enospc_errors);
+		ret = -ENOSPC;
+	}
+
+	return ret;
+}
+
+/*
+ * Should be called with restripe_mutex held
+ */
+int btrfs_restripe(struct restripe_control *rctl)
+{
+	struct btrfs_fs_info *fs_info = rctl->fs_info;
+	u64 allowed;
+	int ret;
+
+	mutex_lock(&fs_info->volume_mutex);
+
+	/*
+	 * Profile changing sanity checks
+	 */
+	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	if (fs_info->fs_devices->num_devices == 1)
+		allowed |= BTRFS_BLOCK_GROUP_DUP;
+	else if (fs_info->fs_devices->num_devices < 4)
+		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
+	else
+		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID10);
+
+	if (rctl->data.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start restripe with target "
+		       "data profile %llu\n",
+		       (unsigned long long)rctl->data.target);
+		ret = -EINVAL;
+		goto out;
+	}
+	if (rctl->sys.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start restripe with target "
+		       "system profile %llu\n",
+		       (unsigned long long)rctl->sys.target);
+		ret = -EINVAL;
+		goto out;
+	}
+	if (rctl->meta.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start restripe with target "
+		       "metadata profile %llu\n",
+		       (unsigned long long)rctl->meta.target);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (rctl->data.target & BTRFS_BLOCK_GROUP_DUP) {
+		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* allow to reduce meta or sys integrity only if force set */
+	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+			BTRFS_BLOCK_GROUP_RAID10;
+	if (((rctl->sys.flags & BTRFS_RESTRIPE_ARGS_CONVERT) &&
+	     (fs_info->avail_system_alloc_bits & allowed) &&
+	     !(rctl->sys.target & allowed)) ||
+	    ((rctl->meta.flags & BTRFS_RESTRIPE_ARGS_CONVERT) &&
+	     (fs_info->avail_metadata_alloc_bits & allowed) &&
+	     !(rctl->meta.target & allowed))) {
+		if (rctl->flags & BTRFS_RESTRIPE_FORCE) {
+			printk(KERN_INFO "btrfs: force reducing metadata "
+			       "integrity\n");
+		} else {
+			printk(KERN_ERR "btrfs: can't reduce metadata "
+			       "integrity\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	set_restripe_control(rctl);
+	mutex_unlock(&fs_info->volume_mutex);
+
+	ret = __btrfs_restripe(fs_info->dev_root);
+
+	mutex_lock(&fs_info->volume_mutex);
+	unset_restripe_control(fs_info);
+	mutex_unlock(&fs_info->volume_mutex);
+
+	return ret;
+
+out:
+	mutex_unlock(&fs_info->volume_mutex);
+	kfree(rctl);
+	return ret;
+}
+
+/*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
  * The chunk relocation code actually frees the device extent
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6d866db..8804c5c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -168,6 +168,23 @@ struct map_lookup {
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+#define BTRFS_RESTRIPE_FORCE		(1ULL << 3)
+
+/*
+ * Profile changing flags
+ */
+#define BTRFS_RESTRIPE_ARGS_CONVERT	(1ULL << 8)
+
+struct btrfs_restripe_args;
+struct restripe_control {
+	struct btrfs_fs_info *fs_info;
+	u64 flags;
+
+	struct btrfs_restripe_args data;
+	struct btrfs_restripe_args sys;
+	struct btrfs_restripe_args meta;
+};
+
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
@@ -211,6 +228,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_restripe(struct restripe_control *rctl);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.5.4

