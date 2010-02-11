From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] btrfs: add discard_compat support
Date: Thu, 11 Feb 2010 14:01:14 +0300
Message-ID: <1265886074-22135-1-git-send-email-dmonakhov@openvz.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
Cc: jens.axboe@oracle.com, linux-btrfs@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
List-ID: <linux-btrfs.vger.kernel.org>

If any device in the list has no native discard support we add
discard compat support. Devices with native discard support still
getting real discard requests.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    8 ++++++++
 fs/btrfs/extent-tree.c |   14 ++++++++------
 fs/btrfs/super.c       |    8 +++++++-
 fs/btrfs/volumes.c     |    6 ++++++
 fs/btrfs/volumes.h     |    6 +++++-
 6 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9f806dd..54854d1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1161,6 +1161,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
+#define BTRFS_MOUNT_DISCARD_COMPAT	(1 << 11)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 009e3bd..c7d4812 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1945,6 +1945,14 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		       "mode\n");
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
+	if (btrfs_test_opt(tree_root, DISCARD) &&
+	    fs_info->fs_devices->discard_compat) {
+		printk(KERN_INFO "Btrfs detected devices without native discard"
+			" support, enabling discard_compat mode mode\n");
+		btrfs_clear_opt(fs_info->mount_opt, DISCARD);
+		btrfs_set_opt(fs_info->mount_opt, DISCARD_COMPAT);
+	}
+
 
 	if (btrfs_super_log_root(disk_super) != 0) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 432a2da..b4c3124 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1585,20 +1585,21 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 }
 
 static void btrfs_issue_discard(struct block_device *bdev,
-				u64 start, u64 len)
+				u64 start, u64 len, int do_compat)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			     DISCARD_FL_BARRIER);
+			     DISCARD_FL_BARRIER |
+				(do_compat ? DISCARD_FL_COMPAT : 0));
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 				u64 num_bytes)
 {
-	int ret;
+	int ret, do_compat = btrfs_test_opt(root, DISCARD_COMPAT);
 	u64 map_length = num_bytes;
 	struct btrfs_multi_bio *multi = NULL;
 
-	if (!btrfs_test_opt(root, DISCARD))
+	if (!btrfs_test_opt(root, DISCARD) && !do_compat)
 		return 0;
 
 	/* Tell the block device(s) that the sectors can be discarded */
@@ -1614,7 +1615,8 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
 			btrfs_issue_discard(stripe->dev->bdev,
 					    stripe->physical,
-					    map_length);
+					    map_length,
+					    do_compat);
 		}
 		kfree(multi);
 	}
@@ -3700,7 +3702,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	 * individual btree blocks isn't a good plan.  Just
 	 * pin everything in discard mode.
 	 */
-	if (btrfs_test_opt(root, DISCARD))
+	if (btrfs_test_opt(root, DISCARD) || btrfs_test_opt(root, DISCARD_COMPAT))
 		goto pinit;
 
 	buf = btrfs_find_tree_block(root, bytenr, num_bytes);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3f9b457..fe7ccf4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -67,7 +67,7 @@ enum {
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl,
 	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_discard_compat, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -90,6 +90,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_discard_compat, "discard_compat"},
 	{Opt_err, NULL},
 };
 
@@ -263,6 +264,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_discard_compat:
+			btrfs_set_opt(info->mount_opt, DISCARD_COMPAT);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -459,6 +463,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",flushoncommit");
 	if (btrfs_test_opt(root, DISCARD))
 		seq_puts(seq, ",discard");
+	if (btrfs_test_opt(root, DISCARD_COMPAT))
+		seq_puts(seq, ",discard_compat");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 220dad5..02e18c8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -621,6 +621,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 			fs_devices->rotating = 1;
 
+		if (!blk_queue_discard(bdev_get_queue(bdev)))
+			fs_devices->discard_compat = 1;
+
 		fs_devices->open_devices++;
 		if (device->writeable) {
 			fs_devices->rw_devices++;
@@ -1522,6 +1525,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 		root->fs_info->fs_devices->rotating = 1;
 
+	if (!blk_queue_discard(bdev_get_queue(bdev)))
+		root->fs_info->fs_devices->discard_compat = 1;
+
 	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	btrfs_set_super_total_bytes(&root->fs_info->super_copy,
 				    total_bytes + device->total_bytes);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 31b0fab..ceb66f0 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -116,7 +116,11 @@ struct btrfs_fs_devices {
 	/* set when we find or add a device that doesn't have the
 	 * nonrot flag set
 	 */
-	int rotating;
+	unsigned int rotating:1;
+	/* set then we find or add a device that doesn't have the
+	 * DISCARD flags set
+	 */
+	unsigned int discard_compat:1;
 };
 
 struct btrfs_bio_stripe {
-- 
1.6.6
