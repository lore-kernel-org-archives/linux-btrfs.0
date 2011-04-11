From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] mark internal functions static
Date: Mon, 11 Apr 2011 23:40:06 +0800
Message-ID: <BANLkTinUKcSNp_TN8FaE8Tiy-VX=F+v03Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This didn't make it in before, so updating to 2.6.39-rc2 and resending:

Prevent needless exporting of internal functions from compilation
units by marking them static.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..6581b37 100644
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
index 8f1d44b..59f2567 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2313,7 +2313,7 @@ static int write_dev_supers(struct btrfs_device *device,
 	return errors < i ? 0 : -1;
 }

-int write_all_supers(struct btrfs_root *root, int max_mirrors)
+static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f619c3c..5394255 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -75,7 +75,7 @@ static int block_group_bits(struct
btrfs_block_group_cache *cache, u64 bits)
 	return (cache->flags & bits) == bits;
 }

-void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
+static void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
 {
 	atomic_inc(&cache->count);
 }
@@ -3586,7 +3586,7 @@ static void block_rsv_add_bytes(struct
btrfs_block_rsv *block_rsv,
 	spin_unlock(&block_rsv->lock);
 }

-void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
+static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 			     struct btrfs_block_rsv *dest, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6541339..6370184 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5305,7 +5305,7 @@ out:
 	return em;
 }

-struct extent_map *btrfs_get_extent_fiemap(struct inode *inode,
struct page *page,
+static struct extent_map *btrfs_get_extent_fiemap(struct inode
*inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create)
 {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cfc264f..de76a6d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2281,7 +2281,7 @@ static void get_block_group_info(struct
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
