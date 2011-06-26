From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v8 1/8] btrfs: Balance progress monitoring
Date: Sun, 26 Jun 2011 21:36:48 +0100
Message-ID: <1309120615-18104-2-git-send-email-hugo@carfax.org.uk>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a basic form of progress monitoring for balance
operations, by counting the number of block groups remaining. The
information is exposed to userspace by an ioctl.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ctree.h   |    9 ++++++++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |   34 +++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    7 ++++++
 fs/btrfs/volumes.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3006287..25aa3cf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -873,6 +873,11 @@ struct btrfs_block_group_cache {
 	struct list_head cluster_list;
 };
 
+struct btrfs_balance_info {
+	u32 expected;
+	u32 completed;
+};
+
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
@@ -1115,6 +1120,10 @@ struct btrfs_fs_info {
 	u64 fs_state;
 
 	struct btrfs_delayed_root *delayed_root;
+
+	/* Keep track of any rebalance operations on this FS */
+	spinlock_t balance_info_lock;
+	struct btrfs_balance_info *balance_info;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5d..38f8fbc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1619,6 +1619,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
+	spin_lock_init(&fs_info->balance_info_lock);
 	mutex_init(&fs_info->reloc_mutex);
 
 	init_completion(&fs_info->kobj_unregister);
@@ -1648,6 +1649,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->trans_no_join = 0;
+	fs_info->balance_info = NULL;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..5ddf816 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2836,6 +2836,38 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
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
@@ -2881,6 +2913,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
+	case BTRFS_IOC_BALANCE_PROGRESS:
+		return btrfs_ioctl_balance_progress(root->fs_info, argp);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..575b25f 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -193,6 +193,11 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_balance_progress {
+	__u32 expected;
+	__u32 completed;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -248,4 +253,6 @@ struct btrfs_ioctl_space_args {
 				 struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 			       struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 32, \
+				  struct btrfs_ioctl_balance_progress)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1efa56e..4c0a386 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2026,6 +2026,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
+	struct btrfs_balance_info *bal_info;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -2036,6 +2037,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
 
+	bal_info = kmalloc(
+		sizeof(struct btrfs_balance_info),
+		GFP_NOFS);
+	if (!bal_info) {
+		ret = -ENOMEM;
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
@@ -2059,10 +2074,37 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		btrfs_end_transaction(trans, dev_root);
 	}
 
-	/* step two, relocate all the chunks */
+	/* step two, count the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
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
+	btrfs_release_path(path);
 
+	/* step three, relocate all the chunks */
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
@@ -2100,10 +2142,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
 					   found_key.offset);
 		BUG_ON(ret && ret != -ENOSPC);
 		key.offset = found_key.offset - 1;
+		spin_lock(&dev_root->fs_info->balance_info_lock);
+		bal_info->completed++;
+		spin_unlock(&dev_root->fs_info->balance_info_lock);
+		printk(KERN_INFO "btrfs: balance: %u/%u block groups completed\n",
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
1.7.2.5

