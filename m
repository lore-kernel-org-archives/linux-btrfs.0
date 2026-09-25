Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A1715746F
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790306197; cv=none; b=XSZXM5YeWTBpmhJWokXfCgfgwXVW0zsZcnpZMNlcMVRpf1CMkj5jJ+KbmxgtCwKzFtwAcMpenhM7TaEXHv1mREPJquVmOiSy6gamd3x5yT4ISsqFeD7dAdlfx1T/5ChXLJccnyN6GdAczjCpi1tfvDnvlUyuhkzuNvDbh3gEhQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790306197; c=relaxed/simple;
	bh=Vo9rNUdbVzEGm/JsVFWjYwPN07BiryU/ZgKQY3eiKpY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeOYGY5ze8ZQTihOxZJ7u3cW1zcp1MUDWD1FpffkCpblX5SMREUDpWIp8OoyPejpFtTEqMMIebf/ebMlNPZRlVqvZzc7gbFefqq3JkxkAjz5ai9I7nVaykoY+VxpwV7NLDj8QHb2sf9kN3u58njTC3j36oNIU2ojpcFFGmDdjDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=APjIRvNd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ee1NZBE1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="APjIRvNd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ee1NZBE1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CA0221C72
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tQ235mVGN9KCXajfjjnKnfiYOZgH2ms6MpqxRgO9F3c=;
	b=APjIRvNdxsjTkSUNkRwmfBvq3tb3we1ZEM+PQ9Ti5KdnZFVX1Ei/J+7XQtazvXl6+caBZj
	utAmXSOU3KX8JszRuMWWvG0GHuk6EtNmkxlsyyenDJ+WBnpkjL/7WSbxIH5FUoj8kQIvEF
	fhM2MrEu2UkuT9mt0/2DHYvJ3mp9ERo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ee1NZBE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tQ235mVGN9KCXajfjjnKnfiYOZgH2ms6MpqxRgO9F3c=;
	b=ee1NZBE1AvRcuCsHqY4a73m855FLozHeNFF2WYt4quU4EuovnMr5+w8PYQKur+ScOZwDT4
	Qg6N/smJrbS5SNFMcxtgPA6XaVtp5qEH9Rns0tDMEh8kjYOhHcZrqlqQ1FVzyYyiCiT1EN
	ypL9ShbtwR5BOPeux1zHMX6KYL+qxfw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C19013939
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fd3cN4HntWpbDQAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 4/6] btrfs: introduce compression for delayed bbio
Date: Fri, 25 Sep 2026 12:45:53 +0930
Message-ID: <c34ab9a02689c3e7a9a6d0501ea7d5877e98a9c6.1790306139.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790306139.git.wqu@suse.com>
References: <cover.1790306139.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4CA0221C72
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The compressed write path inside a delayed bbio is mostly the same as
regular compression, but with some differences:

- The error handling should not touch folio flags
  It will be handled by the parent delayed bbio.
  And those folios already have WRITEBACK flag set, not the LOCKED flag
  of the async submission path.

- The error handling should only be called once
  If we hit a critical error, e.g. unable to create an OE, the range
  will be cleaned up by try_submit_compressed(), thus the parent OE
  should not clean up that range again.

- A successful compression will lead to a child compressed bio
  That compressed bio will be properly submitted, and if there are no
  more pending IOs of the delayed bbio, end the delayed bbio.

  There is a minor note, since we're going through the regular
  extent_writepage_io() path, we can have multiple bbios for the same
  delayed ordered extent.

  This means we may have a slightly lower compression ratio if for
  whatever reason the writeback path chooses to submit a smaller bio.

- No sequential execution of data extent reservation
  The existing async thread has one quirk related to the ordered
  function execution, which is not suitable for this call site.

  After the compressed bio is submitted, we can no longer touch the
  child compressed bio (it could finish immediately and also finish the
  parent delayed bbio).
  Meanwhile the async ordered function needs different entries to handle
  the workload and free involved structures.

  These will be the major changes compared to the existing compressed
  write.

- No extra blkcg/write flag inheritance
  This is a missing feature compared to the older async compression.
  This needs to be implemented in the future, but priority shouldn't be
  that high.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0de121f50562..d301d05f3da1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7714,23 +7714,164 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
 	return em;
 }
 
+static void end_bbio_delayed_compressed(struct btrfs_bio *bbio)
+{
+	struct delayed_bio_private *dbp = bbio->private;
+	struct btrfs_bio *parent = dbp->delayed_bbio;
+	struct folio_iter fi;
+
+	bio_for_each_folio_all(fi, &bbio->bio)
+		btrfs_free_compr_folio(fi.folio);
+	btrfs_bio_end_io(parent, bbio->bio.bi_status);
+	bio_put(&bbio->bio);
+}
+
+/*
+ * If we failed to allocate a child OE for a range, that range will be cleaned
+ * up by the caller, and the parent OE should not clean it up again.
+ * So here we need to clear the bits in the parent OE.
+ */
+static void clear_cleanup_bitmap(struct btrfs_ordered_extent *parent,
+				 u64 file_offset, u32 len)
+{
+	const u32 sectorbits = parent->inode->root->fs_info->sectorsize_bits;
+
+	bitmap_clear(parent->child_cleanup_bitmap,
+		     (file_offset - parent->file_offset) >> sectorbits,
+		     len >> sectorbits);
+}
+
+/*
+ * Return 0 if a compressed write is submitted.
+ * Return >0 if a compressed write is not submitted and we need to fall back to
+ * uncompressed write.
+ * Return <0 if we hit a critical error, and the reserved space is already cleaned
+ * up.
+ */
+static int try_submit_compressed(struct btrfs_bio *parent)
+{
+	struct delayed_bio_private *dbp = parent->private;
+	struct btrfs_inode *inode = parent->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_key ins;
+	struct compressed_bio *cb;
+	struct extent_state *cached = NULL;
+	struct extent_map *em;
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_file_extent file_extent;
+	u64 alloc_hint;
+	const u32 len = bio_get_size(&parent->bio);
+	const u64 fileoff = parent->file_offset;
+	const u64 end = fileoff + len - 1;
+	u32 compressed_size;
+	int compress_type = fs_info->compress_type;
+	int compress_level = fs_info->compress_level;
+	int ret;
+
+	if (!btrfs_inode_can_compress(inode) ||
+	    !inode_need_compress(inode, fileoff, end, false))
+		return 1;
+
+	if (inode->defrag_compress > 0 &&
+	    inode->defrag_compress < BTRFS_NR_COMPRESS_TYPES) {
+		compress_type = inode->defrag_compress;
+		compress_level = inode->defrag_compress_level;
+	} else if (inode->prop_compress) {
+		compress_type = inode->prop_compress;
+	}
+	cb = btrfs_compress_bio(inode, fileoff, len, compress_type,
+				compress_level, 0);
+	if (IS_ERR(cb))
+		return 1;
+
+	round_up_last_block(cb, fs_info->sectorsize);
+	compressed_size = cb->bbio.bio.bi_iter.bi_size;
+	/* If no space is saved, abort and mark the inode NOCOMPRESS. */
+	if (compressed_size >= len) {
+		if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) &&
+		    !inode->prop_compress)
+			inode->flags |= BTRFS_INODE_NOCOMPRESS;
+		cleanup_compressed_bio(cb);
+		return 1;
+	}
+
+	alloc_hint = btrfs_get_extent_allocation_hint(inode, fileoff, len);
+	ret = btrfs_reserve_extent(inode->root, len,
+				   compressed_size, compressed_size,
+				   0, alloc_hint, &ins, true, true);
+	if (ret < 0) {
+		cleanup_compressed_bio(cb);
+		return 1;
+	}
+	btrfs_lock_extent(&inode->io_tree, fileoff, end, &cached);
+	file_extent.disk_bytenr = ins.objectid;
+	file_extent.disk_num_bytes = ins.offset;
+	file_extent.ram_bytes = len;
+	file_extent.num_bytes = len;
+	file_extent.offset = 0;
+	file_extent.compression = cb->compress_type;
+
+	cb->bbio.bio.bi_iter.bi_sector = ins.objectid >> SECTOR_SHIFT;
+	em = btrfs_create_io_em(inode, fileoff, &file_extent, BTRFS_ORDERED_COMPRESSED);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto out_free_reserve;
+	}
+	btrfs_free_extent_map(em);
+
+	ordered = btrfs_alloc_ordered_extent(inode, fileoff, &file_extent,
+					     1U << BTRFS_ORDERED_COMPRESSED);
+	if (IS_ERR(ordered)) {
+		btrfs_drop_extent_map_range(inode, fileoff, end, false);
+		ret = PTR_ERR(ordered);
+		goto out_free_reserve;
+	}
+	cb->bbio.ordered = ordered;
+	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
+
+	cb->bbio.end_io = end_bbio_delayed_compressed;
+	cb->bbio.private = dbp;
+	atomic_inc(&parent->pending_ios);
+	btrfs_submit_bbio(&cb->bbio, 0);
+	return 0;
+
+out_free_reserve:
+	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+	btrfs_delalloc_release_metadata(inode, len, true);
+	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
+	cleanup_compressed_bio(cb);
+	/* parent bbio should have OE populated. */
+	ASSERT(parent->ordered);
+	clear_cleanup_bitmap(parent->ordered, parent->file_offset, len);
+	ASSERT(ret < 0);
+	return ret;
+}
+
 static void run_delayed_bbio(struct work_struct *work)
 {
 	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
 	struct btrfs_bio *parent = dbp->delayed_bbio;
+	int ret;
 
 	/* Parent OE must be set. */
 	ASSERT(parent->ordered && test_bit(BTRFS_ORDERED_DELAYED, &parent->ordered->flags));
 
-	/* Compressed and uncompressed fallback is not yet implemented. */
+	ret = try_submit_compressed(parent);
+	if (ret <= 0)
+		goto finish;
+
+	/* Uncompressed fallback is not yet implemented. */
 	ASSERT(0);
 
+finish:
 	/*
 	 * Any real compressed/uncompressed bios have increased
 	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
 	 * will execute the real endio function.
 	 */
-	btrfs_bio_end_io(parent, BLK_STS_OK);
+	btrfs_bio_end_io(parent, errno_to_blk_status(ret));
 }
 
 static void end_bbio_delayed(struct btrfs_bio *bbio)
-- 
2.55.0

