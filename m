From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v3 0/8] Balance management
Date: Thu,  7 Apr 2011 17:56:27 +0100
Message-ID: <1302195387-1674-1-git-send-email-hugo@carfax.org.uk>
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   Hi, Chris,

   This is a rebased version of my original balance management patches
to the latest kernel. I also include a series of patches which
introduce filtered or partial balances. With these patches, it is
possible to rebalance chunks on the basis of:

 * their chunk flags
 * residency on any device
 * physical block device address
 * logical btrfs-internal address

with a clean infrastructure for implementing further balance filters,
and a forward-compatible ioctl for starting filters.

   Hugo.

---

Hugo Mills (8):
  btrfs: Balance progress monitoring
  btrfs: Cancel filesystem balance
  btrfs: Factor out enumeration of chunks to a separate function
  btrfs: Implement filtered balance ioctl
  btrfs: Balance filter for device ID
  btrfs: Balance filter for virtual address ranges
  btrfs: Replication-type information
  btrfs: Balance filter for physical device address

 fs/btrfs/ctree.h   |   10 ++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |  102 +++++++++++++++-
 fs/btrfs/ioctl.h   |   49 +++++++
 fs/btrfs/super.c   |   16 +--
 fs/btrfs/volumes.c |  353 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   21 +++-
 7 files changed, 465 insertions(+), 88 deletions(-)

-- 
1.7.2.5

>From 60844e06b991d6b629a856a28d9c528a0aed4b89 Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:43 +0100
Subject: [PATCH v3 1/8] btrfs: Balance progress monitoring

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
index 7f78cc7..6c5526c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -865,6 +865,11 @@ struct btrfs_block_group_cache {
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
@@ -1078,6 +1083,10 @@ struct btrfs_fs_info {
 
 	/* filesystem state */
 	u64 fs_state;
+
+	/* Keep track of any rebalance operations on this FS */
+	spinlock_t balance_info_lock;
+	struct btrfs_balance_info *balance_info;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 100b07f..3d690de 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1645,6 +1645,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->ref_cache_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
+	spin_lock_init(&fs_info->balance_info_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
@@ -1670,6 +1671,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
+	fs_info->balance_info = NULL;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..a8fbb07 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2375,6 +2375,38 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
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
@@ -2414,6 +2446,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
+	case BTRFS_IOC_BALANCE_PROGRESS:
+		return btrfs_ioctl_balance_progress(root->fs_info, argp);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 8fb3821..4c82d40 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -157,6 +157,11 @@ struct btrfs_ioctl_space_args {
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
@@ -203,4 +208,6 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
+				  struct btrfs_ioctl_balance_progress)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd13eb8..2bd4565 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2041,6 +2041,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
+	struct btrfs_balance_info *bal_info;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -2051,6 +2052,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
@@ -2074,10 +2089,42 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
@@ -2115,10 +2162,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
1.7.2.5


>From 238424c5d12a89b9b737b0f74b4198b4c9213fe1 Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:43 +0100
Subject: [PATCH v3 2/8] btrfs: Cancel filesystem balance

This patch adds an ioctl for cancelling a btrfs balance operation
mid-flight. The ioctl simply sets a flag, and the operation terminates
after the current block group move has completed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/ioctl.c   |   28 ++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |    7 ++++++-
 4 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6c5526c..8b99807 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -868,6 +868,7 @@ struct btrfs_block_group_cache {
 struct btrfs_balance_info {
 	u64 expected;
 	u64 completed;
+	int cancel_pending;
 };
 
 struct reloc_control;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a8fbb07..aef6329 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2407,6 +2407,32 @@ error:
 	return ret;
 }
 
+/*
+ * Cancel a running balance operation
+ */
+long btrfs_ioctl_balance_cancel(struct btrfs_fs_info *fs_info)
+{
+	int err = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	spin_lock(&fs_info->balance_info_lock);
+	if (!fs_info->balance_info) {
+		err = -EINVAL;
+		goto error;
+	}
+	if (fs_info->balance_info->cancel_pending) {
+		err = -ECANCELED;
+		goto error;
+	}
+	fs_info->balance_info->cancel_pending = 1;
+
+error:
+	spin_unlock(&fs_info->balance_info_lock);
+	return err;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2448,6 +2474,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
+	case BTRFS_IOC_BALANCE_CANCEL:
+		return btrfs_ioctl_balance_cancel(root->fs_info);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 4c82d40..b08a699 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -210,4 +210,5 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 				  struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bd4565..5378b94 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2064,6 +2064,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	bal_info->expected = -1; /* One less than actually counted,
 				    because chunk 0 is special */
 	bal_info->completed = 0;
+	bal_info->cancel_pending = 0;
 	spin_unlock(&dev_root->fs_info->balance_info_lock);
 
 	/* step one make some room on all the devices */
@@ -2129,7 +2130,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
-	while (1) {
+	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
 			goto error;
@@ -2169,6 +2170,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		       bal_info->completed, bal_info->expected);
 	}
 	ret = 0;
+	if (bal_info->cancel_pending) {
+		printk(KERN_INFO "btrfs: balance cancelled\n");
+		ret = -EINTR;
+	}
 error:
 	btrfs_free_path(path);
 	spin_lock(&dev_root->fs_info->balance_info_lock);
-- 
1.7.2.5


>From 62cd35c4895eb2cc77299c620aedd184f72bde6e Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:43 +0100
Subject: [PATCH v3 3/8] btrfs: Factor out enumeration of chunks to a separate function

The main balance function has two loops which are functionally
identical in their looping mechanism, but which perform a different
operation on the chunks they loop over. To avoid repeating code more
than necessary, factor this loop out into a separate iterator function
which takes a function parameter for the action to be performed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/volumes.c |  179 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 99 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5378b94..ffba817 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2029,6 +2029,97 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
+/* Define a type, and two functions which can be used for the two
+ * phases of the balance operation: one for counting chunks, and one
+ * for actually moving them. */
+typedef void (*balance_iterator_function)(struct btrfs_root *,
+					  struct btrfs_balance_info *,
+					  struct btrfs_path *,
+					  struct btrfs_key *);
+
+void balance_count_chunks(struct btrfs_root *chunk_root,
+			  struct btrfs_balance_info *bal_info,
+			  struct btrfs_path *path,
+			  struct btrfs_key *key)
+{
+	spin_lock(&chunk_root->fs_info->balance_info_lock);
+	bal_info->expected++;
+	spin_unlock(&chunk_root->fs_info->balance_info_lock);
+}
+
+void balance_move_chunks(struct btrfs_root *chunk_root,
+			 struct btrfs_balance_info *bal_info,
+			 struct btrfs_path *path,
+			 struct btrfs_key *key)
+{
+	int ret;
+
+	ret = btrfs_relocate_chunk(chunk_root,
+				   chunk_root->root_key.objectid,
+				   key->objectid,
+				   key->offset);
+	BUG_ON(ret && ret != -ENOSPC);
+	spin_lock(&chunk_root->fs_info->balance_info_lock);
+	bal_info->completed++;
+	spin_unlock(&chunk_root->fs_info->balance_info_lock);
+	printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
+	       bal_info->completed, bal_info->expected);
+}
+
+/* Iterate through all chunks, performing some function on each one. */
+int balance_iterate_chunks(struct btrfs_root *chunk_root,
+			   struct btrfs_balance_info *bal_info,
+			   balance_iterator_function fn)
+{
+	int ret;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOSPC;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	while (!bal_info->cancel_pending) {
+		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
+		if (ret < 0)
+			break;
+		/*
+		 * this shouldn't happen, it means the last relocate
+		 * failed
+		 */
+		if (ret == 0)
+			break;
+
+		ret = btrfs_previous_item(chunk_root, path, 0,
+					  BTRFS_CHUNK_ITEM_KEY);
+		if (ret)
+			break;
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
+		/* Call the function to do the work for this chunk */
+		btrfs_release_path(chunk_root, path);
+		fn(chunk_root, bal_info, path, &found_key);
+
+		key.offset = found_key.offset - 1;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_balance(struct btrfs_root *dev_root)
 {
 	int ret;
@@ -2036,11 +2127,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_device *device;
 	u64 old_size;
 	u64 size_to_free;
-	struct btrfs_path *path;
-	struct btrfs_key key;
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_key found_key;
 	struct btrfs_balance_info *bal_info;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
@@ -2061,8 +2149,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	}
 	spin_lock(&dev_root->fs_info->balance_info_lock);
 	dev_root->fs_info->balance_info = bal_info;
-	bal_info->expected = -1; /* One less than actually counted,
-				    because chunk 0 is special */
+	bal_info->expected = 0;
 	bal_info->completed = 0;
 	bal_info->cancel_pending = 0;
 	spin_unlock(&dev_root->fs_info->balance_info_lock);
@@ -2091,91 +2178,23 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	}
 
 	/* step two, count the chunks */
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOSPC;
-		goto error;
-	}
-
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.offset = (u64)-1;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-
-	ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
-	if (ret <= 0) {
-		printk(KERN_ERR "btrfs: Failed to find the last chunk.\n");
-		BUG();
-	}
-
-	while (1) {
-		ret = btrfs_previous_item(chunk_root, path, 0,
-					  BTRFS_CHUNK_ITEM_KEY);
-		if (ret)
-			break;
-
-		spin_lock(&dev_root->fs_info->balance_info_lock);
-		bal_info->expected++;
-		spin_unlock(&dev_root->fs_info->balance_info_lock);
-	}
-
-	btrfs_free_path(path);
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOSPC;
+	ret = balance_iterate_chunks(chunk_root, bal_info,
+				     balance_count_chunks);
+	if (ret)
 		goto error;
-	}
 
 	/* step three, relocate all the chunks */
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.offset = (u64)-1;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-
-	while (!bal_info->cancel_pending) {
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
+	ret = balance_iterate_chunks(chunk_root, bal_info,
+				     balance_move_chunks);
+	if (ret)
+		goto error;
 
-		btrfs_release_path(chunk_root, path);
-		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
-					   found_key.objectid,
-					   found_key.offset);
-		BUG_ON(ret && ret != -ENOSPC);
-		key.offset = found_key.offset - 1;
-		spin_lock(&dev_root->fs_info->balance_info_lock);
-		bal_info->completed++;
-		spin_unlock(&dev_root->fs_info->balance_info_lock);
-		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
-		       bal_info->completed, bal_info->expected);
-	}
 	ret = 0;
 	if (bal_info->cancel_pending) {
 		printk(KERN_INFO "btrfs: balance cancelled\n");
 		ret = -EINTR;
 	}
 error:
-	btrfs_free_path(path);
 	spin_lock(&dev_root->fs_info->balance_info_lock);
 	kfree(dev_root->fs_info->balance_info);
 	dev_root->fs_info->balance_info = NULL;
-- 
1.7.2.5


>From 73082d85a705f47b87515de3e69d083206bfb0a0 Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:43 +0100
Subject: [PATCH v3 4/8] btrfs: Implement filtered balance ioctl

The filtered balance ioctl provides a facility to perform a balance
operation on a subset of the chunks in the filesystem. This patch
implements the base ioctl for this operation, and one filter type.
The filter in this patch selects chunks on the basis of their chunk
flags field, and can select any combination of bits set or unset.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.c   |   40 +++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h   |   27 +++++++++++++++++++++
 fs/btrfs/volumes.c |   65 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.h |    4 ++-
 4 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index aef6329..da3a2d3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2433,6 +2433,42 @@ error:
 	return err;
 }
 
+long btrfs_ioctl_balance(struct btrfs_root *dev_root,
+			 struct btrfs_ioctl_balance_start __user *user_filters)
+{
+	int ret = 0;
+	struct btrfs_ioctl_balance_start *dest;
+
+	dest = kmalloc(sizeof(struct btrfs_ioctl_balance_start), GFP_KERNEL);
+	if (!dest)
+		return -ENOMEM;
+
+	if (copy_from_user(dest, user_filters,
+			   sizeof(struct btrfs_ioctl_balance_start))) {
+		ret = -EFAULT;
+		goto error;
+	}
+
+	/* Basic sanity checking: has the user requested anything outside
+	 * the range we know about? */
+	if (dest->flags & ~BTRFS_BALANCE_FILTER_MASK) {
+		ret = -ENOTSUPP;
+		goto error;
+	}
+
+	/* Do the balance */
+	ret = btrfs_balance(dev_root, dest);
+
+	if (copy_to_user(user_filters, dest,
+			 sizeof(struct btrfs_ioctl_balance_start))) {
+		ret = -EFAULT;
+	}
+
+error:
+	kfree(dest);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2471,11 +2507,13 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
-		return btrfs_balance(root->fs_info->dev_root);
+		return btrfs_ioctl_balance(root->fs_info->dev_root, NULL);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
 	case BTRFS_IOC_BALANCE_CANCEL:
 		return btrfs_ioctl_balance_cancel(root->fs_info);
+	case BTRFS_IOC_BALANCE_FILTERED:
+		return btrfs_ioctl_balance(root->fs_info->dev_root, argp);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b08a699..2ce2180 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -162,6 +162,31 @@ struct btrfs_ioctl_balance_progress {
 	__u64 completed;
 };
 
+/* Types of balance filter */
+#define BTRFS_BALANCE_FILTER_COUNT_ONLY 0x1
+
+#define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
+#define BTRFS_BALANCE_FILTER_MASK 0x3 /* Logical or of all filter
+				       * flags -- effectively versions
+				       * the filtered balance ioctl */
+
+/* All the possible options for a filter */
+struct btrfs_ioctl_balance_start {
+	__u64 flags; /* Bit field indicating which fields of this struct
+			are filled */
+
+	/* Output values: chunk counts */
+	__u64 examined;
+	__u64 balanced;
+
+	/* For FILTER_CHUNK_TYPE */
+	__u64 chunk_type;      /* Flag bits required */
+	__u64 chunk_type_mask; /* Mask of bits to examine */
+
+	__u64 spare[506]; /* Make up the size of the structure to 4088
+			   * bytes for future expansion */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -211,4 +236,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 				  struct btrfs_ioctl_balance_progress)
 #define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_BALANCE_FILTERED _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+				struct btrfs_ioctl_balance_start)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ffba817..ea77c63 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2029,6 +2029,37 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
+int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
+						 struct btrfs_root *chunk_root,
+						 struct btrfs_path *path,
+						 struct btrfs_key *key)
+{
+	struct extent_buffer *eb;
+	struct btrfs_chunk *chunk;
+
+	/* No filter defined, everything matches */
+	if (!filter)
+		return 1;
+
+	/* No flags set, everything matches */
+	if (filter->flags == 0)
+		return 1;
+
+	eb = path->nodes[0];
+	chunk = btrfs_item_ptr(eb, path->slots[0],
+						   struct btrfs_chunk);
+
+	if (filter->flags & BTRFS_BALANCE_FILTER_CHUNK_TYPE) {
+		if ((btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask)
+			!= filter->chunk_type)
+		{
+			return 0;
+		}
+	}
+
+	return ret;
+}
+
 /* Define a type, and two functions which can be used for the two
  * phases of the balance operation: one for counting chunks, and one
  * for actually moving them. */
@@ -2069,6 +2100,7 @@ void balance_move_chunks(struct btrfs_root *chunk_root,
 /* Iterate through all chunks, performing some function on each one. */
 int balance_iterate_chunks(struct btrfs_root *chunk_root,
 			   struct btrfs_balance_info *bal_info,
+			   struct btrfs_ioctl_balance_start *filter,
 			   balance_iterator_function fn)
 {
 	int ret;
@@ -2084,6 +2116,9 @@ int balance_iterate_chunks(struct btrfs_root *chunk_root,
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
+	filter->examined = 0;
+	filter->balanced = 0;
+
 	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
@@ -2110,17 +2145,29 @@ int balance_iterate_chunks(struct btrfs_root *chunk_root,
 			break;
 
 		/* Call the function to do the work for this chunk */
-		btrfs_release_path(chunk_root, path);
-		fn(chunk_root, bal_info, path, &found_key);
+		filter->examined += 1;
+
+		if (balance_chunk_filter(filter, chunk_root,
+					 path, &found_key)) {
+			btrfs_release_path(chunk_root, path);
+			fn(chunk_root, bal_info, path, &found_key);
+			filter->balanced += 1;
+		} else {
+			btrfs_release_path(chunk_root, path);
+		}
 
 		key.offset = found_key.offset - 1;
 	}
 
+	printk(KERN_INFO "btrfs: balance: %llu chunks considered, %llu chunks balanced\n",
+		   filter->examined, filter->balanced);
+
 	btrfs_free_path(path);
 	return ret;
 }
 
-int btrfs_balance(struct btrfs_root *dev_root)
+int btrfs_balance(struct btrfs_root *dev_root,
+				  struct btrfs_ioctl_balance_start *filters)
 {
 	int ret;
 	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
@@ -2179,15 +2226,17 @@ int btrfs_balance(struct btrfs_root *dev_root)
 
 	/* step two, count the chunks */
 	ret = balance_iterate_chunks(chunk_root, bal_info,
-				     balance_count_chunks);
+				 filters, balance_count_chunks);
 	if (ret)
 		goto error;
 
 	/* step three, relocate all the chunks */
-	ret = balance_iterate_chunks(chunk_root, bal_info,
-				     balance_move_chunks);
-	if (ret)
-		goto error;
+	if (!(filters->flags & BTRFS_BALANCE_FILTER_COUNT_ONLY)) {
+		ret = balance_iterate_chunks(chunk_root, bal_info,
+					     filters, balance_move_chunks);
+		if (ret)
+			goto error;
+	}
 
 	ret = 0;
 	if (bal_info->cancel_pending) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7fb59d4..168771b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -22,6 +22,7 @@
 #include <linux/bio.h>
 #include <linux/sort.h>
 #include "async-thread.h"
+#include "ioctl.h"
 
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
@@ -205,7 +206,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
-int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_balance(struct btrfs_root *dev_root,
+		  struct btrfs_ioctl_balance_start *filters);
 void btrfs_unlock_volumes(void);
 void btrfs_lock_volumes(void);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-- 
1.7.2.5


>From 0fc9d9a3edaf69c79c2ae24cad16a19ef25d1e89 Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:43 +0100
Subject: [PATCH v3 5/8] btrfs: Balance filter for device ID

Balance filter to take only chunks which have (or had) a stripe on the
given device. Useful if a device has been forcibly removed from the
filesystem, and the data from that device needs rebuilding.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    8 ++++++--
 fs/btrfs/volumes.c |   16 +++++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 2ce2180..29627ca 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -166,7 +166,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_COUNT_ONLY 0x1
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
-#define BTRFS_BALANCE_FILTER_MASK 0x3 /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVID 0x4
+#define BTRFS_BALANCE_FILTER_MASK 0x7 /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -183,7 +184,10 @@ struct btrfs_ioctl_balance_start {
 	__u64 chunk_type;      /* Flag bits required */
 	__u64 chunk_type_mask; /* Mask of bits to examine */
 
-	__u64 spare[506]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVID */
+	__u64 devid;
+
+	__u64 spare[505]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ea77c63..4f215e7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2036,6 +2036,7 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 {
 	struct extent_buffer *eb;
 	struct btrfs_chunk *chunk;
+	int i;
 
 	/* No filter defined, everything matches */
 	if (!filter)
@@ -2056,8 +2057,21 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 			return 0;
 		}
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_DEVID) {
+		int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+		int res = 0;
+		for (i = 0; i < num_stripes; i++) {
+			struct btrfs_stripe *stripe = btrfs_stripe_nr(chunk, i);
+			if (btrfs_stripe_devid(eb, stripe) == filter->devid) {
+				res = 1;
+				break;
+			}
+		}
+		if (!res)
+			return 0;
+	}
 
-	return ret;
+	return 1;
 }
 
 /* Define a type, and two functions which can be used for the two
-- 
1.7.2.5


>From 20e8d529090a9cf35d1f45320c3007bfcc5bd3ea Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:44 +0100
Subject: [PATCH v3 6/8] btrfs: Balance filter for virtual address ranges

Allow the balancing of chunks where some part of the chunk lies within
the virtual (i.e. btrfs-internal) address range passed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    9 +++++++--
 fs/btrfs/volumes.c |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 29627ca..5177229 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -167,7 +167,8 @@ struct btrfs_ioctl_balance_progress {
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
-#define BTRFS_BALANCE_FILTER_MASK 0x7 /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
+#define BTRFS_BALANCE_FILTER_MASK 0xf /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -187,7 +188,11 @@ struct btrfs_ioctl_balance_start {
 	/* For FILTER_DEVID */
 	__u64 devid;
 
-	__u64 spare[505]; /* Make up the size of the structure to 4088
+	/* For FILTER_VIRTUAL_ADDRESS_RANGE */
+	__u64 vrange_start;
+	__u64 vrange_end;
+
+	__u64 spare[503]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4f215e7..4c1b5a6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2070,6 +2070,12 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 		if (!res)
 			return 0;
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE) {
+		u64 start = key->offset;
+		u64 end = start + btrfs_chunk_length(eb, chunk);
+		if (filter->vrange_start >= end || start >= filter->vrange_end)
+			return 0;
+	}
 
 	return 1;
 }
-- 
1.7.2.5


>From 07c3f09d9e06f7d6356e617b6a26536e0a8e6f01 Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:44 +0100
Subject: [PATCH v3 7/8] btrfs: Replication-type information

There are a few places in btrfs where knowledge of the various
parameters of a replication type is needed. Factor this out into a
single function which can supply all the relevant information.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/super.c   |   16 +++-----
 fs/btrfs/volumes.c |   96 ++++++++++++++++++++++++++++++++++-----------------
 fs/btrfs/volumes.h |   17 +++++++++
 3 files changed, 87 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d39a989..4341730 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -879,12 +879,12 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
+	struct btrfs_replication_info repl_info;
 	u64 skip_space;
 	u64 type;
 	u64 avail_space;
 	u64 used_space;
 	u64 min_stripe_size;
-	int min_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
 
@@ -898,12 +898,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	/* calc min stripe number for data space alloction */
 	type = btrfs_get_alloc_profile(root, 1);
-	if (type & BTRFS_BLOCK_GROUP_RAID0)
-		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID1)
-		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID10)
-		min_stripes = 4;
+	btrfs_get_replication_info(&repl_info, type);
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
 		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
@@ -971,14 +966,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	i = nr_devices - 1;
 	avail_space = 0;
-	while (nr_devices >= min_stripes) {
+	while (nr_devices >= repl_info.devs_min) {
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * min_stripes;
+			avail_space += devices_info[i].max_avail
+			  * repl_info.devs_min;
 			alloc_size = devices_info[i].max_avail;
-			for (j = i + 1 - min_stripes; j <= i; j++)
+			for (j = i + 1 - repl_info.devs_min; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
 		}
 		i--;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4c1b5a6..83f13b6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -141,6 +141,51 @@ static void requeue_list(struct btrfs_pending_bios *pending_bios,
 		pending_bios->tail = tail;
 }
 
+void btrfs_get_replication_info(struct btrfs_replication_info *info,
+								u64 type)
+{
+	info->sub_stripes = 1;
+	info->dev_stripes = 1;
+	info->devs_increment = 1;
+	info->num_copies = 1;
+	info->devs_max = 0;	/* 0 == as many as possible */
+	info->devs_min = 1;
+
+	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
+		info->dev_stripes = 2;
+		info->num_copies = 2;
+		info->devs_max = 1;
+	} else if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
+		info->devs_min = 2;
+	} else if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
+		info->devs_increment = 2;
+		info->num_copies = 2;
+		info->devs_max = 2;
+		info->devs_min = 2;
+	} else if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
+		info->sub_stripes = 2;
+		info->devs_increment = 2;
+		info->num_copies = 2;
+		info->devs_min = 4;
+	}
+
+	if (type & BTRFS_BLOCK_GROUP_DATA) {
+		info->max_stripe_size = 1024 * 1024 * 1024;
+		info->min_stripe_size = 64 * 1024 * 1024;
+		info->max_chunk_size = 10 * info->max_stripe_size;
+	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
+		info->max_stripe_size = 256 * 1024 * 1024;
+		info->min_stripe_size = 32 * 1024 * 1024;
+		info->max_chunk_size = info->max_stripe_size;
+	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		info->max_stripe_size = 8 * 1024 * 1024;
+		info->min_stripe_size = 1 * 1024 * 1024;
+		info->max_chunk_size = 2 * info->max_stripe_size;
+	} else {
+		BUG_ON(1);
+	}
+}
+
 /*
  * we try to collect pending bios for a device so we don't get a large
  * number of procs sending bios down to the same device.  This greatly
@@ -1248,6 +1293,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
+	struct btrfs_replication_info repl_info;
 	u64 all_avail;
 	u64 devid;
 	u64 num_devices;
@@ -1261,18 +1307,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->avail_system_alloc_bits |
 		root->fs_info->avail_metadata_alloc_bits;
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->num_devices <= 4) {
-		printk(KERN_ERR "btrfs: unable to go below four devices "
-		       "on raid10\n");
-		ret = -EINVAL;
-		goto out;
-	}
+	btrfs_get_replication_info(&repl_info, all_avail);
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->num_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid1\n");
+	if (root->fs_info->fs_devices->num_devices <= repl_info.devs_min) {
+		if (all_avail & BTRFS_BLOCK_GROUP_RAID10) {
+			printk(KERN_ERR "btrfs: unable to go below four devices "
+				   "on raid10\n");
+		} else if (all_avail & BTRFS_BLOCK_GROUP_RAID1) {
+			printk(KERN_ERR "btrfs: unable to go below two "
+				   "devices on raid1\n");
+		}
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2037,6 +2081,7 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	struct extent_buffer *eb;
 	struct btrfs_chunk *chunk;
 	int i;
+	struct btrfs_replication_info replinfo;
 
 	/* No filter defined, everything matches */
 	if (!filter)
@@ -2050,6 +2095,8 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	chunk = btrfs_item_ptr(eb, path->slots[0],
 						   struct btrfs_chunk);
 
+	btrfs_get_replication_info(&replinfo, btrfs_chunk_type(eb, chunk));
+
 	if (filter->flags & BTRFS_BALANCE_FILTER_CHUNK_TYPE) {
 		if ((btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask)
 			!= filter->chunk_type)
@@ -2492,34 +2539,19 @@ static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
 				    u64 proposed_size, u64 type,
 				    int num_stripes, int small_stripe)
 {
-	int min_stripe_size = 1 * 1024 * 1024;
+	struct btrfs_replication_info repl_info;
 	u64 calc_size = proposed_size;
 	u64 max_chunk_size = calc_size;
-	int ncopies = 1;
 
-	if (type & (BTRFS_BLOCK_GROUP_RAID1 |
-		    BTRFS_BLOCK_GROUP_DUP |
-		    BTRFS_BLOCK_GROUP_RAID10))
-		ncopies = 2;
-
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
-		max_chunk_size = 10 * calc_size;
-		min_stripe_size = 64 * 1024 * 1024;
-	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		max_chunk_size = 256 * 1024 * 1024;
-		min_stripe_size = 32 * 1024 * 1024;
-	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		calc_size = 8 * 1024 * 1024;
-		max_chunk_size = calc_size * 2;
-		min_stripe_size = 1 * 1024 * 1024;
-	}
+	btrfs_get_replication_info(&repl_info, type);
+	max_chunk_size = repl_info.max_chunk_size;
 
 	/* we don't want a chunk larger than 10% of writeable space */
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-	if (calc_size * num_stripes > max_chunk_size * ncopies) {
-		calc_size = max_chunk_size * ncopies;
+	if (calc_size * num_stripes > max_chunk_size * repl_info.num_copies) {
+		calc_size = max_chunk_size * repl_info.num_copies;
 		do_div(calc_size, num_stripes);
 		do_div(calc_size, BTRFS_STRIPE_LEN);
 		calc_size *= BTRFS_STRIPE_LEN;
@@ -2527,7 +2559,7 @@ static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
 
 	/* we don't want tiny stripes */
 	if (!small_stripe)
-		calc_size = max_t(u64, min_stripe_size, calc_size);
+		calc_size = max_t(u64, repl_info.min_stripe_size, calc_size);
 
 	/*
 	 * we're about to do_div by the BTRFS_STRIPE_LEN so lets make sure
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 168771b..331553e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -146,6 +146,22 @@ struct btrfs_device_info {
 	u64 max_avail;
 };
 
+/*
+ * Information about a the parameters of a replication strategy (RAID
+ * level)
+ */
+struct btrfs_replication_info {
+	u64 sub_stripes;
+	u64 dev_stripes;
+	u64 devs_increment;
+	u64 num_copies;
+	u64 devs_max;
+	u64 devs_min;
+	u64 max_stripe_size;
+	u64 min_stripe_size;
+	u64 max_chunk_size;
+};
+
 /* Used to sort the devices by max_avail(descending sort) */
 int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
 
@@ -214,4 +230,5 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+void btrfs_get_replication_info(struct btrfs_replication_info *info, u64 type);
 #endif
-- 
1.7.2.5


>From 792960d8b868fc1a27250e8993e212c5bdaa488b Mon Sep 17 00:00:00 2001
From: Hugo Mills <hugo@carfax.org.uk>
Date: Thu, 7 Apr 2011 17:38:44 +0100
Subject: [PATCH v3 8/8] btrfs: Balance filter for physical device address

Add a filter for balancing which allows the selection of chunks with
data in the given byte range on any block device in the filesystem. On
its own, this filter is of little use, but when used with the devid
filter, it can be used to rebalance all chunks which lie on a part of
a specific device.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    9 +++++++--
 fs/btrfs/volumes.c |   19 +++++++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 5177229..b13f14d 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -168,7 +168,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
 #define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
-#define BTRFS_BALANCE_FILTER_MASK 0xf /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE 0x10
+#define BTRFS_BALANCE_FILTER_MASK 0x1f /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -192,7 +193,11 @@ struct btrfs_ioctl_balance_start {
 	__u64 vrange_start;
 	__u64 vrange_end;
 
-	__u64 spare[503]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVICE_ADDRESS_RANGE */
+	__u64 drange_start;
+	__u64 drange_end;
+
+	__u64 spare[501]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 83f13b6..f97f19f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2123,6 +2123,25 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 		if (filter->vrange_start >= end || start >= filter->vrange_end)
 			return 0;
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE) {
+		int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+		int stripe_length = btrfs_chunk_length(eb, chunk)
+			* num_stripes / replinfo.num_copies;
+		int res = 0;
+
+		for (i = 0; i < num_stripes; i++) {
+			struct btrfs_stripe *stripe = btrfs_stripe_nr(chunk, i);
+			u64 start = btrfs_stripe_offset(eb, stripe);
+			u64 end = start + stripe_length;
+			if (filter->drange_start < end
+			    && start < filter->drange_end) {
+				res = 1;
+				break;
+			}
+		}
+		if (!res)
+			return 0;
+	}
 
 	return 1;
 }
-- 
1.7.2.5

