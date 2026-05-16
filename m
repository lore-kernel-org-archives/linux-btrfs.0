Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302282236EE
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778903170; cv=none; b=TF3yTaBsEHkJGPWzQElTmrbZBF/axUaYb8fp9x3ya0u+2L0gDp7bP3AMGGCri9SLUC6yKh0lwCNTLH1/GngAeUg/IrUnzWWV/voY/g6ypACeBjAHIlnk22DhBY7KEe6rDEJavfiEmFOdVIe5JbQGCokxUz3tLVl3V4AtxyGAOrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778903170; c=relaxed/simple;
	bh=WU3LapPIA5Uynk8ue7rL4tVRi7AZ9gL4rdxt1O+6cMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyksi915mZHxSk2LooRK0leNoPUA0QwAoBUjUqpjld+lwJUQL8/km4G/7ULWVceHb88ODNYbx5BlBqXllgGgPwgY6MuLJgBRoTinuQ/GQc1soWGw/NtLrrz3WAFSNorxWwkxUa6zcUfmtXuWJtT4L1TEzwc6oQV+3w4JQkALbVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PGM/DBNG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PGM/DBNG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PGM/DBNG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PGM/DBNG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8CF85F3A0
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xB3inYTe7NVkEnamN603aq422yYa6fh0jzVQNxA0e4E=;
	b=PGM/DBNGw8TK1rTNt54MuseqWLTVU3fX+1aiVYw1nAoeR+zImMMs87kFrIjHFbYdQdzC2J
	pWQ4bzBc+u+Wm/x1hu6kg4NkSR3tiE2Q1ghRiXVej+d7lYzrOVQu3DUna0P6c7JTxsXIDG
	JFc9FR8PBtlBdzhPfHhdhFIs9x8badk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xB3inYTe7NVkEnamN603aq422yYa6fh0jzVQNxA0e4E=;
	b=PGM/DBNGw8TK1rTNt54MuseqWLTVU3fX+1aiVYw1nAoeR+zImMMs87kFrIjHFbYdQdzC2J
	pWQ4bzBc+u+Wm/x1hu6kg4NkSR3tiE2Q1ghRiXVej+d7lYzrOVQu3DUna0P6c7JTxsXIDG
	JFc9FR8PBtlBdzhPfHhdhFIs9x8badk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E80F8593A8
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aG5KKmjoB2qdMQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/6] btrfs: enable experimental delayed compression support
Date: Sat, 16 May 2026 13:15:19 +0930
Message-ID: <1e72627dfa498d4437323abd820868c8e3b3dbf5.1778902678.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778902677.git.wqu@suse.com>
References: <cover.1778902677.git.wqu@suse.com>
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

Instead of the existing async submission path, the new delayed bbio will
handle compressed writes by:

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

  This is also why we need complex per-block tracking for writeback
  flags, while iomap only requires a counter tracking.

  With the new delayed compression, the lifespan of a folio aligns with
  DONTCACHE and iomap.

There is an extra handling for defrag, where we have to write and wait
for the defrag range.
This is to avoid clearing inode->defrag_compress before the delayed
compression started.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/defrag.c    | 26 ++++++++++++++++---
 fs/btrfs/extent_io.c |  5 +++-
 fs/btrfs/inode.c     | 61 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index f0c6758b7055..092693cbb79e 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1342,6 +1342,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long sectors_defragged = 0;
 	u64 isize = i_size_read(&inode->vfs_inode);
+	const u64 start = round_down(range->start, fs_info->sectorsize);
 	u64 cur;
 	u64 last_byte;
 	bool do_compress = (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS);
@@ -1393,7 +1394,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 	}
 
 	/* Align the range */
-	cur = round_down(range->start, fs_info->sectorsize);
+	cur = start;
 	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
 
 	/*
@@ -1464,10 +1465,27 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
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
+			 * compression, causing the defrag algorithm not reflected.
+			 */
+			if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL)) {
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
index 7adf8e80ba36..6ec7682df565 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -899,8 +899,11 @@ static unsigned int submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 		 * If we have accumulated decent amount of IO, send it to the
 		 * block layer so that IO can run while we are accumulating
 		 * more folios to write.
+		 *
+		 * This doesn't apply to delayed bbio which is going to be
+		 * compressed.
 		 */
-		else if (bio_ctrl->wbc &&
+		else if (bio_ctrl->wbc && !bio_ctrl->bbio->is_delayed &&
 			 bio_ctrl->bbio->bio.bi_iter.bi_size >=
 			    inode->root->fs_info->writeback_bio_size)
 			submit_one_bio(bio_ctrl);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 75376c2ef665..4acf710f7e0a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1654,6 +1654,58 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
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
+			ret = PTR_ERR(oe);
+			goto error;
+		}
+		btrfs_put_ordered_extent(oe);
+
+		cur += cur_len;
+	}
+	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
+				     EXTENT_LOCKED | EXTENT_DELALLOC,
+				     PAGE_UNLOCK);
+	return 0;
+error:
+	if (start < cur) {
+		btrfs_drop_extent_map_range(inode, start, cur - 1, false);
+		btrfs_cleanup_ordered_extents(inode, start, cur - start);
+	}
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
@@ -2427,9 +2479,12 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
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
2.54.0

