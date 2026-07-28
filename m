Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4079348C54
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785220787; cv=none; b=ulyODmJQmp8CArMKN+i2O8YzikOQJZPFTYQJZThSom/Ip4bB2Sg0VZA5m/wqNzSs8N/BZ6J5N3vIgBUTRTsBTAciZHpXIB2bYhxawLIo462Mx0IfTkPiQyZdcITHQlGUhwxwVa6ktxGsX44yC0XMCwSZFfZLimGVnH3USyV7KnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785220787; c=relaxed/simple;
	bh=oA1w3+OfOjviNPSA8kGGwityH0/RaMZblYiQF2Z2Los=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB9FqZeUs7gIfPUiCJ0JXTeV+B6v4qb3Baipn31zbm9PbqXc6HKD4KSN5x/QUN9S7zH4CZ2k64g6RKa7bhiNQSBoy3p2oHGEyOv9FTDUXGb9qvgGiflrVhDX4T3nPhXVV0uTpyhM0l6W4djKxR/E3iA1ppfk6jJLRHY2WqVXcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XuGpIC1K; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ph73q/hT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XuGpIC1K";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ph73q/hT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0206B7BED5
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VljeH3r6wNjlpLnsbrUcLUFjDTpZzynCxsxG5pQVg4s=;
	b=XuGpIC1KA5lIj2ig+ddODYLnvX2EGVq9uFQ2jm5LE3UogUJ2YM7uaeHJ9O7obPbt9mdmlr
	EL5Pa3HwnU/q4U9OZN9OEkAos730BdqA9aiIYr7dD7R/UT+aqNFoHrE09rWLO7zJKwqmhl
	KzliDYrA8Y69dCSXNZPOJbYqGIlQF5E=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VljeH3r6wNjlpLnsbrUcLUFjDTpZzynCxsxG5pQVg4s=;
	b=Ph73q/hTB/YaNr8E+evFmAFJA5N8bORdiEvD53yno4npeMp46pm7ZfmnE9NxO6fpry58pb
	X9sDNg6KCf++xOyxPytPSU5uEJ2WEKznJtHtM3Au3pqdr+6aWpHjGe6RGA6lbrJzmpkByG
	J36LOn1Csx7gCJt7NZVVmZg2TjhmARE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F202B779B9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aLG5J6FOaGrkSAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: add validation for extent states
Date: Tue, 28 Jul 2026 16:09:04 +0930
Message-ID: <b9f436fc89e7bdb5411ff8e6b5eb8e90ea6043a0.1785220613.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785220613.git.wqu@suse.com>
References: <cover.1785220613.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Extent maps have the extra validation since commit 3f255ece2f1e ("btrfs:
introduce extra sanity checks for extent maps"), but extent states do
not have a similar check.

Introduce a basic alignment check for the following call sites, so that
we can cover all extent maps inserted into the tree:

- insert_state_fast()
- insert_state()
- split_state()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-io-tree.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index c18ea5ef2974..4f1ef33f17ac 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -403,6 +403,21 @@ static void set_state_bits(struct extent_io_tree *tree,
 	state->state |= bits_to_set;
 }
 
+static void validate_extent_state(const struct extent_io_tree *tree,
+				  struct extent_state *state)
+{
+	u32 blocksize;
+
+	if (tree->owner != IO_TREE_INODE_IO)
+		return;
+
+	blocksize = btrfs_extent_io_tree_to_fs_info(tree)->sectorsize;
+	ASSERT(IS_ALIGNED(state->start, blocksize) &&
+	       IS_ALIGNED(state->end + 1, blocksize),
+	       "unaligned extent state, blocksize=%u start=%llu end=%llu state=0x%x",
+	       blocksize, state->start, state->end, state->state);
+}
+
 /*
  * Insert an extent_state struct into the tree.  'bits' are set on the
  * struct before it is inserted.
@@ -429,6 +444,8 @@ static struct extent_state *insert_state(struct extent_io_tree *tree,
 	const u64 end = state->end + 1;
 	const bool try_merge = !(bits & (EXTENT_LOCK_BITS | EXTENT_BOUNDARY));
 
+	validate_extent_state(tree, state);
+
 	set_state_bits(tree, state, bits, changeset);
 
 	node = &tree->state.rb_node;
@@ -481,6 +498,8 @@ static void insert_state_fast(struct extent_io_tree *tree,
 			      struct rb_node *parent, unsigned bits,
 			      struct extent_changeset *changeset)
 {
+	validate_extent_state(tree, state);
+
 	set_state_bits(tree, state, bits, changeset);
 	rb_link_node(&state->rb_node, parent, node);
 	rb_insert_color(&state->rb_node, &tree->state);
@@ -533,6 +552,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 		}
 	}
 
+	validate_extent_state(tree, orig);
+	validate_extent_state(tree, prealloc);
 	rb_link_node(&prealloc->rb_node, parent, node);
 	rb_insert_color(&prealloc->rb_node, &tree->state);
 
-- 
2.54.0

