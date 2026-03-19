Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399EC3ACA5E
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954339; cv=none; b=IHPaGWs4dzvgiTuRNxwJyMH19LH0AyJ6Wsjtksv1sNHW36EtmGkb+yn62zr3bhwsh8yr4tkQWtBlu4yH8ULOX1zzPeZAIMNSGgiT3sP2u0gAXvVE3oIyPbmr6ZssVQa4GFA+PfUhwHVSZS7EGqKBDrLWO0hQGyNmslQGdUr/1fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954339; c=relaxed/simple;
	bh=syqA3qw1XRr/hlL+xH4edDbIkAUIDNnISLMz2/HNDi0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMTbOA0bVdlk3aBrbn6a+YIz1jgsr4jF1bL2wcZMuxpEi/X3DZWs01a0oRk3JvYfMXhWJ84m4gQz40etYhfSCeN34yQIKgf2ZcKPB1FA2UjlDQrQf9UrCSiau3NIH21HDfESZANEwgN48BSD9xNLCOu+eqz7yM68QKGB61aIO+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=B2WWYXDr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=B2WWYXDr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B2WWYXDr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B2WWYXDr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 701855BDE4
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l73gxsxr5mDqJP9oDcrpWfCHlYC+Wt+3YbaXNW1eRO0=;
	b=B2WWYXDrHtITSTrv1px+9HuSrR9WdcVkKfV8bbnjexHceg9J/bdsu4VQRnvQrTYok9rrj3
	NkVCNUP3vjO0ZrfInNmtQbHOH88i6aVh2LK24L6s0cEi0esWBoUtBYFQXuKKxfhqMtNxw9
	my+VB1uGH52T8RKumaClGYyLimG7q+E=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=B2WWYXDr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l73gxsxr5mDqJP9oDcrpWfCHlYC+Wt+3YbaXNW1eRO0=;
	b=B2WWYXDrHtITSTrv1px+9HuSrR9WdcVkKfV8bbnjexHceg9J/bdsu4VQRnvQrTYok9rrj3
	NkVCNUP3vjO0ZrfInNmtQbHOH88i6aVh2LK24L6s0cEi0esWBoUtBYFQXuKKxfhqMtNxw9
	my+VB1uGH52T8RKumaClGYyLimG7q+E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71A554273B
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eJ5ZCA5lvGk5FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: enable experimental delayed compression support
Date: Fri, 20 Mar 2026 07:34:50 +1030
Message-ID: <b966c38785c6d75e96c8f475d5d9e43d17fcd800.1773953307.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773953307.git.wqu@suse.com>
References: <cover.1773953307.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 701855BDE4

Instead of the existing async submission path, the new delayed bbio will
handle compressed write by:

- Allocating delayed em/oe at run_delalloc_*() time
  Thus no data extent is reserved at that time.

- Delayed bbio will be assembled at extent_writepage_io() time

- Delayed bbio will be intercepted just before submission
  Which will run compression (or fallback to uncompressed writes) in
  workqueue.
  Data extents will only be reserved at that time, and the delayed em
  will be replaced by real ones.

  Meanwhile the real OE will be added as a child of the parent delayed
  OE, and when the parent OE finishes, the child OE will be finished
  with their file extents inserted.

This has some benefits:

- Higher concurrency
  Previously async submission will hold the folio and io tree range
  locked, this means we can not even read the uptodate folio.

  Furthermore although the compressed write is queued into a workqueue
  for submission and extent_writepage_io() will skip the compressed
  range, when we need to write the next folio of the compressed range,
  we will need to wait for the folio to be unlocked.

  This makes async submission less async.

- Future DONTCACHE writes support
  We do not support DONTCACHE because that feature requires writeback path
  to clear the folio dirty and submit them sequentially.

  Meanwhile async submission makes the writeback async, breaking the
  sequential submission requirement.

  This is also why we need a complex per-block tracking for writeback
  flags, meanwhile iomap only requires a counter tracking.

  With the new delayed compression, the lifespan of a folio aligns with
  DONTCACHE and iomap.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 60 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 183fb3c83c10..c95207009210 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1673,6 +1673,57 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
 	return true;
 }
 
+static int run_delalloc_delayed(struct btrfs_inode *inode, struct folio *locked_folio,
+				u64 start, u64 end)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct extent_state *cached = NULL;
+	u64 cur = start;
+	int ret;
+
+	if (btrfs_is_shutdown(fs_info)) {
+		ret = -EIO;
+		goto error;
+	}
+	while (cur < end) {
+		struct extent_map *em;
+		struct btrfs_ordered_extent *oe;
+		u32 cur_len = min_t(u64, end + 1 - cur, BTRFS_MAX_COMPRESSED);
+
+		btrfs_lock_extent(&inode->io_tree, cur, cur + cur_len - 1, &cached);
+		em = btrfs_create_delayed_em(inode, cur, cur_len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto error;
+		}
+		btrfs_free_extent_map(em);
+		oe = btrfs_alloc_delayed_ordered_extent(inode, cur, cur_len);
+		if (IS_ERR(oe)) {
+			btrfs_drop_extent_map_range(inode, cur, cur + cur_len - 1, false);
+			ret = PTR_ERR(em);
+			goto error;
+		}
+		btrfs_put_ordered_extent(oe);
+
+		cur += cur_len;
+	}
+	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
+				     EXTENT_LOCKED | EXTENT_DELALLOC,
+				     PAGE_UNLOCK | PAGE_SET_ORDERED);
+	return 0;
+error:
+	/* We have to drop any created delayed extent maps. */
+	if (start < cur)
+		btrfs_drop_extent_map_range(inode, start, cur - 1, false);
+	/* No range has any extent reserved, just clear them all. */
+	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
+			EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+			PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK);
+	return ret;
+}
+
 /*
  * Run the delalloc range from start to end, and write back any dirty pages
  * covered by the range.
@@ -2436,9 +2487,12 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
 		return run_delalloc_nocow(inode, locked_folio, start, end);
 
 	if (btrfs_inode_can_compress(inode) &&
-	    inode_need_compress(inode, start, end, false) &&
-	    run_delalloc_compressed(inode, locked_folio, start, end, wbc))
-		return 1;
+	    inode_need_compress(inode, start, end, false)) {
+		if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL))
+			return run_delalloc_delayed(inode, locked_folio, start, end);
+		else if (run_delalloc_compressed(inode, locked_folio, start, end, wbc))
+			return 1;
+	}
 
 	if (zoned)
 		return run_delalloc_cow(inode, locked_folio, start, end, wbc, true);
-- 
2.53.0

