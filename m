Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4759D2CCC5
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392032; cv=none; b=P4pAr0+Zg2riogMvkrkUGx4ozDMHZ/AwrFTeQAecwgfvAbUqJJm0YmswCdAwwjmT1aw2UMKZ8cJHAdnysGgwSu789GiWH82JsVfs5xs3ISaq4pjgWgS1ALrq+iPJBvfSo4Fu9ZIqWOWazWzxLSs3nE/oVO8PzZr+XRzaTKN+wrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392032; c=relaxed/simple;
	bh=uBM0MC0Oz68YwZ3g2WAG6GLZG2LZFgy/QPdpNRVHqnA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEgL3r1+RfbFpbznD+DK4jxpILFpBbxnjzp1QBohdoPHJfhKY79sYWIuRJJlaHmLj1zCvLtogRXdfwM4WMFMmKH2YLD68ALDTpxv6TgqPlRwtTT7iAUKpCr7Z6CxqjrJKr1KMQ6RUsPe/v1SXdYtQJMBl9OzJD0zR2Mywwm9kpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DPwGXIQg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DPwGXIQg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DPwGXIQg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DPwGXIQg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A47331F7F1
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Cs5Bt/l//FimmB5arPI6qElY15TsAbDl4iiwO8oaB0=;
	b=DPwGXIQgZaCTyfQEj6Eff5nED2lUnF68pqHzc3OIjm920IDIUCKGmU6GdJ+O9ZvZQ6jNJy
	Vr4CEUGvh339ORCgcpb2fJNptPJ8O74nxFxwqn2mDvE+wx4yBc8Hk7VmkfrjyJR/tih9gd
	JehJS9mqOs/EDvD1dsb9U9ghkc+lvxw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Cs5Bt/l//FimmB5arPI6qElY15TsAbDl4iiwO8oaB0=;
	b=DPwGXIQgZaCTyfQEj6Eff5nED2lUnF68pqHzc3OIjm920IDIUCKGmU6GdJ+O9ZvZQ6jNJy
	Vr4CEUGvh339ORCgcpb2fJNptPJ8O74nxFxwqn2mDvE+wx4yBc8Hk7VmkfrjyJR/tih9gd
	JehJS9mqOs/EDvD1dsb9U9ghkc+lvxw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 719C31375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: load the on-disk btrfs_chunk::stripe_len
Date: Mon, 19 Oct 2026 17:09:58 +1030
Message-ID: <fd4c34a411dd1951e0a39453994d9719ee7b834a.1792391732.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

