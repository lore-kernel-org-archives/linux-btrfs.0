Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEF543B3F5
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327304; cv=none; b=Hx/sSBR9bSZgNG9xj0f3NqYuPC2J66/Z03gAq7kc7+zqnNwBP0D9aduoeoYKQRWgEdwbSTQ6sPlOInArWPyiKBpO5Ge6J2+zQhmuQ0wOBhbw4Ifn0jfwAMdAMRx8nYiNjkmP32/Ms/ZcZTBl6X3KwR+j9Z7isdOqOTWkcMoQeMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327304; c=relaxed/simple;
	bh=u37YyDCNlfv6hkzrtpL7R8oDFV9FGbtII3bQIDlPGWI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0rpYakJcOhGhl+jG1AxhtIBmHEWMC16hMk8i/UhyGk9svi0BS5h4XYl5m183vqq2LXFWEMgmc1yPmM7FVmG+Cx6eo95baMD2sUC71HvDhDcCeqlpOaPhBflYywPE05cVXaawy5G3qTbYVh2LjVjvnx3dCWd/8bGKq4uc/ipI2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RDF40IMg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fBuGIsKo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RDF40IMg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fBuGIsKo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4D181FD90
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790327297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6+R/7s2C1ipaKHNJ8tK5reeC+D+rJQ8qePUyaC8i0o=;
	b=RDF40IMgbdHXvf3vyTL14ixtLCD1rXgitLSFpfF7Se2Qv2WXIqZhAMRkH7oEiZthYSA5ac
	sj/+LdjdJyQ1EQki0Wu6+bXdQkqB9RX/XkLIlf7KtMDWtuBQsmE+xNxOg/MvbWQFkwn+Vo
	j7doqvqPR55ayqq3XQA8flmdsGE+utc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790327292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6+R/7s2C1ipaKHNJ8tK5reeC+D+rJQ8qePUyaC8i0o=;
	b=fBuGIsKov3iht7u96yL2P7YMZ5A6ulx+VWQ59cCEjohY5Et4SJqoN/rUjRzON2vFmLnwqd
	G6+9A3SsX72/k2DEZ7bxmEbms/8BRwF11HAIrVQ/CezEDMsYi1FOC4KFz9X6OyEVPApH6k
	8dKTclho2KDuzcCJ86ozEJQkn0xQuBs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97AA2136F7
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 09:08:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KMnsG+45tmpjCQAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 09:08:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 6/6] btrfs: enable experimental delayed compression support
Date: Fri, 25 Sep 2026 18:37:39 +0930
Message-ID: <c0a32b57077db1e01a7047bfe8671dc130a8d4df.1790327143.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790327143.git.wqu@suse.com>
References: <cover.1790327143.git.wqu@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Instead of the existing async submission path, the new delayed bbio will
handle compressed writes by:

- Allocating delayed em/oe at run_delalloc_*() time
  Thus no data extent is reserved at that time.

- Delayed bbio will be assembled at extent_writepage_io() time

- Delayed bbio will be intercepted just before submission
  Which will run compression (or fall back to uncompressed writes) in
  workqueue.
  Data extents will only be reserved at that time, and the delayed em
  will be replaced by real ones.

  Meanwhile the real OE will be added as a child of the parent delayed
  OE, and when the parent OE finishes, the child OEs will be finished
  with their file extents inserted.

This has some benefits:

- Higher concurrency
  The old async submission held the folio and io tree range locked.
  This meant we cannot even read the uptodate folio.

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

  This is also why we need complex per-block tracking for writeback
  flags, while iomap only requires a counter tracking.

  With the new delayed compression, the lifespan of a folio aligns with
  DONTCACHE and iomap.

However there is also a change to the fsync() behavior:

- Now an inode with compressed write will require full sync
  We cannot do any fast sync, as that will grab the info from OE
  directly, but since delayed OE is just a placeholder, all the OE info
  cannot be trusted until the parent OE is finished.

There is an extra handling for defrag, where we have to write and wait
for the defrag range.
This is to avoid clearing inode->defrag_compress before the compression
starts.

Finally this new experimental feature is not yet compatible with zoned,
so for zoned btrfs it will go through the old compression path.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/defrag.c    | 27 ++++++++++++++---
 fs/btrfs/extent_io.c |  5 +++-
 fs/btrfs/inode.c     | 71 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 6ec5dd760d42..2ee447b3cfe3 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1349,6 +1349,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long sectors_defragged = 0;
 	u64 isize = i_size_read(&inode->vfs_inode);
+	const u64 start = round_down(range->start, fs_info->sectorsize);
 	u64 cur;
 	u64 last_byte;
 	bool do_compress = (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS);
@@ -1400,7 +1401,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 	}
 
 	/* Align the range */
-	cur = round_down(range->start, fs_info->sectorsize);
+	cur = start;
 	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
 
 	/*
@@ -1471,10 +1472,28 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 		 * need to be written back immediately.
 		 */
 		if (range->flags & BTRFS_DEFRAG_RANGE_START_IO) {
-			filemap_flush(inode->vfs_inode.i_mapping);
-			if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-				     &inode->runtime_flags))
+			/*
+			 * For experimental delayed writeback, we must wait
+			 * for the range to be fully written back before
+			 * clearing inode->defrag_compress.
+			 *
+			 * Regular filemap_flush() will only start writeback,
+			 * which will only create delayed OEs. But the real
+			 * compression is happening later.
+			 * This means if we just flush but not wait for writeback,
+			 * the inode->defrag_compress clearing can race with
+			 * compression, so the requested compression algorithm
+			 * is not applied.
+			 */
+			if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL) && !btrfs_is_zoned(fs_info)) {
+				filemap_write_and_wait_range(inode->vfs_inode.i_mapping,
+							     start, last_byte);
+			} else {
 				filemap_flush(inode->vfs_inode.i_mapping);
+				if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+					     &inode->runtime_flags))
+					filemap_flush(inode->vfs_inode.i_mapping);
+			}
 		}
 		if (range->compress_type == BTRFS_COMPRESS_LZO)
 			btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a822f6635eba..970548df2dbc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -899,8 +899,11 @@ static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
 	 * If we have accumulated decent amount of IO, send it to the block
 	 * layer so that IO can run while we are accumulating more folios to
 	 * write.
+	 *
+	 * This doesn't apply to delayed bbio which is going to be
+	 * compressed.
 	 */
-	else if (bio_ctrl->wbc &&
+	else if (bio_ctrl->wbc && !bio_ctrl->bbio->is_delayed &&
 		 bio_ctrl->bbio->bio.bi_iter.bi_size >= fs_info->writeback_bio_size)
 		submit_one_bio(bio_ctrl);
 	return 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fcf67a2e118d..b3e4c6426609 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1659,6 +1659,68 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
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
+	btrfs_lock_extent(&inode->io_tree, start, end, &cached);
+	while (cur < end) {
+		struct extent_map *em;
+		struct btrfs_ordered_extent *oe;
+		u32 cur_len = min_t(u64, end + 1 - cur, BTRFS_MAX_COMPRESSED);
+
+		em = btrfs_create_delayed_em(inode, cur, cur_len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto error;
+		}
+		btrfs_free_extent_map(em);
+		oe = btrfs_alloc_delayed_ordered_extent(inode, cur, cur_len);
+		if (IS_ERR(oe)) {
+			btrfs_drop_extent_map_range(inode, cur, cur + cur_len - 1, false);
+			ret = PTR_ERR(oe);
+			goto error;
+		}
+		btrfs_put_ordered_extent(oe);
+
+		cur += cur_len;
+	}
+	/*
+	 * Force the next fsync to wait for any delayed OE to finish,
+	 * as the fast path cannot handle delayed OE correctly.
+	 */
+	btrfs_set_inode_full_sync(inode);
+	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
+				     EXTENT_LOCKED | EXTENT_DELALLOC,
+				     PAGE_UNLOCK);
+	return 0;
+error:
+	if (start < cur) {
+		btrfs_drop_extent_map_range(inode, start, cur - 1, false);
+		btrfs_cleanup_ordered_extents(inode, start, cur - start);
+		extent_clear_unlock_delalloc(inode, start, cur - 1, locked_folio, &cached,
+			EXTENT_LOCKED | EXTENT_DELALLOC,
+			PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK);
+	}
+	if (cur < end) {
+		extent_clear_unlock_delalloc(inode, cur, end, locked_folio, &cached,
+			EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+			PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK);
+		btrfs_qgroup_free_data(inode, NULL, cur, end + 1 - cur, NULL);
+	}
+	return ret;
+}
+
 /*
  * Run the delalloc range from start to end, and write back any dirty pages
  * covered by the range.
@@ -2454,9 +2516,12 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
 		return run_delalloc_nocow(inode, locked_folio, start, end);
 
 	if (btrfs_inode_can_compress(inode) &&
-	    inode_need_compress(inode, start, end, false) &&
-	    run_delalloc_compressed(inode, locked_folio, start, end, wbc))
-		return 1;
+	    inode_need_compress(inode, start, end, false)) {
+		if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL) && !zoned)
+			return run_delalloc_delayed(inode, locked_folio, start, end);
+		else if (run_delalloc_compressed(inode, locked_folio, start, end, wbc))
+			return 1;
+	}
 
 	if (zoned)
 		return run_delalloc_cow(inode, locked_folio, start, end, wbc, true);
-- 
2.55.0

