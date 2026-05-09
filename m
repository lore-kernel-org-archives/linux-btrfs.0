Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D0391E7E
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 09:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778317626; cv=none; b=sBk662EpweESzkQF6EpV6hA8FevSmcqMBSElGiOpz57+5jXtnK2kwji6dO+56psML2D3m9NlO//9rcugv1wdfQw8giooVfSoX24JT/x4d5dRzZDTWuV+VS5Z8fgunzBN2+wuaAO50I1F7e612AisdRy9YvXDVDmxPctYmjaA9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778317626; c=relaxed/simple;
	bh=ER9z+LV+TCSYOc1EPW9+CWhs3fAeiOSgieIXpEyAdvc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NXzatJubbl3dyTfnqUvSpa0kPi/eG1l4EAn5eEgqKjsKzDbZRjoEMNyzLQfjLk55z2dDG4Z2sbOmrPKYELQYBxoOYLWJig0mfuk0lpGb/2A3NEGhLPYREogUH/oZF3kBTerU70+pynZYbBqmNhw2sNx569QYY3Y8dVz3P4ihD2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tkZ+I/id; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tkZ+I/id; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tkZ+I/id";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tkZ+I/id"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53B7D672C4
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 09:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778317614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TlugCdzD+T0orBIiaX1aPa1iZbLgYGx5LliG6g+c9fk=;
	b=tkZ+I/idIDaG+9EkqmMzq28R+XOfro0ZNw30JhU1azj6/UNcVaMyFBqSFZx/tU7cat4H2R
	NgnGeXsTGUYDZGOMFQtdQtIJu1fuCBX4DLl6drUJpHnswkv920hw6usY1bLkE1FWrtTzRo
	RQJScJEOUMI6+pESsdTsc2IaPQL9DM0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="tkZ+I/id"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778317614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TlugCdzD+T0orBIiaX1aPa1iZbLgYGx5LliG6g+c9fk=;
	b=tkZ+I/idIDaG+9EkqmMzq28R+XOfro0ZNw30JhU1azj6/UNcVaMyFBqSFZx/tU7cat4H2R
	NgnGeXsTGUYDZGOMFQtdQtIJu1fuCBX4DLl6drUJpHnswkv920hw6usY1bLkE1FWrtTzRo
	RQJScJEOUMI6+pESsdTsc2IaPQL9DM0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9348D593A3
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 09:06:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vEGkFS35/mlYeAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2026 09:06:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove locked subpage bitmap
Date: Sat,  9 May 2026 18:36:31 +0930
Message-ID: <ce0d536ed12aa0e931a384654447ba183ff068f3.1778317565.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 53B7D672C4
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

Currently there are two members inside btrfs_folio_state that are related
to locked bitmap:

- locked sub-bitmap inside btrfs_folio_state::bitmaps[]
  The enum btrfs_bitmap_nr_locked determines the sub-bitmap.

- btrfs_folio_state::nr_locked
  Which records how many blocks are locked inside the folio.

The locked sub-bitmap is a btrfs specific per-block tracking mechanism,
which is mostly for async-submission, utilized by compressed writes.

The sub-bitmap itself is a super set of nr_locked, as it can provide a
more reliable tracking.

But the sub-bitmap itself can be pretty large for the incoming huge
folio, 2M sized folio for 4K page size, meaning 512 bits for one
sub-bitmap.

Furthermore, in the long run compression will be reworked to get rid of
async-submission completely, there is not much need for a full
sub-bitmap to track the locked status.

This patch removes the locked sub-bitmap and only relies on @nr_locked
atomic to do the tracking.
This can also save 64 bytes from btrfs_folio_state::bitmaps[] for a huge
folio.

This will reduce some safety checks, as previously if a block is not
locked, btrfs_folio_end_lock()/btrfs_folio_end_lock_bitmap() will find
out that, and skip reducing @nr_locked for that block, and avoid
under-flow.

But this safety net itself shouldn't be necessary in the first place.
If we're unlocking a block that is not locked, it's a bug in the logic,
and we should catch it, not silently ignoring it.
Thus I believe the removal of the extra safety net should not be a
problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
This will conflict with the huge folio patchset and the removal of
ordered sub-bitmap.

Thus all three patchsets (including this one) will need some co-ordination
and refresh, depending on which one got merged first.
---
 fs/btrfs/subpage.c | 45 ++++++++++-----------------------------------
 fs/btrfs/subpage.h | 10 ----------
 2 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 8a09f34ea31e..ff68e79fe72d 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -224,11 +224,8 @@ static bool btrfs_subpage_end_and_test_lock(const struct btrfs_fs_info *fs_info,
 					    struct folio *folio, u64 start, u32 len)
 {
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	const int start_bit = subpage_calc_start_bit(fs_info, folio, locked, start, len);
 	const int nbits = (len >> fs_info->sectorsize_bits);
 	unsigned long flags;
-	unsigned int cleared = 0;
-	int bit = start_bit;
 	bool last;
 
 	btrfs_subpage_assert(fs_info, folio, start, len);
@@ -245,15 +242,10 @@ static bool btrfs_subpage_end_and_test_lock(const struct btrfs_fs_info *fs_info,
 		spin_unlock_irqrestore(&bfs->lock, flags);
 		return true;
 	}
-
-	for_each_set_bit_from(bit, bfs->bitmaps, start_bit + nbits) {
-		clear_bit(bit, bfs->bitmaps);
-		cleared++;
-	}
-	ASSERT(atomic_read(&bfs->nr_locked) >= cleared,
-	       "atomic_read(&bfs->nr_locked)=%d cleared=%d",
-	       atomic_read(&bfs->nr_locked), cleared);
-	last = atomic_sub_and_test(cleared, &bfs->nr_locked);
+	ASSERT(atomic_read(&bfs->nr_locked) >= nbits,
+	       "atomic_read(&bfs->nr_locked)=%d nbits=%d",
+	       atomic_read(&bfs->nr_locked), nbits);
+	last = atomic_sub_and_test(nbits, &bfs->nr_locked);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 	return last;
 }
@@ -309,11 +301,9 @@ void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	const int start_bit = blocks_per_folio * btrfs_bitmap_nr_locked;
+	const unsigned int nbits = bitmap_weight(&bitmap, blocks_per_folio);
 	unsigned long flags;
 	bool last = false;
-	int cleared = 0;
-	int bit;
 
 	if (!btrfs_is_subpage(fs_info, folio)) {
 		folio_unlock(folio);
@@ -327,14 +317,10 @@ void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
 	}
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	for_each_set_bit(bit, &bitmap, blocks_per_folio) {
-		if (test_and_clear_bit(bit + start_bit, bfs->bitmaps))
-			cleared++;
-	}
-	ASSERT(atomic_read(&bfs->nr_locked) >= cleared,
-	       "atomic_read(&bfs->nr_locked)=%d cleared=%d",
-	       atomic_read(&bfs->nr_locked), cleared);
-	last = atomic_sub_and_test(cleared, &bfs->nr_locked);
+	ASSERT(atomic_read(&bfs->nr_locked) >= nbits,
+	       "atomic_read(&bfs->nr_locked)=%d nbits=%d",
+	       atomic_read(&bfs->nr_locked), nbits);
+	last = atomic_sub_and_test(nbits, &bfs->nr_locked);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 	if (last)
 		folio_unlock(folio);
@@ -696,7 +682,6 @@ void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_folio_state *bfs;
 	unsigned long flags;
-	unsigned int start_bit;
 	unsigned int nbits;
 	int ret;
 
@@ -705,15 +690,8 @@ void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 		return;
 
 	bfs = folio_get_private(folio);
-	start_bit = subpage_calc_start_bit(fs_info, folio, locked, start, len);
 	nbits = len >> fs_info->sectorsize_bits;
 	spin_lock_irqsave(&bfs->lock, flags);
-	/* Target range should not yet be locked. */
-	if (unlikely(!bitmap_test_range_all_zero(bfs->bitmaps, start_bit, nbits))) {
-		SUBPAGE_DUMP_BITMAP(fs_info, folio, locked, start, len);
-		ASSERT(bitmap_test_range_all_zero(bfs->bitmaps, start_bit, nbits));
-	}
-	bitmap_set(bfs->bitmaps, start_bit, nbits);
 	ret = atomic_add_return(nbits, &bfs->nr_locked);
 	ASSERT(ret <= btrfs_blocks_per_folio(fs_info, folio));
 	spin_unlock_irqrestore(&bfs->lock, flags);
@@ -750,7 +728,6 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	unsigned long dirty_bitmap;
 	unsigned long writeback_bitmap;
 	unsigned long ordered_bitmap;
-	unsigned long locked_bitmap;
 	unsigned long flags;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
@@ -762,16 +739,14 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	GET_SUBPAGE_BITMAP(fs_info, folio, dirty, &dirty_bitmap);
 	GET_SUBPAGE_BITMAP(fs_info, folio, writeback, &writeback_bitmap);
 	GET_SUBPAGE_BITMAP(fs_info, folio, ordered, &ordered_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, locked, &locked_bitmap);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 
 	dump_page(folio_page(folio, 0), "btrfs folio state dump");
 	btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl locked=%*pbl writeback=%*pbl ordered=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl",
 		    start, len, folio_pos(folio),
 		    blocks_per_folio, &uptodate_bitmap,
 		    blocks_per_folio, &dirty_bitmap,
-		    blocks_per_folio, &locked_bitmap,
 		    blocks_per_folio, &writeback_bitmap,
 		    blocks_per_folio, &ordered_bitmap);
 }
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index fdea0b605bfc..ccdb817381dd 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -45,16 +45,6 @@ enum {
 	 */
 	btrfs_bitmap_nr_ordered,
 
-	/*
-	 * The locked bit is for async delalloc range (compression), currently
-	 * async extent is queued with the range locked, until the compression
-	 * is done.
-	 * So an async extent can unlock the range at any random timing.
-	 *
-	 * This will need a rework on the async extent lifespan (mark writeback
-	 * and do compression) before deprecating this flag.
-	 */
-	btrfs_bitmap_nr_locked,
 	btrfs_bitmap_nr_max
 };
 
-- 
2.54.0

