Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4B18787A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778647015; cv=none; b=plK2uYlr3Hfaw2yL2AEcoJ06EX/Vt7qeOFUjrVGp5jbzDOiaByjKNapgmSu7h6xcu2U0gPWRt445MpmRQYgmdKwHER5t06wbOy2jkKhqw3v78+ahaFIYPkbEFQtjQholg9rm2YzrVvUnNTKHlgp7HA5plDkhLCT3hKb7yBsBc8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778647015; c=relaxed/simple;
	bh=HCFZsSY4L5xXwz+R25gbPpVBtDUH3+v2/sQBvLSwORM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0//7arx7qK3rrxGF3DGSbUiLh5FloffO0x60mjwiN9Yt+6VSoCF4UL5vTVash9eOSp9wtwcucd4P4V0lLPt8b4txO6G5MMzqVuTw7DxZP3O/BToW7jEpJAYkKrhO/kD5N1yHf9c987oC+Tx7TMIcHhAvAAP8LzLP8oHnjdoYI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nY0Gouw6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nY0Gouw6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nY0Gouw6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nY0Gouw6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CAF5622BA
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD5vosTa7bv63eBOuvUhwCfd9GYoE6LUWJSSpiu+HVg=;
	b=nY0Gouw6neksW0gMKTGRuxnpoyH8vf3/WRxL/2qTVPbHAU6zB1B/iVNnoYneraeJ6JqgHq
	11jzq0d9XZKzvKHBZfT8GSEH4rrb/IFi1u5nE9Aon5vVyeWC3WesfKR+iNm/F/UTeXC5J6
	Uqc46CseWEqeujE0Vl9XALQYnVRoqrU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD5vosTa7bv63eBOuvUhwCfd9GYoE6LUWJSSpiu+HVg=;
	b=nY0Gouw6neksW0gMKTGRuxnpoyH8vf3/WRxL/2qTVPbHAU6zB1B/iVNnoYneraeJ6JqgHq
	11jzq0d9XZKzvKHBZfT8GSEH4rrb/IFi1u5nE9Aon5vVyeWC3WesfKR+iNm/F/UTeXC5J6
	Uqc46CseWEqeujE0Vl9XALQYnVRoqrU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB435593A9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QO4sJ93/A2r1SQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: prepare subpage operations to support >= BITS_PER_LONG sub-bitmaps
Date: Wed, 13 May 2026 14:06:19 +0930
Message-ID: <78b3cc42dc86e23de803bb1bc1d0004ed7b231a2.1778646753.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778646753.git.wqu@suse.com>
References: <cover.1778646753.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[CURRENT LIMIT]
Btrfs currently only supports sub-bitmaps (e.g. dirty bitmap) no larger
than BITS_PER_LONG.

That limit allows us to easily grab an unsigned long without the need to
properly allocate memory for a larger bitmap.

Unfortunately that limit prevents us from supporting huge folios.
For 4K page size and block size, a huge folio (order 9) means 512 blocks
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
  can directly access the start word of the sub-bitmap.

  This involves get_bitmap_pointer_##name() helper functions.

Then change the existing sub-bitmaps users to use the new helpers:

- Bitmap dumping
  Switch between get_bitmap_value_##name() and
  get_bitmap_pointer_##name() depending on the sub-bitmap size.

- btrfs_get_subpage_dirty_bitmap()
  Rename it to btrfs_get_subpage_dirty_bitmap_value() to follow the new
  value/pointer naming.
  Since we do not support huge folios yet, there is no pointer version
  for the dirty bitmap.

  Furthermore, add the support for bs == ps cases for
  btrfs_get_subpage_dirty_bitmap_value(), so that the caller no longer
  needs to check if the folio needs subpage handling.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c |   7 +--
 fs/btrfs/subpage.c   | 118 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/subpage.h   |   5 +-
 3 files changed, 87 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8cf1e4c5105f..1dfa3152e4bd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1492,12 +1492,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
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
index 99ae53656dba..fb56eaf52325 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -555,25 +555,54 @@ IMPLEMENT_BTRFS_PAGE_OPS(dirty, folio_mark_dirty, folio_clear_dirty_for_io,
 IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_writeback,
 			 folio_test_writeback);
 
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
+static inline const unsigned long *get_bitmap_pointer_##name(			\
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
@@ -663,42 +692,63 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_folio_state *bfs;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	unsigned long uptodate_bitmap;
-	unsigned long dirty_bitmap;
-	unsigned long writeback_bitmap;
 	unsigned long flags;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
 	ASSERT(blocks_per_folio > 1);
 	bfs = folio_get_private(folio);
 
-	spin_lock_irqsave(&bfs->lock, flags);
-	GET_SUBPAGE_BITMAP(fs_info, folio, uptodate, &uptodate_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, dirty, &dirty_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, writeback, &writeback_bitmap);
-	spin_unlock_irqrestore(&bfs->lock, flags);
-
 	dump_page(folio_page(folio, 0), "btrfs folio state dump");
+
+	if (blocks_per_folio <= BITS_PER_LONG) {
+		unsigned long uptodate;
+		unsigned long dirty;
+		unsigned long writeback;
+
+		spin_lock_irqsave(&bfs->lock, flags);
+		uptodate = get_bitmap_value_uptodate(fs_info, folio);
+		dirty = get_bitmap_value_dirty(fs_info, folio);
+		writeback = get_bitmap_value_writeback(fs_info, folio);
+
+		spin_unlock_irqrestore(&bfs->lock, flags);
+
+		btrfs_warn(fs_info,
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl",
+			    start, len, folio_pos(folio),
+			    blocks_per_folio, &uptodate,
+			    blocks_per_folio, &dirty,
+			    blocks_per_folio, &writeback);
+		return;
+	}
+
+	spin_lock_irqsave(&bfs->lock, flags);
 	btrfs_warn(fs_info,
 "start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl",
 		    start, len, folio_pos(folio),
-		    blocks_per_folio, &uptodate_bitmap,
-		    blocks_per_folio, &dirty_bitmap,
-		    blocks_per_folio, &writeback_bitmap);
+		    blocks_per_folio, get_bitmap_pointer_uptodate(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_dirty(fs_info, folio),
+		    blocks_per_folio, get_bitmap_pointer_writeback(fs_info, folio));
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
index b30eb4abae64..756c05c89c11 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -184,9 +184,8 @@ bool btrfs_subpage_clear_and_test_dirty(const struct btrfs_fs_info *fs_info,
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
2.54.0

