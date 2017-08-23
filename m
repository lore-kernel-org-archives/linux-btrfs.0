Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:38740 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbdHWGqQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:16 -0400
Received: by mail-pg0-f48.google.com with SMTP id m133so3933251pga.5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:16 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 3/7] Move Btrfs RCU string to common library
Date: Tue, 22 Aug 2017 23:46:01 -0700
Message-Id: <1270f0e6bfea72e136a42c058afce74f01deab62.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The RCU-friendly string API used internally by Btrfs is generic enough
for common use. This doesn't add any new functionality but instead just
moves the code and documents the existing API.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/check-integrity.c | 12 +++---
 fs/btrfs/dev-replace.c     | 37 +++++++++---------
 fs/btrfs/disk-io.c         |  6 +--
 fs/btrfs/extent_io.c       |  8 ++--
 fs/btrfs/ioctl.c           |  4 +-
 fs/btrfs/raid56.c          |  1 -
 fs/btrfs/rcu-string.h      | 56 --------------------------
 fs/btrfs/scrub.c           | 42 ++++++++++----------
 fs/btrfs/super.c           |  7 ++--
 fs/btrfs/volumes.c         | 58 ++++++++++++++-------------
 include/linux/rcustring.h  | 97 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 187 insertions(+), 141 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 11d37c94ce05..4a09a2d2fcf8 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -95,6 +95,7 @@
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
+#include <linux/rcustring.h>
 #include <linux/string.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -105,7 +106,6 @@
 #include "print-tree.h"
 #include "locking.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "compression.h"
 
 #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
@@ -834,11 +834,11 @@ static int btrfsic_process_superblock_dev_mirror(
 		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
 			btrfs_info_in_rcu(fs_info,
-				"new initial S-block (bdev %p, %s) @%llu (%s/%llu/%d)",
-				     superblock_bdev,
-				     rcu_str_deref(device->name), dev_bytenr,
-				     dev_state->name, dev_bytenr,
-				     superblock_mirror_num);
+					  "new initial S-block (bdev %p, %s) @%llu (%s/%llu/%d)",
+					  superblock_bdev,
+					  rcu_string_dereference(device->name),
+					  dev_bytenr, dev_state->name,
+					  dev_bytenr, superblock_mirror_num);
 		list_add(&superblock_tmp->all_blocks_node,
 			 &state->all_blocks_list);
 		btrfsic_block_hashtable_add(superblock_tmp,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bee3edeea7a3..bd5ba61e4071 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -25,6 +25,7 @@
 #include <linux/capability.h>
 #include <linux/kthread.h>
 #include <linux/math64.h>
+#include <linux/rcustring.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -34,7 +35,6 @@
 #include "volumes.h"
 #include "async-thread.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "dev-replace.h"
 #include "sysfs.h"
 
@@ -362,11 +362,11 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->tgtdev = tgt_device;
 
 	btrfs_info_in_rcu(fs_info,
-		      "dev_replace from %s (devid %llu) to %s started",
-		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
-		      src_device->devid,
-		      rcu_str_deref(tgt_device->name));
+			  "dev_replace from %s (devid %llu) to %s started",
+			  src_device->missing ? "<missing disk>" :
+			  rcu_string_dereference(src_device->name),
+			  src_device->devid,
+			  rcu_string_dereference(tgt_device->name));
 
 	/*
 	 * from now on, the writes to the srcdev are all duplicated to
@@ -539,9 +539,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		btrfs_err_in_rcu(fs_info,
 				 "btrfs_scrub_dev(%s, %llu, %s) failed %d",
 				 src_device->missing ? "<missing disk>" :
-				 rcu_str_deref(src_device->name),
+				 rcu_string_dereference(src_device->name),
 				 src_device->devid,
-				 rcu_str_deref(tgt_device->name), scrub_ret);
+				 rcu_string_dereference(tgt_device->name),
+				 scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace, 1);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -558,9 +559,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	btrfs_info_in_rcu(fs_info,
 			  "dev_replace from %s (devid %llu) to %s finished",
 			  src_device->missing ? "<missing disk>" :
-			  rcu_str_deref(src_device->name),
+			  rcu_string_dereference(src_device->name),
 			  src_device->devid,
-			  rcu_str_deref(tgt_device->name));
+			  rcu_string_dereference(tgt_device->name));
 	tgt_device->is_tgtdev_for_dev_replace = 0;
 	tgt_device->devid = src_device->devid;
 	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
@@ -805,14 +806,14 @@ static int btrfs_dev_replace_kthread(void *data)
 		kfree(status_args);
 		progress = div_u64(progress, 10);
 		btrfs_info_in_rcu(fs_info,
-			"continuing dev_replace from %s (devid %llu) to %s @%u%%",
-			dev_replace->srcdev->missing ? "<missing disk>" :
-			rcu_str_deref(dev_replace->srcdev->name),
-			dev_replace->srcdev->devid,
-			dev_replace->tgtdev ?
-			rcu_str_deref(dev_replace->tgtdev->name) :
-			"<missing target disk>",
-			(unsigned int)progress);
+				  "continuing dev_replace from %s (devid %llu) to %s @%u%%",
+				  dev_replace->srcdev->missing ? "<missing disk>" :
+				  rcu_string_dereference(dev_replace->srcdev->name),
+				  dev_replace->srcdev->devid,
+				  dev_replace->tgtdev ?
+				  rcu_string_dereference(dev_replace->tgtdev->name) :
+				  "<missing target disk>",
+				  (unsigned int)progress);
 	}
 	btrfs_dev_replace_continue_on_mount(fs_info);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f45b61fe9a9a..e0d08c904506 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/migrate.h>
 #include <linux/ratelimit.h>
+#include <linux/rcustring.h>
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
 #include <asm/unaligned.h>
@@ -44,7 +45,6 @@
 #include "free-space-tree.h"
 #include "inode-map.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "dev-replace.h"
 #include "raid56.h"
 #include "sysfs.h"
@@ -3298,8 +3298,8 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 			bh->b_private;
 
 		btrfs_warn_rl_in_rcu(device->fs_info,
-				"lost page write due to IO error on %s",
-					  rcu_str_deref(device->name));
+				     "lost page write due to IO error on %s",
+				     rcu_string_dereference(device->name));
 		/* note, we don't set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0aff9b278c19..4eff5a7d6551 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6,6 +6,7 @@
 #include <linux/page-flags.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
+#include <linux/rcustring.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
@@ -18,7 +19,6 @@
 #include "volumes.h"
 #include "check-integrity.h"
 #include "locking.h"
-#include "rcu-string.h"
 #include "backref.h"
 #include "transaction.h"
 
@@ -2046,9 +2046,9 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	}
 
 	btrfs_info_rl_in_rcu(fs_info,
-		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-				  ino, start,
-				  rcu_str_deref(dev->name), sector);
+			     "read error corrected: ino %llu off %llu (dev %s sector %llu)",
+			     ino, start, rcu_string_dereference(dev->name),
+			     sector);
 	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
 	return 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b51124d5b8a3..befeacd0e847 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -31,6 +31,7 @@
 #include <linux/mount.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/rcustring.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/compat.h>
@@ -52,7 +53,6 @@
 #include "locking.h"
 #include "inode-map.h"
 #include "backref.h"
-#include "rcu-string.h"
 #include "send.h"
 #include "dev-replace.h"
 #include "props.h"
@@ -1604,7 +1604,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	new_size *= fs_info->sectorsize;
 
 	btrfs_info_in_rcu(fs_info, "new size for %s is %llu",
-			  rcu_str_deref(device->name), new_size);
+			  rcu_string_dereference(device->name), new_size);
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 0);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2cf6ba40f7c4..56fc03e7b7b5 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -42,7 +42,6 @@
 #include "raid56.h"
 #include "async-thread.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 
 /* set when additional merges to this rbio are not allowed */
 #define RBIO_RMW_LOCKED_BIT	1
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
deleted file mode 100644
index 9e111e4576d4..000000000000
--- a/fs/btrfs/rcu-string.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (C) 2012 Red Hat.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-struct rcu_string {
-	struct rcu_head rcu;
-	char str[0];
-};
-
-static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
-{
-	size_t len = strlen(src) + 1;
-	struct rcu_string *ret = kzalloc(sizeof(struct rcu_string) +
-					 (len * sizeof(char)), mask);
-	if (!ret)
-		return ret;
-	strncpy(ret->str, src, len);
-	return ret;
-}
-
-static inline void rcu_string_free(struct rcu_string *str)
-{
-	if (str)
-		kfree_rcu(str, rcu);
-}
-
-#define printk_in_rcu(fmt, ...) do {	\
-	rcu_read_lock();		\
-	printk(fmt, __VA_ARGS__);	\
-	rcu_read_unlock();		\
-} while (0)
-
-#define printk_ratelimited_in_rcu(fmt, ...) do {	\
-	rcu_read_lock();				\
-	printk_ratelimited(fmt, __VA_ARGS__);		\
-	rcu_read_unlock();				\
-} while (0)
-
-#define rcu_str_deref(rcu_str) ({				\
-	struct rcu_string *__str = rcu_dereference(rcu_str);	\
-	__str->str;						\
-})
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6f1e4c984b94..d5976c1b1714 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -18,6 +18,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
+#include <linux/rcustring.h>
 #include <linux/sched/mm.h>
 #include "ctree.h"
 #include "volumes.h"
@@ -28,7 +29,6 @@
 #include "extent_io.h"
 #include "dev-replace.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "raid56.h"
 
 /*
@@ -799,7 +799,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 		btrfs_warn_in_rcu(fs_info,
 				  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu, length %llu, links %u (path: %s)",
 				  swarn->errstr, swarn->logical,
-				  rcu_str_deref(swarn->dev->name),
+				  rcu_string_dereference(swarn->dev->name),
 				  (unsigned long long)swarn->sector,
 				  root, inum, offset,
 				  min(isize - offset, (u64)PAGE_SIZE), nlink,
@@ -812,7 +812,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	btrfs_warn_in_rcu(fs_info,
 			  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu: path resolving failed with ret=%d",
 			  swarn->errstr, swarn->logical,
-			  rcu_str_deref(swarn->dev->name),
+			  rcu_string_dereference(swarn->dev->name),
 			  (unsigned long long)swarn->sector,
 			  root, inum, offset, ret);
 
@@ -868,13 +868,13 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 						      item_size, &ref_root,
 						      &ref_level);
 			btrfs_warn_in_rcu(fs_info,
-				"%s at logical %llu on dev %s, sector %llu: metadata %s (level %d) in tree %llu",
-				errstr, swarn.logical,
-				rcu_str_deref(dev->name),
-				(unsigned long long)swarn.sector,
-				ref_level ? "node" : "leaf",
-				ret < 0 ? -1 : ref_level,
-				ret < 0 ? -1 : ref_root);
+					  "%s at logical %llu on dev %s, sector %llu: metadata %s (level %d) in tree %llu",
+					  errstr, swarn.logical,
+					  rcu_string_dereference(dev->name),
+					  (unsigned long long)swarn.sector,
+					  ref_level ? "node" : "leaf",
+					  ret < 0 ? -1 : ref_level,
+					  ret < 0 ? -1 : ref_root);
 		} while (ret != 1);
 		btrfs_release_path(path);
 	} else {
@@ -1068,8 +1068,9 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 		btrfs_dev_replace_stats_inc(
 			&fs_info->dev_replace.num_uncorrectable_read_errors);
 		btrfs_err_rl_in_rcu(fs_info,
-		    "unable to fixup (nodatasum) error at logical %llu on dev %s",
-			fixup->logical, rcu_str_deref(fixup->dev->name));
+				    "unable to fixup (nodatasum) error at logical %llu on dev %s",
+				    fixup->logical,
+				    rcu_string_dereference(fixup->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -1458,8 +1459,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			sblock_to_check->data_corrected = 1;
 			spin_unlock(&sctx->stat_lock);
 			btrfs_err_rl_in_rcu(fs_info,
-				"fixed up error at logical %llu on dev %s",
-				logical, rcu_str_deref(dev->name));
+					    "fixed up error at logical %llu on dev %s",
+					    logical,
+					    rcu_string_dereference(dev->name));
 		}
 	} else {
 did_not_correct_error:
@@ -1467,8 +1469,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
 		btrfs_err_rl_in_rcu(fs_info,
-			"unable to fixup (regular) error at logical %llu on dev %s",
-			logical, rcu_str_deref(dev->name));
+				    "unable to fixup (regular) error at logical %llu on dev %s",
+				    logical, rcu_string_dereference(dev->name));
 	}
 
 out:
@@ -2387,15 +2389,15 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 		sctx->stat.read_errors++;
 		spin_unlock(&sctx->stat_lock);
 		btrfs_err_rl_in_rcu(fs_info,
-			"IO error rebuilding logical %llu for dev %s",
-			logical, rcu_str_deref(dev->name));
+				    "IO error rebuilding logical %llu for dev %s",
+				    logical, rcu_string_dereference(dev->name));
 	} else if (sblock->header_error || sblock->checksum_error) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
 		btrfs_err_rl_in_rcu(fs_info,
-			"failed to rebuild valid logical %llu for dev %s",
-			logical, rcu_str_deref(dev->name));
+				    "failed to rebuild valid logical %llu for dev %s",
+				    logical, rcu_string_dereference(dev->name));
 	} else {
 		scrub_write_block_to_dev_replace(sblock);
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 12540b6104b5..e051fa3bfd93 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -42,6 +42,7 @@
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
 #include <linux/btrfs.h>
+#include <linux/rcustring.h>
 #include "delayed-inode.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -54,7 +55,6 @@
 #include "volumes.h"
 #include "export.h"
 #include "compression.h"
-#include "rcu-string.h"
 #include "dev-replace.h"
 #include "free-space-cache.h"
 #include "backref.h"
@@ -2221,7 +2221,6 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_device *dev, *first_dev = NULL;
 	struct list_head *head;
-	struct rcu_string *name;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	cur_devices = fs_info->fs_devices;
@@ -2240,8 +2239,8 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 
 	if (first_dev) {
 		rcu_read_lock();
-		name = rcu_dereference(first_dev->name);
-		seq_escape(m, name->str, " \t\n\\");
+		seq_escape(m, rcu_string_dereference(first_dev->name),
+			   " \t\n\\");
 		rcu_read_unlock();
 	} else {
 		WARN_ON(1);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bd679bc7a1a9..4010c35898d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -25,6 +25,7 @@
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
+#include <linux/rcustring.h>
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
 #include <asm/div64.h>
@@ -37,7 +38,6 @@
 #include "raid56.h"
 #include "async-thread.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "math.h"
 #include "dev-replace.h"
 #include "sysfs.h"
@@ -584,8 +584,8 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			del = strcmp(rcu_str_deref(dev->name),
-						rcu_str_deref(cur_dev->name));
+			del = strcmp(rcu_string_dereference(dev->name),
+				     rcu_string_dereference(cur_dev->name));
 			rcu_read_unlock();
 			if (!del)
 				break;
@@ -3540,8 +3540,9 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			ret = PTR_ERR(trans);
 			btrfs_info_in_rcu(fs_info,
 		 "resize: unable to start transaction after shrinking device %s (error %d), old size %llu, new size %llu",
-					  rcu_str_deref(device->name), ret,
-					  old_size, old_size - size_to_free);
+					  rcu_string_dereference(device->name),
+					  ret, old_size,
+					  old_size - size_to_free);
 			goto error;
 		}
 
@@ -3552,8 +3553,9 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			WARN_ON(ret > 0);
 			btrfs_info_in_rcu(fs_info,
 		 "resize: unable to grow device after shrinking device %s (error %d), old size %llu, new size %llu",
-					  rcu_str_deref(device->name), ret,
-					  old_size, old_size - size_to_free);
+					  rcu_string_dereference(device->name),
+					  ret, old_size,
+					  old_size - size_to_free);
 			goto error;
 		}
 
@@ -7014,8 +7016,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
 	if (ret < 0) {
 		btrfs_warn_in_rcu(fs_info,
-			"error %d while searching for dev_stats item for device %s",
-			      ret, rcu_str_deref(device->name));
+				  "error %d while searching for dev_stats item for device %s",
+				  ret, rcu_string_dereference(device->name));
 		goto out;
 	}
 
@@ -7025,8 +7027,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_item(trans, dev_root, path);
 		if (ret != 0) {
 			btrfs_warn_in_rcu(fs_info,
-				"delete too small dev_stats item for device %s failed %d",
-				      rcu_str_deref(device->name), ret);
+					  "delete too small dev_stats item for device %s failed %d",
+					  rcu_string_dereference(device->name),
+					  ret);
 			goto out;
 		}
 		ret = 1;
@@ -7039,8 +7042,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 					      &key, sizeof(*ptr));
 		if (ret < 0) {
 			btrfs_warn_in_rcu(fs_info,
-				"insert dev_stats item for device %s failed %d",
-				rcu_str_deref(device->name), ret);
+					  "insert dev_stats item for device %s failed %d",
+					  rcu_string_dereference(device->name),
+					  ret);
 			goto out;
 		}
 	}
@@ -7094,13 +7098,13 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 	if (!dev->dev_stats_valid)
 		return;
 	btrfs_err_rl_in_rcu(dev->fs_info,
-		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
-			   rcu_str_deref(dev->name),
-			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
-			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
-			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
-			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
-			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_GENERATION_ERRS));
+			    "bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
+			    rcu_string_dereference(dev->name),
+			    btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
+			    btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
+			    btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
+			    btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
+			    btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_GENERATION_ERRS));
 }
 
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
@@ -7114,13 +7118,13 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 		return; /* all values == 0, suppress message */
 
 	btrfs_info_in_rcu(dev->fs_info,
-		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
-	       rcu_str_deref(dev->name),
-	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
-	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
-	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
-	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
-	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_GENERATION_ERRS));
+			  "bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
+			  rcu_string_dereference(dev->name),
+			  btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
+			  btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
+			  btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
+			  btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
+			  btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_GENERATION_ERRS));
 }
 
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
new file mode 100644
index 000000000000..d73cfcd7de5a
--- /dev/null
+++ b/include/linux/rcustring.h
@@ -0,0 +1,97 @@
+/*
+ * RCU-friendly strings
+ *
+ * Copyright (C) 2012 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
+ */
+
+#ifndef _LINUX_RCUSTRING_H
+#define _LINUX_RCUSTRING_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/printk.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+
+struct rcu_string {
+	struct rcu_head rcu;
+	char str[0];
+};
+
+/**
+ * rcu_string_strdup() - create an RCU string from a string
+ * @src: The string to copy
+ * @flags: Flags for kmalloc
+ */
+static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t flags)
+{
+	struct rcu_string *ret;
+	size_t len = strlen(src) + 1;
+
+	ret = kmalloc(sizeof(*ret) + (len * sizeof(char)), flags);
+	if (ret)
+		memcpy(ret->str, src, len);
+	return ret;
+}
+
+/**
+ * rcu_string_free() - free an RCU string
+ * @str: The string
+ */
+static inline void rcu_string_free(struct rcu_string *str)
+{
+	if (str)
+		kfree_rcu(str, rcu);
+}
+
+/**
+ * rcu_string_dereference() - dereference an RCU string
+ * @str: The string
+ *
+ * Like rcu_dereference, this must be done in an RCU critical section.
+ */
+static inline char *rcu_string_dereference(struct rcu_string __rcu *rcu_str)
+{
+	return rcu_dereference(rcu_str)->str;
+}
+
+/**
+ * printk_in_rcu() - printk in an RCU read-side critical section
+ * @fmt: Format string
+ * @...: Values
+ */
+#define printk_in_rcu(fmt, ...)			\
+	do {					\
+		rcu_read_lock();		\
+		printk(fmt, ##__VA_ARGS__);	\
+		rcu_read_unlock();		\
+	} while (0)
+
+/**
+ * printk_ratelimited_in_rcu() - printk_ratelimited in an RCU read-side critical
+ * section
+ * @fmt: Format string
+ * @...: Values
+ */
+#define printk_ratelimited_in_rcu(fmt, ...)		\
+	do {						\
+		rcu_read_lock();			\
+		printk_ratelimited(fmt, ##__VA_ARGS__);	\
+		rcu_read_unlock();			\
+	} while (0)
+
+#endif
-- 
2.14.1

