Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:30924 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.1 OK) with ESMTP id p01bfcoA6DKxNb
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/26] Btrfs: introduce a btrfs_dev_replace_item type
Date: Tue,  6 Nov 2012 17:38:32 +0100
Message-Id: <67a4ceb0ccdbf5b9f7d6a76c384eef4421d8e526.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h      | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/print-tree.c |  3 +++
 2 files changed, 69 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 57961f1..4bffc63 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -921,6 +921,23 @@ struct btrfs_dev_replace {
 	struct btrfs_scrub_progress scrub_progress;
 };
 
+struct btrfs_dev_replace_item {
+	/*
+	 * grow this item struct at the end for future enhancements and keep
+	 * the existing values unchanged
+	 */
+	__le64 src_devid;
+	__le64 cursor_left;
+	__le64 cursor_right;
+	__le64 cont_reading_from_srcdev_mode;
+
+	__le64 replace_state;
+	__le64 time_started;
+	__le64 time_stopped;
+	__le64 num_write_errors;
+	__le64 num_uncorrectable_read_errors;
+} __attribute__ ((__packed__));
+
 /* different types of block groups (and chunks) */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1763,6 +1780,12 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_DEV_STATS_KEY	249
 
 /*
+ * Persistantly stores the device replace state in the device tree.
+ * The key is built like this: (0, BTRFS_DEV_REPLACE_KEY, 0).
+ */
+#define BTRFS_DEV_REPLACE_KEY	250
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -2796,6 +2819,49 @@ BTRFS_SETGET_FUNCS(qgroup_limit_rsv_rfer, struct btrfs_qgroup_limit_item,
 BTRFS_SETGET_FUNCS(qgroup_limit_rsv_excl, struct btrfs_qgroup_limit_item,
 		   rsv_excl, 64);
 
+/* btrfs_dev_replace_item */
+BTRFS_SETGET_FUNCS(dev_replace_src_devid,
+		   struct btrfs_dev_replace_item, src_devid, 64);
+BTRFS_SETGET_FUNCS(dev_replace_cont_reading_from_srcdev_mode,
+		   struct btrfs_dev_replace_item, cont_reading_from_srcdev_mode,
+		   64);
+BTRFS_SETGET_FUNCS(dev_replace_replace_state, struct btrfs_dev_replace_item,
+		   replace_state, 64);
+BTRFS_SETGET_FUNCS(dev_replace_time_started, struct btrfs_dev_replace_item,
+		   time_started, 64);
+BTRFS_SETGET_FUNCS(dev_replace_time_stopped, struct btrfs_dev_replace_item,
+		   time_stopped, 64);
+BTRFS_SETGET_FUNCS(dev_replace_num_write_errors, struct btrfs_dev_replace_item,
+		   num_write_errors, 64);
+BTRFS_SETGET_FUNCS(dev_replace_num_uncorrectable_read_errors,
+		   struct btrfs_dev_replace_item, num_uncorrectable_read_errors,
+		   64);
+BTRFS_SETGET_FUNCS(dev_replace_cursor_left, struct btrfs_dev_replace_item,
+		   cursor_left, 64);
+BTRFS_SETGET_FUNCS(dev_replace_cursor_right, struct btrfs_dev_replace_item,
+		   cursor_right, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_src_devid,
+			 struct btrfs_dev_replace_item, src_devid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_cont_reading_from_srcdev_mode,
+			 struct btrfs_dev_replace_item,
+			 cont_reading_from_srcdev_mode, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_replace_state,
+			 struct btrfs_dev_replace_item, replace_state, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_time_started,
+			 struct btrfs_dev_replace_item, time_started, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_time_stopped,
+			 struct btrfs_dev_replace_item, time_stopped, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_num_write_errors,
+			 struct btrfs_dev_replace_item, num_write_errors, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_num_uncorrectable_read_errors,
+			 struct btrfs_dev_replace_item,
+			 num_uncorrectable_read_errors, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_cursor_left,
+			 struct btrfs_dev_replace_item, cursor_left, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_cursor_right,
+			 struct btrfs_dev_replace_item, cursor_right, 64);
+
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 5e23684..50d95fd 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -297,6 +297,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_STATS_KEY:
 			printk(KERN_INFO "\t\tdevice stats\n");
 			break;
+		case BTRFS_DEV_REPLACE_KEY:
+			printk(KERN_INFO "\t\tdev replace\n");
+			break;
 		};
 	}
 }
-- 
1.8.0

