Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261852;
	b=AEQdFg0t5atwYhoSv06PHj5cY+WgOedXnkttIqq7rKmRpnZ9QcWJt9KjJ9giuxU9kql/
	 339+J74P68jyNexhvfnTXHD0gxVKuCOPW6zlF8mJz+Nvb9cN4WussLHBr+Bwta1NfHddE
	 ewsP0ZcApK5nzDLSgSecQqpFSR3g4gGr+FXpBUZ5PY5cppKOm/2navK5mNWGSjccu4+nQ
	 TcLAvwKi/ywmrBT4ugKy5+sUcaey9qGgTKmJz/Aq4mdPo2oCFPu2kupGz+1JSK94KeTnF
	 cEU16/ZgNL0fZCjyXl0Ec1WwciKIni8jlzT91dPXOT0+8gV3ozgVBFZZU/DYYejBNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261852;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=/Qz5w3rjE+M93LaBM+/itVhwGEL9sQz7aBaOStw+8eg=;
	b=lJ00DOrgPoVE8/NG+DHirz2Q4/zhRS776h/oEO2t6LQBOOzg+tg8Kvi8pTy6iu4tggJP
	 vXyIlv9iZnSyEl3Qq9dyWX978V65u74Altg11X8pzvouXQoW/GpyJZXNldUFAruBANvP/
	 paKqzhhuOsc4+sf9lor6xX8ySm5X9qTuOyXGbLtiInFepb9DzDQdlmwX+zLjhctGm6Z8P
	 m2+RTT3dV8caZAxCjg5vF1XwMgSxJvx2/1us1oEcKM7I6P7H8/IKrYGJPQ8AaYXIReYCk
	 zd0Mw+gu7WuUKrDhHj+Ts/A61onN4GVk5ZXQBCLSnqLIxOv/jAeCdIfbcDefq+oWJKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ebKn3rLF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ebKn3rLF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD5606A325
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0CD5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ebKn3rLF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ebKn3rLF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF6892205F
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Qz5w3rjE+M93LaBM+/itVhwGEL9sQz7aBaOStw+8eg=;
	b=ebKn3rLFIKbbn7ZNA9YBIiZrHE16U2q62L5GYqpTWO0zNLNJIHExpB3zndp0OLmj68CGjk
	DawANBNXRgNkkIZWk21rQF+y6sVPvoMLyN0JFsgcCLvQD4xqqTL5t9rJCZg6YGvRjf6D8Z
	9pAZeNlny1/LA6R6JxfnTjzS/MnjfuM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ebKn3rLF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Qz5w3rjE+M93LaBM+/itVhwGEL9sQz7aBaOStw+8eg=;
	b=ebKn3rLFIKbbn7ZNA9YBIiZrHE16U2q62L5GYqpTWO0zNLNJIHExpB3zndp0OLmj68CGjk
	DawANBNXRgNkkIZWk21rQF+y6sVPvoMLyN0JFsgcCLvQD4xqqTL5t9rJCZg6YGvRjf6D8Z
	9pAZeNlny1/LA6R6JxfnTjzS/MnjfuM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE15513479
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3OosElZD8moUPAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 22:04:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: make btrfs_fs_info::workers to be a regular workqueue
Date: Tue, 10 Nov 2026 08:33:39 +1030
Message-ID: <7e5b2733258fddd90462546e10ec75fa3823e688.1794261158.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: CF6892205F

The workers workqueue is only utilized by csum generation offloading
path, which has quite some requirements to meet:

- Non-experimental builds
  Experimental builds are already submitting bios before csum generation
  is finished, which has more concurrency than this method, and still
  ensures the submission sequence is followed.

- Slow csum algorithms
- Non-sync IOs
  Otherwise offloading into a workqueue is only to cause more context
  switch and overhead.

- Not metadata zoned writes

The biggest one that requires sequential submission is already excluded.

So there is not really much need to use btrfs workqueue for the
sequential submission.

Change from a btrfs workqueue to a regular workqueue.
This will make some bios submission out of their original order, but the
order will be back after the async csum generation feature is out of
experimental, which is very soon.

The main objective of this change is to prepare for the incomine async
csum generation as default.
As the previous endio_workers sharing can still cause problems related
to the workqueue flush.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c       | 53 ++++++++++++++------------------------------
 fs/btrfs/disk-io.c   | 14 +++++++-----
 fs/btrfs/file-item.c |  2 +-
 fs/btrfs/fs.h        |  2 +-
 fs/btrfs/super.c     |  2 +-
 5 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2e12a6d7e16f..508b44841768 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -10,7 +10,6 @@
 #include "ctree.h"
 #include "volumes.h"
 #include "raid56.h"
-#include "async-thread.h"
 #include "dev-replace.h"
 #include "zoned.h"
 #include "file-item.h"
@@ -579,7 +578,7 @@ struct async_submit_bio {
 	struct btrfs_io_context *bioc;
 	struct btrfs_io_stripe smap;
 	int mirror_num;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
 /*
@@ -588,45 +587,27 @@ struct async_submit_bio {
  * sums are attached onto the ordered extent record.
  *
  * At IO completion time the csums attached on the ordered extent record are
- * inserted into the btree.
+ * inserted into the tree.
  */
-static void run_one_async_start(struct btrfs_work *work)
+static void run_one_async_submit(struct work_struct *work)
 {
 	struct async_submit_bio *async =
 		container_of(work, struct async_submit_bio, work);
+	struct btrfs_bio *bbio = async->bbio;
+	struct btrfs_io_context *bioc = async->bioc;
+	struct btrfs_io_stripe smap = async->smap;
+	const int mirror_num = async->mirror_num;
+	struct bio *bio = &bbio->bio;
 	int ret;
 
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
+	kfree(async);
 
 	/* If an error occurred we just want to clean up the bio and move on. */
-	if (bio->bi_status) {
-		btrfs_put_bioc(async->bioc);
-		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
-		btrfs_bio_end_io(async->bbio, bio->bi_status);
+	ret = btrfs_bio_csum(bbio);
+	if (ret) {
+		btrfs_put_bioc(bioc);
+		btrfs_bio_counter_dec(bbio->inode->root->fs_info);
+		btrfs_bio_end_io(bbio, errno_to_blk_status(ret));
 		return;
 	}
 
@@ -636,7 +617,7 @@ static void run_one_async_done(struct btrfs_work *work, bool do_free)
 	 * context.  This changes nothing when cgroups aren't in use.
 	 */
 	bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
-	btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
+	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
 }
 
 static bool should_async_write(struct btrfs_bio *bbio)
@@ -692,8 +673,8 @@ static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
 	async->smap = *smap;
 	async->mirror_num = mirror_num;
 
-	btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
-	btrfs_queue_work(fs_info->workers, &async->work);
+	INIT_WORK(&async->work, run_one_async_submit);
+	queue_work(fs_info->workers, &async->work);
 	return true;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 35a43e7cb937..e69055d84606 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1829,7 +1829,8 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
-	btrfs_destroy_workqueue(fs_info->workers);
+	if (fs_info->workers)
+		destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
 		destroy_workqueue(fs_info->endio_workers);
 	if (fs_info->rmw_workers)
@@ -2040,8 +2041,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
-	fs_info->workers =
-		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
+	fs_info->workers = alloc_workqueue("btrfs-worker", flags, max_active);
 
 	fs_info->delalloc_workers =
 		btrfs_alloc_workqueue(fs_info, "delalloc",
@@ -4469,14 +4469,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * We can have ordered extents getting their last reference dropped from
 	 * the fs_info->workers queue because for async writes for data bios we
 	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
-	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
+	 * run_one_async_submit() which calls btrfs_bio_end_io() in case the bio
 	 * has an error, and that later function can do the final
 	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
 	 * which adds a delayed iput for the inode. So we must flush the queue
 	 * so that we don't have delayed iputs after committing the current
 	 * transaction below and stopping the cleaner and transaction kthreads.
+	 *
+	 * That queue also runs the async checksum work, csum_one_bio_work(),
+	 * whose bio_endio() can lead to work being queued on the endio queues
+	 * flushed below, so it must be flushed before them.
 	 */
-	btrfs_flush_workqueue(fs_info->workers);
+	flush_workqueue(fs_info->workers);
 
 	/*
 	 * When finishing a compressed write bio we schedule a work queue item
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ff8f8cad00fc..1fb99e11aa8a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -845,7 +845,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	}
 	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
-	queue_work(fs_info->endio_workers, &bbio->csum_work);
+	queue_work(fs_info->workers, &bbio->csum_work);
 	return 0;
 }
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..abf1db539c49 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -704,7 +704,7 @@ struct btrfs_fs_info {
 	 *
 	 * A third pool does submit_bio to avoid deadlocking with the other two.
 	 */
-	struct btrfs_workqueue *workers;
+	struct workqueue_struct *workers;
 	struct btrfs_workqueue *delalloc_workers;
 	struct btrfs_workqueue *flush_workers;
 	struct workqueue_struct *endio_workers;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..c554391aeb5a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1235,7 +1235,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_info(fs_info, "resize thread pool %d -> %d",
 	       old_pool_size, new_pool_size);
 
-	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
+	workqueue_set_max_active(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
-- 
2.56.0

