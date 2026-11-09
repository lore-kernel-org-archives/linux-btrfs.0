Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261854;
	b=QN3SlHPvOOkDerLhZieeOY/6404zp9W/DQpyVcZG7ah7BWHnE3mkbBSO1gJD2hcLxrZF
	 wjCDc3CETSIkZstiyLaG/n4hGHPgjB3qDZULaSYkOi3+bnMNdYxv+oD8PamYQbRgThs0g
	 f5P+VCxaxzKs+FAWn5Xgs81AGL4FvE7Nd6mXJ9UyprTpDHU+mHzOSR6wM9haleMRs5omG
	 J1cpmFYcNl9wr5x9NojczciU43eNuXdNA5lT+8xfJ/96w72im2aCgSkQmMf/75qlxnHKG
	 zEVMjnS+Dgxw94xlCH3o9lVYHa3wIY0nux5eFpqdRsH25j4k5A/8lvaCHVO5+dWhzJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261854;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=cCh/D+eTKdv0j3QdG1FotRdO3ujUaUS2Mog/H2LmpIs=;
	b=0jsyGhTNwrvJmZuhtJwJxZuL8PMUl+eam999zj+9WaiB+IgkkKBoOUB8V57TAqa41KQo
	 wWUd3UxSp4XwXAeiBFVqDHt4pcDNot9bOPMYwGNgagwi9HffzmVwWevfaYktu58KerlEg
	 cp20Btba+dJlopCSWxEGWDGcqeSuctJFTpQbAL/PWS4IOfBI8PRBt7UsJLbfdEWic3Aa3
	 lpfBaVq0hAGDAa74oWIaY2AH7XhlHv2Vxz/R6wA3aBK7xtecwRrVrmWwp1/HNKOQRnAEB
	 vSYRZoUD7n7UHlK9D0MFRXutyfdRcZOebkP2w6QxNHtfVt6vg0IqHqU6YBWA1S8Yz9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TsoKeAYj;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TsoKeAYj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41391606A337
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41391606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TsoKeAYj;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TsoKeAYj
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 850ED22079
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCh/D+eTKdv0j3QdG1FotRdO3ujUaUS2Mog/H2LmpIs=;
	b=TsoKeAYjuH4yqQcsTpqAI1dvNA7Du4tFPS90AGpjY9gLbZL7VaTMwxTlJ4gKHL6wX7etK1
	lpgoxJP+3qX4lic6nGUZlCnYN/+SG7vviSNB8ootmQEBsJx2FLSd9D2lgLO2i5SP/qDzXC
	q8gO4Fgf7vGp+EDRQUMxMC7mhCZ7QWY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCh/D+eTKdv0j3QdG1FotRdO3ujUaUS2Mog/H2LmpIs=;
	b=TsoKeAYjuH4yqQcsTpqAI1dvNA7Du4tFPS90AGpjY9gLbZL7VaTMwxTlJ4gKHL6wX7etK1
	lpgoxJP+3qX4lic6nGUZlCnYN/+SG7vviSNB8ootmQEBsJx2FLSd9D2lgLO2i5SP/qDzXC
	q8gO4Fgf7vGp+EDRQUMxMC7mhCZ7QWY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 650F713319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3OosElZD8moUPAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 22:04:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: move async data csum generation out of experimental features
Date: Tue, 10 Nov 2026 08:33:40 +1030
Message-ID: <fe6593b495db7a40018e10dc9a979cbe4f6d7cab.1794261158.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794261158.git.wqu@suse.com>
References: <cover.1794261158.git.wqu@suse.com>
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
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

The feature has been under experimental features for a long time, it's
time to enable it by default for end users.

This also means we can completely get rid of the current csum offload
for slow checksum algorithms, as there is no difference between slow and
fast csum generation anyway.

There is a minor behavior change for metadata writes, previously if the
checksum algorithm is slow, we will offload the metadata checksum
generation into a workqueue, and wait for the csum generation to finish
before submission.

That brings no concurrency improvement, and will only introduce extra
context switches as overhead. Now metadata checksum generation is always
inlined.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Kconfig     |   2 -
 fs/btrfs/bio.c       | 120 +------------------------------------------
 fs/btrfs/disk-io.c   |  41 +++++----------
 fs/btrfs/file-item.c |  10 ++--
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  15 +-----
 6 files changed, 22 insertions(+), 168 deletions(-)

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
index 508b44841768..1b3de0ecb3ec 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -562,120 +562,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
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
-	struct work_struct work;
-};
-
-/*
- * In order to insert checksums into the metadata in large chunks, we wait
- * until bio submission time.   All the pages in the bio are checksummed and
- * sums are attached onto the ordered extent record.
- *
- * At IO completion time the csums attached on the ordered extent record are
- * inserted into the tree.
- */
-static void run_one_async_submit(struct work_struct *work)
-{
-	struct async_submit_bio *async =
-		container_of(work, struct async_submit_bio, work);
-	struct btrfs_bio *bbio = async->bbio;
-	struct btrfs_io_context *bioc = async->bioc;
-	struct btrfs_io_stripe smap = async->smap;
-	const int mirror_num = async->mirror_num;
-	struct bio *bio = &bbio->bio;
-	int ret;
-
-	kfree(async);
-
-	/* If an error occurred we just want to clean up the bio and move on. */
-	ret = btrfs_bio_csum(bbio);
-	if (ret) {
-		btrfs_put_bioc(bioc);
-		btrfs_bio_counter_dec(bbio->inode->root->fs_info);
-		btrfs_bio_end_io(bbio, errno_to_blk_status(ret));
-		return;
-	}
-
-	/*
-	 * All of the bios that pass through here are from async helpers.
-	 * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgroup's
-	 * context.  This changes nothing when cgroups aren't in use.
-	 */
-	bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
-	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
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
-	INIT_WORK(&async->work, run_one_async_submit);
-	queue_work(fs_info->workers, &async->work);
-	return true;
+	return btrfs_csum_one_bio(bbio);
 }
 
 static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_length)
@@ -784,10 +671,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
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
@@ -802,7 +685,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	}
 
 	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
-done:
 	return map_length == length;
 
 fail:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e69055d84606..14389e7c22b4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1829,6 +1829,10 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
+	/*
+	 * The async csum work on @workers can queue work on the endio queues
+	 * destroyed below, so @workers must be destroyed before them.
+	 */
 	if (fs_info->workers)
 		destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
@@ -2087,25 +2091,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
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
@@ -3476,7 +3461,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->csum_size = btrfs_super_csum_size(disk_super);
 	fs_info->csum_type = csum_type;
 
-	btrfs_init_csum_hash(fs_info, csum_type);
+	btrfs_info(fs_info, "using %s checksum algorithm",
+		   btrfs_super_csum_name(csum_type));
 
 	/*
 	 * We want to check superblock checksum, the type is stored inside.
@@ -4466,19 +4452,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_flush_workqueue(fs_info->delalloc_workers);
 
 	/*
-	 * We can have ordered extents getting their last reference dropped from
-	 * the fs_info->workers queue because for async writes for data bios we
-	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
-	 * run_one_async_submit() which calls btrfs_bio_end_io() in case the bio
-	 * has an error, and that later function can do the final
+	 * The fs_info->workers queue runs the async data checksum work, queued
+	 * at btrfs_csum_one_bio(), which calls bio_endio() on the write bio
+	 * after the checksums are calculated. If the device has already
+	 * finished the bio, this is the final bio_endio() which ends up in
+	 * btrfs_finish_ordered_extent(), and that can do the final
 	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
 	 * which adds a delayed iput for the inode. So we must flush the queue
 	 * so that we don't have delayed iputs after committing the current
 	 * transaction below and stopping the cleaner and transaction kthreads.
 	 *
-	 * That queue also runs the async checksum work, csum_one_bio_work(),
-	 * whose bio_endio() can lead to work being queued on the endio queues
-	 * flushed below, so it must be flushed before them.
+	 * That final bio_endio() can also queue work on the endio queues
+	 * flushed below, so this queue must be flushed before them.
 	 */
 	flush_workqueue(fs_info->workers);
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1fb99e11aa8a..3081dbeae8d9 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -814,8 +814,12 @@ static void csum_one_bio_work(struct work_struct *work)
 
 /*
  * Calculate checksums of the data contained inside a bio.
+ *
+ * The checksums are calculated by a work queued on fs_info->workers, so they
+ * are not valid on return. This must be called before the bio is submitted, as
+ * the extra bio_inc_remaining() makes the bio completion wait for the work.
  */
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
+int btrfs_csum_one_bio(struct btrfs_bio *bbio)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
@@ -839,10 +843,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	btrfs_add_ordered_sum(ordered, sums);
 
 	bbio->csum_saved_iter = bio->bi_iter;
-	if (!async) {
-		csum_one_bio(bbio);
-		return 0;
-	}
 	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	queue_work(fs_info->workers, &bbio->csum_work);
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
index abf1db539c49..298ebbe71ccf 100644
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
 
@@ -696,13 +690,8 @@ struct btrfs_fs_info {
 	struct list_head delalloc_roots;
 
 	/*
-	 * There is a pool of worker threads for checksumming during writes and
-	 * a pool for checksumming after reads.  This is because readers can
-	 * run with FS locks held, and the writers may be waiting for those
-	 * locks.  We don't want ordering in the pending list to cause
-	 * deadlocks, and so the two are serviced separately.
-	 *
-	 * A third pool does submit_bio to avoid deadlocking with the other two.
+	 * @workers is the pool of worker threads for checksumming during
+	 * data writes.
 	 */
 	struct workqueue_struct *workers;
 	struct btrfs_workqueue *delalloc_workers;
-- 
2.56.0

