Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46305 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab2ETQGk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:40 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 17/24] Btrfs: qgroup state and initialization
Date: Sun, 20 May 2012 18:06:28 +0200
Message-Id: <008c695d681fa072ec50c87a41bb0b7a1bfbfc23.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Add state to fs_info.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |   31 +++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |    7 +++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 283c992..2b6f003 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1102,6 +1102,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *quota_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -1354,6 +1355,29 @@ struct btrfs_fs_info {
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
@@ -3260,4 +3284,11 @@ void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 			    struct seq_list *elem);
 
+static inline int is_fstree(u64 rootid)
+{
+	if (rootid == BTRFS_FS_TREE_OBJECTID ||
+	    (s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+	return 0;
+}
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0c7ac16..d42ad71 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2106,6 +2106,13 @@ int open_ctree(struct super_block *sb,
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

