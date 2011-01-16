From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH RFC] Add ioctl for balancing a subset of the full filesystem.
Date: Sun, 16 Jan 2011 13:06:33 +0000
Message-ID: <E1PfLAh-00035I-Oz@ruthven.carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   This is a patch purely for comment. There's several things wrong
with it that I need to fix (at minimum, it has too much debugging
output, the __balance_chunk_filters function takes the wrong set of
parameters to make it properly extensible, and the progress counter is
broken).

   I'm planning on adding at least two more filters, once this basic
infrastructure is reasonably stable: one to filter on a range of
(virtual) addresses, and one to work on device IDs (i.e. "was any part
of this block group stored on device $n?").

   With the additional filters written, you'll be able to specify any
conjunctive set of filters. i.e. "This block group is RAID1, *and* was
stored on devid 4". Disjunctions ("or") aren't supported, and probably
won't be with this API. The filter data for additional filters will go
at the end of struct btrfs_ioctl_balance_start, ensuring extensibility
and backwards-compatibility (or at least, proper error reporting of
unsupported features).

   Questions for the panel:
   
 * Is the ioctl API reasonably sane, extensible, future-proof?
 * What other block group filters could be useful for this API?

   Hugo.

There are situations, such as restarting an interrupted balance, where
is not necessary or desired to balance all of the block groups in the
filesystem. This patch adds the basic infrastructure for filtering
block groups during a balance. It also adds a single filter method,
allowing the caller to select block groups with specific usage and
replication strategies.
---
 fs/btrfs/ioctl.c   |   44 +++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h   |   15 ++++++++++
 fs/btrfs/volumes.c |   76 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.h |    3 +-
 4 files changed, 124 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6d50d24..a2dd60c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2243,6 +2243,46 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+/* Balance the filesystem unconditionally */
+long btrfs_ioctl_balance(struct btrfs_fs_info *fs_info)
+{
+	return btrfs_balance(fs_info->dev_root, NULL);
+}
+
+/* Balance particular chunks in the filesystem */
+long btrfs_ioctl_balance_filtered(
+	struct btrfs_fs_info *fs_info,
+	struct btrfs_ioctl_balance_start __user *user_filters)
+{
+	int ret = 0;
+	struct btrfs_ioctl_balance_start *dest;
+
+	dest = kmalloc(sizeof(struct btrfs_ioctl_balance_start), GFP_KERNEL);
+	if (!dest)
+		return -ENOMEM;
+
+	if (copy_from_user(dest, user_filters, sizeof(struct btrfs_ioctl_balance_start))) {
+		ret = -EFAULT;
+		goto error;
+	}
+
+	printk("Starting balance with filter: %llx %llx %llx\n",
+	       dest->flags, dest->chunk_type, dest->chunk_type_mask);
+
+	/* Basic sanity checking */
+	if (dest->flags & ~BTRFS_BALANCE_FILTER_MASK) {
+		ret = -ENOTSUPP;
+		goto error;
+	}
+
+	/* Do the balance */
+	ret = btrfs_balance(fs_info->dev_root, dest);
+
+error:
+	kfree(dest);
+	return ret;
+}
+
 /*
  * Return the current status of any balance operation
  */
@@ -2335,11 +2375,13 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
-		return btrfs_balance(root->fs_info->dev_root);
+		return btrfs_ioctl_balance(root->fs_info);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root->fs_info, argp);
 	case BTRFS_IOC_BALANCE_CANCEL:
 		return btrfs_ioctl_balance_cancel(root->fs_info);
+	case BTRFS_IOC_BALANCE_FILTERED:
+		return btrfs_ioctl_balance_filtered(root->fs_info, argp);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 4f73d11..7c0c69c 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -154,6 +154,19 @@ struct btrfs_ioctl_balance_progress {
 	__u64 completed;
 };
 
+/* Types of balance filter */
+#define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x1
+#define BTRFS_BALANCE_FILTER_MASK 0x1
+
+/* All the possible options for a filter */
+struct btrfs_ioctl_balance_start {
+	__u64 flags; /* Bit field indicating which fields of this struct are filled */
+
+	/* For FILTER_CHUNK_TYPE */
+	__u64 chunk_type;      /* Flag bits required */
+	__u64 chunk_type_mask; /* Mask of bits to examine */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -201,4 +214,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
 				struct btrfs_ioctl_balance_progress)
 #define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 26)
+#define BTRFS_IOC_BALANCE_FILTERED _IOW(BTRFS_IOCTL_MAGIC, 27, \
+				struct btrfs_ioctl_balance_start)
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f81535e..b689219 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1899,7 +1899,38 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
-int btrfs_balance(struct btrfs_root *dev_root)
+int __balance_chunk_filters(
+	struct btrfs_ioctl_balance_start *filter,
+	struct extent_buffer *eb,
+	struct btrfs_chunk *chunk,
+	struct btrfs_key *key)
+{
+	if (filter == NULL) {
+		printk("Filter was NULL: pass all chunks\n");
+		return 1;
+	}
+
+	if (filter->flags == 0) {
+		printk("Filter was empty: pass all chunks\n");
+		return 1;
+	}
+
+	if (filter->flags & BTRFS_BALANCE_FILTER_CHUNK_TYPE) {
+		printk(KERN_INFO "btrfs: balance: Filtering chunk at %llu\n", key->offset);
+		printk(KERN_INFO "btrfs: balance:    flags=%llx\n", btrfs_chunk_type(eb, chunk));
+		printk(KERN_INFO "btrfs: balance:    to match type %llx\n", filter->chunk_type);
+		printk(KERN_INFO "btrfs: balance:    mask %llx\n", filter->chunk_type_mask);
+		printk(KERN_INFO "btrfs: balance: not-mask %llx\n", ~filter->chunk_type_mask);
+		printk(KERN_INFO "btrfs: balance: masked flags %llx\n", (btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask));
+		return (btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask)
+			== filter->chunk_type;
+	}
+
+	return 0;
+}
+
+int btrfs_balance(struct btrfs_root *dev_root,
+		  struct btrfs_ioctl_balance_start *filter)
 {
 	int ret;
 	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
@@ -1912,6 +1943,9 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
 	struct btrfs_balance_info *bal_info;
+	struct btrfs_chunk *chunk;
+
+	printk("Balance: filter pointer is %p\n", filter);
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -1980,6 +2014,15 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		if (ret)
 			break;
 
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				       struct btrfs_chunk);
+		if (!__balance_chunk_filters(filter, path->nodes[0], chunk, &found_key)) {
+			printk(KERN_INFO "btrfs: balance (count): Filtering out chunk at %llu\n", found_key.offset);
+			continue;
+		}
+
 		spin_lock(&dev_root->fs_info->balance_info_lock);
 		bal_info->expected++;
 		spin_unlock(&dev_root->fs_info->balance_info_lock);
@@ -2023,18 +2066,27 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		if (found_key.offset == 0)
 			break;
 
-		btrfs_release_path(chunk_root, path);
-		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
-					   found_key.objectid,
-					   found_key.offset);
-		BUG_ON(ret && ret != -ENOSPC);
+		chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				       struct btrfs_chunk);
+		if (__balance_chunk_filters(filter, path->nodes[0], chunk, &found_key)) {
+			btrfs_release_path(chunk_root, path);
+			ret = btrfs_relocate_chunk(chunk_root,
+						   chunk_root->root_key.objectid,
+						   found_key.objectid,
+						   found_key.offset);
+			BUG_ON(ret && ret != -ENOSPC);
+
+			spin_lock(&dev_root->fs_info->balance_info_lock);
+			bal_info->completed++;
+			spin_unlock(&dev_root->fs_info->balance_info_lock);
+			printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
+			       bal_info->completed, bal_info->expected);
+		} else {
+			btrfs_release_path(chunk_root, path);
+			printk(KERN_INFO "btrfs: balance: Filtering out chunk at %llu\n", found_key.offset);
+		}
+
 		key.offset = found_key.offset - 1;
-		spin_lock(&dev_root->fs_info->balance_info_lock);
-		bal_info->completed++;
-		spin_unlock(&dev_root->fs_info->balance_info_lock);
-		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
-		       bal_info->completed, bal_info->expected);
 	}
 	ret = 0;
 	if(bal_info->cancel_pending) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a668c01..cdbafe6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -21,6 +21,7 @@
 
 #include <linux/bio.h>
 #include "async-thread.h"
+#include "ioctl.h"
 
 struct buffer_head;
 struct btrfs_pending_bios {
@@ -179,7 +180,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
-int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_balance(struct btrfs_root *dev_root, struct btrfs_ioctl_balance_start *filters);
 void btrfs_unlock_volumes(void);
 void btrfs_lock_volumes(void);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-- 
1.7.2.3

