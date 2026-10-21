Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554018;
	b=tXNikL7DCw3nfMT+2pB6cmjP4GrXuGMZq5bSRpEtCOCnz5U0NHT213OWsU/ygt965oiP
	 trzZcc5zF+YHYIyLLHE3+GMS1HJxz0R9kbBCpAw0nYw/dSSW1c+hG2G2lnzBi33l/mVN2
	 ZDI0f7E5WPHfJ79UKQqx1HZZ5n+AuCXJ1NNjn1mmUQl4G1Ksd2IYNMy5DCtWOQzlzeArD
	 bemMRAZzxPMPQOm7cgmOOdycem6cxtKlIGy0Z7do5yqGs3laNAnq1s9gXw/9aYTi+tu1l
	 UUkrL4SZd9rSMEwhhb9VAz6YMhRnwVGR2+eVKkIKfOyGxhX9u0Hu00njgJ9Y3SnbsLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554018;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=N1nf3ciNN3eIm4lktjs7Oc3MUL3PEcwahc6e56p32K4=;
	b=P1yYITybRXocarHS0+BeVxozcsVBEW/bTJVCG7j8SVtqCfksEk2dHp56zzWBlcB1Bgzf
	 3frhXHgtAxMf6Ns8XPeApCWP7SUjXMev8YDpVlYVW4t7WIvUAVmTwqcFTqm2570I6KaEq
	 oepfNV4NMEgfF5zd2YcKTSjBSetZmlsmQbiKSUzn2rao2lMOnhDignVLG3xKUrFAc7MOP
	 Z7fllFVAlBJlxqq3cm5eGjvQEKfcIL2rZFdwybspYxILPrj4Gk7qjj5jM3BK6hFS6jT2O
	 rS2e1l+/v86WQeL6IStxF3x4JnsJGdEoBn1HWzUQrg+PvvwxJcYa8yhtXpePy21GI4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="S6tzyGa/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="S6tzyGa/";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE506606A32E
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE506606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S6tzyGa/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S6tzyGa/
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 45B561F7E9
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1nf3ciNN3eIm4lktjs7Oc3MUL3PEcwahc6e56p32K4=;
	b=S6tzyGa/6g2iC/uP9shVMzDHqUK334RlQoXY/NYpapwjiEr1uhO4qU8UbudNDnueCCNkau
	TdxiSIwy7u2HytVHfOX0VkwSTEtvnE9ue+Z/YNPFtzWlpZEiyE/mduu3JkMZz3fwNTwgpl
	4Psbi/+L8ElMBZFQa2vux/G+MHhuu1M=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="S6tzyGa/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1nf3ciNN3eIm4lktjs7Oc3MUL3PEcwahc6e56p32K4=;
	b=S6tzyGa/6g2iC/uP9shVMzDHqUK334RlQoXY/NYpapwjiEr1uhO4qU8UbudNDnueCCNkau
	TdxiSIwy7u2HytVHfOX0VkwSTEtvnE9ue+Z/YNPFtzWlpZEiyE/mduu3JkMZz3fwNTwgpl
	4Psbi/+L8ElMBZFQa2vux/G+MHhuu1M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 356D0134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/9] btrfs: add a new 'stripe_len' parameter to btrfs_stripe_nr_to_offset()
Date: Wed, 21 Oct 2026 14:09:39 +1030
Message-ID: <5c4aca2692c0971f6a28ff25d72ef0e591ecf51f.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792553748.git.wqu@suse.com>
References: <cover.1792553748.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 45B561F7E9
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -3.01

That helper is currently using a fixed BTRFS_STRIPE_LEN, change it to
accept a 'u32 stripe_len'.

Also add an ASSERT() to make sure the @stripe_len passed in is power of
2, and no larger than BTRFS_STRIPE_LEN.

There is a special case where we still pass BTRFS_STRIPE_LEN into
btrfs_stripe_nr_to_offset(), that's for chunk allocation to determine
the minimal device extent size.

In that case, since our future planned map->stripe_len is always power
of 2 and no larger than BTRFS_STRIPE_LEN, we are totally fine to use the
old BTRFS_STRIPE_LEN.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c |  3 ++-
 fs/btrfs/scrub.c       | 32 +++++++++++++++++++-------------
 fs/btrfs/volumes.c     | 40 +++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.h     |  5 +++--
 fs/btrfs/zoned.c       |  7 +++++--
 5 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index f2b55ffbdaef..c0d735cee4a8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2302,7 +2302,8 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 
 	/* For RAID5/6 adjust to a full IO stripe length */
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-		io_stripe_size = btrfs_stripe_nr_to_offset(nr_data_stripes(map));
+		io_stripe_size = btrfs_stripe_nr_to_offset(nr_data_stripes(map),
+							   map->stripe_len);
 
 	buf = kzalloc_objs(u64, map->num_stripes, GFP_NOFS);
 	if (!buf) {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c3387e109779..98362c91bce4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1425,7 +1425,8 @@ static int get_raid56_logic_offset(u64 physical, int num,
 		u32 stripe_index;
 		u32 rot;
 
-		*offset = last_offset + btrfs_stripe_nr_to_offset(i);
+		*offset = last_offset + btrfs_stripe_nr_to_offset(i,
+							map->stripe_len);
 
 		stripe_nr = (u32)(*offset >> map->stripe_shift) / data_stripes;
 
@@ -1439,7 +1440,7 @@ static int get_raid56_logic_offset(u64 physical, int num,
 		if (stripe_index < num)
 			j++;
 	}
-	*offset = last_offset + btrfs_stripe_nr_to_offset(j);
+	*offset = last_offset + btrfs_stripe_nr_to_offset(j, map->stripe_len);
 	return 1;
 }
 
@@ -1924,7 +1925,8 @@ static void submit_initial_group_read(struct scrub_ctx *sctx,
 	ASSERT(first_slot + nr_stripes <= SCRUB_TOTAL_STRIPES);
 
 	scrub_throttle_dev_io(sctx, sctx->stripes[0].dev,
-			      btrfs_stripe_nr_to_offset(nr_stripes));
+			      btrfs_stripe_nr_to_offset(nr_stripes,
+						sctx->stripes[0].stripe_len));
 	blk_start_plug(&plug);
 	for (int i = 0; i < nr_stripes; i++) {
 		struct scrub_stripe *stripe = &sctx->stripes[first_slot + i];
@@ -2102,7 +2104,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 	struct btrfs_raid_bio *rbio;
 	struct bio bio;
 	const int data_stripes = nr_data_stripes(map);
-	u64 length = btrfs_stripe_nr_to_offset(data_stripes);
+	u64 length = btrfs_stripe_nr_to_offset(data_stripes, map->stripe_len);
 	int ret;
 
 	bio_init(&bio, NULL, NULL, 0, REQ_OP_READ);
@@ -2151,6 +2153,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 	BTRFS_PATH_AUTO_RELEASE(csum_path);
 	struct scrub_stripe *stripe;
 	bool all_empty = true;
+	const u32 stripe_len = map->stripe_len;
 	const int data_stripes = nr_data_stripes(map);
 	unsigned long extent_bitmap = 0;
 	int ret;
@@ -2191,14 +2194,15 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 			      data_stripes) >> map->stripe_shift;
 		stripe_index = (i + rot) % map->num_stripes;
 		physical = map->stripes[stripe_index].physical +
-			   btrfs_stripe_nr_to_offset(rot);
+			   btrfs_stripe_nr_to_offset(rot, stripe_len);
 
 		scrub_reset_stripe(stripe);
 		set_bit(SCRUB_STRIPE_FLAG_NO_REPORT, &stripe->state);
 		ret = scrub_find_fill_first_stripe(bg, &extent_path, &csum_path,
 				map->stripes[stripe_index].dev, physical, 1,
-				full_stripe_start + btrfs_stripe_nr_to_offset(i),
-				map->stripe_len, stripe);
+				full_stripe_start +
+				btrfs_stripe_nr_to_offset(i, stripe_len),
+				stripe_len, stripe);
 		if (ret < 0)
 			return ret;
 		/*
@@ -2207,7 +2211,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 		 */
 		if (ret > 0) {
 			stripe->logical = full_stripe_start +
-					  btrfs_stripe_nr_to_offset(i);
+					  btrfs_stripe_nr_to_offset(i, stripe_len);
 			stripe->dev = map->stripes[stripe_index].dev;
 			stripe->mirror_num = 1;
 			set_bit(SCRUB_STRIPE_FLAG_INITIALIZED, &stripe->state);
@@ -2348,7 +2352,8 @@ static u64 simple_stripe_full_stripe_len(const struct btrfs_chunk_map *map)
 	ASSERT(map->type & (BTRFS_BLOCK_GROUP_RAID0 |
 			    BTRFS_BLOCK_GROUP_RAID10));
 
-	return btrfs_stripe_nr_to_offset(map->num_stripes / map->sub_stripes);
+	return btrfs_stripe_nr_to_offset(map->num_stripes / map->sub_stripes,
+					 map->stripe_len);
 }
 
 /* Get the logical bytenr for the stripe */
@@ -2364,8 +2369,8 @@ static u64 simple_stripe_get_logical(struct btrfs_chunk_map *map,
 	 * (stripe_index / sub_stripes) gives how many data stripes we need to
 	 * skip.
 	 */
-	return btrfs_stripe_nr_to_offset(stripe_index / map->sub_stripes) +
-	       bg->start;
+	return btrfs_stripe_nr_to_offset(stripe_index / map->sub_stripes,
+					 map->stripe_len) + bg->start;
 }
 
 /* Get the mirror number for the stripe */
@@ -2504,7 +2509,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	}
 	if (profile & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID10)) {
 		ret = scrub_simple_stripe(sctx, bg, map, scrub_dev, stripe_index);
-		offset = btrfs_stripe_nr_to_offset(stripe_index / map->sub_stripes);
+		offset = btrfs_stripe_nr_to_offset(stripe_index / map->sub_stripes,
+						   stripe_len);
 		goto out;
 	}
 
@@ -2519,7 +2525,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 	/* Initialize @offset in case we need to go to out: label */
 	get_raid56_logic_offset(physical, stripe_index, map, &offset, NULL);
-	increment = btrfs_stripe_nr_to_offset(nr_data_stripes(map));
+	increment = btrfs_stripe_nr_to_offset(nr_data_stripes(map), stripe_len);
 
 	/*
 	 * Due to the rotation, for RAID56 it's better to iterate each stripe
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ff7189ac1c49..6a3ae8a081fe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5823,7 +5823,8 @@ static void init_alloc_chunk_ctl_policy_regular(
 	/* We don't want a chunk larger than 10% of writable space */
 	ctl->max_chunk_size = min(mult_perc(fs_devices->total_rw_bytes, 10),
 				  ctl->max_chunk_size);
-	ctl->dev_extent_min = btrfs_stripe_nr_to_offset(ctl->dev_stripes);
+	ctl->dev_extent_min = btrfs_stripe_nr_to_offset(ctl->dev_stripes,
+							BTRFS_STRIPE_LEN);
 }
 
 static void init_alloc_chunk_ctl_policy_zoned(
@@ -6587,7 +6588,8 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 
 	if (!WARN_ON(IS_ERR(map))) {
 		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-			len = btrfs_stripe_nr_to_offset(nr_data_stripes(map));
+			len = btrfs_stripe_nr_to_offset(nr_data_stripes(map),
+							map->stripe_len);
 		btrfs_free_chunk_map(map);
 	}
 	return len;
@@ -6784,6 +6786,7 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 	u64 stripe_end_offset;
 	u64 stripe_offset;
 	u32 stripe_index;
+	u32 stripe_len;
 	u32 factor = 0;
 	u32 sub_stripes = 0;
 	u32 stripes_per_dev = 0;
@@ -6820,6 +6823,7 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 		goto out_free_map;
 	}
 
+	stripe_len = map->stripe_len;
 	offset = logical - map->start;
 	length = min_t(u64, map->start + map->chunk_len - logical, length);
 	*length_ret = length;
@@ -6831,12 +6835,13 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 	stripe_nr = offset >> BTRFS_STRIPE_LEN_SHIFT;
 
 	/* stripe_offset is the offset of this block in its stripe */
-	stripe_offset = offset - btrfs_stripe_nr_to_offset(stripe_nr);
+	stripe_offset = offset - btrfs_stripe_nr_to_offset(stripe_nr,
+							   stripe_len);
 
 	stripe_nr_end = round_up(offset + length, BTRFS_STRIPE_LEN) >>
 			BTRFS_STRIPE_LEN_SHIFT;
 	stripe_cnt = stripe_nr_end - stripe_nr;
-	stripe_end_offset = btrfs_stripe_nr_to_offset(stripe_nr_end) -
+	stripe_end_offset = btrfs_stripe_nr_to_offset(stripe_nr_end, stripe_len) -
 			    (offset + length);
 	/*
 	 * after this, stripe_nr is the number of stripes on this
@@ -6879,12 +6884,14 @@ struct btrfs_discard_stripe *btrfs_map_discard(struct btrfs_fs_info *fs_info,
 	for (i = 0; i < *num_stripes; i++) {
 		stripes[i].physical =
 			map->stripes[stripe_index].physical +
-			stripe_offset + btrfs_stripe_nr_to_offset(stripe_nr);
+			stripe_offset + btrfs_stripe_nr_to_offset(stripe_nr,
+								  stripe_len);
 		stripes[i].dev = map->stripes[stripe_index].dev;
 
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
 				 BTRFS_BLOCK_GROUP_RAID10)) {
-			stripes[i].length = btrfs_stripe_nr_to_offset(stripes_per_dev);
+			stripes[i].length = btrfs_stripe_nr_to_offset(stripes_per_dev,
+								      stripe_len);
 
 			if (i / sub_stripes < remaining_stripes)
 				stripes[i].length += BTRFS_STRIPE_LEN;
@@ -7022,6 +7029,8 @@ static void handle_ops_on_dev_replace(struct btrfs_io_context *bioc,
 static u64 btrfs_max_io_len(struct btrfs_chunk_map *map, u64 offset,
 			    struct btrfs_io_geometry *io_geom)
 {
+	const u32 stripe_len = map->stripe_len;
+
 	/*
 	 * Stripe_nr is the stripe where this block falls.  stripe_offset is
 	 * the offset of this block in its stripe.
@@ -7033,7 +7042,8 @@ static u64 btrfs_max_io_len(struct btrfs_chunk_map *map, u64 offset,
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		unsigned long full_stripe_len =
-			btrfs_stripe_nr_to_offset(nr_data_stripes(map));
+			btrfs_stripe_nr_to_offset(nr_data_stripes(map),
+						  stripe_len);
 
 		/*
 		 * For full stripe start, we use previously calculated
@@ -7045,7 +7055,8 @@ static u64 btrfs_max_io_len(struct btrfs_chunk_map *map, u64 offset,
 		 * not ensured to be power of 2.
 		 */
 		io_geom->raid56_full_stripe_start = btrfs_stripe_nr_to_offset(
-			rounddown(io_geom->stripe_nr, nr_data_stripes(map)));
+			rounddown(io_geom->stripe_nr, nr_data_stripes(map)),
+			stripe_len);
 
 		ASSERT(io_geom->raid56_full_stripe_start + full_stripe_len > offset,
 		       "raid56_full_stripe_start=%llu full_stripe_len=%lu offset=%llu",
@@ -7084,7 +7095,8 @@ static int set_io_stripe(struct btrfs_fs_info *fs_info, u64 logical,
 
 	dst->physical = map->stripes[io_geom->stripe_index].physical +
 			io_geom->stripe_offset +
-			btrfs_stripe_nr_to_offset(io_geom->stripe_nr);
+			btrfs_stripe_nr_to_offset(io_geom->stripe_nr,
+						  map->stripe_len);
 	return 0;
 }
 
@@ -7207,7 +7219,7 @@ static void map_blocks_raid56_write(struct btrfs_chunk_map *map,
 	/* Return the length to the full stripe end. */
 	*length = min(logical + *length,
 		      io_geom->raid56_full_stripe_start + map->start +
-		      btrfs_stripe_nr_to_offset(data_stripes)) -
+		      btrfs_stripe_nr_to_offset(data_stripes, map->stripe_len)) -
 		logical;
 	io_geom->stripe_index = 0;
 	io_geom->stripe_offset = 0;
@@ -7434,7 +7446,8 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		 */
 		bioc->full_stripe_logical = map->start +
 			btrfs_stripe_nr_to_offset(io_geom.stripe_nr *
-						  nr_data_stripes(map));
+						  nr_data_stripes(map),
+						  map->stripe_len);
 		for (int i = 0; i < io_geom.num_stripes; i++) {
 			struct btrfs_io_stripe *dst = &bioc->stripes[i];
 			u32 stripe_index;
@@ -7444,7 +7457,8 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 			dst->physical =
 				map->stripes[stripe_index].physical +
 				io_geom.stripe_offset +
-				btrfs_stripe_nr_to_offset(io_geom.stripe_nr);
+				btrfs_stripe_nr_to_offset(io_geom.stripe_nr,
+							  map->stripe_len);
 		}
 	} else {
 		/*
@@ -9070,7 +9084,7 @@ static void map_raid56_repair_block(struct btrfs_io_context *bioc,
 
 	for (i = 0; i < data_stripes; i++) {
 		u64 stripe_start = bioc->full_stripe_logical +
-				   btrfs_stripe_nr_to_offset(i);
+				   btrfs_stripe_nr_to_offset(i, bioc->stripe_len);
 
 		if (logical >= stripe_start &&
 		    logical < stripe_start + BTRFS_STRIPE_LEN)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9356cec00a90..75b1179776c8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -722,9 +722,10 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
  * @stripe_nr is u32, with left shift it can overflow u32 for chunks larger
  * than 4G.  This does the proper type cast to avoid overflow.
  */
-static inline u64 btrfs_stripe_nr_to_offset(u32 stripe_nr)
+static inline u64 btrfs_stripe_nr_to_offset(u32 stripe_nr, u32 stripe_len)
 {
-	return (u64)stripe_nr << BTRFS_STRIPE_LEN_SHIFT;
+	ASSERT(is_power_of_2(stripe_len) && stripe_len <= BTRFS_STRIPE_LEN);
+	return (u64)stripe_nr << ilog2(stripe_len);
 }
 
 void btrfs_get_bioc(struct btrfs_io_context *bioc);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1cda88332284..37084c8d8d75 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1630,7 +1630,9 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
 			has_conventional = true;
-			zone_info[i].alloc_offset = btrfs_stripe_nr_to_offset(stripe_nr);
+			zone_info[i].alloc_offset =
+				btrfs_stripe_nr_to_offset(stripe_nr,
+							  map->stripe_len);
 
 			if (stripe_index > i)
 				zone_info[i].alloc_offset += BTRFS_STRIPE_LEN;
@@ -1772,7 +1774,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 
 		if (raid0_allocs[idx] == WP_CONVENTIONAL) {
 			has_conventional = true;
-			raid0_allocs[idx] = btrfs_stripe_nr_to_offset(stripe_nr);
+			raid0_allocs[idx] = btrfs_stripe_nr_to_offset(stripe_nr,
+								map->stripe_len);
 
 			if (stripe_index > idx)
 				raid0_allocs[idx] += BTRFS_STRIPE_LEN;
-- 
2.56.0

