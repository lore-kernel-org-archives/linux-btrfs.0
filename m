Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770590;
	b=U4yp7+tClw/zViHMn0ep9xMmN3om4vY3xwPH8WbsuFb6ecKK/k6arMePtRXTOrJAdTX3
	 5/kv3ZKdYKeW7VB81Bacbyk5RNa890gFOKoiaU/0RiIrErPIZB1vuHMKpPJHCdIEqFZ2r
	 vguuDDrip0gkH5iq4fDAVXW59oUDD0VgDHOsLfjuiB38WLjOE+Ud1MPAGKJ+LjDhKhfmI
	 EXMeRuEA/WZ8x9NRBGbgGmCDArSdHme05tsUwILmoWrlU98Q1tGFENZtbwSsHtd/Yq31P
	 wPfyfokiT0L25nOEgKVE0dVbdu/SNI3lVJaH+U4tWtwsvL+F8nyWO5mg4NJQAbIrVzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770590;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=Q5okmzYvi7Pla1TMe6u5Z8ZjlFtOkNVG9mKM1F+to1U=;
	b=tJ+xQGWMS19ZOtDPL+Vit0ZegRe6i0hyunGYD1fCw3A9l4grEsi54QPV11GKfdvpoYiV
	 3rKq3VU4TAHuapaNFnHeP2MfGP60WVdeCP8FrVG6tV63IXLGZGYaVITxnn8HvzXl/FBwi
	 im5ATZ3oNjBX1IpqJ6DoRY+wDsK3NG5iT4AocSH96MAioDfS53b06WISj4pU/mBsN7BSP
	 bOZXJncu55hUJpsYfzrBwGrpWuhUFsroi1UjnD2ERvfpIq+2O35rJd+SE/bnSiCUQwtPb
	 V/AuVk4rlFF/D59nYcxB80b4t8AB5HkG7TbPKOAzlHe/N1Fq7He2HVqkiWRQptJh0lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lhGpxBt2;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lhGpxBt2;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E6606A338
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 504E6606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lhGpxBt2;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lhGpxBt2
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67AE7227F1
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5okmzYvi7Pla1TMe6u5Z8ZjlFtOkNVG9mKM1F+to1U=;
	b=lhGpxBt2xvjTqAIB8KYgYf3zTbqTP0YKLALlCFNI1hLAfppenb4soZ2s0kUyf+iFmvPqPi
	5KQBAMVyNQ6dxboJ0bVAf7sXw+xTeMClP8a2LxcwHuyrSoOVUCbbfnhLEUwHYXqCXjgLxR
	iTSeledpLqgAnH65kCM3+JOejTrHUgI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=lhGpxBt2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5okmzYvi7Pla1TMe6u5Z8ZjlFtOkNVG9mKM1F+to1U=;
	b=lhGpxBt2xvjTqAIB8KYgYf3zTbqTP0YKLALlCFNI1hLAfppenb4soZ2s0kUyf+iFmvPqPi
	5KQBAMVyNQ6dxboJ0bVAf7sXw+xTeMClP8a2LxcwHuyrSoOVUCbbfnhLEUwHYXqCXjgLxR
	iTSeledpLqgAnH65kCM3+JOejTrHUgI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A7BA134E8
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KmCXKM9ICWu6BwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] btrfs: move async data csum generation out of experimental features
Date: Fri, 27 Nov 2026 19:39:17 +1030
Message-ID: <6076472b9e455efd9fd0fe704758a8033352093d.1795770362.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795770362.git.wqu@suse.com>
References: <cover.1795770362.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 67AE7227F1

The feature has been under experimental features for a long time, it's
time to enable it by default for end users.

This also means we can completely get rid of the current csum offload
for slow checksum algorithms.

The reasons to get rid of the slow csum offloading are:

- The conditions are hard to hit
  To offloading csum, the following conditions are needed:
  * Slow csum algorithm
    Only SHA256 and BLAKE2B are affected. Furthermore SHA256 have
    hardware acceleration for most platforms, thus the offloading may
    not even be beneficial.

  * Non-sync operations

  * Not metadata for zoned fs

  Which is not that easy to meet.

- The performance benefit for metadata is not obvious
  The workload involves:
  * 2K inlined writes
  * Link
  * Unlink

  Which is to stress the metadata write paths in a multi-thread way.
  And bpf shows more than half of the metadata writes go through the
  offloading path when enabled.

  For SHA256, the inlined one is around 3~5% faster than the existing csum
  offloading, and the benefit is pretty reliable.
  For BLAKE2B, the result is within 1.5% of each other, although async
  results is not that reliable.

So I do not think there is any need to support csum offloading for
metadata.
Furthermore, csum offloading for data will be completely replaced by the
async submission (generating csum with bio on the fly).

This means we can completely remove the csum offloading behavior, and
reuse the worker for async csum generation.

And now we can move the async data csum generation out of experimental
features.

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
index 740c3a8e071b..afff5811c8fc 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -564,120 +564,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
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
@@ -786,10 +673,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
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
@@ -804,7 +687,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	}
 
 	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
-done:
 	return map_length == length;
 
 fail:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 69a2c1a0855b..af2da33a6a52 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1842,6 +1842,10 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
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
@@ -2100,25 +2104,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
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
@@ -3491,7 +3476,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->csum_size = btrfs_super_csum_size(disk_super);
 	fs_info->csum_type = csum_type;
 
-	btrfs_init_csum_hash(fs_info, csum_type);
+	btrfs_info(fs_info, "using %s checksum algorithm",
+		   btrfs_super_csum_name(csum_type));
 
 	/*
 	 * We want to check superblock checksum, the type is stored inside.
@@ -4481,19 +4467,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
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
index af3c73189bc1..109806482733 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -813,8 +813,12 @@ static void csum_one_bio_work(struct work_struct *work)
 
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
@@ -840,10 +844,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
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
index 1b6e6cc7dab9..d730d5e65b1b 100644
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
2.56.1

