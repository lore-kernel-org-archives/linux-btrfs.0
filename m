Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33240 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 07/15] Btrfs: qgroup state and initialization
Date: Thu, 12 Jul 2012 11:43:39 +0200
Message-Id: <416ac51da90e98daaac17e1f359a6c5591f7f5bd.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Add state to fs_info.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |   24 ++++++++++++++++++++++++
 fs/btrfs/disk-io.c |    7 +++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 27cf995..a5269d4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1120,6 +1120,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *quota_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -1374,6 +1375,29 @@ struct btrfs_fs_info {
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	u32 check_integrity_print_mask;
 #endif
+	/*
+	 * quota information
+	 */
+	unsigned int quota_enabled:1;
+
+	/*
+	 * quota_enabled only changes state after a commit. This holds the
+	 * next state.
+	 */
+	unsigned int pending_quota_state:1;
+
+	/* is qgroup tracking in a consistent state? */
+	u64 qgroup_flags;
+
+	/* holds configuration and tracking. Protected by qgroup_lock */
+	struct rb_root qgroup_tree;
+	spinlock_t qgroup_lock;
+
+	/* list of dirty qgroups to be written at next commit */
+	struct list_head dirty_qgroups;
+
+	/* used by btrfs_qgroup_record_ref for an efficient tree traversal */
+	u64 qgroup_seq;
 
 	/* filesystem state */
 	u64 fs_state;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fc243e..eca0549 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2110,6 +2110,13 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
 
+	spin_lock_init(&fs_info->qgroup_lock);
+	fs_info->qgroup_tree = RB_ROOT;
+	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
+	fs_info->qgroup_seq = 1;
+	fs_info->quota_enabled = 0;
+	fs_info->pending_quota_state = 0;
+
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
 
-- 
1.7.3.4

