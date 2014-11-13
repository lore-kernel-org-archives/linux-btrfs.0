Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35434 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaKMKSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 05:18:45 -0500
Received: by mail-pd0-f171.google.com with SMTP id r10so14216192pdi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 02:18:45 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v7] Move BTRFS RCU string to common library
Date: Thu, 13 Nov 2014 02:18:21 -0800
Message-Id: <1415873901-5618-1-git-send-email-osandov@osandov.com>
In-Reply-To: <1415463217.23530.26.camel@perches.com>
References: <1415463217.23530.26.camel@perches.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The RCU-friendly string API used internally by BTRFS is generic enough for
common use. This doesn't add any new functionality, but instead just moves the
code and documents the existing API.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Alright, here's one more go at it.

v7: Add arguments to kernel doc for printk wrappers, use ##__VA_ARGS
v6: Add header dependencies to rcustring.h
v5: Rebase against v3.18-rc3
v4: Don't return anything from the printk wrappers on the assumption that
printk will return void someday
v3: Add __rcu annotation to relevant functions, add Paul's ack and Josh's
review

 fs/btrfs/check-integrity.c |  6 +--
 fs/btrfs/dev-replace.c     | 19 ++++-----
 fs/btrfs/disk-io.c         |  6 +--
 fs/btrfs/extent_io.c       |  4 +-
 fs/btrfs/ioctl.c           |  4 +-
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/rcu-string.h      | 56 --------------------------
 fs/btrfs/scrub.c           | 15 +++----
 fs/btrfs/super.c           |  2 +-
 fs/btrfs/volumes.c         | 14 +++----
 include/linux/rcustring.h  | 99 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 136 insertions(+), 91 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index cb7f3fe..a894c94 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -94,6 +94,7 @@
 #include <linux/mutex.h>
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
+#include <linux/rcustring.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "hash.h"
@@ -103,7 +104,6 @@
 #include "print-tree.h"
 #include "locking.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 
 #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
 #define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
@@ -850,8 +850,8 @@ static int btrfsic_process_superblock_dev_mirror(
 			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p, %s)"
 				     " @%llu (%s/%llu/%d)\n",
 				     superblock_bdev,
-				     rcu_str_deref(device->name), dev_bytenr,
-				     dev_state->name, dev_bytenr,
+				     rcu_string_dereference(device->name),
+				     dev_bytenr, dev_state->name, dev_bytenr,
 				     superblock_mirror_num);
 		list_add(&superblock_tmp->all_blocks_node,
 			 &state->all_blocks_list);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f662b3..f697899 100644
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
 
@@ -384,9 +384,9 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+		      rcu_string_dereference(src_device->name),
 		      src_device->devid,
-		      rcu_str_deref(tgt_device->name));
+		      rcu_string_dereference(tgt_device->name));
 
 	/*
 	 * from now on, the writes to the srcdev are all duplicated to
@@ -531,9 +531,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		printk_in_rcu(KERN_ERR
 			      "BTRFS: btrfs_scrub_dev(%s, %llu, %s) failed %d\n",
 			      src_device->missing ? "<missing disk>" :
-			        rcu_str_deref(src_device->name),
+			      rcu_string_dereference(src_device->name),
 			      src_device->devid,
-			      rcu_str_deref(tgt_device->name), scrub_ret);
+			      rcu_string_dereference(tgt_device->name),
+			      scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace);
 		mutex_unlock(&root->fs_info->chunk_mutex);
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
@@ -548,9 +549,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s finished\n",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+		      rcu_string_dereference(src_device->name),
 		      src_device->devid,
-		      rcu_str_deref(tgt_device->name));
+		      rcu_string_dereference(tgt_device->name));
 	tgt_device->is_tgtdev_for_dev_replace = 0;
 	tgt_device->devid = src_device->devid;
 	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
@@ -817,10 +818,10 @@ static int btrfs_dev_replace_kthread(void *data)
 		printk_in_rcu(KERN_INFO
 			"BTRFS: continuing dev_replace from %s (devid %llu) to %s @%u%%\n",
 			dev_replace->srcdev->missing ? "<missing disk>" :
-			rcu_str_deref(dev_replace->srcdev->name),
+			rcu_string_dereference(dev_replace->srcdev->name),
 			dev_replace->srcdev->devid,
 			dev_replace->tgtdev ?
-			rcu_str_deref(dev_replace->tgtdev->name) :
+			rcu_string_dereference(dev_replace->tgtdev->name) :
 			"<missing target disk>",
 			(unsigned int)progress);
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f89..6e9d0e8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -31,6 +31,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
+#include <linux/rcustring.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -44,7 +45,6 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "dev-replace.h"
 #include "raid56.h"
 #include "sysfs.h"
@@ -3058,7 +3058,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 
 		printk_ratelimited_in_rcu(KERN_WARNING "BTRFS: lost page write due to "
 					  "I/O error on %s\n",
-					  rcu_str_deref(device->name));
+					  rcu_string_dereference(device->name));
 		/* note, we dont' set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
@@ -3247,7 +3247,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 		if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 			printk_in_rcu("BTRFS: disabling barriers on dev %s\n",
-				      rcu_str_deref(device->name));
+				      rcu_string_dereference(device->name));
 			device->nobarriers = 1;
 		} else if (!bio_flagged(bio, BIO_UPTODATE)) {
 			ret = -EIO;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf3f424..7435c64 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -11,6 +11,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/rcustring.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "ctree.h"
@@ -18,7 +19,6 @@
 #include "volumes.h"
 #include "check-integrity.h"
 #include "locking.h"
-#include "rcu-string.h"
 #include "backref.h"
 
 static struct kmem_cache *extent_state_cache;
@@ -2048,7 +2048,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	printk_ratelimited_in_rcu(KERN_INFO
 				  "BTRFS: read error corrected: ino %llu off %llu (dev %s sector %llu)\n",
 				  btrfs_ino(inode), start,
-				  rcu_str_deref(dev->name), sector);
+				  rcu_string_dereference(dev->name), sector);
 	bio_put(bio);
 	return 0;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4399f0c..9ebc3cc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -44,6 +44,7 @@
 #include <linux/uuid.h>
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
+#include <linux/rcustring.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -53,7 +54,6 @@
 #include "locking.h"
 #include "inode-map.h"
 #include "backref.h"
-#include "rcu-string.h"
 #include "send.h"
 #include "dev-replace.h"
 #include "props.h"
@@ -1596,7 +1596,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	new_size *= root->sectorsize;
 
 	printk_in_rcu(KERN_INFO "BTRFS: new size for %s is %llu\n",
-		      rcu_str_deref(device->name), new_size);
+		      rcu_string_dereference(device->name), new_size);
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 0);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 6a41631..66944b9 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -32,6 +32,7 @@
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
 #include <linux/vmalloc.h>
+#include <linux/rcustring.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -42,7 +43,6 @@
 #include "raid56.h"
 #include "async-thread.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 
 /* set when additional merges to this rbio are not allowed */
 #define RBIO_RMW_LOCKED_BIT	1
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
deleted file mode 100644
index 9e111e4..0000000
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
index efa0831..0a89364 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -18,6 +18,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
+#include <linux/rcustring.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "disk-io.h"
@@ -27,7 +28,6 @@
 #include "extent_io.h"
 #include "dev-replace.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "raid56.h"
 
 /*
@@ -512,7 +512,8 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 		printk_in_rcu(KERN_WARNING "BTRFS: %s at logical %llu on dev "
 			"%s, sector %llu, root %llu, inode %llu, offset %llu, "
 			"length %llu, links %u (path: %s)\n", swarn->errstr,
-			swarn->logical, rcu_str_deref(swarn->dev->name),
+			swarn->logical,
+			rcu_string_dereference(swarn->dev->name),
 			(unsigned long long)swarn->sector, root, inum, offset,
 			min(isize - offset, (u64)PAGE_SIZE), nlink,
 			(char *)(unsigned long)ipath->fspath->val[i]);
@@ -524,7 +525,7 @@ err:
 	printk_in_rcu(KERN_WARNING "BTRFS: %s at logical %llu on dev "
 		"%s, sector %llu, root %llu, inode %llu, offset %llu: path "
 		"resolving failed with ret=%d\n", swarn->errstr,
-		swarn->logical, rcu_str_deref(swarn->dev->name),
+		swarn->logical, rcu_string_dereference(swarn->dev->name),
 		(unsigned long long)swarn->sector, root, inum, offset, ret);
 
 	free_ipath(ipath);
@@ -582,7 +583,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 				"BTRFS: %s at logical %llu on dev %s, "
 				"sector %llu: metadata %s (level %d) in tree "
 				"%llu\n", errstr, swarn.logical,
-				rcu_str_deref(dev->name),
+				rcu_string_dereference(dev->name),
 				(unsigned long long)swarn.sector,
 				ref_level ? "node" : "leaf",
 				ret < 0 ? -1 : ref_level,
@@ -781,7 +782,7 @@ out:
 			num_uncorrectable_read_errors);
 		printk_ratelimited_in_rcu(KERN_ERR "BTRFS: "
 		    "unable to fixup (nodatasum) error at logical %llu on dev %s\n",
-			fixup->logical, rcu_str_deref(fixup->dev->name));
+		    fixup->logical, rcu_string_dereference(fixup->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -1183,7 +1184,7 @@ corrected_error:
 			spin_unlock(&sctx->stat_lock);
 			printk_ratelimited_in_rcu(KERN_ERR
 				"BTRFS: fixed up error at logical %llu on dev %s\n",
-				logical, rcu_str_deref(dev->name));
+				logical, rcu_string_dereference(dev->name));
 		}
 	} else {
 did_not_correct_error:
@@ -1192,7 +1193,7 @@ did_not_correct_error:
 		spin_unlock(&sctx->stat_lock);
 		printk_ratelimited_in_rcu(KERN_ERR
 			"BTRFS: unable to fixup (regular) error at logical %llu on dev %s\n",
-			logical, rcu_str_deref(dev->name));
+			logical, rcu_string_dereference(dev->name));
 	}
 
 out:
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91e..4df6a26 100644
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
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d47289c..2ad043d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/rcustring.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -37,7 +38,6 @@
 #include "raid56.h"
 #include "async-thread.h"
 #include "check-integrity.h"
-#include "rcu-string.h"
 #include "math.h"
 #include "dev-replace.h"
 #include "sysfs.h"
@@ -6448,7 +6448,7 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		printk_in_rcu(KERN_WARNING "BTRFS: "
 			"error %d while searching for dev_stats item for device %s!\n",
-			      ret, rcu_str_deref(device->name));
+			      ret, rcu_string_dereference(device->name));
 		goto out;
 	}
 
@@ -6459,7 +6459,7 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 		if (ret != 0) {
 			printk_in_rcu(KERN_WARNING "BTRFS: "
 				"delete too small dev_stats item for device %s failed %d!\n",
-				      rcu_str_deref(device->name), ret);
+				rcu_string_dereference(device->name), ret);
 			goto out;
 		}
 		ret = 1;
@@ -6472,8 +6472,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 					      &key, sizeof(*ptr));
 		if (ret < 0) {
 			printk_in_rcu(KERN_WARNING "BTRFS: "
-					  "insert dev_stats item for device %s failed %d!\n",
-				      rcu_str_deref(device->name), ret);
+				      "insert dev_stats item for device %s failed %d!\n",
+				      rcu_string_dereference(device->name), ret);
 			goto out;
 		}
 	}
@@ -6529,7 +6529,7 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 		return;
 	printk_ratelimited_in_rcu(KERN_ERR "BTRFS: "
 			   "bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
-			   rcu_str_deref(dev->name),
+			   rcu_string_dereference(dev->name),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
@@ -6549,7 +6549,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 
 	printk_in_rcu(KERN_INFO "BTRFS: "
 		   "bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
-	       rcu_str_deref(dev->name),
+	       rcu_string_dereference(dev->name),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
new file mode 100644
index 0000000..67277ab
--- /dev/null
+++ b/include/linux/rcustring.h
@@ -0,0 +1,99 @@
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
+static inline struct rcu_string __rcu *rcu_string_strdup(const char *src,
+							 gfp_t flags)
+{
+	struct rcu_string *ret;
+	size_t len = strlen(src) + 1;
+
+	ret = kmalloc(sizeof(*ret) + (len * sizeof(char)), flags);
+	if (!ret)
+		return ret;
+	memcpy(ret->str, src, len);
+	return ret;
+}
+
+/**
+ * rcu_string_free() - free an RCU string
+ * @str: The string
+ */
+static inline void rcu_string_free(struct rcu_string __rcu *str)
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
2.1.3

