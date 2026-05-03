Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1283AEF5C
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777801704; cv=none; b=M7Gort+WtIQMdfWZGNgulGPtPDnDSXzUwUhU7EUm7E/0dXUSdwd5aFLU221LQMsropqxtAvIZbqm/SUjyYXWd+InN7fuiosVvedHRObSNxOZq4W7E7HgY+PzSzvojvFvewsthSqhm9Xh3GyyJ6cqODVdok/mvr12yQmG6c47q5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777801704; c=relaxed/simple;
	bh=g/T3AocahmOo2LtcG3EcdnDrFKdjYf03as1ryCnIbDg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me7dZbb/4ZOIRH3CbhAap1OHkGC8MyiGeDxo1wchoIjJnOAZVbMB8gp897PeHRulPO9DFwQzZK44rqC5SYXmovJFbX/LtdXTjllg2Z8yV3yfqB8alrO/wltza2ze0zdT1/PmsAFU4bVeUG/VV2X5KPUSWzWV7abRM6X0mBRA2C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FgRnEEwd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FgRnEEwd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FgRnEEwd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FgRnEEwd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 38C4C5BFE1
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hVCqEZw1FYe3jyaucLM1QLqvVI5D386M8g5wSbvPvO8=;
	b=FgRnEEwdwbpKgVFZqIbJTgOq3o9SXSQlH6lEZZJrG7He3T27/wYUMkFLTFlWbg15HE2hWA
	idHcvWoGtgsntluBo+TugZt/FoUFr3MrIRjqBHgwRi+gV/Uwd0edCSt2r5EwQ2PQnucazp
	EUalrcXzzsPORrVeyFShJz8cOrKanC0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FgRnEEwd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hVCqEZw1FYe3jyaucLM1QLqvVI5D386M8g5wSbvPvO8=;
	b=FgRnEEwdwbpKgVFZqIbJTgOq3o9SXSQlH6lEZZJrG7He3T27/wYUMkFLTFlWbg15HE2hWA
	idHcvWoGtgsntluBo+TugZt/FoUFr3MrIRjqBHgwRi+gV/Uwd0edCSt2r5EwQ2PQnucazp
	EUalrcXzzsPORrVeyFShJz8cOrKanC0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74E16593A3
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kGUpDt8Z92mUPAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 09:48:15 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: simplify the btree folio wait during invalidation
Date: Sun,  3 May 2026 19:17:51 +0930
Message-ID: <afc8cc0645fb2b0b5e228da96c13d818108f500f.1777801546.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777801546.git.wqu@suse.com>
References: <cover.1777801546.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 38C4C5BFE1

The btree inode is very different from regular data inodes, as the btree
inode is never exposed to user space operations.

All operations are either initiated by btrfs metadata operations, or MM
layer like memory pressure to release folios.

This means we never need to handle partial folio invalidation inside
btree_invalidate_folio().

With that said, we can slightly simplify the btree folio invalidation
by:

- Add ASSERT()s to make sure the range covers the whole folio

- Remove "if (start > end)" check
  As the range always covers the full folio, that check is always
  false and can be removed.

- Open code extent_invalidate_folio()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f925dcea0c46..9e1da0b812e0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -488,25 +488,27 @@ static bool btree_release_folio(struct folio *folio, gfp_t gfp_flags)
 	return try_release_extent_buffer(folio);
 }
 
-/*
- * Basic invalidate_folio code, this waits on any locked or writeback
- * ranges corresponding to the folio.
- */
-static int extent_invalidate_folio(struct extent_io_tree *tree,
-				   struct folio *folio, size_t offset)
+static void btree_invalidate_folio(struct folio *folio, size_t offset,
+				 size_t length)
 {
+	struct extent_io_tree *tree = &folio_to_inode(folio)->io_tree;
 	struct extent_state *cached_state = NULL;
-	u64 start = folio_pos(folio);
-	u64 end = start + folio_size(folio) - 1;
-	size_t blocksize = folio_to_fs_info(folio)->sectorsize;
+	const u64 start = folio_pos(folio);
+	const u64 end = folio_next_pos(folio) - 1;
+
+	/*
+	 * The range must cover the full @folio.
+	 * Btree inode is never exposed to regular file operations, thus there
+	 * is no partial truncation.
+	 * The folio is only invalidated when the btree inode is evicted.
+	 */
+	ASSERT(offset == 0, "folio=%llu offset=%zu", folio_pos(folio), offset);
+	ASSERT(length == folio_size(folio), "folio=%llu folio_size=%zu length=%zu",
+	       folio_pos(folio), folio_size(folio), length);
 
 	/* This function is only called for the btree inode */
 	ASSERT(tree->owner == IO_TREE_BTREE_INODE_IO);
 
-	start += ALIGN(offset, blocksize);
-	if (start > end)
-		return 0;
-
 	btrfs_lock_extent(tree, start, end, &cached_state);
 	folio_wait_writeback(folio);
 
@@ -516,16 +518,7 @@ static int extent_invalidate_folio(struct extent_io_tree *tree,
 	 * existing extent state.
 	 */
 	btrfs_unlock_extent(tree, start, end, &cached_state);
-	return 0;
-}
 
-static void btree_invalidate_folio(struct folio *folio, size_t offset,
-				 size_t length)
-{
-	struct extent_io_tree *tree;
-
-	tree = &folio_to_inode(folio)->io_tree;
-	extent_invalidate_folio(tree, folio, offset);
 	btree_release_folio(folio, GFP_NOFS);
 	if (folio_get_private(folio)) {
 		btrfs_warn(folio_to_fs_info(folio),
-- 
2.54.0

