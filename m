Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554020;
	b=owEm0a5TuRkCGPcO5MDSrZRCkQBRV4HBNdXN+438XYH1tsFi6ryiNUzhljJdOqiP/MO6
	 QR/H5sfJBenLp+bKBAXeWKaw/5WO6oqr7BvMfmK3ueCS7b70jXY7M7eIu9SMmpNV1qKke
	 n/e6QopCppIKcA4qu5F3x3Oxbkqc+CnQd1mNBq4KQGxn7WtV+TZzI5zyLhvA3royMNpXU
	 yI+xGNkHW/gtrCWdjj0Fd2g97ByU6FNKXI8wZeBm28+w5HzGqsRBUbhyHFat8EQI3Ybx4
	 kKSfEzu2a4F2lV5i63sYg1JZHaJeO2p0sKmkDAwIgqFiMzr0JTMtrWA6jhAqfD4CSDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554020;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Action:
	 X-Spam-Score:X-Spam-Flag:X-Spamd-Result:X-Spam-Level:
	 X-Rspamd-Queue-Id:X-Rspamd-Server;
	bh=5B56IEm0RyDAqZqI0lm78P9BsnkFTwJ3U1Km+jfx6z4=;
	b=wFSZifkOj9xbM/i6btrbAj9YaCGNKy3PORWb4nt85xuNbGHAt8IK2qsogXlld0LwhTxe
	 A7Y8TNOS2v5t29SBVNqK7cHqjRxE9q/dOaxY2cnABDuEJfOVFfeqEArMJsWnYRj4AXIpj
	 0E/gaFEuLnRISMcqCCbBkKqV+p0vir+4avntbIyOvMzhmXIwjZo9Sv2prik0XW3JZgOyH
	 TKbOeMaL4yEhbUmz/yiNiBjPonfurKAaxohX+n5f1NBeNODV90JMes5PyQlP905EgBCKb
	 gaw0z8rJ17flmXzMHNkXPG3XJF95txmG9iuC3U0SE36hCzkPD+1JKJIUPO+tpX4G4sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vQLPLJPv;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vQLPLJPv;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7801A606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7801A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vQLPLJPv;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vQLPLJPv
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5C401F7F1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5B56IEm0RyDAqZqI0lm78P9BsnkFTwJ3U1Km+jfx6z4=;
	b=vQLPLJPvKXKulcSq4sFB2bet3E3nP4K5l8T3+wzJhPMWUqDCrPZCSqqwmdfi16ZQJ7dy7v
	mk2MDIWiSN0k2xtpEejp/3qgYBcRO1kqkgMnPMch6svF+W+diPQTM5cmW6T14IVw1fLBon
	BQPphUwnsRbZyHPMqqLzn0xUn/2fHz0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=vQLPLJPv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5B56IEm0RyDAqZqI0lm78P9BsnkFTwJ3U1Km+jfx6z4=;
	b=vQLPLJPvKXKulcSq4sFB2bet3E3nP4K5l8T3+wzJhPMWUqDCrPZCSqqwmdfi16ZQJ7dy7v
	mk2MDIWiSN0k2xtpEejp/3qgYBcRO1kqkgMnPMch6svF+W+diPQTM5cmW6T14IVw1fLBon
	BQPphUwnsRbZyHPMqqLzn0xUn/2fHz0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6AD8134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/9] btrfs: convert volumes.c and block-group.c to use map->stripe_len
Date: Wed, 21 Oct 2026 14:09:40 +1030
Message-ID: <53faf6acf12afafe6479423fd702dcdb75cad0cc.1792553748.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: D5C401F7F1
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

There are still some BTRFS_STRIPE_LEN usage remaining, but they are all
for chunk allocation.

There is one more refactor for is_same_chunk_map(), as there are more
members to compare, the parameter list can go longer and longer.

Instead of passing a new @stripe_len member, pass extent_buffer and
btrfs_chunk pointers, and grab the needed member inside that function.

And doing "if (unlikely()) return false" for each member check.

Although this make is_same_chunk_map() more complex, considering it's
only called for system chunks, it should not bring too much overhead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c |  6 ++---
 fs/btrfs/volumes.c     | 52 ++++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 25 deletions(-)

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
index 6a3ae8a081fe..ce78a9441c64 100644
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
 
@@ -7741,11 +7739,20 @@ static struct btrfs_device *handle_missing_device(struct btrfs_fs_info *fs_info,
 	return dev;
 }
 
-static bool is_same_chunk_map(const struct btrfs_chunk_map *map, u64 logical,
-			      u64 length, u64 type, u16 num_stripes)
+static bool is_same_chunk_map(const struct btrfs_chunk_map *map,
+			      const struct extent_buffer *leaf,
+			      const struct btrfs_chunk *chunk,
+			      u64 logical)
 {
-	if (map->start != logical || map->chunk_len != length ||
-	    map->on_disk_type != type || map->num_stripes != num_stripes)
+	if (unlikely(map->start != logical))
+		return false;
+	if (unlikely(map->chunk_len != btrfs_chunk_length(leaf, chunk)))
+		return false;
+	if (unlikely(map->on_disk_type != btrfs_chunk_type(leaf, chunk)))
+		return false;
+	if (unlikely(map->stripe_len != btrfs_chunk_stripe_len(leaf, chunk)))
+		return false;
+	if (unlikely(map->num_stripes != btrfs_chunk_num_stripes(leaf, chunk)))
 		return false;
 	return true;
 }
@@ -7760,6 +7767,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	u64 length;
 	u64 devid;
 	u64 type;
+	u32 stripe_len;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int index;
 	int num_stripes;
@@ -7770,6 +7778,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	length = btrfs_chunk_length(leaf, chunk);
 	type = btrfs_chunk_type(leaf, chunk);
 	index = btrfs_bg_flags_to_raid_index(type);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
 #if BITS_PER_LONG == 32
@@ -7783,8 +7792,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 
 	/* Already mapped? Check if the existing one matches. */
 	if (map) {
-		if (unlikely(!is_same_chunk_map(map, logical, length,
-						type, num_stripes))) {
+		if (unlikely(!is_same_chunk_map(map, leaf, chunk, logical))) {
 			btrfs_err(fs_info,
 		"existing chunk %llu doesn't match the new one at %llu",
 				  map->start, logical);
@@ -7804,7 +7812,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	map->chunk_len = length;
 	map->num_stripes = num_stripes;
 	map->on_disk_type = type;
-	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	map->stripe_len = stripe_len;
 	map->stripe_shift = ilog2(map->stripe_len);
 	/*
 	 * We can't use the sub_stripes value, as for profiles other than
@@ -9087,14 +9095,14 @@ static void map_raid56_repair_block(struct btrfs_io_context *bioc,
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

