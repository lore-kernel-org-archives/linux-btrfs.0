Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C63BE16F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 06:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407304; cv=none; b=i7s51i1VRTX4UzAtStJa9LR/PBiBdzUtcd7WKn+b4PLBV7u3POHPh8j+5u2mqfnvu0pB3gvUsusK5SasOk3P/sIczi/fx+gf/aM3ZH2a5w8blJNGiYm18WMzLH2lmHD492HgtDGWCPHdvBBxNF/9SOR6LST5sOXauUI7Zo/f3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407304; c=relaxed/simple;
	bh=6WmZAF+MtPtblSTi9n9DNpKNSgr6p7C9a+OtMGm7n58=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R6s1T2ub2XM0XelGYTuELz+slSjPG/dUaWHzMG27Hg3zouwxXAooRNYvISIkb4OATVvFdWbFPRD2jCwFT5bo+3BsAjH22/FyJQFLxFHqHN4T1xKIi1OHB+CbrOUzdSHzlUd4/daVeIerKBDnP/ClV/ZY8UUg9zah+Qa2lPntbes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GsPLrUIZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eFdYZp2U; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GsPLrUIZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eFdYZp2U"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0E7A75B86
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783407298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WnrhnmUeciBVkxSN8hPP0uidtHPP46AVuwoZnvA0/xY=;
	b=GsPLrUIZ1Z2I5ZZtfmqCpdl2M8Zhi6eS1qd6Kw8Lp4M2KVdt25P74RAQqOQdlID0Vi6y2b
	nwfPmiIl28qzjhALRbLeDUbmx2jL9R4wHo8PKM04vgby1K8n5ROZ6h9hBW5RFh48XIJjWm
	KRFAflIN0kCgM6hyQwQstgeI+rT/oZk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eFdYZp2U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783407297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WnrhnmUeciBVkxSN8hPP0uidtHPP46AVuwoZnvA0/xY=;
	b=eFdYZp2UQnYdP+xI/ajPZ1Zt/X2txahBRNE7+g7bOq4hOa/ov/72apREW5LyUq1WZu4JuW
	jaQC4wg1NIoS1hOApRy9HnOLTGT6afSpYBkTx0M03GPZa4T10vqdPOYUi2w6RQW4nn7uk7
	Kj+CHKgFmz9M4blRrlKJAdLeowa+wqs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AACDC779AE
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 06:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NJUDF8CiTGqiLAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 06:54:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is never cleared
Date: Tue,  7 Jul 2026 16:24:30 +0930
Message-ID: <d47af8cae38e32462d61cb62139c2732e4e8fdbe.1783407237.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A0E7A75B86
X-Spam-Score: -3.51

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
The cachestat() goes through the XArray of the page cache, but
instead of checking each folio's flag, it uses the
PAGECACHE_TAG_DIRTY tag to report dirty pages.

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

There is a deeper problem, dirty and writeback folio flags are updated
at very different timing.
The dirty flag is only cleared when the last sub-folio block has dirty
flag cleared.
But the writeback flag is set when the first block starts writeback, and
later blocks that go through writeback will not call
folio_start_writeback() again.

If we rely on folio_start_writeback() to update the
PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE, it will always be
incorrect in one way or another.

[FIX]
Do not let folio_start_writeback() do any PAGECACHE_TAG_TOWRITE
handling.

Instead, manually clear both PAGECACHE_TAG_TOWRITE and
PAGECACHE_TAG_DIRTY flags when the folio is no longer dirty during
btrfs_subpage_set_writeback().

However this is only a hot-fix, for the long term solution we will
follow iomap, by calling folio_start_writeback() immediately for the
whole folio, and folio_end_writeback() after all writeback finished
for the folio.

Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Completely decouple the PAGECACHE_TAG_* handling from
  folio_start_writeback()
  Since folio dirty and writeback flags are only updated once, but at
  very different timings (the last dirty block cleared vs the first
  writeback block started), we have to manually handle the
  PAGECACHE_TAG_* update by ourselves.

- Add a mention about the proper fix using the same solution
  as iomap
---
 fs/btrfs/subpage.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 56060acac2e9..2a9397be8116 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -359,6 +359,23 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
 	folio_mark_dirty(folio);
 }
 
+static void folio_clear_tags(struct folio *folio)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	XA_STATE(xas, &mapping->i_pages, folio->index);
+	unsigned long flags;
+
+	ASSERT(folio_test_locked(folio));
+	ASSERT(mapping);
+	ASSERT(mapping_use_writeback_tags(mapping));
+
+	xas_lock_irqsave(&xas, flags);
+	xas_load(&xas);
+	xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
+	xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
+	xas_unlock_irqrestore(&xas, flags);
+}
+
 /*
  * Extra clear_and_test function for subpage dirty bitmap.
  *
@@ -403,7 +420,6 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							writeback, start, len);
 	unsigned long flags;
-	bool keep_write;
 
 	spin_lock_irqsave(&bfs->lock, flags);
 	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
@@ -413,10 +429,14 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
 	 * folio. Doing so can cause WB_SYNC_ALL writepages() to overlook it,
 	 * assume writeback is complete, and exit too early — violating sync
 	 * ordering guarantees.
+	 *
+	 * Instead we manually clear the DIRTY and TOWRITE tags after the folio
+	 * is no longer dirty.
 	 */
-	keep_write = folio_test_dirty(folio);
 	if (!folio_test_writeback(folio))
-		__folio_start_writeback(folio, keep_write);
+		__folio_start_writeback(folio, true);
+	if (!folio_test_dirty(folio))
+		folio_clear_tags(folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
-- 
2.54.0

