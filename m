Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44D135B63B
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020738; cv=none; b=ZyHlnsaOD//H5ODZNw0/m72qD/m3AwZQCFpDy7RtXATnP62/btX+P6sCP0Qr3QCnlIs140okd/owO/sptMzbeJSvIqYNXNElXCM4HKRpS4JtUYrj1EeqZJCf6g9DvQhCLi27dw5ZM+OK83S54zYkuaJM17hN3fkfbfXUy33q/DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020738; c=relaxed/simple;
	bh=UMR9A5A8tHdQwdvZgoWsr/siAI9OQeUZOqH3oWUqze0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1VDBh+RolSWjfpYcdJdHtEvNYMxhn1UPtK6Ij4noRhAB6Vd6w0jF/Gbdr793ZMYa/uaGpAP9VdRHBshbhlVYn41rJvC/0fx0qoUj+7HTHNqWZZjoTVBEPwcezYVvkbb+mdI5qOrU2pGZ6Iv99Bnm2q8wRf8tka+JO66UGJlDPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZtDxdjgF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CUSpi3rn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZtDxdjgF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CUSpi3rn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA5CD5BD8A
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08ScbQI34qO2Ug2G8pZ5SSkCrTcWaE7kuogoJxrNWsc=;
	b=ZtDxdjgF/a1urxj29ngJPcQQccZmhEf2LOwwUUyZtqWq8RKTt8C3SdVMcmRHVAUquIKx/B
	iw4NEw1znRP4DtnU0lh31IEkjSFuzk4G7W0Q2MDbvFUZWR728ZCPnXz7QjbOrCCVpgz4XO
	yvxRKXJE/RXlQJfPD9VfU7SHyH/o8+w=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08ScbQI34qO2Ug2G8pZ5SSkCrTcWaE7kuogoJxrNWsc=;
	b=CUSpi3rnBI0q9gAWOJM8jcH7g+UoEh02oRRbDU65v4kthvpsiAR7vtWUbWkmFt/Y7fm4aX
	WzS2rFldd6+pSks/OJpLmqJtne3WCJakJVYiqzE2vnvOSfrKdQMVgvKaRusoT5+GxgfWKu
	XFEVRzkWS/1agq+c6sxwnM1a6GtmIkQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E62F0593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KORqJDQv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:04 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/5] btrfs: prepare subpage operations to support >= BITS_PER_LONG sub-bitmaps
Date: Fri, 24 Apr 2026 18:21:31 +0930
Message-ID: <3f27ba806b162b0368be5e324eefeac3fca5e045.1777019132.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777019132.git.wqu@suse.com>
References: <cover.1777019132.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[CURRENT LIMIT]
Btrfs currently only supports sub-bitmaps (e.g. dirty bitmap) no larger
than BITS_PER_LONG.

That limit allows us to easily grab an unsigned long without the need to
properly allocate memory for a larger bitmap.

Unfortunately that limit prevents us from supporting huge folios, which
means order 9 and for 4K page size and block size, it means 512 blocks
inside a 2M folio.

[ENHANCEMENT]
To allow direct bitmap operations without allocating new memory,
introduce two different ways to access the subpage bitmaps:

- Return an unsigned long value
  This only happens if blocks_per_folio <= BITS_PER_LONG.

  We read out the sub-bitmap into an unsigned long, and return the
  value.
  This is the old existing method.

  This involves get_bitmap_value_##name() helper functions.
  And this time the helper functions are defined as inline functions
  instead of macros to provide better type checks.

- Return a pointer where the sub-bitmap starts
  This only happens if blocks_per_folio >= BITS_PER_LONG.

  This is the new method for sub-bitmaps larger than BITS_PER_LONG.
  Since the sizes of sub-bitmaps are all aligned to BITS_PER_LONG, we
  can directly access the start byte of the sub-bitmap.

  This involves get_bitmap_pointer_##name() helper functions.
  And this time the helper functions are defined as inline functions
  instead of macros to provide better type checks.

Then change the existing sub-bitmaps users to use the new helpers:

- Bitmap dumping
  Switch between get_bitmap_value_##name() and
  get_bitmap_pointer_##name() depending on the sub-bitmap size.

- btrfs_get_subpage_dirty_bitmap()
  Rename it to btrfs_get_subpage_dirty_bitmap_value() to follow the new
  value/pointer naming.
  Since we do not support huge folios yet, there is no pointer version
  for it yet.

  Furthermore add the support for bs == ps cases for
  btrfs_get_subpage_dirty_bitmap_value(), so that the caller no longer
  needs to check if the folio needs subpage handling.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c |   7 +--
 fs/btrfs/subpage.c   | 133 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/subpage.h   |   5 +-
 3 files changed, 96 insertions(+), 49 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6a6d98eec787..13b726831aa0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1447,12 +1447,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	int ret = 0;
 
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
-	if (btrfs_is_subpage(fs_info, folio)) {
-		ASSERT(blocks_per_folio > 1);
-		btrfs_get_subpage_dirty_bitmap(fs_info, folio, &bio_ctrl->submit_bitmap);
-	} else {
-		bio_ctrl->submit_bitmap = 1;
-	}
+	bio_ctrl->submit_bitmap = btrfs_get_subpage_dirty_bitmap_value(fs_info, folio);
 
 	for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index becaa1dc0001..2116a6b4a476 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -601,25 +601,56 @@ IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_writeback,
 IMPLEMENT_BTRFS_PAGE_OPS(ordered, folio_set_ordered, folio_clear_ordered,
 			 folio_test_ordered);
 
-#define GET_SUBPAGE_BITMAP(fs_info, folio, name, dst)			\
-{									\
-	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio); \
-	const struct btrfs_folio_state *__bfs = folio_get_private(folio); \
-									\
-	ASSERT(__bpf <= BITS_PER_LONG);					\
-	*dst = bitmap_read(__bfs->bitmaps,				\
-			   __bpf * btrfs_bitmap_nr_##name, __bpf);	\
+#define DEFINE_GET_SUBPAGE_BITMAP(name)						\
+static inline unsigned long get_bitmap_value_##name(				\
+					const struct btrfs_fs_info *fs_info,	\
+					struct folio *folio)			\
+{										\
+	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio);	\
+	const struct btrfs_folio_state *__bfs = folio_get_private(folio);	\
+	unsigned long value;							\
+										\
+	ASSERT(__bpf <= BITS_PER_LONG);						\
+	value = bitmap_read(__bfs->bitmaps, __bpf * btrfs_bitmap_nr_##name,	\
+			     __bpf);						\
+	return value;								\
+}										\
+static inline unsigned long *get_bitmap_pointer_##name(				\
+					const struct btrfs_fs_info *fs_info,	\
+					struct folio *folio)			\
+{										\
+	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio);	\
+	struct btrfs_folio_state *__bfs = folio_get_private(folio);		\
+	unsigned long *pointer;							\
+										\
+	ASSERT(__bpf >= BITS_PER_LONG);						\
+	ASSERT(IS_ALIGNED(__bpf, BITS_PER_LONG));				\
+	pointer = __bfs->bitmaps + (BIT_WORD(__bpf) * btrfs_bitmap_nr_##name);	\
+	return pointer;								\
 }
 
-#define SUBPAGE_DUMP_BITMAP(fs_info, folio, name, start, len)		\
-{									\
-	unsigned long bitmap;						\
-	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio); \
-									\
-	GET_SUBPAGE_BITMAP(fs_info, folio, name, &bitmap);		\
-	btrfs_warn(fs_info,						\
-	"dumping bitmap start=%llu len=%u folio=%llu " #name "_bitmap=%*pbl", \
-		   start, len, folio_pos(folio), __bpf, &bitmap);	\
+DEFINE_GET_SUBPAGE_BITMAP(uptodate);
+DEFINE_GET_SUBPAGE_BITMAP(dirty);
+DEFINE_GET_SUBPAGE_BITMAP(writeback);
+DEFINE_GET_SUBPAGE_BITMAP(ordered);
+DEFINE_GET_SUBPAGE_BITMAP(locked);
+
+#define SUBPAGE_DUMP_BITMAP(fs_info, folio, name, start, len)			\
+{										\
+	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio);	\
+										\
+	if (__bpf <= BITS_PER_LONG) {						\
+		unsigned long bitmap = get_bitmap_value_##name(fs_info, folio);	\
+										\
+		btrfs_warn(fs_info,						\
+	"dumping bitmap start=%llu len=%u folio=%llu " #name "_bitmap=%*pbl",	\
+		   start, len, folio_pos(folio), __bpf, &bitmap);		\
+	} else {								\
+		btrfs_warn(fs_info,						\
+	"dumping bitmap start=%llu len=%u folio=%llu " #name "_bitmap=%*pbl",	\
+		   start, len, folio_pos(folio), __bpf,				\
+		   get_bitmap_pointer_##name(fs_info, folio));			\
+	}									\
 }
 
 /*
@@ -717,48 +748,70 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_folio_state *bfs;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	unsigned long uptodate_bitmap;
-	unsigned long dirty_bitmap;
-	unsigned long writeback_bitmap;
-	unsigned long ordered_bitmap;
-	unsigned long locked_bitmap;
 	unsigned long flags;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
 	ASSERT(blocks_per_folio > 1);
 	bfs = folio_get_private(folio);
 
-	spin_lock_irqsave(&bfs->lock, flags);
-	GET_SUBPAGE_BITMAP(fs_info, folio, uptodate, &uptodate_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, dirty, &dirty_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, writeback, &writeback_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, ordered, &ordered_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, locked, &locked_bitmap);
-	spin_unlock_irqrestore(&bfs->lock, flags);
+	if (blocks_per_folio <= BITS_PER_LONG) {
+		unsigned long uptodate;
+		unsigned long dirty;
+		unsigned long writeback;
+		unsigned long ordered;
+		unsigned long locked;
+
+		spin_lock_irqsave(&bfs->lock, flags);
+		uptodate = get_bitmap_value_uptodate(fs_info, folio);
+		dirty = get_bitmap_value_dirty(fs_info, folio);
+		writeback = get_bitmap_value_writeback(fs_info, folio);
+		ordered = get_bitmap_value_ordered(fs_info, folio);
+		locked = get_bitmap_value_locked(fs_info, folio);
+
+		spin_unlock_irqrestore(&bfs->lock, flags);
+
+		btrfs_warn(fs_info,
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl locked=%*pbl",
+			    start, len, folio_pos(folio),
+			    blocks_per_folio, &uptodate,
+			    blocks_per_folio, &dirty,
+			    blocks_per_folio, &writeback,
+			    blocks_per_folio, &ordered,
+			    blocks_per_folio, &locked);
+		return;
+	}
 
 	dump_page(folio_page(folio, 0), "btrfs folio state dump");
+	spin_lock_irqsave(&bfs->lock, flags);
 	btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl locked=%*pbl writeback=%*pbl ordered=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl locked=%*pbl",
 		    start, len, folio_pos(folio),
-		    blocks_per_folio, &uptodate_bitmap,
-		    blocks_per_folio, &dirty_bitmap,
-		    blocks_per_folio, &locked_bitmap,
-		    blocks_per_folio, &writeback_bitmap,
-		    blocks_per_folio, &ordered_bitmap);
+		    blocks_per_folio, get_bitmap_pointer_uptodate(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_dirty(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_writeback(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_ordered(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_locked(fs_info, folio));
+	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
-void btrfs_get_subpage_dirty_bitmap(struct btrfs_fs_info *fs_info,
-				    struct folio *folio,
-				    unsigned long *ret_bitmap)
+unsigned long btrfs_get_subpage_dirty_bitmap_value(struct btrfs_fs_info *fs_info,
+						   struct folio *folio)
 {
 	struct btrfs_folio_state *bfs;
+	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
 	unsigned long flags;
+	unsigned long value;
+
+	if (blocks_per_folio == 1)
+		return 1;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
-	ASSERT(btrfs_blocks_per_folio(fs_info, folio) > 1);
+	ASSERT(blocks_per_folio > 1);
+	ASSERT(blocks_per_folio <= BITS_PER_LONG);
 	bfs = folio_get_private(folio);
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	GET_SUBPAGE_BITMAP(fs_info, folio, dirty, ret_bitmap);
+	value = get_bitmap_value_dirty(fs_info, folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
+	return value;
 }
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index fdea0b605bfc..9e92877e7251 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -200,9 +200,8 @@ bool btrfs_subpage_clear_and_test_dirty(const struct btrfs_fs_info *fs_info,
 void btrfs_folio_assert_not_dirty(const struct btrfs_fs_info *fs_info,
 				  struct folio *folio, u64 start, u32 len);
 bool btrfs_meta_folio_clear_and_test_dirty(struct folio *folio, const struct extent_buffer *eb);
-void btrfs_get_subpage_dirty_bitmap(struct btrfs_fs_info *fs_info,
-				    struct folio *folio,
-				    unsigned long *ret_bitmap);
+unsigned long btrfs_get_subpage_dirty_bitmap_value(struct btrfs_fs_info *fs_info,
+						   struct folio *folio);
 void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 				      struct folio *folio, u64 start, u32 len);
 
-- 
2.53.0

