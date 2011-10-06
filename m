From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 09/18] btrfs: qgroup state and initialization
Date: Thu,  6 Oct 2011 17:54:19 +0200
Message-ID: <1579efc0b03fdaa80effc51c6581fcab63d10015.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add state to fs_info.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |   32 ++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |    7 +++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 09c58e5..49f97d8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -958,6 +958,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *quota_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -1185,6 +1186,30 @@ struct btrfs_fs_info {
 	int scrub_workers_refcnt;
 	struct btrfs_workers scrub_workers;
 
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
+
 	/* filesystem state */
 	u64 fs_state;
 
@@ -2845,4 +2870,11 @@ int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid);
 int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress);
 
+static inline int is_fstree(u64 rootid)
+{
+	if (rootid == BTRFS_FS_TREE_OBJECTID ||
+	    (s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+	return 0;
+}
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 672747d..cb25017 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1825,6 +1825,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
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

