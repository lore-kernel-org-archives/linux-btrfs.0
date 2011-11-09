From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 4/4] Btrfs: integrate integrity check module into btrfs
Date: Wed,  9 Nov 2011 16:18:01 +0100
Message-ID: <39be5392577531b7008e8f44055e286e48d64c07.1320850526.git.sbehrens@giantdisaster.de>
References: <cover.1320849129.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1320849129.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

This is the last part of the patch series. It modifies the btrfs
code to use the integrity check module if configured to do so
with the define BTRFS_FS_CHECK_INTEGRITY. If this define is not set,
the only effective change is that code is added that handles the
mount option to activate the integrity check. If the mount option is
set and the define BTRFS_FS_CHECK_INTEGRITY is not set, that code
complains in the log and the mount fails with EINVAL.

Add the mount option to activate the usage of the integrity check
code.
Add invocation of btrfs integrity check code init and cleanup
function on mount and umount, respectively.
Add hook to call btrfs integrity check code version of
submit_bh/submit_bio.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h     |    8 +++++++-
 fs/btrfs/disk-io.c   |   26 ++++++++++++++++++++++++--
 fs/btrfs/extent_io.c |    5 +++--
 fs/btrfs/scrub.c     |    5 +++--
 fs/btrfs/super.c     |   39 ++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c   |    7 ++++---
 6 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b9ba59f..136674d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -970,7 +970,7 @@ struct btrfs_fs_info {
 	 * is required instead of the faster short fsync log commits
 	 */
 	u64 last_trans_log_full_commit;
-	unsigned long mount_opt:20;
+	unsigned long mount_opt:21;
 	unsigned long compress_type:4;
 	u64 max_inline;
 	u64 alloc_start;
@@ -1154,6 +1154,10 @@ struct btrfs_fs_info {
 	int scrub_workers_refcnt;
 	struct btrfs_workers scrub_workers;
 
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	u32 check_integrity_print_mask;
+#endif
+
 	/* filesystem state */
 	u64 fs_state;
 
@@ -1410,6 +1414,8 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
 #define BTRFS_MOUNT_RECOVERY		(1 << 18)
+#define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 19)
+#define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 20)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e53a5bb..a03db2a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -43,6 +43,7 @@
 #include "tree-log.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "check-integrity.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -2006,6 +2007,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->scrub_pause_wait);
 	init_rwsem(&fs_info->scrub_super_lock);
 	fs_info->scrub_workers_refcnt = 0;
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	fs_info->check_integrity_print_mask = 0;
+#endif
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
@@ -2353,6 +2357,19 @@ retry_root_backup:
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
+		ret = btrfsic_mount(tree_root, fs_devices,
+				    btrfs_test_opt(tree_root,
+					CHECK_INTEGRITY_INCLUDING_EXTENT_DATA) ?
+				    1 : 0,
+				    fs_info->check_integrity_print_mask);
+		if (ret)
+			printk(KERN_WARNING "btrfs: failed to initialize"
+			       " integrity check module %s\n", sb->s_id);
+	}
+#endif
+
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
@@ -2641,9 +2658,9 @@ static int write_dev_supers(struct btrfs_device *device,
 		}
 
 		if (i == last_barrier && do_barriers)
-			ret = submit_bh(WRITE_FLUSH_FUA, bh);
+			ret = btrfsic_submit_bh(WRITE_FLUSH_FUA, bh);
 		else
-			ret = submit_bh(WRITE_SYNC, bh);
+			ret = btrfsic_submit_bh(WRITE_SYNC, bh);
 
 		if (ret)
 			errors++;
@@ -2944,6 +2961,11 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	if (btrfs_test_opt(root, CHECK_INTEGRITY))
+		btrfsic_unmount(root, fs_info->fs_devices);
+#endif
+
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1f87c4d..fd78232 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -18,6 +18,7 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "volumes.h"
+#include "check-integrity.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -1887,7 +1888,7 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 	}
 	bio->bi_bdev = dev->bdev;
 	bio_add_page(bio, page, length, start-page_offset(page));
-	submit_bio(WRITE_SYNC, bio);
+	btrfsic_submit_bio(WRITE_SYNC, bio);
 	wait_for_completion(&compl);
 
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
@@ -2372,7 +2373,7 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags, start);
 	else
-		submit_bio(rw, bio);
+		btrfsic_submit_bio(rw, bio);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ed11d38..e821da4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -25,6 +25,7 @@
 #include "transaction.h"
 #include "backref.h"
 #include "extent_io.h"
+#include "check-integrity.h"
 
 /*
  * This is only the first step towards a full-features scrub. It reads all
@@ -727,7 +728,7 @@ static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio->bi_end_io = scrub_fixup_end_io;
 	bio->bi_private = &complete;
-	submit_bio(rw, bio);
+	btrfsic_submit_bio(rw, bio);
 
 	/* this will also unplug the queue */
 	wait_for_completion(&complete);
@@ -980,7 +981,7 @@ static int scrub_submit(struct scrub_dev *sdev)
 	sdev->curr = -1;
 	atomic_inc(&sdev->in_flight);
 
-	submit_bio(READ, bio);
+	btrfsic_submit_bio(READ, bio);
 
 	return 0;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index dcd5aef..7b93b16 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -164,7 +164,10 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_no_space_cache, Opt_recovery, Opt_err,
+	Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
+	Opt_check_integrity, Opt_check_integrity_including_extent_data,
+	Opt_check_integrity_print_mask,
+	Opt_err,
 };
 
 static match_table_t tokens = {
@@ -199,6 +202,9 @@ static match_table_t tokens = {
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "no_space_cache"},
 	{Opt_recovery, "recovery"},
+	{Opt_check_integrity, "check_int"},
+	{Opt_check_integrity_including_extent_data, "check_int_data"},
+	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_err, NULL},
 };
 
@@ -397,6 +403,37 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: enabling auto recovery");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+		case Opt_check_integrity_including_extent_data:
+			printk(KERN_INFO "btrfs: enabling check integrity"
+			       " including extent data\n");
+			btrfs_set_opt(info->mount_opt,
+				      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
+			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+			break;
+		case Opt_check_integrity:
+			printk(KERN_INFO "btrfs: enabling check integrity\n");
+			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+			break;
+		case Opt_check_integrity_print_mask:
+			intarg = 0;
+			match_int(&args[0], &intarg);
+			if (intarg) {
+				info->check_integrity_print_mask = intarg;
+				printk(KERN_INFO "btrfs:"
+				       " check_integrity_print_mask 0x%x\n",
+				       info->check_integrity_print_mask);
+			}
+			break;
+#else
+		case Opt_check_integrity_including_extent_data:
+		case Opt_check_integrity:
+		case Opt_check_integrity_print_mask:
+			printk(KERN_ERR "btrfs: support for check_integrity*"
+			       " not compiled in!\n");
+			ret = -EINVAL;
+			goto out;
+#endif
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f8e29431..d74ff01 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -32,6 +32,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "async-thread.h"
+#include "check-integrity.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -246,7 +247,7 @@ loop_lock:
 			sync_pending = 0;
 		}
 
-		submit_bio(cur->bi_rw, cur);
+		btrfsic_submit_bio(cur->bi_rw, cur);
 		num_run++;
 		batch_run++;
 		if (need_resched())
@@ -3295,7 +3296,7 @@ static noinline int schedule_bio(struct btrfs_root *root,
 	/* don't bother with additional async steps for reads, right now */
 	if (!(rw & REQ_WRITE)) {
 		bio_get(bio);
-		submit_bio(rw, bio);
+		btrfsic_submit_bio(rw, bio);
 		bio_put(bio);
 		return 0;
 	}
@@ -3390,7 +3391,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			if (async_submit)
 				schedule_bio(root, dev, rw, bio);
 			else
-				submit_bio(rw, bio);
+				btrfsic_submit_bio(rw, bio);
 		} else {
 			bio->bi_bdev = root->fs_info->fs_devices->latest_bdev;
 			bio->bi_sector = logical >> 9;
-- 
1.7.3.4

