Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBB8263F44
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111724; cv=none; b=Nsd7V2bpA2UOxTrNCTzVksm9sX/SksBAtEqf3Vw2P/6Bxd9mloN/2vjuCNrFnl0umT46B1GCRI3toHNuYYuaAI+pmJhdvmymAKv5r3MOK4BYgwz55b2fz+YvSJYCRYnusOBETlYQNTp/lbKnPCT2kbjovhiK+xVUMP4hKFsMbPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111724; c=relaxed/simple;
	bh=GU0TlVW7IxXSSbSWPt121IDYY+LCxKBnwnuz+XoasT8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJDxe8Z2JIdYhi+aH5wwVN3uatl7m0tKzR+TGDlllejIr35Bdeo8oRGCb/+aXguVrqWE1IeUmaKYN9sWx8mEo1qNre4pBZkaCOBEiPxhM+f5RjYB4VLHMpjoXRcDCTekOHDJE7crjmuSgRr1n4DesMzj41IVyr9gqjn9/Km0iaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RQAAmag4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RQAAmag4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RQAAmag4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RQAAmag4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CB691FD71
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaB4Flpd3Ic4xYfjHtrZ7+felmkSmFwqU+Kst4BzLec=;
	b=RQAAmag4ge2glDjx+dg1Vpl5RU+p8p8Vcf1R8+rUKwkngDydVevI5uhoZTNnVYHZWScFk4
	IoHgI8If/8BF7BwM1/6FYqfPXlXd2PQneibAIl13+xvo7X4Tfx3Bw7XQfUYxtIQfilqNyg
	RIlwfczB9hmfxL6hGJb13V/Qo7WnnKM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaB4Flpd3Ic4xYfjHtrZ7+felmkSmFwqU+Kst4BzLec=;
	b=RQAAmag4ge2glDjx+dg1Vpl5RU+p8p8Vcf1R8+rUKwkngDydVevI5uhoZTNnVYHZWScFk4
	IoHgI8If/8BF7BwM1/6FYqfPXlXd2PQneibAIl13+xvo7X4Tfx3Bw7XQfUYxtIQfilqNyg
	RIlwfczB9hmfxL6hGJb13V/Qo7WnnKM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 046771339F
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id inJNK2V00WojCAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: rename btrfs_chunk_map::stripe_size
Date: Fri, 16 Oct 2026 11:18:17 +1030
Message-ID: <2de717ff9795d0e69a843f7190cd96b7a7750add.1792111604.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792111604.git.wqu@suse.com>
References: <cover.1792111604.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

The member btrfs_chunk_map::stripe_size sounds very similar to
btrfs_chunk::stripe_len, but they have very different meanings.

btrfs_chunk_map::stripe_size is in fact the device extent size for the
chunk. E.g. a 2GiB RAID0 chunk with 2 stripes,
btrfs_chunk_map::stripe_size will be 1GiB (2GiB / 2).

But btrfs_chunk::stripe_len is the stripe length that striping profiles
should follow, and the value is now fixed to 64KiB.
E.g. for a 2GiB RAID0 chunk with 2 stripes, every write will be split
into 64KiB stripes, and then distributed across the 2 devices.

To avoid confusion, rename btrfs_chunk_map::stripe_size to
dev_extent_size.

And since we're here, also rename the helper btrfs_calc_stripe_length()
to btrfs_calc_dev_extent_size().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c            |  4 ++--
 fs/btrfs/scrub.c                  |  2 +-
 fs/btrfs/tests/extent-map-tests.c |  2 +-
 fs/btrfs/volumes.c                | 20 ++++++++++----------
 fs/btrfs/volumes.h                |  4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8ff21dde9a46..1896a4ae91a6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2326,7 +2326,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 	if (IS_ERR(map))
 		return -EIO;
 
-	data_stripe_length = map->stripe_size;
+	data_stripe_length = map->dev_extent_size;
 	io_stripe_size = BTRFS_STRIPE_LEN;
 	chunk_start = map->start;
 
@@ -2945,7 +2945,7 @@ static int insert_dev_extents(struct btrfs_trans_handle *trans,
 		dev_offset = map->stripes[i].physical;
 
 		ret = insert_dev_extent(trans, device, chunk_offset, dev_offset,
-					map->stripe_size);
+					map->dev_extent_size);
 		if (ret)
 			break;
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 479c0e037015..cb17aef81166 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2410,7 +2410,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	int ret;
 	int ret2;
 	u64 physical = map->stripes[stripe_index].physical;
-	const u64 dev_stripe_len = btrfs_calc_stripe_length(map);
+	const u64 dev_stripe_len = btrfs_calc_dev_extent_size(map);
 	const u64 physical_end = physical + dev_stripe_len;
 	u64 logical;
 	u64 logic_end;
diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 811f36d41101..80f39c87268b 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -1029,7 +1029,7 @@ static int test_rmap_block(struct btrfs_fs_info *fs_info,
 	/* Start at 4GiB logical address */
 	map->start = SZ_4G;
 	map->chunk_len = test->data_stripe_size * test->num_data_stripes;
-	map->stripe_size = test->data_stripe_size;
+	map->dev_extent_size = test->data_stripe_size;
 	map->num_stripes = test->num_stripes;
 	map->type = test->raid_type;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f1305f68b1f8..2db449f7c495 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6090,7 +6090,7 @@ static void chunk_map_device_set_bits(struct btrfs_chunk_map *map, unsigned int
 		struct btrfs_device *device = stripe->dev;
 
 		btrfs_set_extent_bit(&device->alloc_state, stripe->physical,
-				     stripe->physical + map->stripe_size - 1,
+				     stripe->physical + map->dev_extent_size - 1,
 				     bits | EXTENT_NOWAIT, NULL);
 	}
 }
@@ -6102,7 +6102,7 @@ void btrfs_chunk_map_device_clear_bits(struct btrfs_chunk_map *map, unsigned int
 		struct btrfs_device *device = stripe->dev;
 
 		btrfs_clear_extent_bit(&device->alloc_state, stripe->physical,
-				       stripe->physical + map->stripe_size - 1,
+				       stripe->physical + map->dev_extent_size - 1,
 				       bits | EXTENT_NOWAIT, NULL);
 	}
 }
@@ -6199,7 +6199,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 
 	map->start = start;
 	map->chunk_len = ctl->chunk_size;
-	map->stripe_size = ctl->stripe_size;
+	map->dev_extent_size = ctl->stripe_size;
 	map->on_disk_type = type;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
@@ -7650,7 +7650,7 @@ static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
 			      devid, uuid);
 }
 
-u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map)
+u64 btrfs_calc_dev_extent_size(const struct btrfs_chunk_map *map)
 {
 	const int data_stripes = calc_data_stripes(map->type, map->num_stripes);
 
@@ -7778,9 +7778,9 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	set_real_chunk_type(map);
 
 	if (num_stripes > 0)
-		map->stripe_size = btrfs_calc_stripe_length(map);
+		map->dev_extent_size = btrfs_calc_dev_extent_size(map);
 	else
-		map->stripe_size = 0;
+		map->dev_extent_size = 0;
 
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
@@ -8673,7 +8673,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct btrfs_chunk_map *map;
 	struct btrfs_device *dev;
-	u64 stripe_len;
+	u64 dev_extent_size;
 	bool found = false;
 	int ret = 0;
 	int i;
@@ -8687,12 +8687,12 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	stripe_len = btrfs_calc_stripe_length(map);
-	if (unlikely(physical_len != stripe_len)) {
+	dev_extent_size = btrfs_calc_dev_extent_size(map);
+	if (unlikely(physical_len != dev_extent_size)) {
 		btrfs_err(fs_info,
 "dev extent physical offset %llu on devid %llu length doesn't match chunk %llu, have %llu expect %llu",
 			  physical_offset, devid, map->start, physical_len,
-			  stripe_len);
+			  dev_extent_size);
 		ret = -EUCLEAN;
 		goto out;
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6eddda239221..67464025e449 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -628,7 +628,7 @@ struct btrfs_chunk_map {
 	refcount_t refs;
 	u64 start;
 	u64 chunk_len;
-	u64 stripe_size;
+	u64 dev_extent_size;
 	/*
 	 * The real type that is utilized during logical address mapping.
 	 *
@@ -799,7 +799,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev,
 void btrfs_free_device(struct btrfs_device *device);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    u64 logical);
-u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map);
+u64 btrfs_calc_dev_extent_size(const struct btrfs_chunk_map *map);
 int btrfs_nr_parity_stripes(u64 type);
 int btrfs_chunk_alloc_add_chunk_item(struct btrfs_trans_handle *trans,
 				     struct btrfs_block_group *bg);
-- 
2.56.0

