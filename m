Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:21803 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 30.22 OK)
	with ESMTP id g022fdoA6Asgwy for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/26] Btrfs: enhance btrfs structures for device replace support
Date: Tue,  6 Nov 2012 17:38:31 +0100
Message-Id: <cbc2d3cf05205599d3d12dff786e2986a539a277.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   | 39 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |  5 +++++
 2 files changed, 44 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ef83538..57961f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -885,6 +885,42 @@ struct btrfs_dev_stats_item {
 	__le64 values[BTRFS_DEV_STAT_VALUES_MAX];
 } __attribute__ ((__packed__));
 
+#define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
+#define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID	1
+#define BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED	0
+#define BTRFS_DEV_REPLACE_ITEM_STATE_STARTED		1
+#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED		2
+#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED		3
+#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED		4
+
+struct btrfs_dev_replace {
+	u64 replace_state;	/* see #define above */
+	u64 time_started;	/* seconds since 1-Jan-1970 */
+	u64 time_stopped;	/* seconds since 1-Jan-1970 */
+	atomic64_t num_write_errors;
+	atomic64_t num_uncorrectable_read_errors;
+
+	u64 cursor_left;
+	u64 committed_cursor_left;
+	u64 cursor_left_last_write_of_item;
+	u64 cursor_right;
+
+	u64 cont_reading_from_srcdev_mode;	/* see #define above */
+
+	int is_valid;
+	int item_needs_writeback;
+	struct btrfs_device *srcdev;
+	struct btrfs_device *tgtdev;
+
+	pid_t lock_owner;
+	atomic_t nesting_level;
+	struct mutex lock_finishing_cancel_unmount;
+	struct mutex lock_management_lock;
+	struct mutex lock;
+
+	struct btrfs_scrub_progress scrub_progress;
+};
+
 /* different types of block groups (and chunks) */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1471,6 +1507,9 @@ struct btrfs_fs_info {
 	int backup_root_index;
 
 	int num_tolerated_disk_barrier_failures;
+
+	/* device replace state */
+	struct btrfs_dev_replace dev_replace;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 53ab3cd..bdf6345 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2131,6 +2131,11 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
+	fs_info->dev_replace.lock_owner = 0;
+	atomic_set(&fs_info->dev_replace.nesting_level, 0);
+	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
+	mutex_init(&fs_info->dev_replace.lock_management_lock);
+	mutex_init(&fs_info->dev_replace.lock);
 
 	spin_lock_init(&fs_info->qgroup_lock);
 	fs_info->qgroup_tree = RB_ROOT;
-- 
1.8.0

