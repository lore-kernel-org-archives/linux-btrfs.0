From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 3/5] btrfs: droptree structures and initialization
Date: Thu, 12 Apr 2012 17:54:40 +0200
Message-ID: <30fbc3b4f9f1b38bb44375beafd175158d85cbc2.1334241664.git.sensille@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add the fs-global state and initialization for snapshot deletion

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |   35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |   18 ++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e187ab9..8eb0795 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1257,6 +1257,41 @@ struct btrfs_fs_info {
 
 	/* next backup root to be overwritten */
 	int backup_root_index;
+
+	/*
+	 * global state for snapshot deletion via readahead. All fields are
+	 * protected by droptree_lock. droptree_lock is a mutex and not a
+	 * spinlock as allocations are done inside and we don't want to use
+	 * atomic allocations unless we really have to.
+	 */
+	struct mutex droptree_lock;
+
+	/*
+	 * currently running requests (droptree_nodes) for each level and
+	 * the corresponding limits. It's necessary to limit them to have
+	 * an upper limit on the state that has to be written with each
+	 * commit. All nodes exceeding the limit are enqueued to droptree_queue.
+	 */
+	long droptree_req[BTRFS_MAX_LEVEL + 1];
+	long droptree_limit[BTRFS_MAX_LEVEL + 1];
+	struct list_head droptree_queue[BTRFS_MAX_LEVEL + 1];
+
+	/*
+	 * when droptree is paused, all currently running requests are moved
+	 * to droptree_restart. All nodes in droptree_queue are moved to
+	 * droptree_requeue
+	 */
+	struct list_head droptree_restart;
+	struct list_head droptree_requeue;
+
+	/*
+	 * synchronization for pause/restart. droptree_rc is the top-level
+	 * reada_control, used to cancel all running requests
+	 */
+	int droptrees_running;
+	int droptree_pause_req;
+	wait_queue_head_t droptree_wait;
+	struct reada_control *droptree_rc;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b801d29..7b3ddd7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1911,6 +1911,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
+	int i;
 
 	extent_root = fs_info->extent_root =
 		kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
@@ -1989,6 +1990,23 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
 	spin_lock_init(&fs_info->reada_lock);
 
+	/* snapshot deletion state */
+	mutex_init(&fs_info->droptree_lock);
+	fs_info->droptree_pause_req = 0;
+	fs_info->droptrees_running = 0;
+	for (i = 0; i < BTRFS_MAX_LEVEL; ++i) {
+		fs_info->droptree_limit[i] = 100;
+		fs_info->droptree_req[i] = 0;
+		INIT_LIST_HEAD(fs_info->droptree_queue + i);
+	}
+	/* FIXME calculate some sane values, maybe based on avail RAM */
+	fs_info->droptree_limit[0] = 40000;
+	fs_info->droptree_limit[1] = 10000;
+	fs_info->droptree_limit[2] = 4000;
+	INIT_LIST_HEAD(&fs_info->droptree_restart);
+	INIT_LIST_HEAD(&fs_info->droptree_requeue);
+	init_waitqueue_head(&fs_info->droptree_wait);
+
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
 
-- 
1.7.3.4

