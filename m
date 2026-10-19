Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E36044A3F4
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392041; cv=none; b=lLLohMJ5ZGZxurOxuCKL777gMKTtaoPxq012u9sPoBNnuwX+JhFYdOrf0SWaixdh5vluupLw/ZX03kVvCe1AuGSYl3FswNagi0fTSJU+39QDM4MIZQZ4phMtAeq96eo74AWl1pkgAUaMle3YthUj9+Y3wWXb4r6DqCP8vvxx0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392041; c=relaxed/simple;
	bh=dGRdj7nmmGGBESLU4eYAIwkdpev2fxETMx1JoUW1HV4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glMmWmghMHm3jmzhrkx4e+W39tCHoaUyN0wvQwObCJ/EQdfq+owALnd5O0ZM2m1SRSBkdHigEE8Bp7hHaynfZe60cKhwK43gyxP8H5F9sQdlXor54FoTy0syvYw5UqDqHDC4/3+ra/Sazb/xRqBnJ46DmnwzgavKt016tCGgTrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gIOOdHOQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sahpOj9Q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gIOOdHOQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sahpOj9Q"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6E982200E
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA2bXkJluKEEFzgeNagNu1LlmHMAHvIskWzRbZ4y4Mg=;
	b=gIOOdHOQUOKdBHK1KYPsfxjjV+dQEZHDbYzBzNYs7LffjWYIGYZaKuHLb9AZP381RIWpsc
	PDIE5o62Iyoeau9129ZwiHn+JtdM+HLxZyzWQuw2h2hGxmjxXShKZOrpMd4T6Rbx1p4dTE
	oSqeIyjBg+xnQgADpJ9DOSsVHzRkuao=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=sahpOj9Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA2bXkJluKEEFzgeNagNu1LlmHMAHvIskWzRbZ4y4Mg=;
	b=sahpOj9QeU5s1Nn4u5ia7WgpFM2Nsd/g3ODPPr21nCZxFcOKDxT1YCb7t20BiSwt7KMeYR
	UTqgUqqWIcD1lx31eum2sewyN9n0J9Oj5hQJomD/GjA/0hFnsp4Y+W3eW7BtDb93iwarg+
	gLDDAHvdT2pNjctku7qtfqdnCi5Mz4A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B51461375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: convert volumes.c and block-group.c to use map->stripe_len
Date: Mon, 19 Oct 2026 17:10:02 +1030
Message-ID: <ce051c4b36def7f5104945ef5402b36d175381c1.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
References: <cover.1792391732.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E6E982200E
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

There are still some BTRFS_STRIPE_LEN usage remaining, but they are all
for chunk allocation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c |  6 +++---
 fs/btrfs/volumes.c     | 41 ++++++++++++++++++++++-------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c0d735cee4a8..092cdbedf39f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2297,7 +2297,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 		return -EIO;
 
 	data_stripe_length = map->dev_extent_size;
-	io_stripe_size = BTRFS_STRIPE_LEN;
+	io_stripe_size = map->stripe_len;
 	chunk_start = map->start;
 
 	/* For RAID5/6 adjust to a full IO stripe length */
@@ -2322,9 +2322,9 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 			continue;
 
 		stripe_nr = (physical - map->stripes[i].physical) >>
-			    BTRFS_STRIPE_LEN_SHIFT;
+			    map->stripe_shift;
 		offset = (physical - map->stripes[i].physical) &
-			 BTRFS_STRIPE_LEN_MASK;
+			 (map->stripe_len - 1);
 
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
 				 BTRFS_BLOCK_GROUP_RAID10))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6a3ae8a081fe..c1e2ba046609 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6168,8 +6168,8 @@ struct btrfs_chunk_map *btrfs_alloc_chunk_map(int num_stripes, gfp_t gfp)
 	RB_CLEAR_NODE(&map->rb_node);
 
 	/*
-	 * Initialize the default stripe len, selftests will utilize them
-	 * without an on-disk chunk item.
+	 * Initialize the default stripe len, selftests and some other call
+	 * sites relies on the sane default value.
 	 */
 	map->stripe_len = BTRFS_STRIPE_LEN;
 	map->stripe_shift = ilog2(map->stripe_len);
@@ -6210,8 +6210,6 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	map->on_disk_type = type;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
-	map->stripe_len = BTRFS_STRIPE_LEN;
-	map->stripe_shift = ilog2(BTRFS_STRIPE_LEN);
 	set_real_chunk_type(map);
 
 	for (int i = 0; i < ctl->ndevs; i++) {
@@ -6393,8 +6391,8 @@ int btrfs_chunk_alloc_add_chunk_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_chunk_stripe_len(chunk, map->stripe_len);
 	btrfs_set_stack_chunk_type(chunk, map->on_disk_type);
 	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
-	btrfs_set_stack_chunk_io_align(chunk, BTRFS_STRIPE_LEN);
-	btrfs_set_stack_chunk_io_width(chunk, BTRFS_STRIPE_LEN);
+	btrfs_set_stack_chunk_io_align(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_io_width(chunk, map->stripe_len);
 	btrfs_set_stack_chunk_sector_size(chunk, fs_info->sectorsize);
 	btrfs_set_stack_chunk_sub_stripes(chunk, map->sub_stripes);
 
@@ -6832,14 +6830,14 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 	 * stripe_nr counts the total number of stripes we have to stride
 	 * to get to this block
 	 */
-	stripe_nr = offset >> BTRFS_STRIPE_LEN_SHIFT;
+	stripe_nr = offset >> map->stripe_shift;
 
 	/* stripe_offset is the offset of this block in its stripe */
 	stripe_offset = offset - btrfs_stripe_nr_to_offset(stripe_nr,
 							   stripe_len);
 
-	stripe_nr_end = round_up(offset + length, BTRFS_STRIPE_LEN) >>
-			BTRFS_STRIPE_LEN_SHIFT;
+	stripe_nr_end = round_up(offset + length, stripe_len) >>
+			map->stripe_shift;
 	stripe_cnt = stripe_nr_end - stripe_nr;
 	stripe_end_offset = btrfs_stripe_nr_to_offset(stripe_nr_end, stripe_len) -
 			    (offset + length);
@@ -6894,7 +6892,7 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 								      stripe_len);
 
 			if (i / sub_stripes < remaining_stripes)
-				stripes[i].length += BTRFS_STRIPE_LEN;
+				stripes[i].length += stripe_len;
 
 			/*
 			 * Special for the first stripe and
@@ -7035,8 +7033,8 @@ static u64 btrfs_max_io_len(struct btrfs_chunk_map *map, u64 offset,
 	 * Stripe_nr is the stripe where this block falls.  stripe_offset is
 	 * the offset of this block in its stripe.
 	 */
-	io_geom->stripe_offset = offset & BTRFS_STRIPE_LEN_MASK;
-	io_geom->stripe_nr = offset >> BTRFS_STRIPE_LEN_SHIFT;
+	io_geom->stripe_offset = offset & (stripe_len - 1);
+	io_geom->stripe_nr = offset >> map->stripe_shift;
 	ASSERT(io_geom->stripe_offset < U32_MAX,
 	       "stripe_offset=%llu", io_geom->stripe_offset);
 
@@ -7077,7 +7075,7 @@ static u64 btrfs_max_io_len(struct btrfs_chunk_map *map, u64 offset,
 	 * a single disk).
 	 */
 	if (map->type & BTRFS_BLOCK_GROUP_STRIPE_MASK)
-		return BTRFS_STRIPE_LEN - io_geom->stripe_offset;
+		return stripe_len - io_geom->stripe_offset;
 	return U64_MAX;
 }
 
@@ -7742,10 +7740,12 @@ static struct btrfs_device *handle_missing_device(struct btrfs_fs_info *fs_info,
 }
 
 static bool is_same_chunk_map(const struct btrfs_chunk_map *map, u64 logical,
-			      u64 length, u64 type, u16 num_stripes)
+			      u64 length, u64 type, u32 stripe_len,
+			      u16 num_stripes)
 {
 	if (map->start != logical || map->chunk_len != length ||
-	    map->on_disk_type != type || map->num_stripes != num_stripes)
+	    map->on_disk_type != type || map->stripe_len != stripe_len ||
+	    map->num_stripes != num_stripes)
 		return false;
 	return true;
 }
@@ -7760,6 +7760,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	u64 length;
 	u64 devid;
 	u64 type;
+	u32 stripe_len;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int index;
 	int num_stripes;
@@ -7770,6 +7771,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	length = btrfs_chunk_length(leaf, chunk);
 	type = btrfs_chunk_type(leaf, chunk);
 	index = btrfs_bg_flags_to_raid_index(type);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
 #if BITS_PER_LONG == 32
@@ -7784,7 +7786,8 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	/* Already mapped? Check if the existing one matches. */
 	if (map) {
 		if (unlikely(!is_same_chunk_map(map, logical, length,
-						type, num_stripes))) {
+						type, stripe_len,
+						num_stripes))) {
 			btrfs_err(fs_info,
 		"existing chunk %llu doesn't match the new one at %llu",
 				  map->start, logical);
@@ -7804,7 +7807,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	map->chunk_len = length;
 	map->num_stripes = num_stripes;
 	map->on_disk_type = type;
-	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	map->stripe_len = stripe_len;
 	map->stripe_shift = ilog2(map->stripe_len);
 	/*
 	 * We can't use the sub_stripes value, as for profiles other than
@@ -9087,14 +9090,14 @@ static void map_raid56_repair_block(struct btrfs_io_context *bioc,
 				   btrfs_stripe_nr_to_offset(i, bioc->stripe_len);
 
 		if (logical >= stripe_start &&
-		    logical < stripe_start + BTRFS_STRIPE_LEN)
+		    logical < stripe_start + bioc->stripe_len)
 			break;
 	}
 	ASSERT(i < data_stripes, "i=%d data_stripes=%d", i, data_stripes);
 	smap->dev = bioc->stripes[i].dev;
 	smap->physical = bioc->stripes[i].physical +
 			((logical - bioc->full_stripe_logical) &
-			 BTRFS_STRIPE_LEN_MASK);
+			 (bioc->stripe_len - 1));
 }
 
 /*
-- 
2.56.0

