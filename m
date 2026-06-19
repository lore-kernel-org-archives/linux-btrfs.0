Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59035C1AE
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859756; cv=none; b=FYHABpB39UpKq9UDm0fC38fgJKZN5v3c9JBpOmTCLHuJcAXyrWM62xudhYv+aj4qzxTIc+C7+7aZPvNIarOiTzKi4e/bMsCYdjOmNuOI9j2uSNpBnia6rE6kPTBEcmWlRiy1bkRM+BM3wKDLF9UPNsafMJGssvPzjdsNz9rUqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859756; c=relaxed/simple;
	bh=vo4KUq0ovgyuL6bXZ+m39/14lIoDGV4w4/hU26Le+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5MWep5dOWcssF8JRzugp4/E3orbLE5MG3CuUvc9UnHTeH6wPmXWnYYq2HyRFgHcfZOp+K5TF370z2OSCeaC6AufF7whQgKEsYZ1BN1ELHBrzGOsdpYzYtqj6QWS6anenOJo7pUmrKyWQhRBsWFFtwiVm29sw0dEPNjaSYyLO+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=axeJMOV7; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="axeJMOV7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859756; x=1813395756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vo4KUq0ovgyuL6bXZ+m39/14lIoDGV4w4/hU26Le+Mc=;
  b=axeJMOV7gShNM4UJTxuFF4RDx7h6/vyMgWAJIh1W+k2dcPurOEpj+vFm
   povOihB36fvk5WUu2KDXiBDi9QmW6j5HqexI8C34jrJ/k8JIsuQlReMtQ
   enStegye9ZyLRkWXGeDHyFKOV1YA8/AkCToKvhwqXLZyvijhZtfYhR/zl
   VdWcFr4nQIk4RJ/20TJOMbxcYkoVsekxJCzojEL1U7lmfEtU2neBmgMUD
   TOKPer+Oy7aI+hfCmoHBb2BZJizZPog1qmOwOcZj1wH4W7UcDB3MBTKBk
   Sm2O3NCZ5G+AguSzDLKQfop1sQx/OkJSxgwuMscizys0bY9JMARwW/p9q
   A==;
X-CSE-ConnectionGUID: OX8eMhedQxWrfO1Eg4oGpg==
X-CSE-MsgGUID: l8QeVgtBRsi5z+Pay+YDmA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951283"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:29 +0800
X-CSE-ConnectionGUID: CYGTvLSDS7CtNSGiD5g8zQ==
X-CSE-MsgGUID: noAfaxiUS9ubvwgnkqNtDA==
IronPort-SDR: 6a3505a4_Ksqxn9i8zvP/3g1Xk74IkTHKk22ycLyHJUCxW6LIxx7jDz2
 ZUyaANU2aM/AtCzgUT1UYz6KAaiiC1llqfmo6ZA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:28 -0700
X-CSE-ConnectionGUID: FVVUDsWzRHW3Z1I26UrG1w==
X-CSE-MsgGUID: 9gBvn7UYSei6Rh8REyA2+g==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:28 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 12/15] btrfs: compute RAID stripe-tree RAID5 parity for sub-stripe writes
Date: Fri, 19 Jun 2026 11:02:07 +0200
Message-ID: <20260619090211.497100-13-johannes.thumshirn@wdc.com>
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

The RAID5 write path accumulates a full stripe's parity and submits it once
all of its data columns have been folded. A sub-stripe tail - a file tail
shorter than a full stripe - never fills its stripe, so its parity would
never be submitted and the tail would be left unprotected.

Finalize such a stripe from the ordered-extent completion
(btrfs_rst_raid56_finish_ordered()), once the tail's data is on disk: submit
the parity of the stripe holding the last byte of the ordered extent, unless
the file extends past it, in which case more data (possibly still dirty) will
complete the stripe and it is left to the eager path. A finalized flag
coordinates the eager and the ordered-extent path so a stripe's parity is
submitted exactly once.

No zero padding is written to the data columns, so partial stripes waste no
space and the data column write pointers reflect the actual logical
allocation (handled by btrfs_load_block_group_raid56()).

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c          |  11 +++
 fs/btrfs/inode.c            |   7 ++
 fs/btrfs/raid-stripe-tree.c | 157 +++++++++++++++++++++++++++++++++---
 fs/btrfs/raid-stripe-tree.h |   3 +
 fs/btrfs/super.c            |   9 +++
 5 files changed, 175 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22bbd7c7c1ba..3ab2bc5416c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -31,6 +31,7 @@
 #include "free-space-tree.h"
 #include "dev-replace.h"
 #include "raid56.h"
+#include "raid-stripe-tree.h"
 #include "sysfs.h"
 #include "qgroup.h"
 #include "compression.h"
@@ -4496,6 +4497,16 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
+	/*
+	 * On an aborted (forced read-only) filesystem, partial-tail stripe
+	 * sets may have leaked because their data ordered extents completed
+	 * with an error and never finalized the parity. Free them so the
+	 * ASSERT below holds; in the clean case the list is already empty and
+	 * any leftover is a genuine bug we still want to catch.
+	 */
+	if (BTRFS_FS_ERROR(fs_info))
+		btrfs_rst_destroy_stripe_sets(fs_info);
+
 	ASSERT(list_empty(&fs_info->stripe_sets));
 
 	ASSERT(list_empty(&fs_info->delayed_iputs));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16f097f58acc..65bd76eadf0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3164,6 +3164,13 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
+
+	/*
+	 * The data of this ordered extent is now on disk. Finalize the RAID
+	 * stripe-tree parity of a partial tail stripe that no further data will
+	 * complete.
+	 */
+	btrfs_rst_raid56_finish_ordered(ordered_extent);
 out:
 	if (clear_bits)
 		btrfs_clear_extent_bit(&inode->io_tree, start, end, clear_bits,
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index abe0ad10ee87..513bb5bba2ef 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -14,6 +14,7 @@
 #include "volumes.h"
 #include "print-tree.h"
 #include "zoned.h"
+#include "ordered-data.h"
 
 static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 					       struct btrfs_path *path,
@@ -621,6 +622,8 @@ struct btrfs_stripe_set {
 	atomic_t pending_ios;
 	spinlock_t lock;
 	u32 covered;
+	bool finalized;
+	bool can_use_append;
 	unsigned int nr_data;
 	unsigned int npar;
 	struct btrfs_stripe_unit stripe_units[] __counted_by(npar);
@@ -635,10 +638,12 @@ static void btrfs_stripe_set_put(struct btrfs_fs_info *fs_info,
 				   struct btrfs_stripe_set *set)
 {
 	if (refcount_dec_and_test(&set->refs)) {
+		unsigned long flags;
+
 		ASSERT(atomic_read(&set->pending_ios) == 0);
-		spin_lock(&fs_info->stripe_set_list_lock);
+		spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
 		list_del_init(&set->list);
-		spin_unlock(&fs_info->stripe_set_list_lock);
+		spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
 
 		kfree(set);
 	}
@@ -650,10 +655,13 @@ static struct btrfs_stripe_set *btrfs_stripe_set_lookup(
 {
 	struct btrfs_fs_info *fs_info = bioc->fs_info;
 	struct btrfs_stripe_set *set;
+	unsigned long flags;
 	bool found = false;
 
-	spin_lock(&fs_info->stripe_set_list_lock);
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
 	list_for_each_entry(set, &fs_info->stripe_sets, list) {
+		if (set->finalized)
+			continue;
 		if (in_range(bioc->logical, set->full_stripe_logical,
 			     set->full_stripe_len)) {
 			found = true;
@@ -663,7 +671,7 @@ static struct btrfs_stripe_set *btrfs_stripe_set_lookup(
 	}
 	if (found)
 		btrfs_stripe_set_get(set);
-	spin_unlock(&fs_info->stripe_set_list_lock);
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
 
 	if (!found)
 		return NULL;
@@ -751,6 +759,7 @@ static struct btrfs_stripe_set *btrfs_stripe_set_alloc(
 	const unsigned int nr_parity = btrfs_nr_parity_stripes(bioc->map_type);
 	const unsigned int nr_data = bioc->num_stripes - nr_parity;
 	struct btrfs_stripe_set *set;
+	unsigned long flags;
 
 	set = kzalloc(struct_size(set, stripe_units, nr_parity), GFP_NOFS);
 	if (!set)
@@ -760,6 +769,7 @@ static struct btrfs_stripe_set *btrfs_stripe_set_alloc(
 	atomic_set(&set->pending_ios, 0);
 	spin_lock_init(&set->lock);
 	set->covered = 0;
+	set->finalized = false;
 	INIT_LIST_HEAD(&set->list);
 	INIT_WORK(&set->work, insert_parity_stripe_work);
 	set->fs_info = fs_info;
@@ -792,9 +802,9 @@ static struct btrfs_stripe_set *btrfs_stripe_set_alloc(
 		bio_add_folio_nofail(bio, folio, BTRFS_STRIPE_LEN, 0);
 	}
 
-	spin_lock(&fs_info->stripe_set_list_lock);
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
 	list_add_tail(&set->list, &fs_info->stripe_sets);
-	spin_unlock(&fs_info->stripe_set_list_lock);
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
 
 	return set;
 }
@@ -854,14 +864,23 @@ static void btrfs_stripe_set_finalize(struct btrfs_stripe_set *set)
 	struct btrfs_io_stripe *pstripe = set->stripe_units[0].pstripe;
 	struct bio *bio = set->stripe_units[0].bio;
 	u64 physical = pstripe->physical;
+	unsigned long flags;
 
 	ASSERT(set->npar == 1, "npar=%u", set->npar);
 
-	spin_lock(&fs_info->stripe_set_list_lock);
+	spin_lock(&set->lock);
+	if (set->finalized) {
+		spin_unlock(&set->lock);
+		return;
+	}
+	set->finalized = true;
+	spin_unlock(&set->lock);
+
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
 	list_del_init(&set->list);
-	spin_unlock(&fs_info->stripe_set_list_lock);
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
 
-	if (btrfs_dev_is_sequential(pstripe->dev, physical)) {
+	if (set->can_use_append && btrfs_dev_is_sequential(pstripe->dev, physical)) {
 		bio->bi_opf &= ~REQ_OP_WRITE;
 		bio->bi_opf |= REQ_OP_ZONE_APPEND;
 		physical = round_down(physical, fs_info->zone_size);
@@ -893,15 +912,17 @@ int btrfs_rst_raid56_write(struct btrfs_bio *orig,
 	/*
 	 * Accumulate the parity for the full stripe bioc->logical falls into.
 	 * Each data bbio folds its column into the shared stripe set; when all
-	 * nr_data columns have been folded the parity is submitted. A full stripe
-	 * split across ordered extents is thus completed once its last column
-	 * arrives.
+	 * nr_data columns have been folded the parity is submitted eagerly. A
+	 * full stripe split across ordered extents is completed when its last
+	 * column arrives; a partial tail stripe is finalized from the ordered-
+	 * extent completion in btrfs_rst_raid56_finish_ordered().
 	 */
 	set = btrfs_stripe_set_lookup(bioc, full_stripe_len);
 	if (!set) {
 		set = btrfs_stripe_set_alloc(bioc, full_stripe_len);
 		if (IS_ERR(set))
 			return PTR_ERR(set);
+		set->can_use_append = orig->can_use_append;
 		created = true;
 	}
 
@@ -915,6 +936,114 @@ int btrfs_rst_raid56_write(struct btrfs_bio *orig,
 	return 0;
 }
 
+/*
+ * Finalize the parity of a partial tail stripe once its data ordered extent has
+ * completed (so the data columns are committed). Complete stripes are submitted
+ * by btrfs_rst_raid56_write(). The only stripe that can still be pending here
+ * is the one holding the last byte of ordered's data. If a data extent
+ * continues right after ordered, that stripe spans two ordered extents and
+ * will be completed by the next one's data, so it is left alone.
+ */
+void btrfs_rst_raid56_finish_ordered(struct btrfs_ordered_extent *ordered)
+{
+	struct btrfs_inode *inode = ordered->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u64 logical_end = ordered->disk_bytenr + ordered->disk_num_bytes;
+	struct btrfs_stripe_set *set, *found = NULL;
+	unsigned long flags;
+
+	if (!fs_info->stripe_root)
+		return;
+
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
+	list_for_each_entry(set, &fs_info->stripe_sets, list) {
+		if (set->finalized)
+			continue;
+		if (in_range(logical_end - 1, set->full_stripe_logical,
+			     set->full_stripe_len)) {
+			found = set;
+			btrfs_stripe_set_get(set);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
+
+	if (!found)
+		return;
+
+	/*
+	 * If the file extends past this ordered extent, more data
+	 * will land in this stripe and complete it eagerly, so leave it alone.
+	 * Only when this ordered extent reaches i_size is the stripe a genuine
+	 * tail.
+	 */
+	if (ordered->file_offset + ordered->num_bytes <
+	    i_size_read(&inode->vfs_inode)) {
+		btrfs_stripe_set_put(fs_info, found);
+		return;
+	}
+
+	btrfs_stripe_set_finalize(found);
+	btrfs_stripe_set_put(fs_info, found);
+}
+
+void btrfs_rst_flush_stripe_sets(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_stripe_set *set, *tmp;
+	unsigned long flags;
+	LIST_HEAD(pending);
+
+	if (!fs_info->stripe_root)
+		return;
+
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
+	list_splice_init(&fs_info->stripe_sets, &pending);
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
+
+	list_for_each_entry_safe(set, tmp, &pending, list)
+		btrfs_stripe_set_finalize(set);
+}
+
+/*
+ * Free any stripe sets still pending at unmount of an aborted filesystem.
+ *
+ * When the filesystem is forced read-only mid-write, the data ordered extents
+ * complete with an error and never reach btrfs_rst_raid56_finish_ordered(), so
+ * the partial-tail stripe sets they allocated are never finalized: their parity
+ * bios/folios are never submitted and the sets stay on fs_info->stripe_sets.
+ * Tear them down here (we cannot submit parity on a read-only fs) so the list
+ * is empty and close_ctree() does not trip its ASSERT.
+ */
+void btrfs_rst_destroy_stripe_sets(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_stripe_set *set, *tmp;
+	unsigned long flags;
+	LIST_HEAD(pending);
+
+	if (!fs_info->stripe_root)
+		return;
+
+	spin_lock_irqsave(&fs_info->stripe_set_list_lock, flags);
+	list_splice_init(&fs_info->stripe_sets, &pending);
+	spin_unlock_irqrestore(&fs_info->stripe_set_list_lock, flags);
+
+	list_for_each_entry_safe(set, tmp, &pending, list) {
+		ASSERT(!set->finalized);
+		ASSERT(atomic_read(&set->pending_ios) == 0);
+
+		for (int i = 0; i < set->npar; i++) {
+			struct btrfs_stripe_unit *unit = &set->stripe_units[i];
+
+			if (unit->folio)
+				folio_put(unit->folio);
+			if (unit->bio)
+				bio_io_error(unit->bio);
+		}
+
+		btrfs_stripe_set_put(fs_info, set);
+	}
+}
+
 static int btrfs_rst_read_stripe(struct btrfs_device *dev, u64 physical,
 				 struct folio *folio, u64 len)
 {
@@ -1006,6 +1135,10 @@ int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 		s.dev = bioc->stripes[i].dev;
 		ret = btrfs_get_raid_extent_offset(fs_info, slogical, &slen,
 						   bioc->map_type, 0, &s);
+		if (ret == -ENODATA) {
+			ret = 0;
+			continue;
+		}
 		if (ret)
 			goto out;
 
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index bf8b66b5ad8c..9f45378dd3c8 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -37,6 +37,9 @@ int btrfs_rst_raid56_write(struct btrfs_bio *bbio,
 			   struct btrfs_io_context *bioc);
 int btrfs_rst_raid56_read(struct btrfs_bio *orig,
 			  struct btrfs_io_context *bioc);
+void btrfs_rst_raid56_finish_ordered(struct btrfs_ordered_extent *ordered);
+void btrfs_rst_flush_stripe_sets(struct btrfs_fs_info *fs_info);
+void btrfs_rst_destroy_stripe_sets(struct btrfs_fs_info *fs_info);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c946bccf0748..b23dbebe7231 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -33,6 +33,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "raid-stripe-tree.h"
 #include "btrfs_inode.h"
 #include "direct-io.h"
 #include "props.h"
@@ -1023,6 +1024,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
 
+	/*
+	 * All ordered extents are now on disk, so any RAID56 stripe-tree set
+	 * still pending is a genuine partial stripe (e.g. an interior partial
+	 * write) that finish_ordered left for a completion that will never
+	 * come. Finalize them now, before they leak past unmount.
+	 */
+	btrfs_rst_flush_stripe_sets(fs_info);
+
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
-- 
2.54.0

