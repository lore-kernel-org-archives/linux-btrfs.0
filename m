Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A05187FE4
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 03:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769483482; cv=none; b=p1DuGaKhFX9zqgolW31myvdEmjodxW9QWzGsLLWj0eEN321c5e4esT2lc3L8UzTS9Xxxr9+CZu38QXDIWSrfttsovRzh6sCmX/H1iZfZqlQVF2lUUVW1iKcP5KAsFJsvN/YkyFP+zGnMgDd7sXVCUv65L5Ow34irWlhuyFBSvfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769483482; c=relaxed/simple;
	bh=wPdWzLdukjUGnHtDHzdNjobwIWWu9RmhP+fv3tBnWCM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOy0fJREbRTuxLsICXh8xa6GpBb8C8SvfIrnbEcnMoqDuurfe/cUe3+CeEJvVmyMbo2bcKuhWtolTY0y3h1yXQEThRYQuvNSpmNOjduCvRr1vkkxPf06oHUgaR3mvINeWhzCbSnfafsSdAcoFdLELnvUL2AYLEXH9xcFLs9w2U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UQQ3GFO7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UQQ3GFO7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UQQ3GFO7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UQQ3GFO7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23FEA5BCE6
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 03:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769483474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2OBknixlUIXwsQOiaggfhh4KbJ+88B+6mr+MQNPT84E=;
	b=UQQ3GFO7SytMxaJ7ECHts9xwog2zChRVCNKEz4yubGhK5NrcvEV06GO2K8qTept6hLsXUY
	/OYE75NmhM9NAr8pxZEsTehRVjYQdeth8syhh+BtYBTSEB8YESPEU8Hf/kjP8FwH/rrUG0
	1qJXKCzHK9RzXelBP94NhoePBRnQDfs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769483474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2OBknixlUIXwsQOiaggfhh4KbJ+88B+6mr+MQNPT84E=;
	b=UQQ3GFO7SytMxaJ7ECHts9xwog2zChRVCNKEz4yubGhK5NrcvEV06GO2K8qTept6hLsXUY
	/OYE75NmhM9NAr8pxZEsTehRVjYQdeth8syhh+BtYBTSEB8YESPEU8Hf/kjP8FwH/rrUG0
	1qJXKCzHK9RzXelBP94NhoePBRnQDfs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1206C13712
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 03:11:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gC1dLNAseGnFewAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 03:11:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 7/9] btrfs: get rid of compressed_folios[] usage for compressed read
Date: Tue, 27 Jan 2026 13:40:40 +1030
Message-ID: <428a89e9b79c5f49a0746a92cb5fbfe4f64b91be.1769482298.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769482298.git.wqu@suse.com>
References: <cover.1769482298.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Currently btrfs_submit_compressed_read() still uses
compressed_bio::compressed_folios[] array.

Change it to allocate each folio and queue them into the compressed bio
so that we do not need to allocate that array.

Considering how small each compressed read bio is (less than 128KiB), we
do not benefit that much from btrfs_alloc_folio_array() anyway,
meanwhile we may benefit more from btrfs_alloc_compr_folio() by using
the global folio pool.

So chaning from btrfs_alloc_folio_array() to btrfs_alloc_compr_folio()
in a loop should still be fine.

This removes one error path, and paves the way to completely remove
compressed_folios[] array.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1bf17c269524..c018b3c4554e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -239,7 +239,7 @@ static void end_bbio_compressed_read(struct btrfs_bio *bbio)
 
 	btrfs_bio_end_io(cb->orig_bbio, status);
 	bio_for_each_folio_all(fi, &bbio->bio)
-		folio_put(fi.folio);
+		btrfs_free_compr_folio(fi.folio);
 	bio_put(&bbio->bio);
 }
 
@@ -537,13 +537,13 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct compressed_bio *cb;
 	unsigned int compressed_len;
+	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
 	u64 file_offset = bbio->file_offset;
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
 	unsigned long pflags;
 	int memstall = 0;
-	blk_status_t status;
 	int ret;
 
 	/* we need the actual starting offset of this extent in the file */
@@ -551,7 +551,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
 	read_unlock(&em_tree->lock);
 	if (!em) {
-		status = BLK_STS_IOERR;
+		ret = -EIO;
 		goto out;
 	}
 
@@ -573,27 +573,31 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 
 	btrfs_free_extent_map(em);
 
-	cb->nr_folios = DIV_ROUND_UP(compressed_len, btrfs_min_folio_size(fs_info));
-	cb->compressed_folios = kcalloc(cb->nr_folios, sizeof(struct folio *), GFP_NOFS);
-	if (!cb->compressed_folios) {
-		status = BLK_STS_RESOURCE;
-		goto out_free_bio;
-	}
+	for (int i = 0; i * min_folio_size < compressed_len; i++) {
+		struct folio *folio;
+		u32 cur_len = min(compressed_len - i * min_folio_size,
+				  min_folio_size);
 
-	ret = btrfs_alloc_folio_array(cb->nr_folios, fs_info->block_min_order,
-				      cb->compressed_folios);
-	if (ret) {
-		status = BLK_STS_RESOURCE;
-		goto out_free_compressed_pages;
+		folio = btrfs_alloc_compr_folio(fs_info);
+		if (!folio) {
+			ret = -ENOMEM;
+			goto out_free_bio;
+		}
+
+		ret = bio_add_folio(&cb->bbio.bio, folio, cur_len, 0);
+		if (unlikely(!ret)) {
+			folio_put(folio);
+			ret = -EINVAL;
+			goto out_free_bio;
+		}
 	}
+	ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
 
 	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
 			 &pflags);
 
-	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bbio->bio.bi_iter.bi_size;
 	cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;
-	btrfs_add_compressed_bio_folios(cb);
 
 	if (memstall)
 		psi_memstall_leave(&pflags);
@@ -601,12 +605,10 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	btrfs_submit_bbio(&cb->bbio, 0);
 	return;
 
-out_free_compressed_pages:
-	kfree(cb->compressed_folios);
 out_free_bio:
-	bio_put(&cb->bbio.bio);
+	cleanup_compressed_bio(cb);
 out:
-	btrfs_bio_end_io(bbio, status);
+	btrfs_bio_end_io(bbio, errno_to_blk_status(ret));
 }
 
 /*
-- 
2.52.0

