From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 5/6] btrfs: add state information for scrub
Date: Fri, 11 Mar 2011 15:49:42 +0100
Message-ID: <2280f3a33ef55a94c905665238ecbec282a63185.1299854593.git.sensille@gmx.net>
References: <cover.1299854593.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299854593.git.sensille@gmx.net>
In-Reply-To: <cover.1299854593.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add structures and state information needed for scrub

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |   26 ++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |   15 +++++++++++++++
 fs/btrfs/ioctl.h   |   17 +++++++++++++++++
 fs/btrfs/volumes.h |    3 +++
 4 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 030c321..3584179 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/fs.h>
+#include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
@@ -32,6 +33,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "ioctl.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -48,6 +50,8 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
+#define SCRUB_BTRFS_WORKER
+
 /*
  * files bigger than this get some pre-flushing when they are added
  * to the ordered operations list.  That way we limit the total
@@ -508,6 +512,12 @@ struct btrfs_extent_item_v0 {
 /* use full backrefs for extent pointers in the block */
 #define BTRFS_BLOCK_FLAG_FULL_BACKREF	(1ULL << 8)
 
+/*
+ * this flag is only used internally by scrub and may be changed at any time
+ * it is only declared here to avoid collisions
+ */
+#define BTRFS_EXTENT_FLAG_SUPER		(1ULL << 48)
+
 struct btrfs_tree_block_info {
 	struct btrfs_disk_key key;
 	u8 level;
@@ -1067,6 +1077,22 @@ struct btrfs_fs_info {
 
 	void *bdev_holder;
 
+	/* private scrub information */
+	struct mutex scrub_lock;
+	struct scrub_info *scrub_info;
+	atomic_t scrubs_running;
+	atomic_t scrub_pause_req;
+	atomic_t scrubs_paused;
+	atomic_t scrub_cancel_req;
+	wait_queue_head_t scrub_pause_wait;
+	struct rw_semaphore scrub_super_lock;
+	int scrub_workers_refcnt;
+#ifdef SCRUB_BTRFS_WORKER
+	struct btrfs_workers scrub_workers;
+#else
+	struct workqueue_struct *scrub_workers;
+#endif
+
 	/* filesystem state */
 	u64 fs_state;
 };
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 924a366..4d62bc3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1677,6 +1677,21 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->ordered_extents);
 	spin_lock_init(&fs_info->ordered_extent_lock);
 
+	mutex_init(&fs_info->scrub_lock);
+	atomic_set(&fs_info->scrubs_running, 0);
+	atomic_set(&fs_info->scrub_pause_req, 0);
+	atomic_set(&fs_info->scrubs_paused, 0);
+	atomic_set(&fs_info->scrub_cancel_req, 0);
+	init_waitqueue_head(&fs_info->scrub_pause_wait);
+	init_rwsem(&fs_info->scrub_super_lock);
+	fs_info->scrub_workers_refcnt = 0;
+#ifdef SCRUB_BTRFS_WORKER
+	btrfs_init_workers(&fs_info->scrub_workers, "scrub",
+			   fs_info->thread_pool_size, &fs_info->generic_worker);
+#else
+	fs_info->scrub_workers = NULL;
+#endif
+
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 8fb3821..973e7c8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -42,6 +42,23 @@ struct btrfs_ioctl_vol_args_v2 {
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
+struct btrfs_scrub_progress {
+	__u64 data_extents_scrubbed;
+	__u64 tree_extents_scrubbed;
+	__u64 data_bytes_scrubbed;
+	__u64 tree_bytes_scrubbed;
+	__u64 read_errors;
+	__u64 csum_errors;
+	__u64 verify_errors;
+	__u64 no_csum;
+	__u64 csum_discards;
+	__u64 super_errors;
+	__u64 malloc_errors;
+	__u64 uncorrectable_errors;
+	__u64 corrected_errors;
+	__u64 last_physical;
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0ccc982..92204d9 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -86,6 +86,9 @@ struct btrfs_device {
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 
+	/* per-device scrub information */
+	struct scrub_dev *scrub_device;
+
 	struct btrfs_work work;
 };
 
-- 
1.7.3.4

