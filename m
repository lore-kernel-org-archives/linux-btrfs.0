Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F92AE78
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777189900; cv=none; b=b8fbcic9FQybm/qGnkLz+lel9HpybO5uQinSZ/C8u05gYuqdqH27TEO2ZjGzkyFAxyScY9muRSAy41XQhUMQRUHmHD+cB1QlJ3R/RgOFDpccULgjq/lHKcZCzUEsPHUTK3KQgUyp15RmFKXLXrBp1vupMpG6hMJG/OZTApkuPD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777189900; c=relaxed/simple;
	bh=H9nHT4b9Ju/C0eOqgyNbcu1S7O+Ry1YVvbQXGXog218=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ekb5nCa9HkHLZjiNM89JpaQqdEUkiMo2W00k7zLRpJrCtA+kb+4xUfWMrz4N+v17u/gO2K62piI30g3deYfovfWrMYqTsItQ3VJKfoaU3h44/rE3IbmWbMHPvNj1WMR6Un+4+afHTHnpiSkzkynFPAQSjec5PsWOPWYpnGIHTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nDUnPOfl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nDUnPOfl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nDUnPOfl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nDUnPOfl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 904A26A7D5
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdh/sN0nx6ZpzghIPof6+m6389+Tp/xB4uFrBJ87y9c=;
	b=nDUnPOfljrOR3YqLDmTAn+63fsXNhUW8okKMEDx1glKn9Rw16I5BPQg8KjrsrEFwDLs59S
	cAvwiu+tZI2Jkq61/3mIvr0kK3ZR5QeAMsNJ5CIP+kcdkOEswF5ouot05cHzYde9OCINyt
	H+hZfAPgFvfgbgAOB/o1+hszXvqH4rg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=nDUnPOfl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdh/sN0nx6ZpzghIPof6+m6389+Tp/xB4uFrBJ87y9c=;
	b=nDUnPOfljrOR3YqLDmTAn+63fsXNhUW8okKMEDx1glKn9Rw16I5BPQg8KjrsrEFwDLs59S
	cAvwiu+tZI2Jkq61/3mIvr0kK3ZR5QeAMsNJ5CIP+kcdkOEswF5ouot05cHzYde9OCINyt
	H+hZfAPgFvfgbgAOB/o1+hszXvqH4rg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F697593B0
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0KKbDwLE7Wm3IwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: refresh add_ra_bio_pages() to indicate it's using folios
Date: Sun, 26 Apr 2026 17:21:04 +0930
Message-ID: <4a5a1581ed3ecad6df8fd35a5e56f7fe460a5867.1777189624.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777189624.git.wqu@suse.com>
References: <cover.1777189624.git.wqu@suse.com>
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 904A26A7D5
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The function add_ra_bio_folios() has been utilizing folio interfaces
since c808c1dcb1b2 ("btrfs: convert add_ra_bio_pages() to use only
folios"), but we are still referring to "pages" inside the function name
and all comments.

Furthermore, such folio/page mixing can even be confusing, e.g. the
variable @page_end is very confusing as we're not really referring to
the end of the page, but the end of the folio, especially when we
already have large folio support.

Enhance that function by:

- Rename "page" to "folio" to avoid confusion

- Skip to the folio end if there is already a folio in the page cache
  The existing skip is:

  	cur += folio_size(folio);

  This is incorrect if @cur is not folio size aligned, and can be
  common with large folio support.

  Thankfully this is not going to cause any real bugs, but at most will
  skip some blocks that can be added to readahead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 09729728624b..8ee0a4117d62 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -355,18 +355,18 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
 }
 
 /*
- * Add extra pages in the same compressed file extent so that we don't need to
+ * Add extra folios in the same compressed file extent so that we don't need to
  * re-read the same extent again and again.
  *
- * If we have several sectors in the same page points to the same
+ * If we have several blocks in the same folio pointing to the same
  * on-disk compressed data, we will re-read the same extent many times and
- * this function can only help for the next page.
+ * this function can only help for the next folio(s).
  */
-static noinline int add_ra_bio_pages(struct inode *inode,
-				     u64 compressed_end,
-				     struct compressed_bio *cb,
-				     int *memstall, unsigned long *pflags,
-				     bool direct_reclaim)
+static noinline int add_ra_bio_folios(struct inode *inode,
+				      u64 compressed_end,
+				      struct compressed_bio *cb,
+				      int *memstall, unsigned long *pflags,
+				      bool direct_reclaim)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	pgoff_t end_index;
@@ -396,7 +396,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 	/*
 	 * Avoid direct reclaim when the caller does not allow it.  Since
-	 * add_ra_bio_pages() is always speculative, suppress allocation warnings
+	 * add_ra_bio_folios() is always speculative, suppress allocation warnings
 	 * in either case.
 	 */
 	if (!direct_reclaim) {
@@ -408,7 +408,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	}
 
 	while (cur < compressed_end) {
-		pgoff_t page_end;
+		u64 folio_end;
 		pgoff_t pg_index = cur >> PAGE_SHIFT;
 		u32 add_size;
 
@@ -442,8 +442,8 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			break;
 
 		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
-			/* There is already a folio, skip to folio end */
-			cur += folio_size(folio);
+			/* There is already a folio, skip to the folio end */
+			cur += folio_size(folio) - offset_in_folio(folio, cur);
 			folio_put(folio);
 			continue;
 		}
@@ -460,10 +460,10 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			break;
 		}
 
-		page_end = (pg_index << PAGE_SHIFT) + folio_size(folio) - 1;
-		btrfs_lock_extent(tree, cur, page_end, NULL);
+		folio_end = folio_next_pos(folio) - 1;
+		btrfs_lock_extent(tree, cur, folio_end, NULL);
 		read_lock(&em_tree->lock);
-		em = btrfs_lookup_extent_mapping(em_tree, cur, page_end + 1 - cur);
+		em = btrfs_lookup_extent_mapping(em_tree, cur, folio_end + 1 - cur);
 		read_unlock(&em_tree->lock);
 
 		/*
@@ -476,14 +476,14 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		    (btrfs_extent_map_block_start(em) >> SECTOR_SHIFT) !=
 		    orig_bio->bi_iter.bi_sector) {
 			btrfs_free_extent_map(em);
-			btrfs_unlock_extent(tree, cur, page_end, NULL);
+			btrfs_unlock_extent(tree, cur, folio_end, NULL);
 			folio_unlock(folio);
 			folio_put(folio);
 			break;
 		}
-		add_size = min(btrfs_extent_map_end(em), page_end + 1) - cur;
+		add_size = min(btrfs_extent_map_end(em), folio_end + 1) - cur;
 		btrfs_free_extent_map(em);
-		btrfs_unlock_extent(tree, cur, page_end, NULL);
+		btrfs_unlock_extent(tree, cur, folio_end, NULL);
 
 		if (folio_contains(folio, end_index)) {
 			size_t zero_offset = offset_in_folio(folio, isize);
@@ -592,8 +592,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	}
 	ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
 
-	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
-			 &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
+	add_ra_bio_folios(&inode->vfs_inode, em_start + em_len, cb, &memstall,
+			  &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
 
 	cb->len = bbio->bio.bi_iter.bi_size;
 	cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;
-- 
2.53.0

