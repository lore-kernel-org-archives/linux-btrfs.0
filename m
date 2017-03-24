Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46998 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932502AbdCXCAp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 22:00:45 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v2 1/5] btrfs: scrub: Introduce full stripe lock for RAID56
Date: Fri, 24 Mar 2017 10:00:23 +0800
Message-ID: <20170324020027.21228-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike mirror based profiles, RAID5/6 recovery needs to read out the
whole full stripe.

And if we don't do proper protect, it can easily cause race condition.

Introduce 2 new functions: lock_full_stripe() and unlock_full_stripe()
for RAID5/6.
Which stores a rb_tree of mutex for full stripes, so scrub callers can
use them to lock a full stripe to avoid race.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   4 ++
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/scrub.c       | 177 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc28c607..4d570e1040e6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -648,6 +648,10 @@ struct btrfs_block_group_cache {
 	 * Protected by free_space_lock.
 	 */
 	int needs_free_space;
+
+	/* Scrub full stripe lock tree for RAID5/6 scrub */
+	struct rb_root scrub_lock_root;
+	spinlock_t scrub_lock;
 };
 
 /* delayed seq elem */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be5477676cc8..db5d9f84535e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -131,6 +131,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 	if (atomic_dec_and_test(&cache->count)) {
 		WARN_ON(cache->pinned > 0);
 		WARN_ON(cache->reserved > 0);
+		WARN_ON(!RB_EMPTY_ROOT(&cache->scrub_lock_root));
 		kfree(cache->free_space_ctl);
 		kfree(cache);
 	}
@@ -9907,6 +9908,8 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
+	spin_lock_init(&cache->scrub_lock);
+	cache->scrub_lock_root = RB_ROOT;
 	init_rwsem(&cache->data_rwsem);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb1239f..38b300ac4567 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -240,6 +240,13 @@ struct scrub_warning {
 	struct btrfs_device	*dev;
 };
 
+struct scrub_full_stripe_lock {
+	struct rb_node node;
+	u64 logical;
+	u64 refs;
+	struct mutex mutex;
+};
+
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx);
 static void scrub_pending_bio_dec(struct scrub_ctx *sctx);
 static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx);
@@ -349,6 +356,176 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 }
 
 /*
+ * Caller must hold cache->scrub_root_lock.
+ *
+ * Return existing full stripe and increase it refs
+ * Or return NULL, and insert @fstripe_lock into the bg cache
+ */
+static struct scrub_full_stripe_lock *
+add_scrub_lock(struct btrfs_block_group_cache *cache,
+	       struct scrub_full_stripe_lock *fstripe_lock)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct scrub_full_stripe_lock *entry;
+
+	p = &cache->scrub_lock_root.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct scrub_full_stripe_lock, node);
+		if (fstripe_lock->logical < entry->logical) {
+			p = &(*p)->rb_left;
+		} else if (fstripe_lock->logical > entry->logical) {
+			p = &(*p)->rb_right;
+		} else {
+			entry->refs++;
+			return entry;
+		}
+	}
+	/* Insert new one */
+	rb_link_node(&fstripe_lock->node, parent, p);
+	rb_insert_color(&fstripe_lock->node, &cache->scrub_lock_root);
+
+	return NULL;
+}
+
+static struct scrub_full_stripe_lock *
+search_scrub_lock(struct btrfs_block_group_cache *cache, u64 bytenr)
+{
+	struct rb_node *node;
+	struct scrub_full_stripe_lock *entry;
+
+	node = cache->scrub_lock_root.rb_node;
+	while (node) {
+		entry = rb_entry(node, struct scrub_full_stripe_lock, node);
+		if (bytenr < entry->logical)
+			node = node->rb_left;
+		else if (bytenr > entry->logical)
+			node = node->rb_right;
+		else
+			return entry;
+	}
+	return NULL;
+}
+
+/*
+ * Helper to get full stripe logical from a normal bytenr.
+ * Thanks to the chaos of scrub structures, we need to get it all
+ * by ourselves, using btrfs_map_sblock().
+ */
+static int get_full_stripe_logical(struct btrfs_fs_info *fs_info, u64 bytenr,
+				   u64 *bytenr_ret)
+{
+	struct btrfs_bio *bbio = NULL;
+	u64 len;
+	int ret;
+
+	/* Just use map_sblock() to get full stripe logical */
+	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, bytenr,
+			       &len, &bbio, 0, 1);
+	if (ret || !bbio || !bbio->raid_map)
+		goto error;
+	*bytenr_ret = bbio->raid_map[0];
+	btrfs_put_bbio(bbio);
+	return 0;
+error:
+	btrfs_put_bbio(bbio);
+	if (ret)
+		return ret;
+	return -EIO;
+}
+
+/*
+ * To lock a full stripe to avoid concurrency of recovery and read
+ * It's only used for profiles with parities(RAID5/6), for other profiles it
+ * does nothing
+ */
+static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr,
+			    gfp_t gfp_flags)
+{
+	struct btrfs_block_group_cache *bg_cache;
+	struct scrub_full_stripe_lock *fstripe_lock;
+	struct scrub_full_stripe_lock *existing;
+	u64 fstripe_start;
+	int ret = 0;
+
+	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
+	if (!bg_cache)
+		return -ENOENT;
+
+	/* Mirror based profiles don't need full stripe lock */
+	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
+		goto out;
+
+	ret = get_full_stripe_logical(fs_info, bytenr, &fstripe_start);
+	if (ret < 0)
+		goto out;
+
+	fstripe_lock = kmalloc(sizeof(*fstripe_lock), gfp_flags);
+	if (!fstripe_lock) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	fstripe_lock->logical = fstripe_start;
+	fstripe_lock->refs = 1;
+	mutex_init(&fstripe_lock->mutex);
+
+	/* Now insert the full stripe lock */
+	spin_lock(&bg_cache->scrub_lock);
+	existing = add_scrub_lock(bg_cache, fstripe_lock);
+	if (existing) {
+		kfree(fstripe_lock);
+		fstripe_lock = existing;
+	}
+	spin_unlock(&bg_cache->scrub_lock);
+	mutex_lock(&fstripe_lock->mutex);
+
+out:
+	btrfs_put_block_group(bg_cache);
+	return ret;
+}
+
+static int unlock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct btrfs_block_group_cache *bg_cache;
+	struct scrub_full_stripe_lock *fstripe_lock;
+	u64 fstripe_start;
+	int ret = 0;
+
+	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
+	if (!bg_cache)
+		return -ENOENT;
+	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
+		goto out;
+
+	ret = get_full_stripe_logical(fs_info, bytenr, &fstripe_start);
+	if (ret < 0)
+		goto out;
+
+	spin_lock(&bg_cache->scrub_lock);
+	fstripe_lock = search_scrub_lock(bg_cache, fstripe_start);
+	/* This is a deadly problem, we hold a mutex but can't unlock it */
+	if (WARN_ON(!fstripe_lock)) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	mutex_unlock(&fstripe_lock->mutex);
+	if (!WARN_ON(fstripe_lock->refs == 0))
+		fstripe_lock->refs--;
+	if (fstripe_lock->refs == 0) {
+		rb_erase(&fstripe_lock->node, &bg_cache->scrub_lock_root);
+		kfree(fstripe_lock);
+	}
+unlock:
+	spin_unlock(&bg_cache->scrub_lock);
+out:
+	btrfs_put_block_group(bg_cache);
+	return ret;
+}
+
+/*
  * used for workers that require transaction commits (i.e., for the
  * NOCOW case)
  */
-- 
2.12.1



