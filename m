Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38314 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:17 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 12/17] btrfs: expire submit buffer on timeout
Date: Fri, 10 Aug 2018 03:04:45 +0900
Message-Id: <20180809180450.5091-13-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is possible to have bios stalled in the submit buffer due to some bug or
device problem. In such such situation, btrfs stops working waiting for
buffered bios completions. To avoid such hang, add a worker that will
cancel the stalled bios after an expiration time out.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/async-thread.c |  1 +
 fs/btrfs/async-thread.h |  1 +
 fs/btrfs/ctree.h        |  5 +++
 fs/btrfs/disk-io.c      |  7 +++-
 fs/btrfs/extent-tree.c  | 20 ++++++++++
 fs/btrfs/super.c        | 20 ++++++++++
 fs/btrfs/volumes.c      | 83 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h      |  1 +
 8 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d522494698fa..86735dfbabcc 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -109,6 +109,7 @@ BTRFS_WORK_HELPER(scrub_helper);
 BTRFS_WORK_HELPER(scrubwrc_helper);
 BTRFS_WORK_HELPER(scrubnc_helper);
 BTRFS_WORK_HELPER(scrubparity_helper);
+BTRFS_WORK_HELPER(bio_expire_helper);
 
 static struct __btrfs_workqueue *
 __btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 7861c9feba5f..2c041f0668d4 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -54,6 +54,7 @@ BTRFS_WORK_HELPER_PROTO(scrub_helper);
 BTRFS_WORK_HELPER_PROTO(scrubwrc_helper);
 BTRFS_WORK_HELPER_PROTO(scrubnc_helper);
 BTRFS_WORK_HELPER_PROTO(scrubparity_helper);
+BTRFS_WORK_HELPER_PROTO(bio_expire_helper);
 
 
 struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ebbbf46aa540..8f85c96cd262 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -699,6 +699,10 @@ struct btrfs_block_group_cache {
 	spinlock_t submit_lock;
 	u64 submit_offset;
 	struct list_head submit_buffer;
+	struct btrfs_work work;
+	unsigned long last_submit;
+	int expired:1;
+	struct task_struct *expire_thread;
 };
 
 /* delayed seq elem */
@@ -974,6 +978,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *submit_workers;
 	struct btrfs_workqueue *caching_workers;
 	struct btrfs_workqueue *readahead_workers;
+	struct btrfs_workqueue *bio_expire_workers;
 
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6a014632ca1e..00fa6aca9bb5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2040,6 +2040,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_destroy_workqueue(fs_info->endio_meta_workers);
 	btrfs_destroy_workqueue(fs_info->endio_meta_write_workers);
+	btrfs_destroy_workqueue(fs_info->bio_expire_workers);
 }
 
 static void free_root_extent_buffers(struct btrfs_root *root)
@@ -2245,6 +2246,9 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
 		btrfs_alloc_workqueue(fs_info, "extent-refs", flags,
 				      min_t(u64, fs_devices->num_devices,
 					    max_active), 8);
+	fs_info->bio_expire_workers =
+		btrfs_alloc_workqueue(fs_info, "bio-expire", flags,
+				      max_active, 0);
 
 	if (!(fs_info->workers && fs_info->delalloc_workers &&
 	      fs_info->submit_workers && fs_info->flush_workers &&
@@ -2256,7 +2260,8 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
 	      fs_info->caching_workers && fs_info->readahead_workers &&
 	      fs_info->fixup_workers && fs_info->delayed_workers &&
 	      fs_info->extent_workers &&
-	      fs_info->qgroup_rescan_workers)) {
+	      fs_info->qgroup_rescan_workers &&
+	      fs_info->bio_expire_workers)) {
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6b7b632b0791..a5f5935315c8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9745,6 +9745,14 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		    block_group->cached == BTRFS_CACHE_ERROR)
 			free_excluded_extents(block_group);
 
+		if (block_group->alloc_type == BTRFS_ALLOC_SEQ) {
+			spin_lock(&block_group->submit_lock);
+			if (block_group->expire_thread)
+				wake_up_process(block_group->expire_thread);
+			spin_unlock(&block_group->submit_lock);
+			flush_work(&block_group->work.normal_work);
+		}
+
 		btrfs_remove_free_space_cache(block_group);
 		ASSERT(block_group->cached != BTRFS_CACHE_STARTED);
 		ASSERT(list_empty(&block_group->dirty_list));
@@ -10061,6 +10069,10 @@ btrfs_get_block_group_alloc_offset(struct btrfs_block_group_cache *cache)
 	}
 
 	cache->submit_offset = logical + cache->alloc_offset;
+	btrfs_init_work(&cache->work, btrfs_bio_expire_helper,
+			expire_bios_fn, NULL, NULL);
+	cache->last_submit = 0;
+	cache->expired = 0;
 
 out:
 	cache->alloc_type = alloc_type;
@@ -10847,6 +10859,14 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		}
 		spin_unlock(&fs_info->unused_bgs_lock);
 
+		if (block_group->alloc_type == BTRFS_ALLOC_SEQ) {
+			spin_lock(&block_group->submit_lock);
+			if (block_group->expire_thread)
+				wake_up_process(block_group->expire_thread);
+			spin_unlock(&block_group->submit_lock);
+			flush_work(&block_group->work.normal_work);
+		}
+
 		mutex_lock(&fs_info->delete_unused_bgs_mutex);
 
 		/* Don't want to race with allocators so take the groups_sem */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cc812e459197..4d1d6cc7cd59 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -154,6 +154,25 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	 * completes. The next time when the filesystem is mounted writeable
 	 * again, the device replace operation continues.
 	 */
+
+	/* expire pending bios in submit buffer */
+	if (btrfs_fs_incompat(fs_info, HMZONED)) {
+		struct btrfs_block_group_cache *block_group;
+		struct rb_node *node;
+
+		spin_lock(&fs_info->block_group_cache_lock);
+		for (node = rb_first(&fs_info->block_group_cache_tree); node;
+		     node = rb_next(node)) {
+			block_group = rb_entry(node,
+					       struct btrfs_block_group_cache,
+					       cache_node);
+			spin_lock(&block_group->submit_lock);
+			if (block_group->expire_thread)
+				wake_up_process(block_group->expire_thread);
+			spin_unlock(&block_group->submit_lock);
+		}
+		spin_unlock(&fs_info->block_group_cache_lock);
+	}
 }
 
 #ifdef CONFIG_PRINTK
@@ -1730,6 +1749,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->scrub_wr_completion_workers,
 				new_pool_size);
+	btrfs_workqueue_set_max(fs_info->bio_expire_workers, new_pool_size);
 }
 
 static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ca03b7136892..0e68003a429d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6498,6 +6498,7 @@ static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
 	struct btrfs_block_group_cache *cache = NULL;
 	int sent;
 	LIST_HEAD(submit_list);
+	int should_queue = 1;
 
 	WARN_ON(bio_op(bbio->orig_bio) != REQ_OP_WRITE);
 
@@ -6512,7 +6513,21 @@ static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
 	bbio->need_seqwrite = 1;
 
 	spin_lock(&cache->submit_lock);
-	if (cache->submit_offset == logical)
+
+	if (cache->expired) {
+		int i, total_devs = bbio->num_stripes;
+
+		spin_unlock(&cache->submit_lock);
+		btrfs_err(cache->fs_info,
+			  "IO in expired block group %llu+%llu",
+			  logical, length);
+		for (i = 0; i < total_devs; i++)
+			bbio_error(bbio, bbio->orig_bio, logical);
+		btrfs_put_block_group(cache);
+		return;
+	}
+
+	if (cache->submit_offset == logical || cache->expired)
 		goto send_bios;
 
 	if (cache->submit_offset > logical) {
@@ -6527,7 +6542,11 @@ static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
 
 	/* buffer the unaligned bio */
 	list_add_tail(&bbio->list, &cache->submit_buffer);
+	should_queue = !cache->last_submit;
+	cache->last_submit = jiffies;
 	spin_unlock(&cache->submit_lock);
+	if (should_queue)
+		btrfs_queue_work(fs_info->bio_expire_workers, &cache->work);
 	btrfs_put_block_group(cache);
 
 	return;
@@ -6561,6 +6580,14 @@ static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
 			}
 		}
 	} while (sent);
+
+	if (list_empty(&cache->submit_buffer)) {
+		should_queue = 0;
+		cache->last_submit = 0;
+	} else {
+		should_queue = !cache->last_submit;
+		cache->last_submit = jiffies;
+	}
 	spin_unlock(&cache->submit_lock);
 
 	/* send the collected bios */
@@ -6572,6 +6599,8 @@ static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
 
 	if (length)
 		goto loop;
+	if (should_queue)
+		btrfs_queue_work(fs_info->bio_expire_workers, &cache->work);
 	btrfs_put_block_group(cache);
 }
 
@@ -6632,6 +6661,58 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
+void expire_bios_fn(struct btrfs_work *work)
+{
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_bio *bbio, *next;
+	unsigned long expire_time, cur;
+	unsigned long expire = 90 * HZ;
+	LIST_HEAD(submit_list);
+
+	cache = container_of(work, struct btrfs_block_group_cache, work);
+	btrfs_get_block_group(cache);
+loop:
+	spin_lock(&cache->submit_lock);
+	cache->expire_thread = current;
+	if (list_empty(&cache->submit_buffer)) {
+		cache->last_submit = 0;
+		cache->expire_thread = NULL;
+		spin_unlock(&cache->submit_lock);
+		btrfs_put_block_group(cache);
+		return;
+	}
+	cur = jiffies;
+	expire_time = cache->last_submit + expire;
+	if (time_before(cur, expire_time) && !sb_rdonly(cache->fs_info->sb)) {
+		spin_unlock(&cache->submit_lock);
+		schedule_timeout_interruptible(expire_time - cur);
+		goto loop;
+	}
+
+	list_splice_init(&cache->submit_buffer, &submit_list);
+	cache->expired = 1;
+	cache->expire_thread = NULL;
+	spin_unlock(&cache->submit_lock);
+
+	btrfs_handle_fs_error(cache->fs_info, -EIO,
+			      "bio submit buffer expired");
+	btrfs_err(cache->fs_info, "block group %llu submit pos %llu",
+		  cache->key.objectid, cache->submit_offset);
+
+	list_for_each_entry_safe(bbio, next, &submit_list, list) {
+		u64 logical = (u64)bbio->orig_bio->bi_iter.bi_sector << 9;
+		int i, total_devs = bbio->num_stripes;
+
+		btrfs_err(cache->fs_info, "expiring %llu", logical);
+		list_del_init(&bbio->list);
+		for (i = 0; i < total_devs; i++)
+			bbio_error(bbio, bbio->orig_bio, logical);
+	}
+
+	cache->last_submit = 0;
+	btrfs_put_block_group(cache);
+}
+
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3db90f5395cd..2a3c046fa31b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -415,6 +415,7 @@ void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num, int async_submit);
+void expire_bios_fn(struct btrfs_work *work);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
-- 
2.18.0

