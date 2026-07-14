Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7DF285C91
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011788; cv=none; b=BjIpHjfXVuEX5jznKmldPFr9M8VsMoy3HCb6KEjIFL63rMH+oHgbMeVPuk9fW+A+tq5V+pe4wT/pXrs91/cn7573nAO59VPMWD/bb81Rm+M4yf65bVQvm9TQ1BaUH7yZwKnOxycdvGDoJcx3YwTWfkSAEKPgBjUy/RL/ZAE6yoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011788; c=relaxed/simple;
	bh=fyzM5ZLd2LxF04sNkpQ9qDOO9dWExhc1ycpLON1gHDk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5jW4akFqHtKGKoZ1hUq6dx1cAo5wAkF9rtDuEU4DSZoIT68fmk3TVh0QqWVDpM1gLRO7ez3HhWIfNDbMYMNSWS+Ahd1zWIRnm7d++HKcdU3Na/T5dgyl02NZzSqtydEgCyv3BkOQyJJaweCAB3N/HYMOpjigrjm045bJXMY31I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dCdVUwOg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dCdVUwOg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dCdVUwOg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dCdVUwOg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F2B53E24
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784011779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIgNRMcK7b/4R9MSbd2OPVlZYdKkNDc0Ww3DoJymMvw=;
	b=dCdVUwOgoyDTXHnsnkKANhFTq0PlFhcnCF6/WXlYclFC/bdW8gnrSzbER9IrofXd+8YRhv
	2mb07/S+89ZpM2+GsTwsuqn+ep8CFWRLWhqwZJPKGPpAn0h0XZQvnIfk3V/h6NdbIdINDc
	SKuawAwF/Cowq9AjxWKg6Fa8I72S4pE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dCdVUwOg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784011779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIgNRMcK7b/4R9MSbd2OPVlZYdKkNDc0Ww3DoJymMvw=;
	b=dCdVUwOgoyDTXHnsnkKANhFTq0PlFhcnCF6/WXlYclFC/bdW8gnrSzbER9IrofXd+8YRhv
	2mb07/S+89ZpM2+GsTwsuqn+ep8CFWRLWhqwZJPKGPpAn0h0XZQvnIfk3V/h6NdbIdINDc
	SKuawAwF/Cowq9AjxWKg6Fa8I72S4pE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADE01779AE
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QL0OHALcVWp+TAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/4] btrfs: use a shared helper to calculate data checksum for a bio
Date: Tue, 14 Jul 2026 16:19:16 +0930
Message-ID: <ec580b8b558b7f37ffc9762e5acd313bcb2a5dd4.1784011486.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1784011485.git.wqu@suse.com>
References: <cover.1784011485.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6F2B53E24
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Since we are already calculating data checksum using bio interface,
extract the generation part into btrfs_csum_one_bio_block(), and use that
to replace the paddrs[] array based solution in csum_one_bio().

This will reduce 128 bytes on-stack memory usage for csum_one_bio().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h |  2 ++
 fs/btrfs/file-item.c   | 20 ++++++------------
 fs/btrfs/inode.c       | 46 +++++++++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 940cc1b24d1b..c8e3078784c3 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -515,6 +515,8 @@ int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8
 			   const u8 * const csum_expected);
 bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
 			    struct btrfs_device *dev);
+void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
+			      const struct bvec_iter *orig_iter, u8 *csum);
 noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
 			      struct btrfs_file_extent *file_extent,
 			      bool nowait);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index cf50fd623f41..72ebd7c9ef10 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -801,25 +801,17 @@ static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums = bbio->sums;
-	struct bvec_iter iter = *src;
-	phys_addr_t paddr;
+	struct bvec_iter iter;
 	const u32 blocksize = fs_info->sectorsize;
-	const u32 step = min(blocksize, PAGE_SIZE);
-	const u32 nr_steps = blocksize / step;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-	u32 offset = 0;
 	int index = 0;
 
-	btrfs_bio_for_each_block(paddr, bio, &iter, step) {
-		paddrs[(offset / step) % nr_steps] = paddr;
-		offset += step;
+	for (iter = *src; iter.bi_size;
+	     bio_advance_iter(&bbio->bio, &iter, blocksize)) {
+		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
+					 sums->sums + index);
 
-		if (IS_ALIGNED(offset, blocksize)) {
-			btrfs_calculate_block_csum_pages(fs_info, paddrs, sums->sums + index);
-			index += fs_info->csum_size;
-		}
+		index += fs_info->csum_size;
 	}
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9c960cf7ccbe..d0cfa88179a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3342,6 +3342,32 @@ int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8
 	return 0;
 }
 
+/* Generate data checksum for a single fs block, pointed by @orig_iter. */
+void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
+			      const struct bvec_iter *orig_iter, u8 *csum)
+{
+	struct btrfs_csum_ctx cctx;
+	struct bvec_iter iter = *orig_iter;
+	const u32 blocksize = fs_info->sectorsize;
+	u32 cur = 0;
+
+	btrfs_csum_init(&cctx, fs_info->csum_type);
+	while (cur < blocksize) {
+		struct page *page = bio_iter_page(bio, iter);
+		const u32 pg_off = bio_iter_offset(bio, iter);
+		const u32 cur_len = min(bio_iter_len(bio, iter), blocksize - cur);
+		void *kaddr;
+
+		kaddr = kmap_local_page(page) + pg_off;
+		btrfs_csum_update(&cctx, kaddr, cur_len);
+		kunmap_local(kaddr);
+
+		bio_advance_iter_single(bio, &iter, cur_len);
+		cur += cur_len;
+	}
+	btrfs_csum_final(&cctx, csum);
+}
+
 /*
  * Verify the checksum of a single data sector, which can be scattered at
  * different noncontiguous pages.
@@ -3362,7 +3388,6 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct bvec_iter iter = *orig_iter;
-	struct btrfs_csum_ctx cctx;
 	const u32 blocksize = fs_info->sectorsize;
 	const u32 bio_offset = (iter.bi_sector - bbio->saved_iter.bi_sector) << SECTOR_SHIFT;
 	u64 file_offset = bbio->file_offset + bio_offset;
@@ -3387,22 +3412,7 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 
 	csum_expected = bbio->csum + (bio_offset >> fs_info->sectorsize_bits) *
 				fs_info->csum_size;
-	btrfs_csum_init(&cctx, fs_info->csum_type);
-	while (cur < blocksize) {
-		struct page *page = bio_iter_page(&bbio->bio, iter);
-		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
-		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
-		void *kaddr;
-
-		kaddr = kmap_local_page(page) + pg_off;
-		btrfs_csum_update(&cctx, kaddr, cur_len);
-		kunmap_local(kaddr);
-
-		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
-		cur += cur_len;
-	}
-	btrfs_csum_final(&cctx, csum);
-
+	btrfs_csum_one_bio_block(fs_info, &bbio->bio, orig_iter, csum);
 	if (unlikely(memcmp(csum, csum_expected, fs_info->csum_size) != 0))
 		goto zeroit;
 	return true;
@@ -3412,8 +3422,6 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 				    bbio->mirror_num);
 	if (dev)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS);
-	cur = 0;
-	iter = *orig_iter;
 	while (cur < blocksize) {
 		struct page *page = bio_iter_page(&bbio->bio, iter);
 		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
-- 
2.54.0

