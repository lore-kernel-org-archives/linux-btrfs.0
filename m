Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0623D523F
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954320; cv=none; b=cLWlnV7igK0OSCd9XJTYSn6uxrS0BkJvzw4E1oC5BkCXLKtUuKK+hHj+Rh5b93ngb1dMXAQTdj/tu0Ou+ZtF0bpN72n5n6LFbJVFnQXaDHPiow34YVBNm+VIg/IEZq8MTno/Tgv414pK+q1yPo2SmtA7xDz+Och1vH31gvtRz/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954320; c=relaxed/simple;
	bh=+OtrkuYMh1gWtXtVzJdLj0zTzz6bc83eCV3NsU5p/Vc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8CbeidRIrUjjjm4tG8RFT8NGiFDU7cUH1eKh0Bzc0tsESAx6VM/4TAz13iPvsqlPKVTVgkmqa7ropfpIjGaBXayDSShjEdYJtkQcv0WbBgPoocAvM2xozHI0yaDRlDbSeCrhFUmgkqykJuwOKFfm6TDh61LfbUG3NkWmuoE4gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WRonTnWs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WRonTnWs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WRonTnWs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WRonTnWs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 321DA4D414
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4o15cfGSoDRI0AIKqQFkZKI8Jc8/xVRVYotoe8cGg50=;
	b=WRonTnWsOzJmnEtL8KiFbTiwwQ0IRmDXwyiQCXatKHkKMt8BUJ1nWIxR7z5t7V6v6vMj34
	ScXrqJ/olBO5tOGTWJ1CXLS4WBe7WEMbl8Qt/wUL8PwtYmREnNbeNER/fXhNwYOUiT7U/Z
	OS10iW0luioTwq94YhY1amh73nFNJOY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4o15cfGSoDRI0AIKqQFkZKI8Jc8/xVRVYotoe8cGg50=;
	b=WRonTnWsOzJmnEtL8KiFbTiwwQ0IRmDXwyiQCXatKHkKMt8BUJ1nWIxR7z5t7V6v6vMj34
	ScXrqJ/olBO5tOGTWJ1CXLS4WBe7WEMbl8Qt/wUL8PwtYmREnNbeNER/fXhNwYOUiT7U/Z
	OS10iW0luioTwq94YhY1amh73nFNJOY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32E074273B
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KD2ONAplvGk5FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: introduce compression for delayed bbio
Date: Fri, 20 Mar 2026 07:34:48 +1030
Message-ID: <1580b78e10ec13364e8dd8f50a8ced765b7ff3b3.1773953307.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773953307.git.wqu@suse.com>
References: <cover.1773953307.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The compressed write path inside a delayed bbio is mostly the same as
regular compression, but with some differences:

- The error handling should not touch folio flags
  It will be handled by the parent delayed bbio.
  And those folios already have WRITEBACK flag set, not the LOCKED flag
  of the async submission path.

- A successful compression will lead to a child compressed bio
  That compressed bio will be properly submitted, and if there is no
  more pending ios of the delayed bbio, end the delayed bbio.

  There is minor note, since we're going through the regular
  extent_writepage_io() path, we can have multiple bbios for the same
  delayed ordered extent.

  This means we may have a slightly lower compression ratio if by
  whatever reason the write back path choose to skip the bio.

- No sequential execution of data extent reservation
  The existing async thread has one quirk related to the ordered
  function execution, which is not suitable for this call site.

  After the compressed bio is submitted, we can no longer touch the
  child compressed bio (it can finished immediately and also finish the
  parent delayed bbio).
  Meanwhile the async ordered function needs different entries to handle
  the workload and free involved structures.

  This will be the major changes compared to the existing compressed
  write.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03018cc3bd25..ef1f5efb68ca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7663,6 +7663,111 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
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
+	bio_put(&bbio->bio);
+
+	cmpxchg(&parent->status, BLK_STS_OK, bbio->status);
+	if (atomic_dec_and_test(&dbp->pending_ios))
+		btrfs_bio_end_io(parent, parent->status);
+}
+
+static bool try_submit_compressed(struct btrfs_bio *parent)
+{
+	struct delayed_bio_private *dbp = parent->private;
+	struct btrfs_bio *bbio = dbp->delayed_bbio;
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_key ins;
+	struct compressed_bio *cb;
+	struct extent_state *cached = NULL;
+	struct extent_map *em;
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_file_extent file_extent;
+	u64 alloc_hint;
+	const u32 len = bio_get_size(&bbio->bio);
+	const u64 fileoff = bbio->file_offset;
+	const u64 end = fileoff + len - 1;
+	u32 compressed_size;
+	int compress_type = fs_info->compress_type;
+	int compress_level = fs_info->compress_level;
+	int ret;
+
+	if (!btrfs_inode_can_compress(inode) ||
+	    !inode_need_compress(inode, fileoff, end, false))
+		return false;
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
+		return false;
+
+	round_up_last_block(cb, fs_info->sectorsize);
+	compressed_size = cb->bbio.bio.bi_iter.bi_size;
+
+	alloc_hint = btrfs_get_extent_allocation_hint(inode, fileoff, len);
+	ret = btrfs_reserve_extent(inode->root, len,
+				   compressed_size, compressed_size,
+				   0, alloc_hint, &ins, true, true);
+	if (ret < 0) {
+		cleanup_compressed_bio(cb);
+		return false;
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
+	atomic_inc(&dbp->pending_ios);
+	btrfs_submit_bbio(&cb->bbio, 0);
+	return true;
+
+out_free_reserve:
+	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+	mapping_set_error(inode->vfs_inode.i_mapping, -EIO);
+	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
+	cleanup_compressed_bio(cb);
+	return false;
+}
+
 static void run_delayed_bbio(struct work_struct *work)
 {
 	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
@@ -7673,8 +7778,13 @@ static void run_delayed_bbio(struct work_struct *work)
 	 * until all child ones are submitted.
 	 */
 	atomic_inc(&dbp->pending_ios);
-	/* Compressed and uncompressed fallback is not yet implemented. */
+	if (try_submit_compressed(parent))
+		goto finish;
+
+	/* Uncompressed fallback is not yet implemented. */
 	ASSERT(0);
+
+finish:
 	if (atomic_dec_and_test(&dbp->pending_ios))
 		btrfs_bio_end_io(parent, parent->status);
 }
-- 
2.53.0

