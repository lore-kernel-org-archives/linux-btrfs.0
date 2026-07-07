Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A92B13B293
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783392049; cv=none; b=sI7ZC0k5jKBAz1lp4oIzl+RndJnAtwHBOUOh3ZCJz/azc0dqLluxinlyJZbAS9JM/vx7XiTdOQq+8OGOVXhAJ/GqPNdEPYBxnRawKg4l5oh+X7t9kM1H4z1QVYiJrAYiU/BBAy1oRsBxqO7lPdUc8tNuOi+b+HuMr/XiBXEoBPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783392049; c=relaxed/simple;
	bh=XISW5J+0q6I+giOAV3jr73x1jNDgI2PHdpUBTTP2WbQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QHHpqCMeMkwOn4TD4/8KBcKC6UIEiMgU+Ad6akK7srNwES6pT9pzTPodobYKYTIbbKm0BKdZwHV8mhwIj2XRyLuYNU4jLHl+caA1hvrhaQa9jn6jvxth2l+2CtNUUJfck6ZKUL2ZKamL42bFpuM9jhwhM5g5fCSMmwDRv0uS89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PPKG6WTA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YayDI2zp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PPKG6WTA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YayDI2zp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4908275E2E
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 02:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783392046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=752EumSH6uoebGa0JvHO6ZqwwnQRyeomluekDoC6FKI=;
	b=PPKG6WTASzVfNbqfxNbQanhXHf6oLJFKxYbjJKmLLkKKVFv3kdlAtgJ1lTUn5HJ6uX9x3N
	xUhJWIZE7ev54PbbqECWz34zU/ujKSX4vNAKa+FSpqfr+0Un3IFdLmhAIRFEGRWD6uwZv4
	2F8P7w0rhkEzdSIJtsx1TdttHyZeabI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YayDI2zp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783392045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=752EumSH6uoebGa0JvHO6ZqwwnQRyeomluekDoC6FKI=;
	b=YayDI2zpgdI+5YRL9Zmahn6Y/n3+uJBIgo00gMjvbi7kTl2ZWSLwdmT7+F4+JKnbl+DfHs
	Q5/yr5ycNFLtgHXuQUEzCLCwk0l8DlqyWfvCAuDnkkeInhPd1kSU1rOiAVAOn9c+8R0Ahw
	WVrteCPxr7GwElzHawQ+ddc+CyiB1Hw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5208D779AE
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 02:40:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PpAXASxnTGqVQwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 02:40:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is never cleared
Date: Tue,  7 Jul 2026 12:10:25 +0930
Message-ID: <02e6596cdba776b63528ead37324076dd664a11e.1783392018.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4908275E2E
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

[BUG]
The following script (already submitted as generic/798) will report
incorrect dirty page numbers, with 64K page size systems and 4K fs block
size:

 # mkfs.btrfs -s 4k -f $dev
 # mount $dev $mnt
 # xfs_io -f -c "pwrite 0 64K" -c fsync -c "cachestat 0 64K" $mnt/foobar
 Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0

Note that the dirtied page number is still 1.

[CAUSE]
The cachestat() go through the XArray of the page cache, but
instead of checking each folio's flag, it uses the
PAGECACHE_TAG_DIRTY tag to report dirty pages

Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
btrfs replaced a folio_clear_dirty_for_io() call inside
extent_write_cache_pages() with folio_test_dirty().

This will cause the following call sequence for the folio at file offset
0:

 extent_write_cache_pages()
 |- folio_test_dirty()
 |  The folio is still dirty, continue to writeback.
 |
 |- extent_writepage()
    |- extent_writepage_io()
       |- submit_one_sector() for range [0, 4K)
       |  |- btrfs_folio_clear_dirty()
       |  |- btrfs_folio_set_writeback()
       |     |- folio_start_writeback()
       |        It's the first writeback block, we set the writeback
       |	flag for the folio.
       |	But the folio is still dirty, PAGECACHE_TAG_DIRTY is
       |	kept
       |
       |- submit_one_sector() for range [4K, 8K)
       |  |- btrfs_folio_clear_dirty()
       |  |- btrfs_folio_set_writeback()
       |     The folio already has writeback flag, no need to call
       |     folio_start_writeback()
       |
       | ...
       |- submit_one_sector() for range [60K, 64K)
	  |- btrfs_folio_clear_dirty()
	  |- btrfs_folio_set_writeback()
             The folio already has writeback flag, no need to call
             folio_start_writeback()

So the PAGECACHE_TAG_DIRTY is never cleared.

Meanwhile for the old code, before that commit, the sequence looks
like:

 extent_write_cache_pages()
 |- folio_clear_dirty_for_io()
 |  The folio is still dirty, so continue to writeback.
 |  But the folio dirty flag is cleared now.
 |
 |- extent_writepage()
    |- extent_writepage_io()
       |- submit_one_sector() for range [0, 4K)
       |  |- btrfs_folio_clear_dirty()
       |  |- btrfs_folio_set_writeback()
       |     |- folio_start_writeback()
       |        |- xas_clear(PAGECACHE_TAG)
       |
       |        It's the first writeback block, we set the writeback
       |	flag for the folio.
       |	And the folio is not dirty, PAGECACHE_TAG_DIRTY is
       |        cleared
       |
       |- submit_one_sector() for range [4K, 8K)
       |  |- btrfs_folio_clear_dirty()
       |  |- btrfs_folio_set_writeback()
       |     The folio already has writeback flag, no need to call
       |     folio_start_writeback()
       |
       | ...
       |- submit_one_sector() for range [60K, 64K)
	  |- btrfs_folio_clear_dirty()
	  |- btrfs_folio_set_writeback()
             The folio already has writeback flag, no need to call
             folio_start_writeback()

Unlike the new code, old code will clear PAGECACHE_TAG_DIRTY for the
first writeback block.

[FIX]
Revert that folio_test_dirty() back to folio_clear_dirty_for_io(), and
add a comment explaining why we need to use folio_clear_dirty_for_io().

Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8fbb798767ca..78bd4ec541f8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2584,8 +2584,31 @@ static int extent_write_cache_pages(struct address_space *mapping,
 				folio_wait_writeback(folio);
 			}
 
+			/*
+			 * For folios that are under writeback or no longer dirty,
+			 * we can skip the folio.
+			 *
+			 * Here we have to call folio_clear_dirty_for_io() to clear
+			 * the folio dirty flag.
+			 *
+			 * Without that call, btrfs_folio_set_writeback() will call
+			 * folio_start_writeback() for the first block to be written back.
+			 * But since the folio can still be dirty, e.g. other
+			 * blocks inside the folio are still dirty,
+			 * PAGECACHE_TAG_DIRTY will not be cleared.
+			 *
+			 * On the other hand, for btrfs_folio_set_writeback() of the
+			 * last block, although the folio is no longer dirty,
+			 * btrfs_folio_set_writeback() won't call folio_start_writeback()
+			 * as the folio already has that flag.
+			 *
+			 * This means, if we only rely one btrfs_folio_*()
+			 * helpers for both dirty and writeback flags,
+			 * PAGECACHE_TAG_DIRTY will never be cleared for subpage cases.
+			 * The only way to break out is to clear folio dirty here.
+			 */
 			if (folio_test_writeback(folio) ||
-			    !folio_test_dirty(folio)) {
+			    !folio_clear_dirty_for_io(folio)) {
 				folio_unlock(folio);
 				continue;
 			}
-- 
2.54.0

