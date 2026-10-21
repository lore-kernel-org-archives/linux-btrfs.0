Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554023;
	b=IgO0g8O51gv0tAdoo7jA3vmZOr+isSRTxt2ETVi8SshO0YWU86LXreQrUil5p+6rRL99
	 bJ+DtWkTdOscJPBFPRAVUZQE3SyEWDRGi0NZNWPUqDt5DNjBiv39JrsnYWlVpNJ+NuwCF
	 Lql3DqUwvWaeyyrXiaC831HM7iHfJxLPx3liNmrZ46Z3kxurxyvAxKiUsiV2rZn6JVGr3
	 YtNCJi1Mcs+ZQU5wa9+xpII0sK0ink/Mdkg7CGJfmWrqIsbr82bjrj/CXB5sX6dHD9DmT
	 nISrq88Gng8ZG4KkuuOCRcRWHK/qRUZ0iO+CC8Z2c3okHXMul6roRKuq0YaKD1shhsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554023;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=CmQ1XAA8fsjCQIApHOhEV9RpZB64ndsUr6vg5EKajTE=;
	b=41ijhvd1G/FoEySOaD5VNMhM0ORH8qIHTdeXWahGq912W+MLK2oMzw2OU0RIvaybC7Kq
	 fK5h4QWyqobgecwVf/Y32C1lnt3Yw07Mhej6UoN/87atNc0swIvILoJWW8sUoQVDUywOL
	 JfsdRflx4Z9PEIQO+FsrmjazjAVyKfdxITyqinBYaHaiyaUQesrozLFZ70rgoejFVz9/5
	 RIn6vqKrBLxGqrMwK8PelmTVZz5ICqnMSzmEWDjrUbFUlZlEVVbeB6X/5OuD57SF6PbXG
	 m6Env0LyF3gJZRKPWsXg02WipN3nUG/tC3MiKFaixJ8cwVNVPlDDdGj6LN9ntBdH0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="iYx2/9sw";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="iYx2/9sw";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692F9606A33B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 692F9606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iYx2/9sw;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iYx2/9sw
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1232E1F7F1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmQ1XAA8fsjCQIApHOhEV9RpZB64ndsUr6vg5EKajTE=;
	b=iYx2/9swo1jEeLtWcgh446m70rzukJK7GbbPqocGIT5zZNnPUJ1lhJIWD5v6WsY3eUjaiv
	cW+h+wL3Z1qqeo9whBbcR5uSknvUTU52iQO9iVXlgAsH6y2UCe6JpOhADg5U3JgK05bGGR
	7kqWl3ktN3dmsaDQbVO+9h0y8i6Gmbs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="iYx2/9sw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmQ1XAA8fsjCQIApHOhEV9RpZB64ndsUr6vg5EKajTE=;
	b=iYx2/9swo1jEeLtWcgh446m70rzukJK7GbbPqocGIT5zZNnPUJ1lhJIWD5v6WsY3eUjaiv
	cW+h+wL3Z1qqeo9whBbcR5uSknvUTU52iQO9iVXlgAsH6y2UCe6JpOhADg5U3JgK05bGGR
	7kqWl3ktN3dmsaDQbVO+9h0y8i6Gmbs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00AA4134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T9
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 8/9] btrfs: convert zoned.c to use map->stripe_len
Date: Wed, 21 Oct 2026 14:09:42 +1030
Message-ID: <1d86ab0d5458e27fca96d860d07be79ee812994d.1792553748.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 1232E1F7F1
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

There are still several call sites using BTRFS_STRIPE_LEN, but that's
when doing the basic zoned checks.

For other call sites with a btrfs_chunk_map, use map->stripe_len instead
of the hardcoded BTRFS_STRIPE_LEN.

And since we're here, replace the following pattern

	if (val & BTRFS_STRIPE_LEN_MASK)

with
	if (!IS_ALIGNED(val, stripe_len))

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/zoned.c | 55 ++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 37084c8d8d75..6b6228aaa5fa 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1576,6 +1576,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	const u32 stripe_len = map->stripe_len;
+	const u8 stripe_shift = map->stripe_shift;
 	u64 stripe_nr = 0, stripe_offset = 0;
 	u64 prev_offset = 0;
 	u32 stripe_index = 0;
@@ -1599,18 +1601,18 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
 			continue;
 
-		stripe_nr = zone_info[i].alloc_offset >> BTRFS_STRIPE_LEN_SHIFT;
-		stripe_offset = zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = zone_info[i].alloc_offset >> stripe_shift;
+		stripe_offset = zone_info[i].alloc_offset & (stripe_len - 1);
 		if (stripe_offset == 0 && stripe_nr > 0) {
 			stripe_nr--;
-			stripe_offset = BTRFS_STRIPE_LEN;
+			stripe_offset = stripe_len;
 		}
-		alloc = ((stripe_nr * map->num_stripes + i) << BTRFS_STRIPE_LEN_SHIFT) +
+		alloc = ((stripe_nr * map->num_stripes + i) << stripe_shift) +
 			stripe_offset;
 		last_alloc = max(last_alloc, alloc);
 
 		/* Partially written stripe found. It should be last. */
-		if (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK)
+		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
 			break;
 	}
 	stripe_nr = 0;
@@ -1619,8 +1621,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 	if (last_alloc) {
 		u32 factor = map->num_stripes;
 
-		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
-		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = last_alloc >> stripe_shift;
+		stripe_offset = last_alloc & (stripe_len - 1);
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 	}
 
@@ -1631,11 +1633,10 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
 			has_conventional = true;
 			zone_info[i].alloc_offset =
-				btrfs_stripe_nr_to_offset(stripe_nr,
-							  map->stripe_len);
+				btrfs_stripe_nr_to_offset(stripe_nr, stripe_len);
 
 			if (stripe_index > i)
-				zone_info[i].alloc_offset += BTRFS_STRIPE_LEN;
+				zone_info[i].alloc_offset += stripe_len;
 			else if (stripe_index == i)
 				zone_info[i].alloc_offset += stripe_offset;
 		}
@@ -1650,7 +1651,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 			}
 
 			if (unlikely(has_partial &&
-				     (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK))) {
+				     !IS_ALIGNED(zone_info[i].alloc_offset,
+						 stripe_len))) {
 				btrfs_err(fs_info,
 				"zoned: multiple partial written stripe found in block group %llu",
 					  bg->start);
@@ -1659,7 +1661,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		}
 		prev_offset = zone_info[i].alloc_offset;
 
-		if ((zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK) != 0)
+		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
 			has_partial = true;
 
 		if (test_bit(0, active) != test_bit(i, active)) {
@@ -1675,7 +1677,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 
 	/* Check if all devices stay in the same stripe row. */
 	if (unlikely(zone_info[0].alloc_offset -
-		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		     zone_info[map->num_stripes - 1].alloc_offset > stripe_len)) {
 		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu", bg->start);
 		return -EIO;
 	}
@@ -1699,6 +1701,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	u64 AUTO_KFREE(raid0_allocs);
 	u64 stripe_nr = 0, stripe_offset = 0;
 	u32 stripe_index = 0;
+	const u32 stripe_len = map->stripe_len;
+	const u8 stripe_shift = map->stripe_shift;
 	bool has_partial = false, has_conventional = false;
 	u64 prev_offset = 0;
 
@@ -1746,16 +1750,16 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 			return -EIO;
 		}
 
-		stripe_nr = alloc >> BTRFS_STRIPE_LEN_SHIFT;
-		stripe_offset = alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = alloc >> stripe_shift;
+		stripe_offset = alloc & (stripe_len - 1);
 		if (stripe_offset == 0 && stripe_nr > 0) {
 			stripe_nr--;
-			stripe_offset = BTRFS_STRIPE_LEN;
+			stripe_offset = stripe_len;
 		}
 
 		alloc = ((stripe_nr * (map->num_stripes / map->sub_stripes) +
-			  (i / map->sub_stripes)) <<
-			 BTRFS_STRIPE_LEN_SHIFT) + stripe_offset;
+			  (i / map->sub_stripes)) << stripe_shift) +
+			stripe_offset;
 		last_alloc = max(last_alloc, alloc);
 	}
 	stripe_nr = 0;
@@ -1764,8 +1768,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	if (last_alloc) {
 		u32 factor = map->num_stripes / map->sub_stripes;
 
-		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
-		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = last_alloc >> stripe_shift;
+		stripe_offset = last_alloc & (stripe_len - 1);
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 	}
 
@@ -1775,10 +1779,10 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		if (raid0_allocs[idx] == WP_CONVENTIONAL) {
 			has_conventional = true;
 			raid0_allocs[idx] = btrfs_stripe_nr_to_offset(stripe_nr,
-								map->stripe_len);
+								      stripe_len);
 
 			if (stripe_index > idx)
-				raid0_allocs[idx] += BTRFS_STRIPE_LEN;
+				raid0_allocs[idx] += stripe_len;
 			else if (stripe_index == idx)
 				raid0_allocs[idx] += stripe_offset;
 		}
@@ -1794,7 +1798,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 				}
 
 				if (unlikely(has_partial &&
-					     (raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK))) {
+					     !IS_ALIGNED(raid0_allocs[idx],
+							 stripe_len))) {
 					btrfs_err(fs_info,
 					"zoned: multiple partial written stripe found in block group %llu",
 						  bg->start);
@@ -1803,7 +1808,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 			}
 			prev_offset = raid0_allocs[idx];
 
-			if ((raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK) != 0)
+			if (!IS_ALIGNED(raid0_allocs[idx], stripe_len))
 				has_partial = true;
 		}
 
@@ -1826,7 +1831,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 
 	/* Check if all devices stay in the same stripe row. */
 	if (unlikely(zone_info[0].alloc_offset -
-		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		     zone_info[map->num_stripes - 1].alloc_offset > stripe_len)) {
 		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu",
 			  bg->start);
 		return -EIO;
-- 
2.56.0

