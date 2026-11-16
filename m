Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868483;
	b=cTpufeQ+IJ1wIMaejQ6Q52z/F14yeSERnPHl26eGjTdK8cAKqv0wcR9lvRBKhY15YnRp
	 UK4V5Yhsb/ivzBnWk0PZp5YgxO0vdavuzD3s8101iQn9KOU8kY9rOBXw0pj/zqRD4wZyw
	 c/vatwE+VoBV8WrfNVCIrnlDh4uvwnuqSbERRXqxUl63GsskqclXUziXGqmfEbf/p3+5o
	 UGNBx9qECPs2wLY4i5yC2d8Sh+SP8gdZCsk1rAbZGvVGMF4orBO5w7PuBSIIFt0w6enNv
	 2FLcWiIxZGI4dk6RitA8va0SFmCFRRaj2RJewRmk2O9a1d07L7dHI5J6ggFn3qgfzbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868483;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=UTNhy5iFBHI+tzAhRcUhCEvQNqj8C5CPchIyrNxDSBU=;
	b=bOtazveFhJyoVoUuF00l2EOY3bGTDLItNDQ9frcHNzmdBsypCWfqWoS5f5CEy6AAWl9I
	 2Ty1IJkEFTNddPgixvLaD6VjtM4pG6RKLZD2SYiZ73k930cjGXa2aiawU2fnybjwgOVYE
	 2oGz/EDWUhfPFlDHwy3TKxR5T2ObVN3KnGVL+nv+6nioGfYlPegrzGwaToDIIWJoSYMuV
	 X8N/hHL36nYZMvFH+dnNIDrLhJY2BdxXUjaKIRhQdTmTv7jtDgchLtpVcK2v+peVdjslt
	 jKCsHP7nkMLiYmcHuJWzmsAjUTyP8IqanvvxamMbgPGubH/iz2Q+4FHR6K1aNl1qj/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rbtb1x0j;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sotOQ+ud;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3492606A337;
	Mon, 16 Nov 2026 22:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3492606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rbtb1x0j;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sotOQ+ud
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA5DB1F899;
	Mon, 16 Nov 2026 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTNhy5iFBHI+tzAhRcUhCEvQNqj8C5CPchIyrNxDSBU=;
	b=Rbtb1x0jd1Z11ItSkipeh5FBUSEo+UQsh9kdpTsnSIxAx5Sh/8nmq5ANsfqXkzjATUdtzG
	s8xXAvTUk2SJ3rJPjz4Dhb70a9U4aovMkoaihTn7NWNfF+/Z94h163W4dS52vJwweoexaF
	oPYsuVQ3w0fms4BjwxuN5zBNxWWcjUc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=sotOQ+ud
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTNhy5iFBHI+tzAhRcUhCEvQNqj8C5CPchIyrNxDSBU=;
	b=sotOQ+udbPLhmcj4esfO2ZEqQEX5vFBjXTPvDWMn7l22axFXFWqgOt4Bqn+i0RwVsbKRX8
	WCwSPwmgruJTMXfnE5oPpgXJ5+I0ENmhRzJ8nDyGPI+VwRpp5lcuu2dNiTwYYhPb8MpXuC
	x/B39xjNySkwx9Tf9co+FLuAaJDn70Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E089134B8;
	Mon, 16 Nov 2026 22:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tMNxC/uE+2p2ZwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Mon, 16 Nov 2026 22:34:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 2/2] btrfs: scrub: fix use-after-free when waking up the stripe I/O waiter
Date: Tue, 17 Nov 2026 09:04:17 +1030
Message-ID: <51527ea5f9f456a7ebe70b7fcaf626fac3dab945.1794867985.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794867985.git.wqu@suse.com>
References: <cover.1794867985.git.wqu@suse.com>
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: EA5DB1F899

The scrub_write_endio() can race with scrub finishing, which can lead to
use-after-free:

 CPU0 (write endio)                  CPU1 (scrub)
 scrub_write_endio()                 flush_scrub_stripes()
 |                                   |-wait_scrub_stripe_io()
 |                                   | \-wait_event()
 |                                   |   ^^^ checks the condition without
 |                                   |       taking io_wait.lock
 |-atomic_dec_and_test()             |
 | ^^^ pending_io hits 0             |
 |                                   | ^^^ sees 0, doesn't sleep
 |                                   |
 |                                   btrfs_scrub_dev()
 |                                   \-scrub_put_ctx()
 |                                     \-scrub_free_ctx()
 |                                       ^^^ stripe freed
 |
 \-wake_up()
   \-_raw_spin_lock_irqsave()
     ^^^ io_wait.lock is in freed memory
         Too late.

Fix it by waiting with a completion instead. complete_all() wakes the
waiter under the completion's lock and does not touch it afterwards, and
wait_for_completion_io() returns only after taking that lock, so the
stripe can be freed as soon as the wait returns.

There are locations that we submit multiple bios in one go, with extra
care the pending_io can reach 0 during the submission, to address it:

- Re-arm the completion when the first pending_io ref is taken, in
  scrub_stripe_get_io(). Any previous round of IO is waited for before the
  next one starts.

- Hold one extra ref for batched submission
  This includes:
  * scrub_write_sectors()
  * scrub_stripe_submit_repair_read() for non-zoned cases

  This is the same pattern used in other scrub path.

The completion is initialized as completed, so waiting on a stripe without
any pending IO returns immediately as before.

This is the same problem fixed for the RAID56 rbio in commit
26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbio
I/O waiter").

Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair worker for scrub_stripe")
Fixes: 058e09e6fe7c ("btrfs: scrub: introduce a writeback helper for scrub_stripe")
Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 97 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4b37ae143f61..a8c62a3aea0c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -149,7 +149,9 @@ struct scrub_stripe {
 	atomic_t pending_io;
 	/* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_STRIPE_LEN. */
 	u32 stripe_len;
-	wait_queue_head_t io_wait;
+
+	/* Completed by the last endio when pending_io drops to zero. */
+	struct completion io_done;
 
 	/* Completed when the read-repair is finished. */
 	struct completion repair_done;
@@ -357,9 +359,11 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 	stripe->stripe_len = BTRFS_STRIPE_LEN;
 	stripe->state = 0;
 
-	init_waitqueue_head(&stripe->io_wait);
 	init_completion(&stripe->repair_done);
+	init_completion(&stripe->io_done);
 	atomic_set(&stripe->pending_io, 0);
+	/* No pending IO by default, thus nothing to wait. */
+	complete_all(&stripe->io_done);
 	spin_lock_init(&stripe->write_error_lock);
 
 	stripe->buffer = kvmalloc(BTRFS_STRIPE_LEN, GFP_KERNEL);
@@ -381,9 +385,25 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 	return -ENOMEM;
 }
 
+static void scrub_stripe_get_io(struct scrub_stripe *stripe)
+{
+	/* The first pending IO re-arms the completion. */
+	if (atomic_inc_return(&stripe->pending_io) == 1)
+		reinit_completion(&stripe->io_done);
+}
+
+/* Drop one pending IO, return true if it was the last one. */
+static bool scrub_stripe_put_io(struct scrub_stripe *stripe)
+{
+	if (!atomic_dec_and_test(&stripe->pending_io))
+		return false;
+	complete_all(&stripe->io_done);
+	return true;
+}
+
 static void wait_scrub_stripe_io(struct scrub_stripe *stripe)
 {
-	wait_event(stripe->io_wait, atomic_read(&stripe->pending_io) == 0);
+	wait_for_completion_io(&stripe->io_done);
 }
 
 static void scrub_put_ctx(struct scrub_ctx *sctx);
@@ -891,8 +911,7 @@ static void scrub_repair_read_endio(struct btrfs_bio *bbio)
 
 	scrub_read_endio_common(bbio);
 
-	if (atomic_dec_and_test(&stripe->pending_io))
-		wake_up(&stripe->io_wait);
+	scrub_stripe_put_io(stripe);
 }
 
 static int calc_next_mirror(int mirror, int num_copies)
@@ -941,6 +960,18 @@ static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
 	return bbio;
 }
 
+static void scrub_submit_repair_read_bio(struct scrub_stripe *stripe,
+					 struct btrfs_bio *bbio, int mirror,
+					 bool wait)
+{
+	ASSERT(bbio->bio.bi_iter.bi_size);
+
+	scrub_stripe_get_io(stripe);
+	btrfs_submit_bbio(bbio, mirror);
+	if (wait)
+		wait_scrub_stripe_io(stripe);
+}
+
 static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 					    int mirror, int blocksize, bool wait)
 {
@@ -953,15 +984,19 @@ static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 	ASSERT(atomic_read(&stripe->pending_io) == 0,
 	       "atomic_read(&stripe->pending_io)=%d", atomic_read(&stripe->pending_io));
 
+	/*
+	 * Hold an extra ref during submission, so the IO can not be reported as
+	 * finished before all bios are submitted.
+	 * If we wait for every bio, no extra ref as it would block the wait.
+	 */
+	if (!wait)
+		scrub_stripe_get_io(stripe);
+
 	for_each_set_bit(i, &old_error_bitmap, stripe->nr_sectors) {
 		/* The current sector cannot be merged, submit the bio. */
 		if (bbio && ((i > 0 && !test_bit(i - 1, &old_error_bitmap)) ||
 			     bbio->bio.bi_iter.bi_size >= blocksize)) {
-			ASSERT(bbio->bio.bi_iter.bi_size);
-			atomic_inc(&stripe->pending_io);
-			btrfs_submit_bbio(bbio, mirror);
-			if (wait)
-				wait_scrub_stripe_io(stripe);
+			scrub_submit_repair_read_bio(stripe, bbio, mirror, wait);
 			bbio = NULL;
 		}
 
@@ -973,13 +1008,10 @@ static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 
 		scrub_bio_add_sector(bbio, stripe, i);
 	}
-	if (bbio) {
-		ASSERT(bbio->bio.bi_iter.bi_size);
-		atomic_inc(&stripe->pending_io);
-		btrfs_submit_bbio(bbio, mirror);
-		if (wait)
-			wait_scrub_stripe_io(stripe);
-	}
+	if (bbio)
+		scrub_submit_repair_read_bio(stripe, bbio, mirror, wait);
+	if (!wait)
+		scrub_stripe_put_io(stripe);
 }
 
 static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
@@ -1242,8 +1274,7 @@ static void scrub_read_endio(struct btrfs_bio *bbio)
 
 	scrub_read_endio_common(bbio);
 
-	if (atomic_dec_and_test(&stripe->pending_io)) {
-		wake_up(&stripe->io_wait);
+	if (scrub_stripe_put_io(stripe)) {
 		INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker);
 		queue_work(stripe->bg->fs_info->scrub_workers, &stripe->work);
 	}
@@ -1269,8 +1300,7 @@ static void scrub_write_endio(struct btrfs_bio *bbio)
 	}
 	bio_put(&bbio->bio);
 
-	if (atomic_dec_and_test(&stripe->pending_io))
-		wake_up(&stripe->io_wait);
+	scrub_stripe_put_io(stripe);
 }
 
 static void scrub_submit_write_bio(struct scrub_ctx *sctx,
@@ -1283,7 +1313,7 @@ static void scrub_submit_write_bio(struct scrub_ctx *sctx,
 		      stripe->logical;
 
 	fill_writer_pointer_gap(sctx, stripe->physical + bio_off);
-	atomic_inc(&stripe->pending_io);
+	scrub_stripe_get_io(stripe);
 	btrfs_submit_repair_write(bbio, stripe->mirror_num, dev_replace);
 	if (!btrfs_is_zoned(fs_info))
 		return;
@@ -1322,6 +1352,15 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 	struct btrfs_bio *bbio = NULL;
 	int sector_nr;
 
+	/*
+	 * Hold an extra ref during submission, so the IO can not be reported as
+	 * finished before all bios are submitted.
+	 * For zoned, we wait for every bio, no extra ref as it would block the
+	 * wait.
+	 */
+	if (!btrfs_is_zoned(fs_info))
+		scrub_stripe_get_io(stripe);
+
 	for_each_set_bit(sector_nr, &write_bitmap, stripe->nr_sectors) {
 		/* We should only writeback sectors covered by an extent. */
 		ASSERT(scrub_bitmap_test_bit_has_extent(stripe, sector_nr));
@@ -1340,6 +1379,8 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 	}
 	if (bbio)
 		scrub_submit_write_bio(sctx, stripe, bbio, dev_replace);
+	if (!btrfs_is_zoned(fs_info))
+		scrub_stripe_put_io(stripe);
 }
 
 /*
@@ -1786,7 +1827,8 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 	int mirror = stripe->mirror_num;
 	int i;
 
-	atomic_inc(&stripe->pending_io);
+	/* The extra ref is dropped after all bios are submitted. */
+	scrub_stripe_get_io(stripe);
 
 	for_each_set_bit(i, &has_extent, stripe->nr_sectors) {
 		/* We're beyond the chunk boundary, no need to read anymore. */
@@ -1798,7 +1840,7 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 		    ((i > 0 && !test_bit(i - 1, &has_extent)) ||
 		     bbio->bio.bi_iter.bi_size >= stripe_len)) {
 			ASSERT(bbio->bio.bi_iter.bi_size);
-			atomic_inc(&stripe->pending_io);
+			scrub_stripe_get_io(stripe);
 			btrfs_submit_bbio(bbio, mirror);
 			bbio = NULL;
 		}
@@ -1844,12 +1886,11 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 
 	if (bbio) {
 		ASSERT(bbio->bio.bi_iter.bi_size);
-		atomic_inc(&stripe->pending_io);
+		scrub_stripe_get_io(stripe);
 		btrfs_submit_bbio(bbio, mirror);
 	}
 
-	if (atomic_dec_and_test(&stripe->pending_io)) {
-		wake_up(&stripe->io_wait);
+	if (scrub_stripe_put_io(stripe)) {
 		INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker);
 		queue_work(stripe->bg->fs_info->scrub_workers, &stripe->work);
 	}
@@ -1877,7 +1918,7 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 	/* Read the whole range inside the chunk boundary. */
 	for (unsigned int cur = 0; cur < nr_sectors; cur++)
 		scrub_bio_add_sector(bbio, stripe, cur);
-	atomic_inc(&stripe->pending_io);
+	scrub_stripe_get_io(stripe);
 
 	/*
 	 * For dev-replace, either user asks to avoid the source dev, or
-- 
2.56.0

