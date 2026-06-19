Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8E93603D7
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859754; cv=none; b=CL+ls6FskJCSq6NEMWx9ra0QAKJ7fvsOA8+90BmfJydYAIV6rSbLjcnORc3pkhwNW3pdNeaDbsNWgj2UP69eNQeDAPpZ3RaoYYSWOjiXBtfuZ0n/bwBHaYl6IsCJWsAMP+PybMvosS7Ti2c1o2Lq2A6LNmCf2yo/Qv4HlnRb9vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859754; c=relaxed/simple;
	bh=VbOiXNPwIKwXal4KphunzBQoAv466VoTrZxy3RUjs80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWdaJJx8TtgyNJmor416EWkYFLFkrT3BpkF1Le1XnHwhCyOkNq1A/QTL8fc6evPmZ956LRtohgkvokhR/vATntzDwuGOJCiDepEDxtN51JpQRLRT+6dwi3zma51C7vAIQVUQk+ts+1hpRkP6bKg0aeQ+OyStD1d7hLk3XHoPQKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LI9D6CxE; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LI9D6CxE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859754; x=1813395754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VbOiXNPwIKwXal4KphunzBQoAv466VoTrZxy3RUjs80=;
  b=LI9D6CxEAhrsnpkiXCOVXive0lQIzc4jEZQUWL4kqtgx2PxXG3o1JtSC
   OZeJLHl5rxTy5f+0DfbdJZJ19NGpDO6FCR4lbtmQqzeTA0rmbk/lJK25W
   snaLc35Kl+/xMrUf/wJp9K3GbaOX7BnO+gayrmB8xcHT1d3KUiy/twnCj
   gDawJd0iVHA5A5yyU8wbdw0v2fP3aKnqiTcoiUEBbsjGgwG2KFITYuODA
   u0RnOh7Lalduo+u+JbnYPN52jEi/Dvhe8rfjBbCulZhRtZ2VUe3ZF4dtP
   /qY/Kao9nflLbzUEg/jLC7vP3RCevBlFgnBrraB+ljpauMx5BJn/BxI4r
   w==;
X-CSE-ConnectionGUID: wKbTXZxhRA6ddz/bzVOMlw==
X-CSE-MsgGUID: u2eHEk17QJCcywQI1XSD/Q==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951278"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: bcYWpd0vQDKt5T01cdE9GQ==
X-CSE-MsgGUID: 3+Mah7r2QA+VUif7XorPPg==
IronPort-SDR: 6a3505a1_RNGYgB9fTtdU2SPCAp4xf+7XKq/pCUrNNy9UZe3jn2u9swv
 xidw4hhccheYP2x1WmERVnDxCI1gAnmhRLr2y4g==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:25 -0700
X-CSE-ConnectionGUID: mlcxZqObQq27H/bPR/4G8w==
X-CSE-MsgGUID: vacAD89yTW23af7tCrcdTg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:24 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 09/15] btrfs: implement basic RAID stripe-tree RAID5 read
Date: Fri, 19 Jun 2026 11:02:04 +0200
Message-ID: <20260619090211.497100-10-johannes.thumshirn@wdc.com>
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

Implement the read side of RAID5 backed by the raid-stripe-tree.

The stripe-tree records a single physical location per data stripe per
device, so there is no second mirror to rotate to and the regular RAID56
read path does not apply. btrfs_rst_raid56_read() resolves the targeted
data stripe and its parity stripe from the stripe-tree and, depending on
the requested mirror, either reads the data stripe directly (mirror 1) or
reconstructs it from the parity and the surviving data stripes via XOR
(higher mirrors). The reconstruction helper is exported for the sanity
tests.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/bio.c              |  20 +++-
 fs/btrfs/raid-stripe-tree.c | 204 +++++++++++++++++++++++++++++++++++-
 fs/btrfs/raid-stripe-tree.h |   5 +
 3 files changed, 225 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 3245a706a895..ce16a295e4ee 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -615,6 +615,24 @@ static void btrfs_submit_raid56_write(struct bio *bio, struct btrfs_io_context *
 	btrfs_submit_dev_bio(smap->dev, bio);
 }
 
+static void btrfs_submit_rst_raid56_read(struct bio *bio,
+					 struct btrfs_io_context *bioc)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+	int stripe_nr = btrfs_bioc_to_stripe_nr(bioc);
+	struct btrfs_device *dev = bioc->stripes[stripe_nr].dev;
+	int ret;
+
+	bbio->mirror_num = bioc->mirror_num;
+	ret = btrfs_rst_raid56_read(bbio, bioc);
+	btrfs_bio_counter_dec(bioc->fs_info);
+	if (ret && !bio->bi_status)
+		bio->bi_status = errno_to_blk_status(ret);
+	if (bio->bi_status)
+		btrfs_log_dev_io_error(bio, dev);
+	btrfs_check_read_bio(bbio, dev);
+}
+
 static bool btrfs_is_rst_raid56_bioc(struct btrfs_io_context *bioc)
 {
 	if (!bioc)
@@ -652,7 +670,7 @@ static void btrfs_submit_bio(struct bio *bio, struct btrfs_io_context *bioc,
 			raid56_parity_write(bio, bioc);
 	} else if (btrfs_is_rst_raid56_bioc(bioc)) {
 		if (bio_op(bio) == REQ_OP_READ)
-			ASSERT(0, "RST RAID56 read not implemented yet");
+			btrfs_submit_rst_raid56_read(bio, bioc);
 		else
 			btrfs_submit_raid56_write(bio, bioc);
 	} else {
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 28aa5e5b21bd..ebf416281274 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -414,9 +414,10 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
+static int btrfs_get_raid_extent(struct btrfs_fs_info *fs_info,
 				 u64 logical, u64 *length, u64 map_type,
-				 u32 stripe_index, struct btrfs_io_stripe *stripe)
+				 u32 stripe_index, u8 type,
+				 struct btrfs_io_stripe *stripe)
 {
 	struct btrfs_root *stripe_root = fs_info->stripe_root;
 	struct btrfs_stripe_extent *stripe_extent;
@@ -425,7 +426,6 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	BTRFS_PATH_AUTO_FREE(path);
 	struct extent_buffer *leaf;
 	const u64 end = logical + *length;
-	int type = BTRFS_RAID_STRIPE_KEY;
 	int num_stripes;
 	u64 offset;
 	u64 found_logical;
@@ -495,6 +495,37 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	num_stripes = btrfs_num_raid_stripes(btrfs_item_size(leaf, slot));
 	stripe_extent = btrfs_item_ptr(leaf, slot, struct btrfs_stripe_extent);
 
+	if (map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		/*
+		 * Unlike the other profiles, a RAID56 data (or parity) column is
+		 * not placed on a device the caller can derive from the chunk's
+		 * geometric rotation: with a zone append the device picks where
+		 * the write lands, so the stripe tree records the device the
+		 * column actually went to. Trust that recorded (devid, physical)
+		 * rather than the caller's rotation-derived device - matching
+		 * against the latter can spuriously miss and return -ENODATA for
+		 * data that is present, just on a different device.
+		 */
+		struct btrfs_raid_stride *stride = &stripe_extent->strides[0];
+		BTRFS_DEV_LOOKUP_ARGS(args);
+		struct btrfs_device *dev;
+
+		args.devid = btrfs_raid_stride_devid(leaf, stride);
+		dev = btrfs_find_device(fs_info->fs_devices, &args);
+		if (!dev) {
+			ret = -ENODATA;
+			goto out;
+		}
+
+		stripe->dev = dev;
+		stripe->physical = btrfs_raid_stride_physical(leaf, stride) + offset;
+
+		trace_btrfs_get_raid_extent_offset(fs_info, logical, *length,
+						   stripe->physical, args.devid);
+
+		return 0;
+	}
+
 	for (int i = 0; i < num_stripes; i++) {
 		struct btrfs_raid_stride *stride = &stripe_extent->strides[i];
 		u64 devid = btrfs_raid_stride_devid(leaf, stride);
@@ -529,6 +560,24 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
+				 u64 logical, u64 *length, u64 map_type,
+				 u32 stripe_index, struct btrfs_io_stripe *stripe)
+{
+	return btrfs_get_raid_extent(fs_info, logical, length, map_type,
+				     stripe_index, BTRFS_RAID_STRIPE_KEY,
+				     stripe);
+}
+
+int btrfs_get_parity_extent(struct btrfs_fs_info *fs_info,
+			    u64 logical, u64 *length, u64 map_type,
+			    struct btrfs_io_stripe *stripe)
+{
+	return btrfs_get_raid_extent(fs_info, logical, length, map_type,
+				     0, BTRFS_RAID_STRIPE_PARITY_KEY,
+				     stripe);
+}
+
 struct btrfs_stripe_unit {
 	struct btrfs_io_stripe *pstripe;
 	struct bio *bio;
@@ -840,3 +889,152 @@ int btrfs_rst_raid56_write(struct btrfs_bio *orig,
 
 	return 0;
 }
+
+static int btrfs_rst_read_stripe(struct btrfs_device *dev, u64 physical,
+				 struct folio *folio, u64 len)
+{
+	struct bio *bio;
+	int ret;
+
+	if (!dev->bdev)
+		return -EIO;
+
+	bio = bio_alloc(dev->bdev, 1, REQ_OP_READ, GFP_NOFS);
+	if (!bio)
+		return -ENOMEM;
+
+	bio_add_folio_nofail(bio, folio, len, 0);
+	bio->bi_iter.bi_sector = physical >> SECTOR_SHIFT;
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+
+	return ret;
+}
+
+int btrfs_rst_raid56_read(struct btrfs_bio *orig,
+			  struct btrfs_io_context *bioc)
+{
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
+	const unsigned int nr_parity = btrfs_nr_parity_stripes(bioc->map_type);
+	const unsigned int nr_data = bioc->num_stripes - nr_parity;
+	const unsigned int target = btrfs_bioc_to_stripe_nr(bioc);
+	const u64 full = bioc->full_stripe_logical;
+	const u64 off_in_stripe =
+		bioc->logical - (full + (u64)target * BTRFS_STRIPE_LEN);
+	const u64 len = orig->bio.bi_iter.bi_size;
+	const int order = get_order(len);
+	struct btrfs_io_stripe pstripe = { 0 };
+	struct folio **folios = NULL;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	void **bufs = NULL;
+	u64 plen = len;
+	u64 off;
+	unsigned int idx = 0;
+	int ret;
+
+	const bool target_present = bioc->stripes[target].dev->bdev != NULL;
+	bool others_present = true;
+
+	for (int i = 0; i < bioc->num_stripes; i++)
+		if (i != target && !bioc->stripes[i].dev->bdev)
+			others_present = false;
+
+	if (target_present && (orig->mirror_num <= 1 || !others_present)) {
+		struct btrfs_io_stripe dstripe = { 0 };
+		u64 dlen = len;
+
+		dstripe.dev = bioc->stripes[target].dev;
+		ret = btrfs_get_raid_extent_offset(fs_info, bioc->logical, &dlen,
+						   bioc->map_type, 0, &dstripe);
+		if (ret)
+			return ret;
+
+		bio_set_dev(&orig->bio, dstripe.dev->bdev);
+		orig->bio.bi_iter.bi_sector = dstripe.physical >> SECTOR_SHIFT;
+		return submit_bio_wait(&orig->bio);
+	}
+
+	if (!others_present)
+		return -EIO;
+
+	folios = kcalloc(nr_data, sizeof(*folios), GFP_NOFS);
+	if (!folios) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bufs = kcalloc(nr_data, sizeof(*bufs), GFP_NOFS);
+	if (!bufs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (int i = 0; i < nr_data; i++) {
+		struct btrfs_io_stripe s = { 0 };
+		u64 slogical = full + (u64)i * BTRFS_STRIPE_LEN + off_in_stripe;
+		u64 slen = len;
+
+		if (i == target)
+			continue;
+
+		s.dev = bioc->stripes[i].dev;
+		ret = btrfs_get_raid_extent_offset(fs_info, slogical, &slen,
+						   bioc->map_type, 0, &s);
+		if (ret)
+			goto out;
+
+		folios[idx] = folio_alloc(GFP_NOFS, order);
+		if (!folios[idx]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = btrfs_rst_read_stripe(s.dev, s.physical, folios[idx], len);
+		if (ret)
+			goto out;
+
+		bufs[idx] = folio_address(folios[idx]);
+		idx++;
+	}
+
+	folios[idx] = folio_alloc(GFP_NOFS, order);
+	if (!folios[idx]) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pstripe.dev = bioc->stripes[nr_data].dev;
+	ret = btrfs_get_parity_extent(fs_info, full + off_in_stripe, &plen,
+				      bioc->map_type, &pstripe);
+	if (ret)
+		goto out;
+
+	ret = btrfs_rst_read_stripe(pstripe.dev, pstripe.physical, folios[idx],
+				    len);
+	if (ret)
+		goto out;
+
+	bufs[idx] = folio_address(folios[idx]);
+	idx++;
+
+	xor_gen(bufs[idx - 1], bufs, idx - 1, len);
+
+	off = 0;
+	bio_for_each_segment(bv, &orig->bio, iter) {
+		memcpy_to_bvec(&bv, (const char *)bufs[idx - 1] + off);
+		off += bv.bv_len;
+	}
+	ret = 0;
+
+out:
+	if (folios) {
+		for (unsigned int i = 0; i < nr_data; i++)
+			if (folios[i])
+				folio_put(folios[i]);
+	}
+	kfree(folios);
+	kfree(bufs);
+
+	return ret;
+}
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 6daa00184f8e..bf8b66b5ad8c 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -28,10 +28,15 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 				 u64 logical, u64 *length, u64 map_type,
 				 u32 stripe_index, struct btrfs_io_stripe *stripe);
+int btrfs_get_parity_extent(struct btrfs_fs_info *fs_info,
+			    u64 logical, u64 *length, u64 map_type,
+			    struct btrfs_io_stripe *stripe);
 int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent);
 int btrfs_rst_raid56_write(struct btrfs_bio *bbio,
 			   struct btrfs_io_context *bioc);
+int btrfs_rst_raid56_read(struct btrfs_bio *orig,
+			  struct btrfs_io_context *bioc);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
-- 
2.54.0

