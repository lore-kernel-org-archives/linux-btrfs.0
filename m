Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40842931EF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692283; cv=none; b=YlFtDxoM/396QeWXMmATLW1GZaQjw+BUMa+5LCMPpR5Zf1nRX7apdF7OdKNP/R7gTOmBY3TaPxybMFMsoxMYm6WqV5pUOJI2Ki+2QKNXxS9cTeHCvhpa/ieGwbACJvR2otLcaXr7WfPHHH15LNCVuQdGULUfbzVQFFwmcu9By2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692283; c=relaxed/simple;
	bh=B3XZjF1e/h3aNvtVD7IVRlCkCcdFQqpJvlrrTaViOZU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTBWO0wAGbe03yAnI3RXiT9KZVz+tJJW2tftcsy7IUQ5ZlknZrRWk0gLtgMnQIr3bUNV+LHDl6ZxFP56YfibbbgSlLxraD2Qjv3eqmJ7V6n9WiiCuF1w8VDlst2eCqFOZc24lrdaVuE9yDhf3f2uibAaFU391orZElEiFYbiPB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PWulBJJA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CUmc0oeK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PWulBJJA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CUmc0oeK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5521D21C13
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789692275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyECQAWHgdwYKH7As/ZVpD8OG/8Ok4thxnLb2DeseHA=;
	b=PWulBJJA0yVMomap6AGpMAK01D0imFQujohXULuZdcZBScZGqGZhrXh64GM8gM+TaTKLoC
	6fIEj7cdTW3l/UYRuSgpzJXEQ2bMHrSmCw32UpMUOh70ntGvM22/bGOq2TwxhMF762vHgb
	U48jpHW7mnU4ybXuLVBdIzwh6NCIQt4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CUmc0oeK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789692271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyECQAWHgdwYKH7As/ZVpD8OG/8Ok4thxnLb2DeseHA=;
	b=CUmc0oeKAnqxh1JA7bwEkOPJwRuVLjNbEkeQQtrof1Gh6CxoW+kbYB+5jAY3Tzjo9qCtT8
	ZsaID/TZ4rqnWGW+OU6eOslEa9+B4k85ax9So/gzSkV+Y3p5uxwmpCREykarSXPe/Hw7Kz
	1K8PBvIIgRRpsF2/xpoAtJ7/8CjQQ5c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A69D13927
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Z0mA2eJrGovEwAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 RESEND 4/6] btrfs: introduce compression for delayed bbio
Date: Fri, 18 Sep 2026 10:14:03 +0930
Message-ID: <67f3d7f43f5644e26cc8723aa8be37714877cd1a.1789692182.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789692182.git.wqu@suse.com>
References: <cover.1789692182.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 5521D21C13
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

The compressed write path inside a delayed bbio is mostly the same as
regular compression, but with some differences:

- The error handling should not touch folio flags
  It will be handled by the parent delayed bbio.
  And those folios already have WRITEBACK flag set, not the LOCKED flag
  of the async submission path.

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
 fs/btrfs/inode.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9568118e65b4..eff06a5193b3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7712,14 +7712,126 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
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
+static bool try_submit_compressed(struct btrfs_bio *parent)
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
+	/* If no space is saved, abort and mark the inode NOCOMPRESS. */
+	if (compressed_size >= len) {
+		if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) &&
+		    !inode->prop_compress)
+			inode->flags |= BTRFS_INODE_NOCOMPRESS;
+		cleanup_compressed_bio(cb);
+		return false;
+	}
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
+	atomic_inc(&parent->pending_ios);
+	btrfs_submit_bbio(&cb->bbio, 0);
+	return true;
+
+out_free_reserve:
+	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
+	cleanup_compressed_bio(cb);
+	return false;
+}
+
 static void run_delayed_bbio(struct work_struct *work)
 {
 	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
 	struct btrfs_bio *parent = dbp->delayed_bbio;
 
-	/* Compressed and uncompressed fallback is not yet implemented. */
+	if (try_submit_compressed(parent))
+		goto finish;
+
+	/* Uncompressed fallback is not yet implemented. */
 	ASSERT(0);
 
+finish:
 	/*
 	 * Any real compressed/uncompressed bios have increased
 	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
-- 
2.55.0

