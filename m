Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE70329373
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938592; cv=none; b=nlCSSzIVGIUahZNh3i+ZfyabdChLK6Fqgcwvogcd0k9D6JC7n15u9zGYBw2i4WCBIKA7CS3hqDCnbUI0r2ARgADCuKUBeGkgQxUnvnTajdCIDuJ2ME+rNUqBOIOf3VA21+72zndcm4y1W95OiCr6ym3aH5tJm6pLgEB/TJ0WQDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938592; c=relaxed/simple;
	bh=YhYpaqG1aK6znaPFjeiraxsnpzWQUFPe2q1lbbIxTI0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej1yFkTkpFyhPPAzGHsJY8XWHYBLR3bFO1DiWXQEVtcs7M2gWowVuLZ/1nZJfjSv8MPER7dtMbbJ55ls114LiLAjNTw2ikJEdbwDQILLBjd1vWyCmxn6pUAx/72oMbBgIajWkn7KecTN7q3AdCHa8eYeq7O+289ZThY2F4DgClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VvCsiwWM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VvCsiwWM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VvCsiwWM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VvCsiwWM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1ABB6B681
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIOFqrYFMbsvenFI37y2yQBd3R9c0cp3b0fLSeJXWLU=;
	b=VvCsiwWMWKFz7MkpYCiGjyAwHdrzhjlgefp9X7SIWZybVfYouhe6Q3SPYkxYA2SPrPZJ+A
	GrTC1qmqeW7+k6wqxO/HdoBZJ3FVEBSOUNd9yFa1GWGWa2Ks3MEf4Rz2SlS1uvGHnsIHj1
	UzjSBDIhOPUaa059FRWvL88JwealMRY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIOFqrYFMbsvenFI37y2yQBd3R9c0cp3b0fLSeJXWLU=;
	b=VvCsiwWMWKFz7MkpYCiGjyAwHdrzhjlgefp9X7SIWZybVfYouhe6Q3SPYkxYA2SPrPZJ+A
	GrTC1qmqeW7+k6wqxO/HdoBZJ3FVEBSOUNd9yFa1GWGWa2Ks3MEf4Rz2SlS1uvGHnsIHj1
	UzjSBDIhOPUaa059FRWvL88JwealMRY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A84E593A3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLi8M5Yw+WmKAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 23:49:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/4] btrfs: unify folio dirty flag clearing
Date: Tue,  5 May 2026 09:19:21 +0930
Message-ID: <620d0a378cfa307cc3d12988b1350881f1cc0dfa.1777937175.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777937175.git.wqu@suse.com>
References: <cover.1777937175.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Currently during folio writeback, we call folio_clear_dirty_for_io()
before extent_writepage(), which causes folio dirty flag to be cleared,
but without touching the subpage bitmaps.

This works fine for the bio submission path, as we always call
btrfs_folio_clear_dirty() to clear subpage bitmap.

But this is far from consistent, thus this patch is going to unify the
behavior to always use btrfs_folio_clear_dirty() helper to clear both
folio flag and subpage bitmap.

This involves:

- Change the folio_clear_dirty_for_io() with folio_test_dirty()
  There is only one call site calling folio_clear_dirty_for_io() outside
  of subpage.c, that's inside extent_write_cache_pages() just before
  extent_writepage().

- Make btrfs_invalidate_folio() to clear dirty range for the whole folio
  The function btrfs_invalidate_folio() is also called during
  extent_writepage().

  If we had a folio completely beyond isize, we call
  folio_invalidate() -> btrfs_invalidate_folio() to free the folio.

  Since we no longer have folio_clear_dirty_for_io() to clear the folio
  dirty flag, we must manually clear the folio dirty flag for the
  to-be-invalidated folio, and also clear the PAGECACHE_TAG_DIRTY tag.

  The tag clearing is done using a new helper,
  btrfs_clear_folio_dirty_tag(), which is almost the same as the old
  btree_clear_folio_dirty_tag(), but with minor improvements including:

  * Remove the folio_test_dirty() check
    We have already done an ASSERT().

  * Add an ASSERT() to make sure folio is mapped

- Add extra ASSERT()s before clearing folio private
  During development I hit dirty folios without the private flag set,
  and that caused a lot of ASSERT()s.
  The reason is that btrfs_invalidate_folio() is relying on the dirty
  flag not set when it's called from extent_writepage().

  Add extra ASSERT()s inside clear_folio_extent_mapped() to catch
  wild dirty/writeback flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 26 +++++++++++++-------------
 fs/btrfs/extent_io.h | 11 +++++++++++
 fs/btrfs/inode.c     |  2 ++
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ebf9a63946e5..5cab9e7a5762 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -933,6 +933,17 @@ void clear_folio_extent_mapped(struct folio *folio)
 	struct btrfs_fs_info *fs_info;
 
 	ASSERT(folio->mapping);
+	/*
+	 * The folio should not have writeback nor dirty flag set.
+	 *
+	 * If dirty flag is set, the folio can be written back again and we
+	 * expect the private flag set for the folio.
+	 *
+	 * If writeback flag is set, the endio may need to utilize the
+	 * private for btrfs_folio_state.
+	 */
+	ASSERT(!folio_test_dirty(folio));
+	ASSERT(!folio_test_writeback(folio));
 
 	if (!folio_test_private(folio))
 		return;
@@ -2562,7 +2573,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			}
 
 			if (folio_test_writeback(folio) ||
-			    !folio_clear_dirty_for_io(folio)) {
+			    !folio_test_dirty(folio)) {
 				folio_unlock(folio);
 				continue;
 			}
@@ -3725,17 +3736,6 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	release_extent_buffer(eb);
 }
 
-static void btree_clear_folio_dirty_tag(struct folio *folio)
-{
-	ASSERT(!folio_test_dirty(folio));
-	ASSERT(folio_test_locked(folio));
-	xa_lock_irq(&folio->mapping->i_pages);
-	if (!folio_test_dirty(folio))
-		__xa_clear_mark(&folio->mapping->i_pages, folio->index,
-				PAGECACHE_TAG_DIRTY);
-	xa_unlock_irq(&folio->mapping->i_pages);
-}
-
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *eb)
 {
@@ -3776,7 +3776,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		folio_lock(folio);
 		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
 		if (last)
-			btree_clear_folio_dirty_tag(folio);
+			btrfs_clear_folio_dirty_tag(folio);
 		folio_unlock(folio);
 	}
 	WARN_ON(refcount_read(&eb->refs) == 0);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ede7abbe4031..29c57623385d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -384,6 +384,17 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
 
+static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
+{
+	ASSERT(!folio_test_dirty(folio));
+	ASSERT(folio_test_locked(folio));
+	ASSERT(folio->mapping);
+	xa_lock_irq(&folio->mapping->i_pages);
+	__xa_clear_mark(&folio->mapping->i_pages, folio->index,
+			PAGECACHE_TAG_DIRTY);
+	xa_unlock_irq(&folio->mapping->i_pages);
+}
+
 int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
 			   bool nofail);
 int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8fb00d22a924..4cc4643af7b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7665,6 +7665,8 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 					       &cached_state);
 		cur = range_end + 1;
 	}
+	btrfs_folio_clear_dirty(fs_info, folio, page_start, folio_size(folio));
+	btrfs_clear_folio_dirty_tag(folio);
 	/*
 	 * We have iterated through all ordered extents of the page, the page
 	 * should not have Ordered anymore, or the above iteration
-- 
2.54.0

