Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37317 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:14 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 11/17] btrfs: introduce submit buffer
Date: Fri, 10 Aug 2018 03:04:44 +0900
Message-Id: <20180809180450.5091-12-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sequential allocation is not enough to maintain sequential delivery of
write IOs to the device. Various features (async compress, async checksum,
...) of btrfs affect ordering of the IOs. This patch introduce submit
buffer to sort WRITE bios belonging to a block group and sort them out
sequentially in increasing block address to achieve sequential write
sequences with submit_stripe_bio().

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/ctree.h       |   3 +
 fs/btrfs/extent-tree.c |   5 ++
 fs/btrfs/volumes.c     | 121 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h     |   3 +
 4 files changed, 128 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5060bcdcb72b..ebbbf46aa540 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -696,6 +696,9 @@ struct btrfs_block_group_cache {
 	 */
 	enum btrfs_alloc_type alloc_type;
 	u64 alloc_offset;
+	spinlock_t submit_lock;
+	u64 submit_offset;
+	struct list_head submit_buffer;
 };
 
 /* delayed seq elem */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d4355b9b494e..6b7b632b0791 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -105,6 +105,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 	if (atomic_dec_and_test(&cache->count)) {
 		WARN_ON(cache->pinned > 0);
 		WARN_ON(cache->reserved > 0);
+		WARN_ON(!list_empty(&cache->submit_buffer));
 
 		/*
 		 * If not empty, someone is still holding mutex of
@@ -10059,6 +10060,8 @@ btrfs_get_block_group_alloc_offset(struct btrfs_block_group_cache *cache)
 		goto out;
 	}
 
+	cache->submit_offset = logical + cache->alloc_offset;
+
 out:
 	cache->alloc_type = alloc_type;
 	kfree(alloc_offsets);
@@ -10095,6 +10098,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
+	spin_lock_init(&cache->submit_lock);
 	init_rwsem(&cache->data_rwsem);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
@@ -10102,6 +10106,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&cache->ro_list);
 	INIT_LIST_HEAD(&cache->dirty_list);
 	INIT_LIST_HEAD(&cache->io_list);
+	INIT_LIST_HEAD(&cache->submit_buffer);
 	btrfs_init_free_space_ctl(cache);
 	atomic_set(&cache->trimming, 0);
 	mutex_init(&cache->free_space_lock);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 08d13da2553f..ca03b7136892 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -513,6 +513,8 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 	spin_unlock(&device->io_lock);
 
 	while (pending) {
+		struct btrfs_bio *bbio;
+		struct completion *sent = NULL;
 
 		rmb();
 		/* we want to work on both lists, but do more bios on the
@@ -550,7 +552,12 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 			sync_pending = 0;
 		}
 
+		bbio = cur->bi_private;
+		if (bbio)
+			sent = bbio->sent;
 		btrfsic_submit_bio(cur);
+		if (sent)
+			complete(sent);
 		num_run++;
 		batch_run++;
 
@@ -5542,6 +5549,7 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 
 	atomic_set(&bbio->error, 0);
 	refcount_set(&bbio->refs, 1);
+	INIT_LIST_HEAD(&bbio->list);
 
 	return bbio;
 }
@@ -6351,7 +6359,7 @@ static void btrfs_end_bio(struct bio *bio)
  * the work struct is scheduled.
  */
 static noinline void btrfs_schedule_bio(struct btrfs_device *device,
-					struct bio *bio)
+					struct bio *bio, int need_seqwrite)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	int should_queue = 1;
@@ -6365,7 +6373,12 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 
 	/* don't bother with additional async steps for reads, right now */
 	if (bio_op(bio) == REQ_OP_READ) {
+		struct btrfs_bio *bbio = bio->bi_private;
+		struct completion *sent = bbio->sent;
+
 		btrfsic_submit_bio(bio);
+		if (sent)
+			complete(sent);
 		return;
 	}
 
@@ -6373,7 +6386,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 	bio->bi_next = NULL;
 
 	spin_lock(&device->io_lock);
-	if (op_is_sync(bio->bi_opf))
+	if (op_is_sync(bio->bi_opf) && need_seqwrite == 0)
 		pending_bios = &device->pending_sync_bios;
 	else
 		pending_bios = &device->pending_bios;
@@ -6412,8 +6425,21 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 
+	/* queue all bios into scheduler if sequential write is required */
+	if (bbio->need_seqwrite) {
+		if (!async) {
+			DECLARE_COMPLETION_ONSTACK(sent);
+
+			bbio->sent = &sent;
+			btrfs_schedule_bio(dev, bio, bbio->need_seqwrite);
+			wait_for_completion_io(&sent);
+		} else {
+			btrfs_schedule_bio(dev, bio, bbio->need_seqwrite);
+		}
+		return;
+	}
 	if (async)
-		btrfs_schedule_bio(dev, bio);
+		btrfs_schedule_bio(dev, bio, bbio->need_seqwrite);
 	else
 		btrfsic_submit_bio(bio);
 }
@@ -6465,6 +6491,90 @@ static void __btrfs_map_bio(struct btrfs_fs_info *fs_info, u64 logical,
 	btrfs_bio_counter_dec(fs_info);
 }
 
+static void __btrfs_map_bio_zoned(struct btrfs_fs_info *fs_info, u64 logical,
+		struct btrfs_bio *bbio, int async_submit)
+{
+	u64 length = bbio->orig_bio->bi_iter.bi_size;
+	struct btrfs_block_group_cache *cache = NULL;
+	int sent;
+	LIST_HEAD(submit_list);
+
+	WARN_ON(bio_op(bbio->orig_bio) != REQ_OP_WRITE);
+
+	cache = btrfs_lookup_block_group(fs_info, logical);
+	if (!cache || cache->alloc_type != BTRFS_ALLOC_SEQ) {
+		if (cache)
+			btrfs_put_block_group(cache);
+		__btrfs_map_bio(fs_info, logical, bbio, async_submit);
+		return;
+	}
+
+	bbio->need_seqwrite = 1;
+
+	spin_lock(&cache->submit_lock);
+	if (cache->submit_offset == logical)
+		goto send_bios;
+
+	if (cache->submit_offset > logical) {
+		btrfs_info(fs_info, "sending unaligned bio... %llu+%llu %llu\n",
+			logical, length, cache->submit_offset);
+		spin_unlock(&cache->submit_lock);
+		WARN_ON(1);
+		btrfs_put_block_group(cache);
+		__btrfs_map_bio(fs_info, logical, bbio, async_submit);
+		return;
+	}
+
+	/* buffer the unaligned bio */
+	list_add_tail(&bbio->list, &cache->submit_buffer);
+	spin_unlock(&cache->submit_lock);
+	btrfs_put_block_group(cache);
+
+	return;
+
+send_bios:
+	spin_unlock(&cache->submit_lock);
+	/* send this bio */
+	__btrfs_map_bio(fs_info, logical, bbio, 1);
+
+loop:
+	/* and send previously buffered following bios */
+	spin_lock(&cache->submit_lock);
+	cache->submit_offset += length;
+	length = 0;
+	INIT_LIST_HEAD(&submit_list);
+
+	/* collect sequential bios into submit_list */
+	do {
+		struct btrfs_bio *next;
+
+		sent = 0;
+		list_for_each_entry_safe(bbio, next,
+					 &cache->submit_buffer, list) {
+			struct bio *orig_bio = bbio->orig_bio;
+			u64 logical = (u64)orig_bio->bi_iter.bi_sector << 9;
+
+			if (logical == cache->submit_offset + length) {
+				sent = 1;
+				length += orig_bio->bi_iter.bi_size;
+				list_move_tail(&bbio->list, &submit_list);
+			}
+		}
+	} while (sent);
+	spin_unlock(&cache->submit_lock);
+
+	/* send the collected bios */
+	list_for_each_entry(bbio, &submit_list, list) {
+		__btrfs_map_bio(bbio->fs_info,
+				(u64)bbio->orig_bio->bi_iter.bi_sector << 9,
+				bbio, 1);
+	}
+
+	if (length)
+		goto loop;
+	btrfs_put_block_group(cache);
+}
+
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num, int async_submit)
 {
@@ -6515,7 +6625,10 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		BUG();
 	}
 
-	__btrfs_map_bio(fs_info, logical, bbio, async_submit);
+	if (btrfs_fs_incompat(fs_info, HMZONED) && bio_op(bio) == REQ_OP_WRITE)
+		__btrfs_map_bio_zoned(fs_info, logical, bbio, async_submit);
+	else
+		__btrfs_map_bio(fs_info, logical, bbio, async_submit);
 	return BLK_STS_OK;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 58053d2e24aa..3db90f5395cd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -317,6 +317,9 @@ struct btrfs_bio {
 	int mirror_num;
 	int num_tgtdevs;
 	int *tgtdev_map;
+	int need_seqwrite;
+	struct list_head list;
+	struct completion *sent;
 	/*
 	 * logical block numbers for the start of each stripe
 	 * The last one or two are p/q.  These are sorted,
-- 
2.18.0

