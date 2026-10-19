Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FB427FB37
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392044; cv=none; b=OqKcycXnHoAeID9v48tzpEA1qyWhsYT1bgSqq5hbpCHE9Md/Mq+tXPw9hAj7kspINkDFNJOwAIhd72XHM5sTYv400XmKi8g/VVW6I53BUbJGkHwsfxXrNBQ1Ux5zvtEBJIj55AT1ziriA22BhswxYq80v6DtUSkphGxOU8C2LBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392044; c=relaxed/simple;
	bh=kbHV+7ngYCuIWsALkm3jhdBQdrlPNVzBQbb+TEIMUlI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9iV8WV2uMPajWmW6nQyi+LCt49dc6yqfZd4VKWaHjLz6s8l6Yhmdhk8TxOA8ilcmFZA2quJXgWgyASjTKQ0lxb7btQHQ7A1SOgTCkAtS5JbPTKntcTWgvFsjviE7y5aGo6T2murEGDaybjtoZTM04TdVNQFyYujAy5pwhJbi4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qQzpWj2U; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qQzpWj2U; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qQzpWj2U";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qQzpWj2U"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9507E1F7F1
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWfbnOuauc2wjNdNqBRC647wYewBEPtjio1z1vgptWk=;
	b=qQzpWj2UULmd9LD3+f4rm1kucWwZ4b2eje8bvD9I53vcbJPHjifatQSL/NiAl07cingmtp
	F1PhufR5GQDijj34ypLA1dBZpjZb3OxuBp1zNed74094B2oW9QDN0HhcE6kFmHQmx116IU
	y6I282nC8YJQnZAETFY2vIdZqRUyhpk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qQzpWj2U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWfbnOuauc2wjNdNqBRC647wYewBEPtjio1z1vgptWk=;
	b=qQzpWj2UULmd9LD3+f4rm1kucWwZ4b2eje8bvD9I53vcbJPHjifatQSL/NiAl07cingmtp
	F1PhufR5GQDijj34ypLA1dBZpjZb3OxuBp1zNed74094B2oW9QDN0HhcE6kFmHQmx116IU
	y6I282nC8YJQnZAETFY2vIdZqRUyhpk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6295D1375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T9
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs: convert zoned.c to use map->stripe_len
Date: Mon, 19 Oct 2026 17:10:04 +1030
Message-ID: <5b7b68cf9d8a6ccfb89b78939507146c3f52652f.1792391732.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 9507E1F7F1
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

There are still several call sites using BTRFS_STRIPE_LEN, but that's
when doing the basic zoned checks.

For other call sites with a btrfs_chunk_map, use map->stripe_len instead
of the hardcoded BTRFS_STRIPE_LEN.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/zoned.c | 53 +++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 37084c8d8d75..263f8a5475e8 100644
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
+		if (zone_info[i].alloc_offset & (stripe_len - 1))
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
@@ -1650,7 +1651,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 			}
 
 			if (unlikely(has_partial &&
-				     (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK))) {
+				     (zone_info[i].alloc_offset & (stripe_len - 1)))) {
 				btrfs_err(fs_info,
 				"zoned: multiple partial written stripe found in block group %llu",
 					  bg->start);
@@ -1659,7 +1660,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		}
 		prev_offset = zone_info[i].alloc_offset;
 
-		if ((zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK) != 0)
+		if ((zone_info[i].alloc_offset & (stripe_len - 1)) != 0)
 			has_partial = true;
 
 		if (test_bit(0, active) != test_bit(i, active)) {
@@ -1675,7 +1676,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 
 	/* Check if all devices stay in the same stripe row. */
 	if (unlikely(zone_info[0].alloc_offset -
-		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		     zone_info[map->num_stripes - 1].alloc_offset > stripe_len)) {
 		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu", bg->start);
 		return -EIO;
 	}
@@ -1699,6 +1700,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	u64 AUTO_KFREE(raid0_allocs);
 	u64 stripe_nr = 0, stripe_offset = 0;
 	u32 stripe_index = 0;
+	const u32 stripe_len = map->stripe_len;
+	const u8 stripe_shift = map->stripe_shift;
 	bool has_partial = false, has_conventional = false;
 	u64 prev_offset = 0;
 
@@ -1746,16 +1749,16 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
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
@@ -1764,8 +1767,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	if (last_alloc) {
 		u32 factor = map->num_stripes / map->sub_stripes;
 
-		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
-		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = last_alloc >> stripe_shift;
+		stripe_offset = last_alloc & (stripe_len - 1);
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 	}
 
@@ -1775,10 +1778,10 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
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
@@ -1794,7 +1797,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 				}
 
 				if (unlikely(has_partial &&
-					     (raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK))) {
+					     (raid0_allocs[idx] & (stripe_len - 1)))) {
 					btrfs_err(fs_info,
 					"zoned: multiple partial written stripe found in block group %llu",
 						  bg->start);
@@ -1803,7 +1806,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 			}
 			prev_offset = raid0_allocs[idx];
 
-			if ((raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK) != 0)
+			if ((raid0_allocs[idx] & (stripe_len - 1)) != 0)
 				has_partial = true;
 		}
 
@@ -1826,7 +1829,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 
 	/* Check if all devices stay in the same stripe row. */
 	if (unlikely(zone_info[0].alloc_offset -
-		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		     zone_info[map->num_stripes - 1].alloc_offset > stripe_len)) {
 		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu",
 			  bg->start);
 		return -EIO;
-- 
2.56.0

