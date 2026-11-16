Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868483;
	b=vyPk8an3M1rDrah49w6wVqgGQ56n0CvjqpBi2v4SqzjwSDGn9Q4WhLYi7qBl4/ClaRYX
	 cD7gLZEH8ehaMv1gLY1bB54jU30hhYvpDMCmdq09ZMLeJHoovwD8A1YXSxRqCCkcu03TX
	 xboCnsLlDyJJrop7YJXWjPPduDRllDLGTetBzPASZWbQLc8xGYFpBPbr58WAk/wE5Ptnl
	 S7n28AXPdkKp7dyIWZqkAbe22/13rShfjlUPl3KZED8aKnPmz8D4Ol7JRswzqycPbDvCd
	 acxesWO+l5CCUptz6P9U1yPN6piJUz5jvUn3nNy0iIa/sjJ+3cxzkJPU7Bx8qmMEj1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868483;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=1nsdcP6EWm98cPheGtN2mzwCS7JvRHvEaxSnDwHM7VM=;
	b=SYORvh0JWc9gBRBySgmRHOxFS9CddVyC3c7Xc2tegFu5x3G6SqxWpzJR5ALfn7oRW6YQ
	 qTEBszpTjGl2ww1+8yUVEgtLNJYHSi0yHmD5hQUcmF5e55We3tLfnsOI9GWydxcc//R6G
	 /w1lb7iPSFx8oyQu0/lygwhVXm81NQciD+OylbKm7e6CWWi51tCXp8fdDrR5J6RqMKk76
	 NDEebV1CMUeYiq0TEXe4/QGsQMlhFPGifLqP4LBRreA5NaIGpcr57uwpXzrpWyMg6Bde9
	 ZZeNVBVbmkyO34aE+3LxHAl7AbxGmgblpmDkFTZ1afirHOnQaJtQi4w2vF4pQG/Dd1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=X9cwObg0;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XG9kP77s;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA1606A33E;
	Mon, 16 Nov 2026 22:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBCA1606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=X9cwObg0;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XG9kP77s
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F05742228A;
	Mon, 16 Nov 2026 22:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nsdcP6EWm98cPheGtN2mzwCS7JvRHvEaxSnDwHM7VM=;
	b=X9cwObg05/yO4YqUYvyz/yAZWWHAPqQMhpLX2AyhrqNdEiG2fEC92jyS98N9rHo/FbzuZu
	QeHDoFZlo83mOXM3r0uRaZkvDoLQDRiRErbhLGCgWyvdpOCKB0BT0JkEgXSAmLdmwAduSO
	7w+0mqcoQEbpfu1gM8txZF251ntgLHc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XG9kP77s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nsdcP6EWm98cPheGtN2mzwCS7JvRHvEaxSnDwHM7VM=;
	b=XG9kP77sskZok96gbA+UdagRzLlETjoCmaJbxeJL32ZkD46fTcKoutoZXMqwWyErK/xR59
	pLX4o5h0u5HqMDtBF5YM4Io2H23HfatBFJ87MBLJeC6UgdmN1+pB2TCxfzHN2aGpqXe52g
	GMU3z+xNMCp6St3ZwHDp4AwWnxsmPg0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 805AB1334C;
	Mon, 16 Nov 2026 22:34:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tMNxC/uE+2p2ZwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Mon, 16 Nov 2026 22:34:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: scrub: fix use-after-free when waking up the repair waiter
Date: Tue, 17 Nov 2026 09:04:16 +1030
Message-ID: <217e66b15e1646812cc86be582be67b7e558b270.1794867985.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: F05742228A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

The read-repair worker of a scrub_stripe can race with stripe freeing:

 CPU0 (repair worker)                CPU1 (scrub)
 scrub_stripe_read_repair_worker()   scrub_raid56_parity_stripe()
 |                                   |-wait_event()
 |                                   | ^^^ checks the condition without
 |                                   |     taking repair_wait.lock
 |-set_bit(REPAIR_DONE)              |
 | ^^^ the waiter can see it now     | ^^^ sees the bit, doesn't sleep
 |                                   |
 |                                   \-scrub_simple_mirror()
 |                                     \-...
 |                                   scrub_stripe()
 |                                   |-release_scrub_stripe()
 |                                   \-kfree(sctx->raid56_data_stripes)
 |                                     ^^^ stripe freed
 |
 \-wake_up()
   \-_raw_spin_lock_irqsave()
     ^^^ repair_wait.lock is in freed memory
     Too late.

The same applies to flush_scrub_stripes(), where the stripes are freed by
scrub_free_ctx() at the end of the scrub.

Fix it by waiting with a completion instead. complete_all() wakes the
waiter under the completion's lock and does not touch it afterwards, and
wait_for_completion() returns only after taking that lock, so the stripe
can be freed as soon as the wait returns.

The completion is re-armed by scrub_reset_stripe(), which is called
before every refill of a stripe, i.e. after the previous waiter has
returned. The SCRUB_STRIPE_FLAG_REPAIR_DONE flag has no user left, remove
it.

This is the same problem fixed for the RAID56 rbio in commit
26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbio
I/O waiter").

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

