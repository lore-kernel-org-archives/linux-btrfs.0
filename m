Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E1330337
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131796; cv=none; b=WXBLufItYqGpf4bxRkasbDopHhpeNa2NaDZBpt43ZX6C9gJHRJew8i/e/svq2VCixG/7bk1TeBbnueZ50Ey46mXDUu4hjp8mUhascv9KILLfE1iwRy/rgCTxRH1KZkh14T67kaGMkybNDGPmjvHFMurI8nv0MrsrLNdNS46s8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131796; c=relaxed/simple;
	bh=may7vcPjWvPsy10tYt3wOAd7o7PPUioGojFM3WRH2IU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwCcd2/FNiYaiE+yaOv9nUvMBJ2ocutKNs7XN0Dy++x0rO1Nq7TipCEUADzZf/wTjQyQ+Prb+1a0IhfJg3ThxwzAUc8Ky0jlxMrcVsavV6Kx371fwbDDsr6NIsvLa6M9HbV9B4k9HLUyR3TRoUVDRZiAIfgDqRBaO3/pGxCBpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=i5kMSjnA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AchpZAD9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="i5kMSjnA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AchpZAD9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE62D5D22F
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSg68LMkhVC5Jw6zBPs7JFjA/lCMTDcIadFyMhiV+f0=;
	b=i5kMSjnAT4acuM4jZLj3Zv2E9BVn6zG9v8plwmEPDixjMdkQboL2LgCIUPQ2DTvLtFskoh
	ezzYLuSjiZFVZMHHqV1odyCg62Hw3b5+U0RFplX0u5y9sPXgi8AgvcBMsB3FuSdk8/TXA5
	ffvmZJyzxllywXkjwjg0HOVHOKfWlDc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=AchpZAD9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSg68LMkhVC5Jw6zBPs7JFjA/lCMTDcIadFyMhiV+f0=;
	b=AchpZAD9P5kOEwNYgqxvqatXIi37+y+J/a4hepZNBNqUjMWe6At6ZIDrS8d+46UfR7UovU
	IQAOsPNW4s+3rN3ixKSICAXm9Ut5WOBqzr94a9EVnoS0pZzDrvwAvP9k7ssanUXMwTt+rS
	GFyFIUpISHMyYT5YO/EpJ6P18ohMybc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1104D593A7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IPvMMEQj/GmvEgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2026 05:29:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs: detect dirty blocks without an ordered extent more reliably
Date: Thu,  7 May 2026 14:59:17 +0930
Message-ID: <e52caa0b55dade2020a615eabc3d8aea9fcb55fa.1778131118.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778131118.git.wqu@suse.com>
References: <cover.1778131118.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CE62D5D22F
X-Spam-Level: 

Currently btrfs detects dirty folio which doesn't have an ordered extent
at extent_writepage_io(), but that is not ideal:

- The check is not handling all dirty blocks
  We can have multiple blocks inside a large folio, but the whole folio
  is marked ordered as long as there is one ordered extent in the range.

  We can still hit cases where some dirty blocks do not have
  corresponding ordered extents.

Instead of checking the folio ordered flags, do the check at
alloc_new_bio(), where we're already searching for ordered extents for
writebacks.

If we didn't find an ordered extent, we should already give an error
message and notify the caller there is something wrong.

This allows us to check every block that goes through
submit_extent_folio().

With this new and more reliable check, we can remove the old check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 85 ++++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ebf9a63946e5..3550ae40255c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -730,9 +730,9 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 		bio_end_sector(bio) == sector;
 }
 
-static void alloc_new_bio(struct btrfs_inode *inode,
-			  struct btrfs_bio_ctrl *bio_ctrl,
-			  u64 disk_bytenr, u64 file_offset)
+static int alloc_new_bio(struct btrfs_inode *inode,
+			 struct btrfs_bio_ctrl *bio_ctrl,
+			 u64 disk_bytenr, u64 file_offset)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_bio *bbio;
@@ -749,13 +749,25 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 	if (bio_ctrl->wbc) {
 		struct btrfs_ordered_extent *ordered;
 
+		/* This must be a write for data inodes. */
+		ASSERT(btrfs_op(&bio_ctrl->bbio->bio) == BTRFS_MAP_WRITE);
+		ASSERT(is_data_inode(inode));
+
 		ordered = btrfs_lookup_ordered_extent(inode, file_offset);
-		if (ordered) {
-			bio_ctrl->len_to_oe_boundary = min_t(u32, U32_MAX,
-					ordered->file_offset +
-					ordered->disk_num_bytes - file_offset);
-			bbio->ordered = ordered;
+		if (unlikely(!ordered)) {
+			bio_ctrl->bbio = NULL;
+			bio_ctrl->next_file_offset = 0;
+			bio_put(&bbio->bio);
+			btrfs_err_rl(fs_info,
+	"root %lld ino %llu file offset %llu is marked dirty without notifying the fs",
+				     btrfs_root_id(inode->root), btrfs_ino(inode),
+				     file_offset);
+			return -EUCLEAN;
 		}
+		bio_ctrl->len_to_oe_boundary = min_t(u32, U32_MAX,
+				ordered->file_offset +
+				ordered->disk_num_bytes - file_offset);
+		bbio->ordered = ordered;
 
 		/*
 		 * Pick the last added device to support cgroup writeback.  For
@@ -766,6 +778,7 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 		bio_set_dev(&bbio->bio, fs_info->fs_devices->latest_dev->bdev);
 		wbc_init_bio(bio_ctrl->wbc, &bbio->bio);
 	}
+	return 0;
 }
 
 /*
@@ -781,14 +794,19 @@ static void alloc_new_bio(struct btrfs_inode *inode,
  * new one in @bio_ctrl->bbio.
  * The mirror number for this IO should already be initialized in
  * @bio_ctrl->mirror_num.
+ *
+ * Return the number of bytes that are queued into a bio.
+ * If the returned bytes is smaller than @size, it means we hit a critical error
+ * for data write, where there is no ordered extent for the range.
  */
-static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
-			       u64 disk_bytenr, struct folio *folio,
-			       size_t size, unsigned long pg_offset,
-			       u64 read_em_generation)
+static unsigned int submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
+					u64 disk_bytenr, struct folio *folio,
+					size_t size, unsigned long pg_offset,
+					u64 read_em_generation)
 {
 	struct btrfs_inode *inode = folio_to_inode(folio);
 	loff_t file_offset = folio_pos(folio) + pg_offset;
+	unsigned int queued = 0;
 
 	ASSERT(pg_offset + size <= folio_size(folio));
 	ASSERT(bio_ctrl->end_io_func);
@@ -801,8 +819,13 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 		u32 len = size;
 
 		/* Allocate new bio if needed */
-		if (!bio_ctrl->bbio)
-			alloc_new_bio(inode, bio_ctrl, disk_bytenr, file_offset);
+		if (!bio_ctrl->bbio) {
+			int ret;
+
+			ret = alloc_new_bio(inode, bio_ctrl, disk_bytenr, file_offset);
+			if (ret < 0)
+				break;
+		}
 
 		/* Cap to the current ordered extent boundary if there is one. */
 		if (len > bio_ctrl->len_to_oe_boundary) {
@@ -830,6 +853,7 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 		pg_offset += len;
 		disk_bytenr += len;
 		file_offset += len;
+		queued += len;
 
 		/*
 		 * len_to_oe_boundary defaults to U32_MAX, which isn't folio or
@@ -869,6 +893,7 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 			submit_one_bio(bio_ctrl);
 
 	} while (size);
+	return queued;
 }
 
 static int attach_extent_buffer_folio(struct extent_buffer *eb,
@@ -1041,6 +1066,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		u64 disk_bytenr;
 		u64 block_start;
 		u64 em_gen;
+		unsigned int queued;
 
 		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
 		if (cur >= last_byte) {
@@ -1154,8 +1180,10 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 
 		if (force_bio_submit)
 			submit_one_bio(bio_ctrl);
-		submit_extent_folio(bio_ctrl, disk_bytenr, folio, blocksize,
-				    pg_offset, em_gen);
+		queued = submit_extent_folio(bio_ctrl, disk_bytenr, folio, blocksize,
+					     pg_offset, em_gen);
+		/* Read submission should not fail. */
+		ASSERT(queued == blocksize);
 	}
 	return 0;
 }
@@ -1643,6 +1671,7 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	u64 extent_offset;
 	u64 em_end;
 	const u32 sectorsize = fs_info->sectorsize;
+	unsigned int queued;
 
 	ASSERT(IS_ALIGNED(filepos, sectorsize));
 
@@ -1709,8 +1738,15 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	 */
 	ASSERT(folio_test_writeback(folio));
 
-	submit_extent_folio(bio_ctrl, disk_bytenr, folio,
-			    sectorsize, filepos - folio_pos(folio), 0);
+	queued = submit_extent_folio(bio_ctrl, disk_bytenr, folio,
+				     sectorsize, filepos - folio_pos(folio), 0);
+	if (unlikely(queued < sectorsize)) {
+		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_clear_ordered(fs_info, folio, filepos, sectorsize);
+		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
+					       false);
+		return -EUCLEAN;
+	}
 	return 0;
 }
 
@@ -1743,19 +1779,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
 	       start, len, folio_start, folio_size(folio));
 
-	if (unlikely(!folio_test_ordered(folio))) {
-		DEBUG_WARN();
-		btrfs_err_rl(fs_info,
-	"root %lld ino %llu folio %llu is marked dirty without notifying the fs",
-			     btrfs_root_id(inode->root),
-			     btrfs_ino(inode),
-			     folio_pos(folio));
-		btrfs_folio_clear_dirty(fs_info, folio, start, len);
-		btrfs_folio_set_writeback(fs_info, folio, start, len);
-		btrfs_folio_clear_writeback(fs_info, folio, start, len);
-		return -EUCLEAN;
-	}
-
 	/* Truncate the submit bitmap to the current range. */
 	if (start > folio_start)
 		bitmap_clear(bio_ctrl->submit_bitmap, 0,
-- 
2.54.0

