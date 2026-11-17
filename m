Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952134;
	b=5jSBEpZAdp+re+XCXj1LlPO7yUUaoKKbGXP/v3kVEqgYURalyzvh5lROVrupglFNZDsc
	 iAA6XyPyVPyFVY9837VOZ30ycQWn3l3Xd4+OCzNL0rjHMsyBZ8LVxxzchw3aWv5YaPxMe
	 9HzuLhzVTnLlrAZ694v9lvrEiOrFWjFn4eXMkby5NTzj5NoWc1GeZAHVCeBL7tiymdStV
	 2OhB99z4SDnE8l53A8muRnDdIxei1+Ro3FEs6z5oAmEgR+EY0chLjHb2KfIGrfQuOONr4
	 lef1K6vuaj0Ph7QEyYECUq/ejWbb1b916u9hB5qDp+mym+1NcK4CeQXrIynI485xFzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952134;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=2XRm3i4T136XGATaur233RlIJqclEC1Cy4fcsrA8P0k=;
	b=jZl+7u1TXQrCeSBsYOtxmIz0siIQVhVIqS7PJUyxkui830SNbgNoZqZQbHDuvEG+ZYmN
	 q8hv58ygYIEqVQatsRh9YkLv+lcmG6bcWrzuZ4EpKCnzsgMdr0nXmkd+0F2VSoMOyoyuN
	 oghy25N/XtEAdgCgRY3UbnKidHR0uqxSFbsxw4G4AzMhx6VaZoKi5gooUPcgG1E96grqR
	 PCTmgKuT+QrDrhAD0w9hKMOgzD/fTXoHQZnDAk5eGsun7VuDua8DOFykncA75ibbxZHNb
	 oYPVNGrCXwMlOo3DXorTLp4g24qjkIoDc8x0s1x0D3KIPIlV9vVTEg53BmjX5hwRtBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=aVc09kfa;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=aVc09kfa;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA03606A332;
	Tue, 17 Nov 2026 21:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCA03606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=aVc09kfa;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=aVc09kfa
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A4341F839;
	Tue, 17 Nov 2026 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794952132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2XRm3i4T136XGATaur233RlIJqclEC1Cy4fcsrA8P0k=;
	b=aVc09kfafJ2DxfUou8k2xoz7wDte2QwguNq5MicVzOJnFD4+Cys7p5mQpCM1VrlH5Kua9S
	veIgVWwtuQdGykgpuP3eeSvx52FTv4xQCpsQ4F94NKqCAYoB5uFwcDe8fwyB+LVGIKn/Vc
	ojnRu/B4q3GnRHOGmT1D5LKV6CqM/AU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794952132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2XRm3i4T136XGATaur233RlIJqclEC1Cy4fcsrA8P0k=;
	b=aVc09kfafJ2DxfUou8k2xoz7wDte2QwguNq5MicVzOJnFD4+Cys7p5mQpCM1VrlH5Kua9S
	veIgVWwtuQdGykgpuP3eeSvx52FTv4xQCpsQ4F94NKqCAYoB5uFwcDe8fwyB+LVGIKn/Vc
	ojnRu/B4q3GnRHOGmT1D5LKV6CqM/AU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C014913302;
	Tue, 17 Nov 2026 21:48:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FVJTGcDL/GoEBwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Tue, 17 Nov 2026 21:48:50 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: scrub: fix use-after-free when waking up the repair waiter
Date: Wed, 18 Nov 2026 08:18:29 +1030
Message-ID: <bcf557f882d3c7f9aff004612a0334f087a498a4.1794951798.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794951798.git.wqu@suse.com>
References: <cover.1794951798.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

The read-repair worker of a scrub_stripe can race with stripe freeing:

   CPU0 (repair worker)                CPU1 (scrub)
                                       btrfs_scrub_dev()
                                       |-scrub_enumerate_chunks()
                                       | \-scrub_chunk()
                                       |   \-scrub_stripe()
                                       |     \-flush_scrub_stripes()
                                       |       |-submit_initial_group_read()
                                       |       | The read bio is submitted
                                       |       | and read repair is
                                       |       | triggered.
   scrub_stripe_read_repair_worker()   |       |
   |-set_bit(REPAIR_DONE)              |       |
   | The waiter can see it now         |       \-wait_event()
   |                                   |         Checks the condition without
   |                                   |         taking repair_wait.lock, sees
   |                                   |         the bit and doesn't sleep
   |                                   |
   |                                   \-scrub_put_ctx()
   |                                     \-scrub_free_ctx()
   |                                       \-kvfree(sctx)
   |                                         Stripe freed
   |
   \-wake_up()
     \-_raw_spin_lock_irqsave()
       repair_wait.lock is in freed memory
       Too late.

The same applies to scrub_raid56_parity_stripe(), which allocates
scrub_stripe to scrub data stripes, and free them later.

Fix it by waiting with a completion instead. complete_all() wakes the
waiter under the completion's lock and does not touch it afterwards, and
wait_for_completion() returns only after taking that lock, so the stripe
can be freed as soon as the wait returns.

The completion is re-armed by scrub_reset_stripe(), which is called
before every refill of a stripe, i.e. after the previous waiter has
returned. The SCRUB_STRIPE_FLAG_REPAIR_DONE flag has no user left, remove
it.

This is the same problem fixed for the RAID56 rbio in commit
"btrfs: raid56: fix use-after-free when waking up the rbio I/O waiter".

Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair worker for scrub_stripe")
Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 98362c91bce4..4b37ae143f61 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -80,9 +80,6 @@ enum scrub_stripe_flags {
 	/* Set when @mirror_num, @dev, @physical and @logical are set. */
 	SCRUB_STRIPE_FLAG_INITIALIZED,
 
-	/* Set when the read-repair is finished. */
-	SCRUB_STRIPE_FLAG_REPAIR_DONE,
-
 	/*
 	 * Set for data stripes if it's triggered from P/Q stripe.
 	 * During such scrub, we should not report errors in data stripes, nor
@@ -153,7 +150,9 @@ struct scrub_stripe {
 	/* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_STRIPE_LEN. */
 	u32 stripe_len;
 	wait_queue_head_t io_wait;
-	wait_queue_head_t repair_wait;
+
+	/* Completed when the read-repair is finished. */
+	struct completion repair_done;
 
 	/*
 	 * Indicate the states of the stripe.  Bits are defined in
@@ -359,7 +358,7 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 	stripe->state = 0;
 
 	init_waitqueue_head(&stripe->io_wait);
-	init_waitqueue_head(&stripe->repair_wait);
+	init_completion(&stripe->repair_done);
 	atomic_set(&stripe->pending_io, 0);
 	spin_lock_init(&stripe->write_error_lock);
 
@@ -1234,8 +1233,7 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 	}
 
 	scrub_stripe_report_errors(sctx, stripe, &errors);
-	set_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &stripe->state);
-	wake_up(&stripe->repair_wait);
+	complete_all(&stripe->repair_done);
 }
 
 static void scrub_read_endio(struct btrfs_bio *bbio)
@@ -1762,6 +1760,7 @@ static void scrub_reset_stripe(struct scrub_stripe *stripe)
 	stripe->nr_meta_extents = 0;
 	stripe->nr_data_extents = 0;
 	stripe->state = 0;
+	reinit_completion(&stripe->repair_done);
 
 	for (int i = 0; i < stripe->nr_sectors; i++) {
 		stripe->sectors[i].csum = NULL;
@@ -1960,8 +1959,7 @@ static int flush_scrub_stripes(struct scrub_ctx *sctx)
 	for (int i = 0; i < nr_stripes; i++) {
 		stripe = &sctx->stripes[i];
 
-		wait_event(stripe->repair_wait,
-			   test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &stripe->state));
+		wait_for_completion(&stripe->repair_done);
 	}
 
 	/* Submit for dev-replace. */
@@ -2236,8 +2234,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 	for (int i = 0; i < data_stripes; i++) {
 		stripe = &sctx->raid56_data_stripes[i];
 
-		wait_event(stripe->repair_wait,
-			   test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &stripe->state));
+		wait_for_completion(&stripe->repair_done);
 	}
 	/* For now, no zoned support for RAID56. */
 	ASSERT(!btrfs_is_zoned(sctx->fs_info));
-- 
2.56.0

