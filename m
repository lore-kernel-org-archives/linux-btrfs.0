From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 1/2] Balance progress monitoring.
Date: Tue, 9 Nov 2010 22:43:15 +0000
Message-ID: <0435dceee4613994f662ac4e3f423bf4274136a4.1289522188.git.hugo@carfax.org.uk>
References: <cover.1289522188.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1289522188.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a basic form of progress monitoring for balance
operations, by counting the number of block groups remaining. The
information is exposed to userspace by an ioctl.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ctree.h   |    9 +++++++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |   34 +++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    7 ++++++
 fs/btrfs/volumes.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..67fb603 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -841,6 +841,11 @@ struct btrfs_block_group_cache {
 	struct list_head cluster_list;
 };
 
+struct btrfs_balance_info {
+	u64 expected;
+	u64 completed;
+};
+
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
@@ -1050,6 +1055,10 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+
+	/* Keep track of any rebalance operations on this FS */
+	spinlock_t balance_info_lock;
+	struct btrfs_balance_info *balance_info;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b40dfe4..87d9315 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1590,6 +1590,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->ref_cache_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
+	spin_lock_init(&fs_info->balance_info_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
@@ -1615,6 +1616,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
+	fs_info->balance_info = NULL;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 463d91b..c247985 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2220,6 +2220,38 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+/*
+ * Return the current status of any balance operation
+ */
+long btrfs_ioctl_balance_progress(
+	struct btrfs_fs_info *fs_info,
+	struct btrfs_ioctl_balance_progress __user *user_dest)
+{
+	int ret = 0;
+	struct btrfs_ioctl_balance_progress dest;
+
+	spin_lock(&fs_info->balance_info_lock);
+	if (!fs_info->balance_info) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	dest.expected = fs_info->balance_info->expected;
+	dest.completed = fs_info->balance_info->completed;
+
+	spin_unlock(&fs_info->balance_info_lock);
+
+	if (copy_to_user(user_dest, &dest,
+			 sizeof(struct btrfs_ioctl_balance_progress)))
+		return -EFAULT;
+
+	return 0;
+
+error:
+	spin_unlock(&fs_info->balance_info_lock);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2255,6 +2287,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
+	case BTRFS_IOC_BALANCE_PROGRESS:
+		return btrfs_ioctl_balance_progress(root->fs_info, argp);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 17c99eb..b2103b2 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -145,6 +145,11 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_balance_progress {
+	__u64 expected;
+	__u64 completed;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -189,4 +194,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_async_vol_args)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
+				  struct btrfs_ioctl_balance_progress)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 91851b5..f00edc1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1904,6 +1904,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
+	struct btrfs_balance_info *bal_info;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -1911,6 +1912,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
 
+	bal_info = kmalloc(
+		sizeof(struct btrfs_balance_info),
+		GFP_NOFS);
+	if (!bal_info) {
+		ret = -ENOSPC;
+		goto error_no_status;
+	}
+	spin_lock(&dev_root->fs_info->balance_info_lock);
+	dev_root->fs_info->balance_info = bal_info;
+	bal_info->expected = -1; /* One less than actually counted,
+				    because chunk 0 is special */
+	bal_info->completed = 0;
+	spin_unlock(&dev_root->fs_info->balance_info_lock);
+
 	/* step one make some room on all the devices */
 	list_for_each_entry(device, devices, dev_list) {
 		old_size = device->total_bytes;
@@ -1934,10 +1949,42 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		btrfs_end_transaction(trans, dev_root);
 	}
 
-	/* step two, relocate all the chunks */
+	/* step two, count the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOSPC;
+		goto error;
+	}
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
+	if (ret <= 0) {
+		printk(KERN_ERR "btrfs: Failed to find the last chunk.\n");
+		BUG();
+	}
+
+	while (1) {
+		ret = btrfs_previous_item(chunk_root, path, 0,
+					  BTRFS_CHUNK_ITEM_KEY);
+		if (ret)
+			break;
+
+		spin_lock(&dev_root->fs_info->balance_info_lock);
+		bal_info->expected++;
+		spin_unlock(&dev_root->fs_info->balance_info_lock);
+	}
+
+	btrfs_free_path(path);
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOSPC;
+		goto error;
+	}
 
+	/* step three, relocate all the chunks */
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
@@ -1975,10 +2022,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
 					   found_key.offset);
 		BUG_ON(ret && ret != -ENOSPC);
 		key.offset = found_key.offset - 1;
+		spin_lock(&dev_root->fs_info->balance_info_lock);
+		bal_info->completed++;
+		spin_unlock(&dev_root->fs_info->balance_info_lock);
+		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
+		       bal_info->completed, bal_info->expected);
 	}
 	ret = 0;
 error:
 	btrfs_free_path(path);
+	spin_lock(&dev_root->fs_info->balance_info_lock);
+	kfree(dev_root->fs_info->balance_info);
+	dev_root->fs_info->balance_info = NULL;
+	spin_unlock(&dev_root->fs_info->balance_info_lock);
+error_no_status:
 	mutex_unlock(&dev_root->fs_info->volume_mutex);
 	return ret;
 }
-- 
1.7.1


