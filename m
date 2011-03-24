From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH V4 4/4] Btrfs: add btrfs_trim_fs() to handle FITRIM
Date: Thu, 24 Mar 2011 18:24:28 +0800
Message-ID: <1300962268-12774-5-git-send-email-lidongyang@novell.com>
References: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

We take an free extent out from allocator, trim it, then put it back,
but before we trim the block group, we should make sure the block group is
cached, so plus a little change to make cache_block_group() run without a
transaction.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/extent-tree.c      |   50 +++++++++++++++++++++++-
 fs/btrfs/free-space-cache.c |   92 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |    2 +
 fs/btrfs/ioctl.c            |   46 +++++++++++++++++++++
 5 files changed, 190 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 94bb772..df206c1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2232,6 +2232,7 @@ int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
 			       u64 num_bytes, u64 *actual_bytes);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 type);
+int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range);
 
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 10e542a..d876759 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -440,7 +440,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	 * allocate blocks for the tree root we can't do the fast caching since
 	 * we likely hold important locks.
 	 */
-	if (!trans->transaction->in_commit &&
+	if (trans && (!trans->transaction->in_commit) &&
 	    (root && root != root->fs_info->tree_root)) {
 		spin_lock(&cache->lock);
 		if (cache->cached != BTRFS_CACHE_NO) {
@@ -8739,3 +8739,51 @@ int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
 {
 	return btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
 }
+
+int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_group_cache *cache = NULL;
+	u64 group_trimmed;
+	u64 start;
+	u64 end;
+	u64 trimmed = 0;
+	int ret = 0;
+
+	cache = btrfs_lookup_block_group(fs_info, range->start);
+
+	while (cache) {
+		if (cache->key.objectid >= (range->start + range->len)) {
+			btrfs_put_block_group(cache);
+			break;
+		}
+
+		start = max(range->start, cache->key.objectid);
+		end = min(range->start + range->len,
+				cache->key.objectid + cache->key.offset);
+
+		if (end - start >= range->minlen) {
+			if (!block_group_cache_done(cache)) {
+				ret = cache_block_group(cache, NULL, root, 0);
+				if (!ret)
+					wait_block_group_cache_done(cache);
+			}
+			ret = btrfs_trim_block_group(cache,
+						     &group_trimmed,
+						     start,
+						     end,
+						     range->minlen);
+
+			trimmed += group_trimmed;
+			if (ret) {
+				btrfs_put_block_group(cache);
+				break;
+			}
+		}
+
+		cache = next_block_group(fs_info->tree_root, cache);
+	}
+
+	range->len = trimmed;
+	return ret;
+}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a039065..d0dc812 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2154,3 +2154,95 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	cluster->block_group = NULL;
 }
 
+int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
+			   u64 *trimmed, u64 start, u64 end, u64 minlen)
+{
+	struct btrfs_free_space *entry = NULL;
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	u64 bytes = 0;
+	u64 actually_trimmed;
+	int ret = 0;
+
+	*trimmed = 0;
+
+	while (start < end) {
+		spin_lock(&block_group->tree_lock);
+
+		if (block_group->free_space < minlen) {
+			spin_unlock(&block_group->tree_lock);
+			break;
+		}
+
+		entry = tree_search_offset(block_group, start, 0, 1);
+		if (!entry)
+			entry = tree_search_offset(block_group,
+						   offset_to_bitmap(block_group,
+								    start),
+						   1, 1);
+
+		if (!entry || entry->offset >= end) {
+			spin_unlock(&block_group->tree_lock);
+			break;
+		}
+
+		if (entry->bitmap) {
+			ret = search_bitmap(block_group, entry, &start, &bytes);
+			if (!ret) {
+				if (start >= end) {
+					spin_unlock(&block_group->tree_lock);
+					break;
+				}
+				bytes = min(bytes, end - start);
+				bitmap_clear_bits(block_group, entry,
+						  start, bytes);
+				if (entry->bytes == 0)
+					free_bitmap(block_group, entry);
+			} else {
+				start = entry->offset + BITS_PER_BITMAP *
+					block_group->sectorsize;
+				spin_unlock(&block_group->tree_lock);
+				ret = 0;
+				continue;
+			}
+		} else {
+			start = entry->offset;
+			bytes = min(entry->bytes, end - start);
+			unlink_free_space(block_group, entry);
+			kfree(entry);
+		}
+
+		spin_unlock(&block_group->tree_lock);
+
+		if (bytes >= minlen) {
+			int update_ret;
+			update_ret = btrfs_update_reserved_bytes(block_group,
+								 bytes, 1, 1);
+
+			ret = btrfs_error_discard_extent(fs_info->extent_root,
+							 start,
+							 bytes,
+							 &actually_trimmed);
+
+			btrfs_add_free_space(block_group,
+					     start, bytes);
+			if (!update_ret)
+				btrfs_update_reserved_bytes(block_group,
+							    bytes, 0, 1);
+
+			if (ret)
+				break;
+			*trimmed += actually_trimmed;
+		}
+		start += bytes;
+		bytes = 0;
+
+		if (fatal_signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		cond_resched();
+	}
+
+	return ret;
+}
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index e49ca5c..65c3b93 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -68,4 +68,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 int btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group_cache *block_group,
 			       struct btrfs_free_cluster *cluster);
+int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
+			   u64 *trimmed, u64 start, u64 end, u64 minlen);
 #endif
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..eff9228 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -40,6 +40,7 @@
 #include <linux/xattr.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -225,6 +226,49 @@ static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
 	return put_user(inode->i_generation, arg);
 }
 
+static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = fdentry(file)->d_sb->s_fs_info;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_device *device;
+	struct request_queue *q;
+	struct fstrim_range range;
+	u64 minlen = ULLONG_MAX;
+	u64 num_devices = 0;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
+		if (!device->bdev)
+			continue;
+		q = bdev_get_queue(device->bdev);
+		if (blk_queue_discard(q)) {
+			num_devices++;
+			minlen = min((u64)q->limits.discard_granularity,
+				     minlen);
+		}
+	}
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	if (!num_devices)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&range, arg, sizeof(range)))
+		return -EFAULT;
+
+	range.minlen = max(range.minlen, minlen);
+	ret = btrfs_trim_fs(root, &range);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(arg, &range, sizeof(range)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static noinline int create_subvol(struct btrfs_root *root,
 				  struct dentry *dentry,
 				  char *name, int namelen,
@@ -2388,6 +2432,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_setflags(file, argp);
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
+	case FITRIM:
+		return btrfs_ioctl_fitrim(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SNAP_CREATE_V2:
-- 
1.7.4.1

