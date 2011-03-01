From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.38-rc6, patch] mark some internal functions static...
Date: Wed, 2 Mar 2011 00:26:30 +0800
Message-ID: <AANLkTinCvzNcK-Xpp7R15u1GZzUC+eSNUn=ytdyoL5vM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Prevent needless exporting of internal functions from compilation
units by marking them static.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..5e49196 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -74,7 +74,7 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
  * retake all the spinlocks in the path.  You can safely use NULL
  * for held
  */
-noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
+static noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 					struct extent_buffer *held)
 {
 	int i;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..c48d699 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2279,7 +2279,7 @@ static int write_dev_supers(struct btrfs_device *device,
 	return errors < i ? 0 : -1;
 }

-int write_all_supers(struct btrfs_root *root, int max_mirrors)
+static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f3c96fc..1961081 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -77,7 +77,7 @@ static int block_group_bits(struct
btrfs_block_group_cache *cache, u64 bits)
 	return (cache->flags & bits) == bits;
 }

-void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
+static void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
 {
 	atomic_inc(&cache->count);
 }
@@ -3576,7 +3576,7 @@ static void block_rsv_add_bytes(struct
btrfs_block_rsv *block_rsv,
 	spin_unlock(&block_rsv->lock);
 }

-void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
+static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 			     struct btrfs_block_rsv *dest, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a039065..ec5015c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1371,7 +1371,7 @@ out:
 	return ret;
 }

-bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
+static bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 			  struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *left_info;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be2d4f6..7b97854 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2193,7 +2193,7 @@ static void get_block_group_info(struct
list_head *groups_list,
 	}
 }

-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
 	struct btrfs_ioctl_space_info space;
-- 
Daniel J Blueman
