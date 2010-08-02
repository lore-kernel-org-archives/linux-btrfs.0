From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] btrfs: Add a new mount option to grow the FS to the limit of
 the device
Date: Mon, 02 Aug 2010 17:42:00 +0900
Message-ID: <4C5684D8.4080702@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, kyungmin.park@samsung.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In some cases, resizing a file system to the maximum device size is required.
When flashing a file system image to a block device,
the file system does not fit into the block device's size.
Currently, executing 'btrfsctl' application is the only way
to grow the file system to the limit of the device.
If the mount option which alters the device size of a file system
to the limit of the device is supported,
it can be useful regardless of the existence of 'btrfsctl' program.
This patch allows the file system to grow to the maximum size of the device
on mount time.
The new mount option name is 'maxsize'.

Thank you.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |   30 ++++++++++++++++++++++++++++++
 fs/btrfs/super.c   |    8 +++++++-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..ee71964 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1192,6 +1192,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+#define BTRFS_MOUNT_MAXSIZE		(1 << 12)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..a1abf7c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1533,6 +1533,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	u32 stripesize;
 	u64 generation;
 	u64 features;
+	u64 dev_max_size;
+	u64 dev_old_size;
+	u64 devid;
 	struct btrfs_key location;
 	struct buffer_head *bh;
 	struct btrfs_root *extent_root = kzalloc(sizeof(struct btrfs_root),
@@ -1554,6 +1557,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	struct btrfs_super_block *disk_super;
 
+	struct btrfs_trans_handle *trans;
+	struct btrfs_device *device;
+
 	if (!extent_root || !tree_root || !fs_info ||
 	    !chunk_root || !dev_root || !csum_root) {
 		err = -ENOMEM;
@@ -1928,6 +1934,30 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+	if (btrfs_test_opt(tree_root, MAXSIZE)) {
+		devid = fs_devices->latest_devid;
+		device = btrfs_find_device(tree_root, devid, NULL, NULL);
+		if (!device) {
+			printk(KERN_WARNING "resizer unable to "
+				"find device %llu\n",
+				(unsigned long long)devid);
+			goto fail_trans_kthread;
+		}
+		dev_max_size = device->bdev->bd_inode->i_size;
+		dev_old_size = device->total_bytes;
+		if (dev_max_size > dev_old_size) {
+			trans = btrfs_start_transaction(tree_root, 0);
+			ret = btrfs_grow_device(trans, device, dev_max_size);
+			if (ret)
+				printk(KERN_INFO "unable to resize for %s\n",
+					device->name);
+			else
+				printk(KERN_INFO "new size for %s is %llu\n",
+					device->name, dev_max_size);
+			btrfs_commit_transaction(trans, tree_root);
+		}
+	}
+
 	if (btrfs_super_log_root(disk_super) != 0) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 859ddaa..d6b8cf2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -68,7 +68,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_maxsize, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -92,6 +92,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_maxsize, "maxsize"},
 	{Opt_err, NULL},
 };
 
@@ -235,6 +236,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_maxsize:
+			btrfs_set_opt(info->mount_opt, MAXSIZE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -541,6 +545,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",flushoncommit");
 	if (btrfs_test_opt(root, DISCARD))
 		seq_puts(seq, ",discard");
+	if (btrfs_test_opt(root, MAXSIZE))
+		seq_puts(seq, ",maxsize");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;
-- 
1.6.3.3

