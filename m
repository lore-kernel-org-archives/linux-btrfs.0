Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28126FA60
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790306199; cv=none; b=MIuJMu1QZDrh/0sJRaKT1LLZ3ug0i2i4LLpT/iybXJNSSr8n7YVKy1MsSkwlTW3asx54KjBuZsw+jE6HZNvJuGPhrRPXgzhex+U2qPvbNJ2olLuwH9gIGIm2dyauU2xK4DoKtxb5MXCNgol6gy29bLJaoi0XfbfHhVzmrRpp8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790306199; c=relaxed/simple;
	bh=84OaiM/Wp3jXUXVyylHx0VJ1wu2Gnu3ijkhM79ytHjM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9CzaCKby4rbM5/BFDwNXFPxpX1BVglF3TGB2Iq4Qk6b2TsJ8PgaNS6jlpTb2wRJ3e/UZsQhGCm93MOhj3lKGnsLcHHb/TsqVEbZFOU1wsaoQNQKPinegJlPZ/oOiM7IzsBwN0l/IuR/96hjYqRJtHnuyx/xFKZ23cD6CmWw/YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JUvc0rRG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P9yjJ8ch; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JUvc0rRG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P9yjJ8ch"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 35848200D2
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kTnh87Izz5q49xp6NfD7+C9QLSvZezFSfXtwLKW/bk=;
	b=JUvc0rRG0vCOrp3VA6qbB3HEIqwxBhzhl8iUPfPZ7FBZB0uG3Q1hBtd99yJNrK0HgI+LNw
	HtUslZ8wyTgGWcz1l+0OKmequsslGRxMEg3BSiJtg83IFB285WAjUvuqR+6PRQqeR8DqGg
	cDtmDyFgXOUwwiHmXreeolMjayEvs0k=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=P9yjJ8ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kTnh87Izz5q49xp6NfD7+C9QLSvZezFSfXtwLKW/bk=;
	b=P9yjJ8chaHQA2EkVm8q94s0pfbHVj398DmiOZ0IDvNu0O6eMpb1s/QxaExMYAGAodF+gFm
	/AWh3VH+E2Wni47JhiYBu3Xwpy3r4fXP3xIn8DzLmVRu4AxVMjDN4XnvkWiOivaMYup9gP
	CwPKk80C57o5SptwJNbaTCqXcFLkX0s=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A209A1394A
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fd3cN4HntWpbDQAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 5/6] btrfs: implement uncompressed fallback for delayed bbio
Date: Fri, 25 Sep 2026 12:45:54 +0930
Message-ID: <fddc496b5849547d5fe8a19a01699d801539abb0.1790306139.git.wqu@suse.com>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 35848200D2
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

When compression fails (either bad ratio, fragmented free space) we have
to fall back to uncompressed writes.

The uncompressed fallback is mostly the same as cow_file_range() but
with some changes:

- Endio function is slightly different from the compressed path
  Only in the folio freeing handling.

- Uncompressed fallback error handling
  Since at this stage, the folios already have WRITEBACK flag set, we do
  not need to do the usual page unlock/end writeback, but just free the
  reserved space and call it a day.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 164 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d301d05f3da1..bb8424af1844 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7849,10 +7849,157 @@ static int try_submit_compressed(struct btrfs_bio *parent)
 	return ret;
 }
 
+static void end_bbio_delayed_uncompressed(struct btrfs_bio *bbio)
+{
+	struct delayed_bio_private *dbp = bbio->private;
+	struct btrfs_bio *parent = dbp->delayed_bbio;
+	struct folio_iter fi;
+
+	bio_for_each_folio_all(fi, &bbio->bio)
+		folio_put(fi.folio);
+	btrfs_bio_end_io(parent, bbio->bio.bi_status);
+	bio_put(&bbio->bio);
+}
+
+static struct btrfs_bio *child_bbio_from_page_cache(struct btrfs_bio *parent,
+						    u64 fileoff, u32 len)
+{
+	struct btrfs_inode *inode = parent->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct address_space *mapping = inode->vfs_inode.i_mapping;
+	struct btrfs_bio *bbio;
+	struct folio_iter fi;
+	u64 cur = fileoff;
+	int ret;
+
+	bbio = btrfs_bio_alloc(len >> fs_info->sectorsize_bits, REQ_OP_WRITE,
+			       inode, fileoff, end_bbio_delayed_uncompressed,
+			       parent->private);
+
+	while (cur < fileoff + len) {
+		struct folio *folio;
+		u32 cur_len;
+		bool queued;
+
+		folio = filemap_get_folio(mapping, cur >> PAGE_SHIFT);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio);
+			goto error;
+		}
+		cur_len = min_t(u64, folio_next_pos(folio), fileoff + len) - cur;
+		queued = bio_add_folio(&bbio->bio, folio, cur_len,
+				    offset_in_folio(folio, cur));
+		/* There should be enough slots for the bio. */
+		if (WARN_ON(!queued)) {
+			ret = -EIO;
+			folio_put(folio);
+			goto error;
+		}
+		cur += cur_len;
+	}
+
+	return bbio;
+error:
+	bio_for_each_folio_all(fi, &bbio->bio)
+		folio_put(fi.folio);
+	bio_put(&bbio->bio);
+	return ERR_PTR(ret);
+}
+
+static int submit_one_uncompressed_range(struct btrfs_bio *parent, struct btrfs_key *ins,
+					 struct extent_state **cached, u64 file_offset,
+					 u32 num_bytes, u64 alloc_hint, u32 *ret_alloc_size)
+{
+	struct btrfs_inode *inode = parent->inode;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_file_extent file_extent;
+	struct btrfs_bio *child = NULL;
+	struct extent_map *em;
+	u64 cur_end;
+	u32 cur_len = 0;
+	int ret;
+
+	ret = btrfs_reserve_extent(root, num_bytes, num_bytes, fs_info->sectorsize,
+				   0, alloc_hint, ins, true, true);
+	if (ret < 0)
+		return ret;
+
+	cur_len = ins->offset;
+	cur_end = file_offset + cur_len - 1;
+
+	file_extent.disk_bytenr = ins->objectid;
+	file_extent.disk_num_bytes = ins->offset;
+	file_extent.num_bytes = ins->offset;
+	file_extent.ram_bytes = ins->offset;
+	file_extent.offset = 0;
+	file_extent.compression = BTRFS_COMPRESS_NONE;
+
+	child = child_bbio_from_page_cache(parent, file_offset, cur_len);
+	if (IS_ERR(child)) {
+		ret = PTR_ERR(child);
+		child = NULL;
+		goto free_reserved;
+	}
+
+	btrfs_lock_extent(&inode->io_tree, file_offset, cur_end, cached);
+	em = btrfs_create_io_em(inode, file_offset, &file_extent, BTRFS_ORDERED_REGULAR);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
+		goto free_reserved;
+	}
+	btrfs_free_extent_map(em);
+	ordered = btrfs_alloc_ordered_extent(inode, file_offset, &file_extent,
+					     1U << BTRFS_ORDERED_REGULAR);
+	if (IS_ERR(ordered)) {
+		btrfs_drop_extent_map_range(inode, file_offset, cur_end, false);
+		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
+		ret = PTR_ERR(ordered);
+		goto free_reserved;
+	}
+	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
+	btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
+
+	child->ordered = ordered;
+	child->private = parent->private;
+	child->end_io = end_bbio_delayed_uncompressed;
+	child->bio.bi_iter.bi_sector = ins->objectid >> SECTOR_SHIFT;
+	atomic_inc(&parent->pending_ios);
+	btrfs_submit_bbio(child, 0);
+	*ret_alloc_size = cur_len;
+	return 0;
+
+free_reserved:
+	if (child) {
+		struct folio_iter fi;
+
+		bio_for_each_folio_all(fi, &child->bio)
+			folio_put(fi.folio);
+		bio_put(&child->bio);
+	}
+	btrfs_qgroup_free_data(inode, NULL, file_offset, cur_len, NULL);
+	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
+	btrfs_free_reserved_extent(fs_info, ins->objectid, ins->offset, true);
+	btrfs_delalloc_release_metadata(inode, cur_len, true);
+	ASSERT(parent->ordered);
+	clear_cleanup_bitmap(parent->ordered, file_offset, cur_len);
+	ASSERT(ret != -EAGAIN);
+	return ret;
+}
+
 static void run_delayed_bbio(struct work_struct *work)
 {
 	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
 	struct btrfs_bio *parent = dbp->delayed_bbio;
+	struct btrfs_key ins;
+	struct extent_state *cached = NULL;
+	const u32 uncompressed_size = bio_get_size(&parent->bio);
+	const u64 start = parent->file_offset;
+	const u64 end = start + uncompressed_size - 1;
+	u64 cur = start;
+	u64 alloc_hint;
 	int ret;
 
 	/* Parent OE must be set. */
@@ -7862,8 +8009,21 @@ static void run_delayed_bbio(struct work_struct *work)
 	if (ret <= 0)
 		goto finish;
 
-	/* Uncompressed fallback is not yet implemented. */
-	ASSERT(0);
+	alloc_hint = btrfs_get_extent_allocation_hint(parent->inode, start,
+						      uncompressed_size);
+	while (cur < end) {
+		u32 cur_len;
+
+		ret = submit_one_uncompressed_range(parent, &ins, &cached,
+						    cur, end + 1 - cur,
+						    alloc_hint, &cur_len);
+		if (ret < 0) {
+			cmpxchg(&parent->status, BLK_STS_OK, errno_to_blk_status(ret));
+			goto finish;
+		}
+		cur += cur_len;
+		alloc_hint = ins.objectid + ins.offset;
+	}
 
 finish:
 	/*
-- 
2.55.0

