Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770588;
	b=dZ8iI+tTGsd/CxEiEQBHH6YUhDSxisfxczG8cg9p+wqgzGu6qlayNIdodKCszdtxBtJP
	 TFjuORvL6sj7FizDpmTN2gz5nanvWTdw131sFBl/mK3jmlfHusDLd5ORi1vE+SwpND6T5
	 Msqz7Kbteh4CHm1CudCawY2ESosb4VmHLCuJvo+j/sdF2VAUK0tnun94xNXc3RtTcCnoH
	 I3JFxtES3k0IGWcUaYR5I/K+1LeEcNMEB4w8LFR82AXmIgnPy3qMInq3Ip9AmQ2O475ha
	 rzno77XiGy0KkjXegVO+R4qqsFaeywilMXMYXMZ/JcXav1aUTgldJS3HB3JhS3gVc0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770588;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=pDpO2mR03zU/fb26i3KiB523rShKa/FTK7fdstriEK4=;
	b=cH9kbWLPSykIj55HAXeUc1D5k8XXTBH5uDc/3g9q7I0O39YWYSxCjgUdcxRI3NUSz/yN
	 ebU+4XGmheOoituP+0jsbq/us0xrXzIRvNyHj2TowxkktQ45w0yrAlLSeM/854v9j63YC
	 2GGGoKytjICzpzS2Y6op31GQmT7N17oriItzdha2UStuNi5tA0gtAQSRP/XjNNDLXTT1J
	 Nwd31cDYdbigyDu2vTWX+VY60IgJkWZk4YaBxGKbB3Wi4COY6/t3wSMTtydnAC4IA/zJa
	 OUAfgbMz2Vgf4s4OheMOJ75GnoTEba+ZuIXbidTQQYkxM5YGwB13gEagBdjYS0dILyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nMAFBNah;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nMAFBNah;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56643606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56643606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nMAFBNah;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nMAFBNah
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C94BA2277A
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDpO2mR03zU/fb26i3KiB523rShKa/FTK7fdstriEK4=;
	b=nMAFBNahDxYwe9MSXnlWdvgvR302XTWIZCi1z7RIyM1vIBdbit6e/bAzkHk5mJ0RpEekjd
	g5ikwehWUf+vRPnP+EcfH0m4RzxK1hlxwF1Q1Wkm6awwJ6AJA86wf06xS8zgNix1N19MG4
	BSS8xEvAD/7WjJomn6N6vf/725Po31s=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDpO2mR03zU/fb26i3KiB523rShKa/FTK7fdstriEK4=;
	b=nMAFBNahDxYwe9MSXnlWdvgvR302XTWIZCi1z7RIyM1vIBdbit6e/bAzkHk5mJ0RpEekjd
	g5ikwehWUf+vRPnP+EcfH0m4RzxK1hlxwF1Q1Wkm6awwJ6AJA86wf06xS8zgNix1N19MG4
	BSS8xEvAD/7WjJomn6N6vf/725Po31s=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EAAF134E8
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KmCXKM9ICWu6BwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: make btrfs_fs_info::workers to be a regular workqueue
Date: Fri, 27 Nov 2026 19:39:16 +1030
Message-ID: <3a4efbfc925d5aff35740ddeeea971be84210e3d.1795770362.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
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

The biggest feature (zoned) that requires sequential submission is
already excluded.

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
index b90ca97c9c4d..740c3a8e071b 100644
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
@@ -581,7 +580,7 @@ struct async_submit_bio {
 	struct btrfs_io_context *bioc;
 	struct btrfs_io_stripe smap;
 	int mirror_num;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
 /*
@@ -590,45 +589,27 @@ struct async_submit_bio {
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
 
@@ -638,7 +619,7 @@ static void run_one_async_done(struct btrfs_work *work, bool do_free)
 	 * context.  This changes nothing when cgroups aren't in use.
 	 */
 	bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
-	btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
+	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
 }
 
 static bool should_async_write(struct btrfs_bio *bbio)
@@ -694,8 +675,8 @@ static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
 	async->smap = *smap;
 	async->mirror_num = mirror_num;
 
-	btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
-	btrfs_queue_work(fs_info->workers, &async->work);
+	INIT_WORK(&async->work, run_one_async_submit);
+	queue_work(fs_info->workers, &async->work);
 	return true;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fde9f4c4ea11..69a2c1a0855b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1842,7 +1842,8 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
-	btrfs_destroy_workqueue(fs_info->workers);
+	if (fs_info->workers)
+		destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
 		destroy_workqueue(fs_info->endio_workers);
 	if (fs_info->rmw_workers)
@@ -2053,8 +2054,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
-	fs_info->workers =
-		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
+	fs_info->workers = alloc_workqueue("btrfs-worker", flags, max_active);
 
 	fs_info->delalloc_workers =
 		btrfs_alloc_workqueue(fs_info, "delalloc",
@@ -4484,14 +4484,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
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
index e19d4c1c754a..af3c73189bc1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -846,7 +846,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	}
 	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
-	queue_work(fs_info->endio_workers, &bbio->csum_work);
+	queue_work(fs_info->workers, &bbio->csum_work);
 	return 0;
 }
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index cdb78c8e1b4b..1b6e6cc7dab9 100644
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
index 2609d7783e8a..691b5d36e618 100644
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
2.56.1

