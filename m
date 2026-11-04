Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766254;
	b=WT/6039k48uciLFYyrZFIg2HzhSVmGKYxkixeLV3/KhjaB9r4yXDlW54ZY7P6lu5tR0F
	 zf9yRnGmtciraNL6dcxUOcEjQkRMBnEsHCVUyukyIXvH2np1IBCX88+ChI6KhUbq5+n+0
	 aJuiS44Tg9rcz0ns53vBgD8bJaOdi15wx6/160rka9VpVY60w+PkrBOVrviahOMqtjZuR
	 WjpxTbCBkYmmfMuogwqSdRX5cNc+bM4/8dHNvYI3c/1wscwjuQOC5Lqy97U71mjdm48Fo
	 wFAe0PpEq/fyZv1k+C65TPlv+/9yuYXrJfwusB+a7rJFMang1AtfzMmd4SyTZYVkJwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766254;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=qvBVRFWHTz8q/o5v+QMz7IAoKDfw2LspyISPp6fj060=;
	b=SvVqHfFWYV4kbc08QUVYdYRBibysO3h+Dy9Hu1i/AaPwDoqNYagFutOXMLgd6IWNy+0B
	 pwpwbsb88peEoVoBHPKCIkSgQtQ1YbA96NR+eIzHCkisS1B98zobl4WXxHCdpRLll3sMT
	 oaBI0XI34R+VydwXSZEYEtKYHGqIiQ7YZ4L0I/qJI+0E+3y/bsuwshSxmcpipou9Hk6Dp
	 +QR/hRLd8gZC2qIbdjLCdr1plyLZrC977t+uyp2QczglBRRpQPc2Ks0GcvB3+9i8Tqi+5
	 LUpERIENLejWNgOgetxOoG8fX8CjeC13d3oE5lEYNplAfXz69+KHHrDnv1WDjVc4Cxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FDCXcHUG;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FDCXcHUG;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3986606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 04:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3986606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FDCXcHUG;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FDCXcHUG
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB77D22032
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 04:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793766251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qvBVRFWHTz8q/o5v+QMz7IAoKDfw2LspyISPp6fj060=;
	b=FDCXcHUGmi2oTI5rSZJcFiEcLnQXgPqZAcL0j63aen1DtnRCFLnnaKbaXd0EtT/R1dJ8pG
	/+L/xYVel2i9hxZBb86bjA91IbY4z7iEzcdwTEhvFEAYmK7LPdw973Osv5hJYAd0iowMew
	zDm6yO+5ApPt4KJYibcvHY4Abwd4VAM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793766251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qvBVRFWHTz8q/o5v+QMz7IAoKDfw2LspyISPp6fj060=;
	b=FDCXcHUGmi2oTI5rSZJcFiEcLnQXgPqZAcL0j63aen1DtnRCFLnnaKbaXd0EtT/R1dJ8pG
	/+L/xYVel2i9hxZBb86bjA91IbY4z7iEzcdwTEhvFEAYmK7LPdw973Osv5hJYAd0iowMew
	zDm6yO+5ApPt4KJYibcvHY4Abwd4VAM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF2C8134F0
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 04:24:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h4j5AWqz6mo1AQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 04:24:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: move async data csum generation out of experimental
Date: Wed,  4 Nov 2026 14:53:51 +1030
Message-ID: <8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

This feature has been inside the experimental features for long enough,
it's time to expose it for end users.

This involves several cleanups:

- Completely remove the workqueue based csum generation
  This removes the involved structure and the fs_info->workers
  workqueue.

- Remove the @async parameter from btrfs_csum_one_bio()

- Remove btrfs_init_csum_hash() and BTRFS_FS_CSUM_IMPL_FAST flag
  Since there is no offload for csum generation any more, the function
  btrfs_init_csum_hash() is just a simple btrfs_info() call.

  Use that btrfs_info() to replace btrfs_init_csum_hash() call.

And introduced one minor behavior change:

- Metadata checksum generation is never delayed to workqueue
  I strongly doubt if the metadata checksum itself should even be
  offloaded to another workqueue.

  The offloading itself only brings nothing but more context switch and
  less locality.
  And metadata itself is also pretty small, 16Kib by default, the
  context switch itself can be more costly than the metadata checksum
  generation.

  I don't think the original introduction of the offload should even
  include metadata in the first place.

  This should not affect most users, as their CRC32/XXHASH is already
  not going to be offloaded.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Kconfig     |   2 -
 fs/btrfs/bio.c       | 138 +------------------------------------------
 fs/btrfs/disk-io.c   |  42 +------------
 fs/btrfs/file-item.c |   6 +-
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  16 -----
 fs/btrfs/super.c     |   1 -
 7 files changed, 6 insertions(+), 201 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 4b10d78ed99b..47faa08d9059 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -111,8 +111,6 @@ config BTRFS_EXPERIMENTAL
 
 	  - huge folios for data - folios can be as large as 2MiB now
 
-	  - asynchronous checksum generation for data writes
-
 	  - remap-tree - logical address remapping tree
 
 	  If unsure, say N.
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2e12a6d7e16f..4f7f7da417f7 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -563,138 +563,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
 {
 	if (bbio->bio.bi_opf & REQ_META)
 		return btree_csum_one_bio(bbio);
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
-	return btrfs_csum_one_bio(bbio, true);
-#else
-	return btrfs_csum_one_bio(bbio, false);
-#endif
-}
-
-/*
- * Async submit bios are used to offload expensive checksumming onto the worker
- * threads.
- */
-struct async_submit_bio {
-	struct btrfs_bio *bbio;
-	struct btrfs_io_context *bioc;
-	struct btrfs_io_stripe smap;
-	int mirror_num;
-	struct btrfs_work work;
-};
-
-/*
- * In order to insert checksums into the metadata in large chunks, we wait
- * until bio submission time.   All the pages in the bio are checksummed and
- * sums are attached onto the ordered extent record.
- *
- * At IO completion time the csums attached on the ordered extent record are
- * inserted into the btree.
- */
-static void run_one_async_start(struct btrfs_work *work)
-{
-	struct async_submit_bio *async =
-		container_of(work, struct async_submit_bio, work);
-	int ret;
-
-	ret = btrfs_bio_csum(async->bbio);
-	if (ret)
-		async->bbio->bio.bi_status = errno_to_blk_status(ret);
-}
-
-/*
- * In order to insert checksums into the metadata in large chunks, we wait
- * until bio submission time.   All the pages in the bio are checksummed and
- * sums are attached onto the ordered extent record.
- *
- * At IO completion time the csums attached on the ordered extent record are
- * inserted into the tree.
- *
- * If called with @do_free == true, then it will free the work struct.
- */
-static void run_one_async_done(struct btrfs_work *work, bool do_free)
-{
-	struct async_submit_bio *async =
-		container_of(work, struct async_submit_bio, work);
-	struct bio *bio = &async->bbio->bio;
-
-	if (do_free) {
-		kfree(container_of(work, struct async_submit_bio, work));
-		return;
-	}
-
-	/* If an error occurred we just want to clean up the bio and move on. */
-	if (bio->bi_status) {
-		btrfs_put_bioc(async->bioc);
-		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
-		btrfs_bio_end_io(async->bbio, bio->bi_status);
-		return;
-	}
-
-	/*
-	 * All of the bios that pass through here are from async helpers.
-	 * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgroup's
-	 * context.  This changes nothing when cgroups aren't in use.
-	 */
-	bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
-	btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
-}
-
-static bool should_async_write(struct btrfs_bio *bbio)
-{
-	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
-	bool auto_csum_mode = true;
-
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
-	/*
-	 * Write bios will calculate checksum and submit bio at the same time.
-	 * Unless explicitly required don't offload serial csum calculate and bio
-	 * submit into a workqueue.
-	 */
-	return false;
-#endif
-
-	/* Submit synchronously if the checksum implementation is fast. */
-	if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags))
-		return false;
-
-	/*
-	 * Try to defer the submission to a workqueue to parallelize the
-	 * checksum calculation unless the I/O is issued synchronously.
-	 */
-	if (op_is_sync(bbio->bio.bi_opf))
-		return false;
-
-	/* Zoned devices require I/O to be submitted in order. */
-	if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
-		return false;
-
-	return true;
-}
-
-/*
- * Submit bio to an async queue.
- *
- * Return true if the work has been successfully submitted, else false.
- */
-static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
-				struct btrfs_io_context *bioc,
-				struct btrfs_io_stripe *smap, int mirror_num)
-{
-	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
-	struct async_submit_bio *async;
-
-	async = kmalloc_obj(*async, GFP_NOFS);
-	if (!async)
-		return false;
-
-	async->bbio = bbio;
-	async->bioc = bioc;
-	async->smap = *smap;
-	async->mirror_num = mirror_num;
-
-	btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
-	btrfs_queue_work(fs_info->workers, &async->work);
-	return true;
+	return btrfs_csum_one_bio(bbio);
 }
 
 static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_length)
@@ -803,10 +672,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
 		    !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
 		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
-			if (should_async_write(bbio) &&
-			    btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
-				goto done;
-
 			ret = btrfs_bio_csum(bbio);
 			status = errno_to_blk_status(ret);
 			if (status)
@@ -821,7 +686,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	}
 
 	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
-done:
 	return map_length == length;
 
 fail:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 35a43e7cb937..c7b9ca7614e0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1829,7 +1829,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
-	btrfs_destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
 		destroy_workqueue(fs_info->endio_workers);
 	if (fs_info->rmw_workers)
@@ -2040,9 +2039,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
-	fs_info->workers =
-		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
-
 	fs_info->delalloc_workers =
 		btrfs_alloc_workqueue(fs_info, "delalloc",
 				      flags, max_active, 2);
@@ -2074,8 +2070,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->discard_ctl.discard_workers =
 		alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
 
-	if (!(fs_info->workers &&
-	      fs_info->delalloc_workers && fs_info->flush_workers &&
+	if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_write_workers && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->fixup_workers &&
@@ -2087,25 +2082,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-static void btrfs_init_csum_hash(struct btrfs_fs_info *fs_info, u16 csum_type)
-{
-	/* Check if the checksum implementation is a fast accelerated one. */
-	switch (csum_type) {
-	case BTRFS_CSUM_TYPE_CRC32:
-		if (crc32_optimizations() & CRC32C_OPTIMIZATION)
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
-		break;
-	case BTRFS_CSUM_TYPE_XXHASH:
-		set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
-		break;
-	default:
-		break;
-	}
-
-	btrfs_info(fs_info, "using %s checksum algorithm",
-		   btrfs_super_csum_name(csum_type));
-}
-
 static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 			    struct btrfs_fs_devices *fs_devices)
 {
@@ -3476,7 +3452,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->csum_size = btrfs_super_csum_size(disk_super);
 	fs_info->csum_type = csum_type;
 
-	btrfs_init_csum_hash(fs_info, csum_type);
+	btrfs_info(fs_info, "using %s checksum algorithm",
+		   btrfs_super_csum_name(csum_type));
 
 	/*
 	 * We want to check superblock checksum, the type is stored inside.
@@ -4465,19 +4442,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_flush_workqueue(fs_info->delalloc_workers);
 
-	/*
-	 * We can have ordered extents getting their last reference dropped from
-	 * the fs_info->workers queue because for async writes for data bios we
-	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
-	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
-	 * has an error, and that later function can do the final
-	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
-	 * which adds a delayed iput for the inode. So we must flush the queue
-	 * so that we don't have delayed iputs after committing the current
-	 * transaction below and stopping the cleaner and transaction kthreads.
-	 */
-	btrfs_flush_workqueue(fs_info->workers);
-
 	/*
 	 * When finishing a compressed write bio we schedule a work queue item
 	 * to finish an ordered extent - end_bbio_compressed_write()
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ff8f8cad00fc..53c4af76cebc 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -815,7 +815,7 @@ static void csum_one_bio_work(struct work_struct *work)
 /*
  * Calculate checksums of the data contained inside a bio.
  */
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
+int btrfs_csum_one_bio(struct btrfs_bio *bbio)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
@@ -839,10 +839,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	btrfs_add_ordered_sum(ordered, sums);
 
 	bbio->csum_saved_iter = bio->bi_iter;
-	if (!async) {
-		csum_one_bio(bbio);
-		return 0;
-	}
 	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	queue_work(fs_info->endio_workers, &bbio->csum_work);
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index 6c678787c770..60a0eb17b3f6 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_ordered_sum *sums);
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
+int btrfs_csum_one_bio(struct btrfs_bio *bbio);
 int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit,
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..7062bb9b242f 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -189,12 +189,6 @@ enum {
 	/* Indicate that the cleaner thread is awake and doing something. */
 	BTRFS_FS_CLEANER_RUNNING,
 
-	/*
-	 * The checksumming has an optimized version and is considered fast,
-	 * so we don't need to offload checksums to workqueues.
-	 */
-	BTRFS_FS_CSUM_IMPL_FAST,
-
 	/* Indicate that the discard workqueue can service discards. */
 	BTRFS_FS_DISCARD_RUNNING,
 
@@ -695,16 +689,6 @@ struct btrfs_fs_info {
 	/* All fs/file tree roots that have delalloc inodes. */
 	struct list_head delalloc_roots;
 
-	/*
-	 * There is a pool of worker threads for checksumming during writes and
-	 * a pool for checksumming after reads.  This is because readers can
-	 * run with FS locks held, and the writers may be waiting for those
-	 * locks.  We don't want ordering in the pending list to cause
-	 * deadlocks, and so the two are serviced separately.
-	 *
-	 * A third pool does submit_bio to avoid deadlocking with the other two.
-	 */
-	struct btrfs_workqueue *workers;
 	struct btrfs_workqueue *delalloc_workers;
 	struct btrfs_workqueue *flush_workers;
 	struct workqueue_struct *endio_workers;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..032238c941bc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1235,7 +1235,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_info(fs_info, "resize thread pool %d -> %d",
 	       old_pool_size, new_pool_size);
 
-	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
-- 
2.56.0

