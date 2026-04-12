Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F139211A28
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 11:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775991695; cv=none; b=eaLno35IX5wQ/lDViSusIwrFQQjzr1bPjGd3S0ryc23C1ht5Doyp0kBtQ0zdiicnSkWciepO4dnspiPT+1M5wB7JM2HhhWqUeN2b7bYNECGUnHVsBmLdJrSGq66uck2rNM5TQjUU8xK7Va2HgKlmaCfmURLxWFk/MFncPPFi8cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775991695; c=relaxed/simple;
	bh=5vWvcw1IZcKUBf2DZWZXSZyBZ8xJ/iZUQgAxA4JINeU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LMnTNs10J2rSaWm6Sgox95w2oixV4hoL5WJYfxTf7g7wiyV04eznWPlANHmo9uyoIFlASXzfRc2xjaarE23iq/z0/VH3EtpFSmKF66BuljVTy8XQMA9qOZvPjbKcRgRYIIVyGPX9MFDm3p8pWCcIxCTYpfea1XsasxpgFr6XzIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YgsK1RBU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YAVUNttp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YgsK1RBU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YAVUNttp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4CF56A84A
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 11:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775991687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sy2Xf4yuFfLqZe64J4ajjE3+z4v0WN23Tqgvh+npYQM=;
	b=YgsK1RBUEQDICRKl+FWNH6c48tSh+6He+30WEF8e8VbDiXwXZK//c8uLO8dEGnFK1G2dOk
	z6dIxtJOr0zF5c8r7BzaGZQ150EB3UCuoWSG6VOn/l+2CR6qg4OM+3e7Fwl8YDTRJ1zbLd
	9GH2xc9Ayn+jCBqOWTWLP1mAlbixy70=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YAVUNttp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775991685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sy2Xf4yuFfLqZe64J4ajjE3+z4v0WN23Tqgvh+npYQM=;
	b=YAVUNttp53UoFZIrtjR5k3ue2fAmagsR+vFd7NAs/lBPurFkw5mVVDxhilSw8sV592s/xI
	SxKBWSyVe5eMOnNd7ANNacjX0qnQhVG9n2aIeDKjk8Msx/0As398qxRWMUzOPyTCMhQPs4
	YX1RIC9G8rJbsPtZlFwE97+CnarkE6k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B0384A8B6
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 11:01:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 12PAEYR722kSTgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 11:01:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: apply first key check for readahead when possible
Date: Sun, 12 Apr 2026 20:31:05 +0930
Message-ID: <49ae0f6badb787c1111daff252f034b7ae94f257.1775991651.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: A4CF56A84A
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Currently for tree block readahead we never pass a
btrfs_tree_parent_check with @has_first_key set.

Without @has_first_key set, btrfs will skip the following extra
checks:

- Header generation check
  This is a minor one.

- Empty leaf/node checks
  This is more serious, for certain trees like the csum tree, they are
  allowed to be empty, thus an empty leaf can pass the tree checker.
  But if there is a parent node for such an empty leaf, it indicates
  corruption.

  Without @has_first_key set, we can no longer detect such a problem.

  In fact there is already a fuzzed image report that a corrupted csum
  leaf which has zero nritems but still has a parent node can trigger
  a BUG_ON() during csum deletion.

However there are only two call sites of btrfs_readahead_tree_block():

- Inside relocate_tree_blocks()
  At this call site we are trying to grab the first key of the tree
  block, thus we are not able to pass a @first_key parameter.

- Inside btrfs_readahead_node_child()
  This is the more common call site, where we have the parent node and
  want to readahead the child tree blocks.

  In this case we can easily grab the node key and pass it for checks.

Add a new parameter @first_key to btrfs_readahead_tree_block() and pass
the node key to it inside btrfs_readahead_node_child().

This should plug the gap in empty leaf detection during readahead.

Link: https://lore.kernel.org/linux-btrfs/20260409071255.3358044-1-gality369@gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c  | 16 +++++++++++++---
 fs/btrfs/extent_io.h  |  3 ++-
 fs/btrfs/relocation.c |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3f59fb0a9ee5..4d5605aaf827 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4635,15 +4635,21 @@ int try_release_extent_buffer(struct folio *folio)
  * to read the block we will not block on anything.
  */
 void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
-				u64 bytenr, u64 owner_root, u64 gen, int level)
+				u64 bytenr, u64 owner_root, u64 gen, int level,
+				const struct btrfs_key *first_key)
 {
 	struct btrfs_tree_parent_check check = {
 		.level = level,
-		.transid = gen
+		.transid = gen,
 	};
 	struct extent_buffer *eb;
 	int ret;
 
+	if (first_key) {
+		memcpy(&check.first_key, first_key, sizeof(struct btrfs_key));
+		check.has_first_key = true;
+	}
+
 	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
 	if (IS_ERR(eb))
 		return;
@@ -4671,9 +4677,13 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
  */
 void btrfs_readahead_node_child(struct extent_buffer *node, int slot)
 {
+	struct btrfs_key node_key;
+
+	btrfs_node_key_to_cpu(node, &node_key, slot);
 	btrfs_readahead_tree_block(node->fs_info,
 				   btrfs_node_blockptr(node, slot),
 				   btrfs_header_owner(node),
 				   btrfs_node_ptr_generation(node, slot),
-				   btrfs_header_level(node) - 1);
+				   btrfs_header_level(node) - 1,
+				   &node_key);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b284aee1bfb0..7b4152387d88 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -287,7 +287,8 @@ static inline void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 }
 
 void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
-				u64 bytenr, u64 owner_root, u64 gen, int level);
+				u64 bytenr, u64 owner_root, u64 gen, int level,
+				const struct btrfs_key *first_key);
 void btrfs_readahead_node_child(struct extent_buffer *node, int slot);
 
 /* Note: this can be used in for loops without caching the value in a variable. */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bdd..c42ef4bed8d3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2607,7 +2607,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		if (!block->key_ready)
 			btrfs_readahead_tree_block(fs_info, block->bytenr,
 						   block->owner, 0,
-						   block->level);
+						   block->level, NULL);
 	}
 
 	/* Get first keys */
-- 
2.53.0

