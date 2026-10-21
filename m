Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554013;
	b=NAZdC72orA6LxN99gyQRZ8ZpQPFkJgBqvL1ltM4TKVDZd3TiW5XUDfEzPAwGao5dJa7K
	 lNiIWCl9ZneSQx1/FCF081+N8gAaS+bVCR747JyeYBaU6eiD/6WW0EsZ/m3U56si1qPTV
	 2Vy3s5eNcPexXXHelzn7N/zSYR0L9Vp8YQYbtdmyxnnV7zDUxUU3BJGP1dXEyE3cyht3K
	 sT656kECDSlbJrfiGosB5ntw3XlE6m+Wr8NDOh9nBCFxbl/BIyjz5UfbN//4R2ICBvuWg
	 Qnrkg99AWBFeaXnaRJRxSeKGOjJixAyX112H4DRlCiSEDniaDYKQdH+PjQG+dGQcucA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554013;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=8S2L10AsHNLSOFGZ6mGrRUSy50jC6UynL9LRqqexaks=;
	b=bRMfpccmOwd4TlRQ3oTYVLlGcb80xAYmtvA9bRJ4L0aSmaK43phes4eVNq5q4Hf+qXr3
	 AFD/+/BqrIhX9E5sjzanLV8Q/iMtfWreQCm4037+dGzVK64W1L3tgroveuhcCrlcygf1R
	 q3DnXs2n1kcpYLEcugH4nEK+dRZEuc3vETp/HDwriw6ictSmEJrIBM5r/B48d0djylLur
	 a4sHjka6E24UfblC5nxejRD9kdeG+oHn4FhxYEhp0UB2cqvQAIY6Oli5a+GskMiZjzVYq
	 1u3M7eS0Pb2R5xz3c9Ti8YXYpsTWYuB54zvNJvnbhUWiw3y0E9W+sbUJrSHzJU47Udw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=KSIbJcVw;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=KSIbJcVw;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03C2606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E03C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=KSIbJcVw;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=KSIbJcVw
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2AFF41F7E9;
	Wed, 21 Oct 2026 03:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8S2L10AsHNLSOFGZ6mGrRUSy50jC6UynL9LRqqexaks=;
	b=KSIbJcVwChzWi1jOC1Rdrn2o1TulzAJ4opUXy7kWSmdDtf1K45CfllvWROCbFPm5MxYvwK
	aajjjNDSXW43AuiDoEf3rkp/KjkeB0IEwt+WEAAK2vtiELPjvv080qDhvNk0QmIFtz5+YI
	jL2iGphnRdzTcaRsDQf4YjbYrJypGZY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KSIbJcVw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8S2L10AsHNLSOFGZ6mGrRUSy50jC6UynL9LRqqexaks=;
	b=KSIbJcVwChzWi1jOC1Rdrn2o1TulzAJ4opUXy7kWSmdDtf1K45CfllvWROCbFPm5MxYvwK
	aajjjNDSXW43AuiDoEf3rkp/KjkeB0IEwt+WEAAK2vtiELPjvv080qDhvNk0QmIFtz5+YI
	jL2iGphnRdzTcaRsDQf4YjbYrJypGZY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1AB5134A5;
	Wed, 21 Oct 2026 03:40:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Wed, 21 Oct 2026 03:40:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/9] btrfs: load the on-disk btrfs_chunk::stripe_len
Date: Wed, 21 Oct 2026 14:09:36 +1030
Message-ID: <f3c45a9c8f8cb8cc4cdadd3ca7a86d4c81d9293a.1792553748.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 2AFF41F7E9
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,wdc.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Currently btrfs doesn't load btrfs_chunk::stripe_len into
btrfs_chunk_map, as tree-checker will reject any chunk whose stripe_len
is not 64K.

But for the future we will want stripe length other than 64K.

As a preparation for the variable stripe length in the future, load
btrfs_chunk::stripe_len into btrfs_chunk_map::stripe_len and
stripe_shift.

For now stripe_len is still 64K, no matter if it's loaded from the
on-disk metadata or newly allocated chunk.
As tree-checker still rejects any chunk whose stripe_len is not 64K.

The two new members fit into the existing hole of btrfs_chunk_map, so
the size of btrfs_chunk_map stay the same.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 12 +++++++++++-
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6574939e1295..a30b212ef0f1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6166,6 +6166,12 @@ struct btrfs_chunk_map *btrfs_alloc_chunk_map(int num_stripes, gfp_t gfp)
 	refcount_set(&map->refs, 1);
 	RB_CLEAR_NODE(&map->rb_node);
 
+	/*
+	 * Initialize the default stripe len, selftests will utilize them
+	 * without an on-disk chunk item.
+	 */
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->stripe_shift = ilog2(map->stripe_len);
 	return map;
 }
 
@@ -6203,6 +6209,8 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	map->on_disk_type = type;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->stripe_shift = ilog2(BTRFS_STRIPE_LEN);
 	set_real_chunk_type(map);
 
 	for (int i = 0; i < ctl->ndevs; i++) {
@@ -6381,7 +6389,7 @@ int btrfs_chunk_alloc_add_chunk_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_chunk_length(chunk, bg->length);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
+	btrfs_set_stack_chunk_stripe_len(chunk, map->stripe_len);
 	btrfs_set_stack_chunk_type(chunk, map->on_disk_type);
 	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
 	btrfs_set_stack_chunk_io_align(chunk, BTRFS_STRIPE_LEN);
@@ -7781,6 +7789,8 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	map->chunk_len = length;
 	map->num_stripes = num_stripes;
 	map->on_disk_type = type;
+	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	map->stripe_shift = ilog2(map->stripe_len);
 	/*
 	 * We can't use the sub_stripes value, as for profiles other than
 	 * RAID10, they may have 0 as sub_stripes for filesystems created by
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d97ca875c596..9dcc14cd61e2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -640,6 +640,8 @@ struct btrfs_chunk_map {
 	u64 on_disk_type;
 	/* For mount time dev extent verification. */
 	u16 verified_stripes;
+	u8 stripe_shift;
+	u32 stripe_len;
 	struct btrfs_io_stripe stripes[];
 };
 
-- 
2.56.0

