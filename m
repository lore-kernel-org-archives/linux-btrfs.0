Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB4E466B08
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545283; cv=none; b=JtX9tslC2+AOvvUKxlU4chI0Jr4vwkutG6aDb7/IcFBoypFMTsKfap+r0vifEM7BAQO1BEyZc9uTpyk6QTZkYJu0mGFoYICXZYILFitVzDVDPhHqqma0NiFDns2bkQjThqqrXM6IxSgkb6fCczdRgfgz0XjCG2plqMue5xGDMaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545283; c=relaxed/simple;
	bh=AnWaiUUox+M8zM/B9EK33jf1e3rErtXISLv9V9tY/98=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8XLlpXvXtzp+2R0uhPqDgK0/TtEEodBhv5QpoLPUjzj9UTi9jSqD0nLFYhguOTHyETbs7+m33phkMI1v2+x0lRG0Xmr6F6vR5MOg4JAF+PHT7yCZF2EpcyrlkWTMQngiASWy7+A88KaARGBhYXnBqZPtuVJI1Zv3a1aAIQA8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=enmu7QXW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OC9AuNXG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="enmu7QXW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OC9AuNXG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93E151FCC4
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789545260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zVF/k2KUxKwi4oHyQi+62Vq2vIk+HW6g75NxFRTKWrw=;
	b=enmu7QXWCM0h0gbumZIMpqP7L0yoLTLwtsdSDA5cbsL8SlKczXnwrYGKAp8wYqa/XFayDf
	tg8NdnE+rZ19TA/6uqULF8madjzhBOilEOIhxLMT2hFB4DoIJzZBHGSBlxOqUzwh5cduk6
	gdeDRxGowWzr1IZ4cyAYlOg8WkaG3Po=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789545256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zVF/k2KUxKwi4oHyQi+62Vq2vIk+HW6g75NxFRTKWrw=;
	b=OC9AuNXGsIdan1PdtE+08aWJFfT81/Z/GRAxZLH52WJ5QzrpWWQYpwiLJ3zGrumlZJ6vNF
	zSsKmk1D8JxnHTfdSu30mY6p2Hc7QsAKdK3IPCO1VObLTz4ZdXRQh9XKiN/mnzxV6ohG4q
	NtjmvtulVkREIOhMoxMn2yJhgYUlwvk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF2D9137D2
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 31W+Dh5LqmqMKgAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/6] btrfs: implement uncompressed fallback for delayed bbio
Date: Wed, 16 Sep 2026 17:23:47 +0930
Message-ID: <7ebedee1ab00f229c33b9f38e8dd51e6fb04b96a.1789545179.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789545179.git.wqu@suse.com>
References: <cover.1789545179.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
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

When compression fails (either bad ratio, fragmented free space, or
writeback path chooses to submit the bio early), we have to fall back to
uncompressed writes.

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
 fs/btrfs/inode.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 160 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c27139b51561..590982424073 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7804,16 +7804,174 @@ static bool try_submit_compressed(struct btrfs_bio *parent)
 	return false;
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
+	int ret = 0;
 
 	if (try_submit_compressed(parent))
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

