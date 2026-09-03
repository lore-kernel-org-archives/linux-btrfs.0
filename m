Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8803C5832
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 08:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424821; cv=none; b=p/CkoTQ2x99vLuZnJ3py4hZWj8YSoq5WCDJCXHNKT1yJDcBWPYJW+JWAqVMvVN3flssK7uhgIEMuUnV/RBsAMYFrWMs6Tuz7Ym82zIl9bmEhsN6FnG0QGt8cigeAAbq4ATx5y6h3a7YJ0QEgYrbpZ1snJtEFcXV29aRyeiPrc24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424821; c=relaxed/simple;
	bh=r3tljMrjpc3A1yLqdrLxT6jHmIi2kKsntZEDQiC3REc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ui+/mX7hkejcjYUaBqpTDz+JGdtTDMTWZIU4k3zVKpaSi4HdVYm4k0d4qvk6fDf/OechXbWm5roqCG9IhuEkk0jv8kFCEl9ZCYI3vPeFw3H1KCF+NzciddjPMtAnHfwrp/Vg5sxUGEuL82LsgztOYsPc8q6hjppyPRHLdHZS/WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=E5wiRrbJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H45rtH/g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="E5wiRrbJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H45rtH/g"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 930D21FDFF;
	Thu,  3 Sep 2026 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788424812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5a7rIee4wy4LUv/AnBoDJrZ2cN8XiJ4d8PdJK5x2GCk=;
	b=E5wiRrbJMqNgRTe5htqfq+jQelLeJMUO5r6TOeELraBG+u69mdacvSEoYxbao0ExNP+uYn
	+v9gohAi2U7zdLw/vF40RJUmVI5cfydk1rCpxQ5UX7FrXeNCEyP0hW25moENOR8JhwSgve
	IUb4Xap0zNnZAeA3YsiV8nqW1uimEOg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788424808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5a7rIee4wy4LUv/AnBoDJrZ2cN8XiJ4d8PdJK5x2GCk=;
	b=H45rtH/gsMRMZmlCKYgUQkpvQLbHXlmvXwyYR2d4YDK1cj/V2sAK/uARFf/WLJGO2NW3JC
	R7TEy1Txn7KxnTv+iEhHCsMUWMvxw5YJwaSpM450xTFnrsTdCb/aeT/84vlsDW+Hk0wPiW
	RNi3lDWHoGJ01XZMPfEj00GWjhKSYKs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7E61136E6;
	Thu,  3 Sep 2026 08:40:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ib63IWYymWq6MwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 03 Sep 2026 08:40:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Daniel Vacek <neelx@suse.com>
Subject: [PATCH] btrfs: move async csum generation out of experimental features
Date: Thu,  3 Sep 2026 18:09:41 +0930
Message-ID: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO

Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
introduced asynchronous data checksum generation for data writes.

That feature can improve write performance, and was introduced in v6.19.
We have not experienced bugs related to that, so it's time to move it out
of experimental features for end users.

Furthermore since the async checksum generation means
should_async_write() will always return false, we no longer need to
maintain the fs_info->workers workqueue, as the async checksum
generation is using the system_percpu_wq.

Suggested-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c       | 136 +------------------------------------------
 fs/btrfs/disk-io.c   |  20 +------
 fs/btrfs/file-item.c |   6 +-
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  10 ----
 fs/btrfs/super.c     |   1 -
 6 files changed, 4 insertions(+), 171 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 771b7d598aee..e08006543c3d 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
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
@@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
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
@@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	}
 
 	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
-done:
 	return map_length == length;
 
 fail:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d83ad9a4c0..0046f3cb75a1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
-	btrfs_destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
 		destroy_workqueue(fs_info->endio_workers);
 	if (fs_info->rmw_workers)
@@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
-	fs_info->workers =
-		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
-
 	fs_info->delalloc_workers =
 		btrfs_alloc_workqueue(fs_info, "delalloc",
 				      flags, max_active, 2);
@@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->discard_ctl.discard_workers =
 		alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
 
-	if (!(fs_info->workers &&
-	      fs_info->delalloc_workers && fs_info->flush_workers &&
+	if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_write_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
@@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
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
index 0fed4e0d32d5..7dbd9b8eec11 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct *work)
 /*
  * Calculate checksums of the data contained inside a bio.
  */
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
+int btrfs_csum_one_bio(struct btrfs_bio *bbio)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
@@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	btrfs_add_ordered_sum(ordered, sums);
 
 	bbio->csum_saved_iter = bio->bi_iter;
-	if (!async) {
-		csum_one_bio(bbio);
-		return 0;
-	}
 	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
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
index 3eba8438593c..203f7131f737 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -696,16 +696,6 @@ struct btrfs_fs_info {
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
index 464129b1b0d4..54f2da47c567 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_info(fs_info, "resize thread pool %d -> %d",
 	       old_pool_size, new_pool_size);
 
-	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
-- 
2.55.0

