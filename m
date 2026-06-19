Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9557E360EFF
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859753; cv=none; b=HxUGjEbwA6ECLLejMPHcZTfb1Sqey7TF0cXacRVbAgSJqHYx7beqeDyzGmXlrle6p2oly90Bcayi9TdNweXN8vnPZhW1lsE0U8P0NJ8XLP/8Uh92I97W3T9X+wI83ILT6SZX0htTZO2Sm8KzoABnXVk5P23UfdhVQLS1pcAPaJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859753; c=relaxed/simple;
	bh=oXmR1+vMmCZOrOfdx1+jUvun844V+eVi2m4eelg6iIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHSLLSr5jcLUkLzccLAevPbbFLSQ69e4yvD4Nn3Euj3a7hg1RqLoPppZXur97aW/7EiJBRDVsLiPtORLnbE1k1XbUhsQ8zxydTZgx24aeKkrBWF+edq0WrMLe0IPPvvW7GYzxwNvvXdY9DrxXORefmspoXBjsWQHBJ1dKsDr6cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V1WDQoNs; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V1WDQoNs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859752; x=1813395752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oXmR1+vMmCZOrOfdx1+jUvun844V+eVi2m4eelg6iIY=;
  b=V1WDQoNsvcX3iPfVmBEGQZBuhqRpYclY3URR9YNL7tx5frNko6YM2ehv
   1SYALuoTPHKLkPW7umpLmgGjPrCn9kgOdveLOl1k+2QfkabytZEQTRoZ8
   4ByBqZYFbaN6uxx70dCtW3tKfLqwubfn4YLqEYx90R6gA6vdd8Ah/s6Mz
   fjT6byih6DHvpZvGZPfkvdqX8FnM8lIBpGzsbRJ71/CXlzGCBLMMvtYSF
   S0TlCgnWH0AyTsqZpYTbmMesZ73zjc/OAH05mjt83bIROjT1oNJdcdjEI
   O/DRUNa8Ve39wnlK1NGDgoiHZfz6rd3b6GPhO1MDMORVqk8WHzHxy4XGb
   g==;
X-CSE-ConnectionGUID: URuOvC7JTKG0EAQiRMQ3tQ==
X-CSE-MsgGUID: ThZBsufaQ8GivPxpo3XAGA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951277"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: nr1R4a99Q/+WQW2oS5QReA==
X-CSE-MsgGUID: DryPhC2/Txq6iKHMw888tA==
IronPort-SDR: 6a3505a0_Ee6ZTDwDOh+k+TwOy5fgHzbqLgNZsGjwg0GkLjKmbMMlNUG
 mqa6XGupkBQNQ3SdhapqQ6VjmNkNUnNj+T3R2FQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:24 -0700
X-CSE-ConnectionGUID: mLXJPie4S9mozufdgoaXVA==
X-CSE-MsgGUID: uCVglJxxR/6IR3IHV36CdA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:23 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 08/15] btrfs: implement RAID stripe-tree RAID5 writes
Date: Fri, 19 Jun 2026 11:02:03 +0200
Message-ID: <20260619090211.497100-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A data write is submitted per device segment, so the data columns of a
full stripe arrive in separate btrfs_bios. Accumulate the parity instead
of computing it from a single btrfs_bio: each data btrfs_bio XORs its
column into a shared, zeroed per-stripe parity buffer (keyed by the full
stripe's logical address) and accounts the bytes folded so far. Once all
nr_data columns of the stripe have been folded, the parity is written
out via a zone append to the parity device.

The data and parity stripes are submitted per device and their actual
on-disk location is recorded in the btrfs_io_stripe from the zone append
completion. A BTRFS_RAID_STRIPE_KEY item for the data and a
BTRFS_RAID_STRIPE_PARITY_KEY item for the parity are inserted into the
stripe-tree, so reads can resolve the physical location of any stripe by a
stripe-tree lookup.

This completes any full stripe whose data columns are all written, even
when the data is split across several btrfs_bios or two ordered extents. A
sub-stripe tail that never fills its stripe is handled in a separate
change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/bio.c               |  79 +++++++++
 fs/btrfs/disk-io.c           |   5 +
 fs/btrfs/fs.h                |   3 +
 fs/btrfs/raid-stripe-tree.c  | 332 ++++++++++++++++++++++++++++++++++-
 fs/btrfs/raid-stripe-tree.h  |   9 +
 fs/btrfs/volumes.c           |   7 +
 include/trace/events/btrfs.h |  24 +++
 7 files changed, 455 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index a16d11c6e251..3245a706a895 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -410,6 +410,37 @@ static void btrfs_simple_end_io(struct bio *bio)
 	queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
 }
 
+static void raid56_write_end_io_work(struct work_struct *work)
+{
+	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, end_io_work);
+	struct bio *bio = &bbio->bio;
+	struct btrfs_io_stripe *stripe = bio->bi_private;
+
+	if (bio_is_zone_append(bio) && !bio->bi_status)
+		stripe->physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+
+	btrfs_bio_end_io(bbio, bbio->bio.bi_status);
+}
+
+static void raid56_write_endio(struct bio *bio)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+	struct btrfs_io_stripe *stripe = bio->bi_private;
+	struct btrfs_io_context *bioc = stripe->bioc;
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
+
+	btrfs_bio_counter_dec(fs_info);
+	bbio->mirror_num = bioc->mirror_num;
+
+	if (bio->bi_status)
+		btrfs_log_dev_io_error(bio, stripe->dev);
+
+	INIT_WORK(&bbio->end_io_work, raid56_write_end_io_work);
+	queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
+
+	btrfs_put_bioc(bioc);
+}
+
 static void btrfs_raid56_end_io(struct bio *bio)
 {
 	struct btrfs_io_context *bioc = bio->bi_private;
@@ -565,6 +596,39 @@ static void btrfs_submit_mirrored_bio(struct btrfs_io_context *bioc, int dev_nr)
 	btrfs_submit_dev_bio(bioc->stripes[dev_nr].dev, bio);
 }
 
+static void btrfs_submit_raid56_write(struct bio *bio, struct btrfs_io_context *bioc)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+	struct btrfs_io_stripe *smap;
+	u64 length = bio->bi_iter.bi_size;
+	int stripe_nr = btrfs_bioc_to_stripe_nr(bioc);
+
+	bioc->size = length;
+	smap = &bioc->stripes[stripe_nr];
+	smap->bioc = bioc;
+
+	bbio->orig_physical = smap->physical;
+	bio->bi_iter.bi_sector = smap->physical >> SECTOR_SHIFT;
+	bio->bi_private = smap;
+	bio->bi_end_io = raid56_write_endio;
+	btrfs_get_bioc(bioc);
+	btrfs_submit_dev_bio(smap->dev, bio);
+}
+
+static bool btrfs_is_rst_raid56_bioc(struct btrfs_io_context *bioc)
+{
+	if (!bioc)
+		return false;
+
+	if (!(bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK))
+		return false;
+
+	if (!bioc->use_rst)
+		return false;
+
+	return true;
+}
+
 static void btrfs_submit_bio(struct bio *bio, struct btrfs_io_context *bioc,
 			     struct btrfs_io_stripe *smap, int mirror_num)
 {
@@ -586,6 +650,11 @@ static void btrfs_submit_bio(struct bio *bio, struct btrfs_io_context *bioc,
 			raid56_parity_recover(bio, bioc, mirror_num);
 		else
 			raid56_parity_write(bio, bioc);
+	} else if (btrfs_is_rst_raid56_bioc(bioc)) {
+		if (bio_op(bio) == REQ_OP_READ)
+			ASSERT(0, "RST RAID56 read not implemented yet");
+		else
+			btrfs_submit_raid56_write(bio, bioc);
 	} else {
 		/* Write to multiple mirrors. */
 		int total_devs = bioc->num_stripes;
@@ -789,6 +858,16 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 
 	bbio->can_use_append = btrfs_use_zone_append(bbio);
 
+	if (btrfs_is_rst_raid56_bioc(bioc) &&
+	    btrfs_op(bio) == BTRFS_MAP_WRITE) {
+		ret = btrfs_rst_raid56_write(bbio, bioc);
+		if (ret) {
+			btrfs_bio_counter_dec(fs_info);
+			status = errno_to_blk_status(ret);
+			goto end_bbio;
+		}
+	}
+
 	map_length = min(map_length, length);
 	if (bbio->can_use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0a7d80da9c94..22bbd7c7c1ba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2912,6 +2912,9 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 
 	fs_info->bg_reclaim_threshold = BTRFS_DEFAULT_RECLAIM_THRESH;
 	INIT_WORK(&fs_info->reclaim_bgs_work, btrfs_reclaim_bgs_work);
+
+	INIT_LIST_HEAD(&fs_info->stripe_sets);
+	spin_lock_init(&fs_info->stripe_set_list_lock);
 }
 
 static int init_mount_fs_info(struct btrfs_fs_info *fs_info, struct super_block *sb)
@@ -4493,6 +4496,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
+	ASSERT(list_empty(&fs_info->stripe_sets));
+
 	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 5f0cfb0b5466..fbd8205b9e77 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -968,6 +968,9 @@ struct btrfs_fs_info {
 	struct list_head allocated_ebs;
 #endif
 
+	spinlock_t stripe_set_list_lock;
+	struct list_head stripe_sets;
+
 	/* Used by self tests only. */
 	bool (*use_bitmap)(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 48436b056191..28aa5e5b21bd 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/btrfs_tree.h>
+#include <linux/raid/xor.h>
 #include "ctree.h"
 #include "fs.h"
 #include "accessors.h"
@@ -12,6 +13,7 @@
 #include "raid-stripe-tree.h"
 #include "volumes.h"
 #include "print-tree.h"
+#include "zoned.h"
 
 static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 					       struct btrfs_path *path,
@@ -353,10 +355,20 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 
 	trace_btrfs_insert_one_raid_extent(fs_info, bioc->logical, bioc->size,
 					   num_stripes);
-	for (int i = 0; i < num_stripes; i++) {
-		struct btrfs_io_stripe *stripe = &bioc->stripes[i];
-		struct btrfs_raid_stride *raid_stride = &stripe_extent->strides[i];
-		fill_raid_stride(stripe, raid_stride);
+
+	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		int stripe_nr = btrfs_bioc_to_stripe_nr(bioc);
+		struct btrfs_raid_stride *raid_stride = &stripe_extent->strides[0];
+
+		fill_raid_stride(&bioc->stripes[stripe_nr], raid_stride);
+	} else {
+		for (int i = 0; i < num_stripes; i++) {
+			struct btrfs_io_stripe *stripe = &bioc->stripes[i];
+			struct btrfs_raid_stride *raid_stride =
+				&stripe_extent->strides[i];
+
+			fill_raid_stride(stripe, raid_stride);
+		}
 	}
 
 	stripe_key.objectid = bioc->logical;
@@ -516,3 +528,315 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 
 	return ret;
 }
+
+struct btrfs_stripe_unit {
+	struct btrfs_io_stripe *pstripe;
+	struct bio *bio;
+	struct folio *folio;
+};
+
+struct btrfs_stripe_set {
+	struct btrfs_fs_info *fs_info;
+	struct work_struct work;
+	struct list_head list;
+	u64 full_stripe_logical;
+	u64 full_stripe_len;
+	u64 logical;
+	u64 len;
+	refcount_t refs;
+	atomic_t pending_ios;
+	spinlock_t lock;
+	u32 covered;
+	unsigned int nr_data;
+	unsigned int npar;
+	struct btrfs_stripe_unit stripe_units[] __counted_by(npar);
+};
+
+static void btrfs_stripe_set_get(struct btrfs_stripe_set *set)
+{
+	refcount_inc(&set->refs);
+}
+
+static void btrfs_stripe_set_put(struct btrfs_fs_info *fs_info,
+				   struct btrfs_stripe_set *set)
+{
+	if (refcount_dec_and_test(&set->refs)) {
+		ASSERT(atomic_read(&set->pending_ios) == 0);
+		spin_lock(&fs_info->stripe_set_list_lock);
+		list_del_init(&set->list);
+		spin_unlock(&fs_info->stripe_set_list_lock);
+
+		kfree(set);
+	}
+}
+
+static struct btrfs_stripe_set *btrfs_stripe_set_lookup(
+					struct btrfs_io_context *bioc,
+					u64 length)
+{
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
+	struct btrfs_stripe_set *set;
+	bool found = false;
+
+	spin_lock(&fs_info->stripe_set_list_lock);
+	list_for_each_entry(set, &fs_info->stripe_sets, list) {
+		if (in_range(bioc->logical, set->full_stripe_logical,
+			     set->full_stripe_len)) {
+			found = true;
+			break;
+		}
+
+	}
+	if (found)
+		btrfs_stripe_set_get(set);
+	spin_unlock(&fs_info->stripe_set_list_lock);
+
+	if (!found)
+		return NULL;
+
+	return set;
+}
+
+static void insert_parity_stripe_work(struct work_struct *work)
+{
+	struct btrfs_stripe_set *set =
+		container_of(work, struct btrfs_stripe_set, work);
+	struct btrfs_fs_info *fs_info = set->fs_info;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key stripe_key;
+	struct btrfs_root *stripe_root = fs_info->stripe_root;
+	struct btrfs_stripe_extent *stripe_extent;
+	const size_t item_size = struct_size(stripe_extent, strides, set->npar);
+	int ret;
+
+	trans = btrfs_join_transaction(stripe_root);
+	if (IS_ERR(trans)) {
+		btrfs_stripe_set_put(fs_info, set);
+		return;
+	}
+
+	stripe_extent = kzalloc(item_size, GFP_NOFS);
+	if (!stripe_extent) {
+		btrfs_abort_transaction(trans, -ENOMEM);
+		btrfs_end_transaction(trans);
+		btrfs_stripe_set_put(fs_info, set);
+		return;
+	}
+
+	trace_btrfs_insert_parity_stripe(fs_info, set->logical, set->len, set->npar);
+
+	for (int i = 0; i < set->npar; i++) {
+		struct btrfs_raid_stride *raid_stride = &stripe_extent->strides[i];
+
+		fill_raid_stride(set->stripe_units[i].pstripe, raid_stride);
+	}
+
+	/* Parity covers the whole full stripe, keyed at the stripe start. */
+	stripe_key.objectid = set->full_stripe_logical;
+	stripe_key.type = BTRFS_RAID_STRIPE_PARITY_KEY;
+	stripe_key.offset = set->len;
+
+	ret = btrfs_insert_item(trans, stripe_root, &stripe_key, stripe_extent,
+				item_size);
+	if (ret == -EEXIST)
+		ret = update_raid_extent_item(trans, &stripe_key, stripe_extent,
+					      item_size);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+
+	btrfs_end_transaction(trans);
+	kfree(stripe_extent);
+	btrfs_stripe_set_put(fs_info, set);
+}
+
+static void raid56_write_endio(struct bio *bio)
+{
+	struct btrfs_stripe_set *set = bio->bi_private;
+	struct btrfs_fs_info *fs_info = set->fs_info;
+	struct folio_iter fi;
+
+	if (bio_is_zone_append(bio) && !bio->bi_status)
+		set->stripe_units[0].pstripe->physical =
+			bio->bi_iter.bi_sector << SECTOR_SHIFT;
+
+	if (atomic_dec_and_test(&set->pending_ios))
+		queue_work(fs_info->endio_workers, &set->work);
+
+	bio_for_each_folio_all(fi, bio)
+		folio_put(fi.folio);
+
+	btrfs_stripe_set_put(fs_info, set);
+	bio_put(bio);
+}
+
+static struct btrfs_stripe_set *btrfs_stripe_set_alloc(
+						struct btrfs_io_context *bioc,
+						u64 len)
+{
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
+	const unsigned int nr_parity = btrfs_nr_parity_stripes(bioc->map_type);
+	const unsigned int nr_data = bioc->num_stripes - nr_parity;
+	struct btrfs_stripe_set *set;
+
+	set = kzalloc(struct_size(set, stripe_units, nr_parity), GFP_NOFS);
+	if (!set)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&set->refs, 1);
+	atomic_set(&set->pending_ios, 0);
+	spin_lock_init(&set->lock);
+	set->covered = 0;
+	INIT_LIST_HEAD(&set->list);
+	INIT_WORK(&set->work, insert_parity_stripe_work);
+	set->fs_info = fs_info;
+	set->full_stripe_logical = bioc->full_stripe_logical;
+	set->full_stripe_len = nr_data * BTRFS_STRIPE_LEN;
+	set->logical = bioc->logical;
+	set->len = len;
+	set->npar = nr_parity;
+	set->nr_data = nr_data;
+
+	/*
+	 * bioc->stripes[0 ... nr_data - 1] holds the data,
+	 * bioc->stripes[nr_data ... nr_data + nr_parity] the parity.
+	 *
+	 * Each parity stripe is exactly BTRFS_STRIPE_LEN bytes, independent of
+	 * the data length @len which spans all nr_data data stripes.
+	 */
+	for (int i = 0; i < nr_parity; i++) {
+		struct btrfs_io_stripe *pstripe = bioc->stripes + nr_data + i;
+		gfp_t gfp = GFP_NOFS | __GFP_ZERO | __GFP_NOFAIL;
+		struct folio *folio;
+		struct bio *bio;
+
+		bio = bio_alloc(pstripe->dev->bdev, 1, REQ_OP_WRITE, gfp);
+		folio = folio_alloc(gfp, get_order(BTRFS_STRIPE_LEN));
+
+		set->stripe_units[i].bio = bio;
+		set->stripe_units[i].folio = folio;
+		set->stripe_units[i].pstripe = pstripe;
+		bio_add_folio_nofail(bio, folio, BTRFS_STRIPE_LEN, 0);
+	}
+
+	spin_lock(&fs_info->stripe_set_list_lock);
+	list_add_tail(&set->list, &fs_info->stripe_sets);
+	spin_unlock(&fs_info->stripe_set_list_lock);
+
+	return set;
+}
+
+static bool btrfs_stripe_set_calc_parity_raid5(struct btrfs_stripe_set *set,
+					       struct btrfs_bio *orig,
+					       struct btrfs_io_context *bioc)
+{
+	const u32 stripe_len = BTRFS_STRIPE_LEN;
+	u8 *parity = folio_address(set->stripe_units[0].folio);
+	const u32 offset = bioc->logical - set->full_stripe_logical;
+	const u32 poff = offset % stripe_len;
+	const u32 to_fold = min_t(u32, orig->bio.bi_iter.bi_size,
+				  stripe_len - poff);
+	struct bio_vec bvec;
+	struct bvec_iter iter;
+	u32 done = 0;
+	bool complete;
+
+	spin_lock(&set->lock);
+	bio_for_each_segment(bvec, &orig->bio, iter) {
+		u8 *src = bvec_virt(&bvec);
+		u32 chunk = min_t(u32, bvec.bv_len, to_fold - done);
+		void *xsrc = src;
+
+		if (!chunk)
+			break;
+		xor_gen(parity + poff + done, &xsrc, 1, chunk);
+		done += chunk;
+		if (done >= to_fold)
+			break;
+	}
+	set->covered += done;
+	complete = (set->covered >= set->full_stripe_len);
+	spin_unlock(&set->lock);
+
+	return complete;
+}
+
+static bool btrfs_stripe_set_calc_parity(struct btrfs_stripe_set *set,
+					 struct btrfs_bio *orig,
+					 struct btrfs_io_context *bioc)
+{
+	switch (set->npar) {
+	case 1:
+		return btrfs_stripe_set_calc_parity_raid5(set, orig, bioc);
+	default:
+		/* TODO: multiple parity (RAID6) calculation. */
+		ASSERT(0, "unsupported number of parity stripes %u", set->npar);
+		return false;
+	}
+}
+
+static void btrfs_stripe_set_finalize(struct btrfs_stripe_set *set)
+{
+	struct btrfs_fs_info *fs_info = set->fs_info;
+	struct btrfs_io_stripe *pstripe = set->stripe_units[0].pstripe;
+	struct bio *bio = set->stripe_units[0].bio;
+	u64 physical = pstripe->physical;
+
+	ASSERT(set->npar == 1, "npar=%u", set->npar);
+
+	spin_lock(&fs_info->stripe_set_list_lock);
+	list_del_init(&set->list);
+	spin_unlock(&fs_info->stripe_set_list_lock);
+
+	if (btrfs_dev_is_sequential(pstripe->dev, physical)) {
+		bio->bi_opf &= ~REQ_OP_WRITE;
+		bio->bi_opf |= REQ_OP_ZONE_APPEND;
+		physical = round_down(physical, fs_info->zone_size);
+	}
+
+	bio_set_dev(bio, pstripe->dev->bdev);
+	bio->bi_iter.bi_sector = physical >> SECTOR_SHIFT;
+	bio->bi_end_io = raid56_write_endio;
+	bio->bi_private = set;
+
+	btrfs_stripe_set_get(set);
+	atomic_inc(&set->pending_ios);
+	submit_bio(bio);
+}
+
+int btrfs_rst_raid56_write(struct btrfs_bio *orig,
+			   struct btrfs_io_context *bioc)
+{
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
+	const unsigned int nr_parity = btrfs_nr_parity_stripes(bioc->map_type);
+	const unsigned int nr_data = bioc->num_stripes - nr_parity;
+	const u64 full_stripe_len = (u64)nr_data * BTRFS_STRIPE_LEN;
+	struct btrfs_stripe_set *set;
+	bool created = false;
+	bool complete;
+
+	ASSERT(nr_parity == 1, "Only single-parity (RAID5) is implemented");
+
+	/*
+	 * Accumulate the parity for the full stripe bioc->logical falls into.
+	 * Each data bbio folds its column into the shared stripe set; when all
+	 * nr_data columns have been folded the parity is submitted. A full stripe
+	 * split across ordered extents is thus completed once its last column
+	 * arrives.
+	 */
+	set = btrfs_stripe_set_lookup(bioc, full_stripe_len);
+	if (!set) {
+		set = btrfs_stripe_set_alloc(bioc, full_stripe_len);
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+		created = true;
+	}
+
+	complete = btrfs_stripe_set_calc_parity(set, orig, bioc);
+	if (complete)
+		btrfs_stripe_set_finalize(set);
+
+	if (!created)
+		btrfs_stripe_set_put(fs_info, set);
+
+	return 0;
+}
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index b1a26e21b0d5..6daa00184f8e 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -10,6 +10,7 @@
 #include <uapi/linux/btrfs_tree.h>
 #include "fs.h"
 #include "accessors.h"
+#include "volumes.h"
 
 #define BTRFS_RST_SUPP_BLOCK_GROUP_MASK    (BTRFS_BLOCK_GROUP_DUP |		\
 					    BTRFS_BLOCK_GROUP_RAID1_MASK |	\
@@ -29,6 +30,8 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 				 u32 stripe_index, struct btrfs_io_stripe *stripe);
 int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent);
+int btrfs_rst_raid56_write(struct btrfs_bio *bbio,
+			   struct btrfs_io_context *bioc);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
@@ -58,4 +61,10 @@ static inline int btrfs_num_raid_stripes(u32 item_size)
 	return item_size / sizeof(struct btrfs_raid_stride);
 }
 
+static inline int btrfs_bioc_to_stripe_nr(struct btrfs_io_context *bioc)
+{
+        u64 offset_in_stripe = bioc->logical - bioc->full_stripe_logical;
+        return offset_in_stripe >> BTRFS_STRIPE_LEN_SHIFT;
+}
+
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..51023bfaf9dd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7305,6 +7305,13 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 				io_geom.stripe_offset +
 				btrfs_stripe_nr_to_offset(io_geom.stripe_nr);
 		}
+		/*
+		 * RAID56 write with RAID stripe-tree needs to split the write
+		 * on the stripe boundary.
+		 */
+		if (io_geom.use_rst)
+			*length = min_t(u64, *length,
+					BTRFS_STRIPE_LEN - io_geom.stripe_offset);
 	} else {
 		/*
 		 * For all other non-RAID56 profiles, just copy the target
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4c5c47c5edb7..a167bd8ad6b4 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -3323,6 +3323,30 @@ DEFINE_EVENT(btrfs_raid56_bio, raid56_write,
 	TP_ARGS(rbio, bio, trace_info)
 );
 
+TRACE_EVENT(btrfs_insert_parity_stripe,
+
+	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 logical, u64 length,
+		 int num_parity),
+
+	TP_ARGS(fs_info, logical, length, num_parity),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	logical		)
+		__field(	u64,	length		)
+		__field(	int,	num_parity	)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->logical	= logical;
+		__entry->length		= length;
+		__entry->num_parity	= num_parity;
+	),
+
+	TP_printk_btrfs("logical=%llu length=%llu num_parity=%d",
+			__entry->logical, __entry->length,
+			__entry->num_parity)
+);
+
 TRACE_EVENT(btrfs_insert_one_raid_extent,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 logical, u64 length,
-- 
2.54.0

