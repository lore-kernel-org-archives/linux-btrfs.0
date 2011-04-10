From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 4/8] btrfs: Implement filtered balance ioctl
Date: Sun, 10 Apr 2011 22:06:07 +0100
Message-ID: <1302469571-12605-5-git-send-email-hugo@carfax.org.uk>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

The filtered balance ioctl provides a facility to perform a balance
operation on a subset of the chunks in the filesystem. This patch
implements the base ioctl for this operation, and one filter type.
The filter in this patch selects chunks on the basis of their chunk
flags field, and can select any combination of bits set or unset.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.c   |   42 ++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h   |   27 +++++++++++++++++++++
 fs/btrfs/volumes.c |   65 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.h |    4 ++-
 4 files changed, 128 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index aef6329..4bc4da2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2433,6 +2433,44 @@ error:
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
+	if (ret)
+		goto error;
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
@@ -2471,11 +2509,13 @@ long btrfs_ioctl(struct file *file, unsigned int
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
index 2c49add..eb91d20 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -162,6 +162,31 @@ struct btrfs_ioctl_balance_progress {
 	__u32 completed;
 };
 
+/* Types of balance filter */
+#define BTRFS_BALANCE_FILTER_COUNT_ONLY (1 << 0)
+
+#define BTRFS_BALANCE_FILTER_CHUNK_TYPE (1 << 1)
+#define BTRFS_BALANCE_FILTER_MASK ((1 << 2) - 1) /* Logical or of all filter
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
index 20c2772..95c603a 100644
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
@@ -2069,6 +2100,7 @@ static void balance_move_chunks(struct btrfs_root *chunk_root,
 /* Iterate through all chunks, performing some function on each one. */
 static int balance_iterate_chunks(struct btrfs_root *chunk_root,
 			   struct btrfs_balance_info *bal_info,
+			   struct btrfs_ioctl_balance_start *filter,
 			   balance_iterator_function iterator_fn)
 {
 	int ret = 0;
@@ -2084,6 +2116,9 @@ static int balance_iterate_chunks(struct btrfs_root *chunk_root,
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
+	filter->examined = 0;
+	filter->balanced = 0;
+
 	while (!bal_info->cancel_pending) {
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0)
@@ -2110,17 +2145,29 @@ static int balance_iterate_chunks(struct btrfs_root *chunk_root,
 			break;
 
 		/* Call the function to do the work for this chunk */
-		btrfs_release_path(chunk_root, path);
-		iterator_fn(chunk_root, bal_info, path, &found_key);
+		filter->examined += 1;
+
+		if (balance_chunk_filter(filter, chunk_root,
+					 path, &found_key)) {
+			btrfs_release_path(chunk_root, path);
+			iterator_fn(chunk_root, bal_info, path, &found_key);
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

