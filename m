Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642479;
	b=odJnnF9Nk9uMabx+MD+NB1jkfJlZqiGbisY8hlWFcnxYUTtl37+eZcYMU8sEVwl2wF72
	 FFvYcRs0ilh5JbzzPagaxv6mwRpJRAbJXOn6cBNdhtvvK/IhQ7UTkrVRQomRd4qC27Q1e
	 4AYx/tpiOEpvAVrTx2fxsEiuMJsAzozPNndV6vUav+2CGrexQ67QYaNKh/0Ro7gKtRjcR
	 uUxDnj5m9UdxUSvtAePjGjL5kmMWdInNB2EiHv2XkVyLA0Mb3AP3JrJF9CFLSiWfTSeXL
	 eyCokDuyHtynppc6p1zYGNy++1gsZnBu6i9ewEEFq2Gmz6o1En2lgxYSkKqVQrCtiyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642479;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=LP9+q6IPDeKpbeBXgkS3GLS+cpydmKPHtlq66w237Hc=;
	b=tma5QZcPf9zCvR4efMY10i3QPoqsa43bY23CeC4qYLUf3EuNEyUNnDPsic1cXhHxy/IY
	 K4mfe1SvlKxYuiZS5ysWiKJ5n12fIZ5HXy74tloFO5tNJFyR5IxeoxbtCGUh5udgWrIgv
	 RpYmMb1eqDJEYImSRpY9tPdGB+8LFhaCSr60J/JTZKGBFyrlrnbhkHYr8tJXHjk5KWZim
	 B2uxYgQxH+AMlrjWRK65urMreK4Vh9F9cAv7D5qQTInnBjOUm4dFvoXP1P9a8Q3PAzrsy
	 hlmLdaiZFM7VJM0rS3Fd3ETqjBJ1p1vTEKVlPoTDx/i3J9mh3Uzt+rkxBuNWFLJbEtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=lWBBfoO0;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WcvsM0Qd;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4328606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 21:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4328606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=lWBBfoO0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WcvsM0Qd
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 06DE11400368
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:34:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 25 Nov 2026 16:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1795642478; x=
	1795728878; bh=LP9+q6IPDeKpbeBXgkS3GLS+cpydmKPHtlq66w237Hc=; b=l
	WBBfoO0cDZH1FnxPFvP3mLABGA/TMPN2GN7I1pW2zXzUJxKgzNXB6kzxmJ3qIV1N
	iTni3IZZqPO0b4eVGuctSGbnxKPBIfycXP70Z9anhwW0YP35PU6/LDmUxqbPoDs2
	a6/LtgtUxWBLcA8FKU8ItSKfu4wtm1q9+nWxcf99z6S1y5on8KICPtuAYFYVWtMQ
	3kmjOprmb0xClI7SFfL3XBnlt6yuOgvv67R161F0TPbVpD8yoq9HWkpUEV+KTDnE
	+N5ToTXTL86OlflYp4iugE+lrMO81DBROghv9C1K7eW7Dg57MZsXR9Lh1ijMBIZL
	xiaOz/8axUjnZuhYjHWYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1795642478; x=1795728878; bh=LP9+q6IPDeKpbeBXgkS3GLS+cpyd
	mKPHtlq66w237Hc=; b=WcvsM0QdWPcpK/C+5CcADU3G7QT2rl7w7guaUR/Oe1v3
	P/KooZAgO5FYFuE9xnIAstRD+QHzTtn0ryMoRduaQ2VtIMBZhBJw0xW80BqbVF7G
	sEM0e2CmJNtDqCSPx/zYQlmTY6CNZZKlF+6D+d7h5DQpDPPJwMtKpIQxspCKEVUb
	JfqBmu8eD+eFUFpYihJlgfA26IVlgp5yLSdKWmOMssUzFioXWQuZRK1bJ+Ryl2sn
	KUCi0vAY+1fsYPWt5hIq/EXajtpCSyzPPvqlC5+Ix7I0cw38DaaT5OCJmt8SMxJt
	Y7gLOq5jc1NuPAOJRRcsyeI8JPWtPvnY3Jb3OFKCNQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642478; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:hNxDIomfp57L8VqUIBUv53eFhHFko0QydJOP4ioaRTW8zYM
	Mhowu7i8+4gzz4CrXbmeMHBWPKB995qTxUpdg9yqqAiZxpaS1/0D72MKmdir95Z6
	aZ2FpAlvzLJRuiamXdEDZSd6L/3ijpzORPD9ViD707t9BCpmkhqtWxxTxlYY3Idb
	+gnXNWnMFnzVak4b+beuLWlxJQmNi6HgX5tI2lbNMLGYxASvO78rhi0f8HAP3GTd
	OqThpU6VGbbZ+Bqve4XoQ9V3qscQTgv1lNlESB8WeE4wwsgUe5fr5kgS0Oo2cKfq
	EjiPIFGp8Cx6PVqbvfKKCmtXyjTsWn5aGy/03cQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:yuD1XFc87gjcTjEJOSQeI0TkAeMh5sqBX8u/GtUMczc=:6lAvFVUEJo3KN88Idy/8S2owseq+y22KA9dv7IdEuZc=;
X-ME-Sender: <xms:bVQHa5Jg4cFBz3aXUO6_BQeFOzObS2NvNvwta5F670oh8NPjjT43HA>
    <xme:bVQHa7Lp5IRj0cE9eBh7gSFmh5nTS16iqIOFpbYlBTQVUFB9kTwpi0poA-tBv1jmS
    _MUcQlWOC8O0r-KAelngBNwHB_T213oehDBQJMSATj6iz2ZwE9rUig>
X-ME-Received: <xmr:bVQHa_Vizj9gtGvY5y2l-HxsM6aF0XuWBaCWfoQLL5Fqf2bU4xxNWEiQ>
X-ME-Proxy-Cause: dmFkZTE6X4ededCa774X9N3oU8PaP7eBbphXYjPAJIQ9yIpGOpNu8Uo7KIqh8Rxm76olh8
    q7IaLvvmrA51+TnYnZOU/MK5rLyWmBHy50m+5C8wMNygPRsJh/GINbXhIw5hzFeAA0zGpx
    7FksVL1P/QVitE3JgZCAr8OZXiidCGT+fXwCx/Pb9DW+Zz5Wr3wgoQ841dKvuDQYJSjzmx
    +paGJ7mt0dcqbWfa4Esh8wChOVkL3h8I4gj0bC2t4GgW92SKsFKr6+mqVUU9ST/FI7YyzL
    l+o3dxunGlBUICLsSMIf+M2epG95fUcn39V0TICel47WQtjaQHWyqdMReXYgr/IL9y62Ly
    2VUqJLBvMP4kAOuU/exg8bCeMA2OjLluSrsPzm5t90FAVHiBVQJbpXQo7lNrDoSD3JMz8c
    QNe9Q4aH8eUot4n7mkaRN6SeN4WG136bgIpDMm9560Hbj6j4rYro3p4QqjtZeWcnZhiTQw
    uqNJGDWXZ6153aK+VxGkAJ/Kix3p1yAV4bIPwJu07okCQGPF/xxj4fOznaao3LrTlHlY0l
    ZqJ3FWBki5uzkxj1uNOM5vuhuB3WMB2IFeJE296UGDhNtez0I32Jf4XtBwgQUdoYlkB1na
    F8qF/IFg0/logOVwuTyTZO8n3dKT/e6h1hqFfNzYxgG45PT7BRd0q94Cb4fg
X-ME-Proxy: <xmx:bVQHa1iJfm-LzpKV1cEKObcLeBo2xS_Dp3wavhieZW2EGfkDXjPlTg>
    <xmx:bVQHay8ILP9veqeIwJ39xNojm51zVOVq2sZzN2QaETA9GkTjSBbyGQ>
    <xmx:bVQHa3ChBSAoeCAFMVlyGLChweTZZptNaX5bLuiJ1ywPLWNUqisjTg>
    <xmx:bVQHa3IPRYDqpPMpu6GPp_oJ1uu1OhSegb-HUJzRvc82AOpdAZ6hng>
    <xmx:blQHazLfdh3AKquZ_nuQ1sk857XEUlmSJgOhWWZ0Mn0lMbEKtZOhSJH7>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:34:37 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 4/4] btrfs: scrub: size read bios to the bwlimit 10ms burst
Date: Wed, 25 Nov 2026 13:34:05 -0800
Message-ID: <231c4b458b357fff6b905dd9c5b3822c32d77c9d.1795642270.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795642270.git.boris@bur.io>
References: <cover.1795642270.git.boris@bur.io>
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

Now that scrub will sleep for long enough to pace to an arbitrary
bandwidth limit, it is also helpful to size the bios in a way that is
more burst aware. For limits below 512 KiB/s it is more logical to
submit more bios with shorter sleeps than to dump a 512KiB bio then
sleep for tens of seconds. Compute a burst size from the burst duration
and the bwlimit, then clamp that between a single sector and the normal
stripe_len to determine the bio size.

Now if we throttle at each bio, the pacing scales naturally with the
behavior essentially unchanged at higher limits but not crazy bursty at
lower bwlimits.

The stripe takes an extra pending_io reference across the submissions,
as scrub_submit_extent_sector_read() does, so the repair worker is not
queued before the last bio is submitted.

To continue to avoid throttling parity reads on scrubs, we must add a
throttle variable to skip throttling / bio shrinking on those bio
submissions.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/scrub.c | 82 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d68e8d2f766f..d7d986300793 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1823,12 +1823,37 @@ static u32 stripe_length(const struct scrub_stripe *stripe)
 		   stripe->bg->start + stripe->bg->length - stripe->logical);
 }
 
-static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
+static u32 scrub_read_burst(const struct scrub_stripe *stripe)
+{
+	const u64 bwlimit = READ_ONCE(stripe->dev->scrub_speed_max);
+	const u32 sectorsize = stripe->bg->fs_info->sectorsize;
+	u64 burst;
+
+	if (bwlimit == 0)
+		return stripe->stripe_len;
+	/* units: (bytes / sec) * msec / (msec / sec) ==> bytes */
+	burst = mul_u64_u32_div(bwlimit, SCRUB_THROTTLE_BURST_MS, MSEC_PER_SEC);
+	burst = round_down(burst, sectorsize);
+	return clamp_t(u64, burst, sectorsize, stripe->stripe_len);
+}
+
+static void scrub_submit_read_bio(struct scrub_ctx *sctx, struct scrub_stripe *stripe,
+				  struct btrfs_bio *bbio, int mirror, bool throttle)
+{
+	if (throttle)
+		scrub_throttle_dev_io(sctx, stripe->dev, bbio->bio.bi_iter.bi_size);
+	scrub_stripe_get_io(stripe);
+	btrfs_submit_bbio(bbio, mirror);
+}
+
+static void scrub_submit_extent_sector_read(struct scrub_ctx *sctx,
+					    struct scrub_stripe *stripe, bool throttle)
 {
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	struct btrfs_bio *bbio = NULL;
 	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	const unsigned long has_extent = scrub_bitmap_read_has_extent(stripe);
+	const u32 burst = throttle ? scrub_read_burst(stripe) : stripe->stripe_len;
 	u64 stripe_len = stripe->stripe_len;
 	int mirror = stripe->mirror_num;
 	int i;
@@ -1844,10 +1869,10 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 		/* The current sector cannot be merged, submit the bio. */
 		if (bbio &&
 		    ((i > 0 && !test_bit(i - 1, &has_extent)) ||
-		     bbio->bio.bi_iter.bi_size >= stripe_len)) {
+		     bbio->bio.bi_iter.bi_size >= stripe_len ||
+		     bbio->bio.bi_iter.bi_size >= burst)) {
 			ASSERT(bbio->bio.bi_iter.bi_size);
-			scrub_stripe_get_io(stripe);
-			btrfs_submit_bbio(bbio, mirror);
+			scrub_submit_read_bio(sctx, stripe, bbio, mirror, throttle);
 			bbio = NULL;
 		}
 
@@ -1892,8 +1917,7 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 
 	if (bbio) {
 		ASSERT(bbio->bio.bi_iter.bi_size);
-		scrub_stripe_get_io(stripe);
-		btrfs_submit_bbio(bbio, mirror);
+		scrub_submit_read_bio(sctx, stripe, bbio, mirror, throttle);
 	}
 
 	if (scrub_stripe_put_io(stripe)) {
@@ -1903,11 +1927,12 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 }
 
 static void scrub_submit_initial_read(struct scrub_ctx *sctx,
-				      struct scrub_stripe *stripe)
+				      struct scrub_stripe *stripe, bool throttle)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
-	struct btrfs_bio *bbio;
+	struct btrfs_bio *bbio = NULL;
 	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
+	const u32 burst = throttle ? scrub_read_burst(stripe) : stripe->stripe_len;
 	int mirror = stripe->mirror_num;
 
 	ASSERT(stripe->bg);
@@ -1915,17 +1940,10 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 	ASSERT(test_bit(SCRUB_STRIPE_FLAG_INITIALIZED, &stripe->state));
 
 	if (btrfs_need_stripe_tree_update(fs_info, stripe->bg->flags)) {
-		scrub_submit_extent_sector_read(stripe);
+		scrub_submit_extent_sector_read(sctx, stripe, throttle);
 		return;
 	}
 
-	bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
-				stripe->logical, scrub_read_endio, stripe);
-	/* Read the whole range inside the chunk boundary. */
-	for (unsigned int cur = 0; cur < nr_sectors; cur++)
-		scrub_bio_add_sector(bbio, stripe, cur);
-	scrub_stripe_get_io(stripe);
-
 	/*
 	 * For dev-replace, either user asks to avoid the source dev, or
 	 * the device is missing, we try the next mirror instead.
@@ -1939,7 +1957,29 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 
 		mirror = calc_next_mirror(mirror, num_copies);
 	}
-	btrfs_submit_bbio(bbio, mirror);
+
+	/* The extra ref is dropped after all bios are submitted. */
+	scrub_stripe_get_io(stripe);
+
+	/* Read the whole range inside the chunk boundary, @burst bytes per bio. */
+	for (unsigned int cur = 0; cur < nr_sectors; cur++) {
+		if (bbio && bbio->bio.bi_iter.bi_size >= burst) {
+			scrub_submit_read_bio(sctx, stripe, bbio, mirror, throttle);
+			bbio = NULL;
+		}
+		if (!bbio)
+			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
+					stripe->logical + (cur << fs_info->sectorsize_bits),
+					scrub_read_endio, stripe);
+		scrub_bio_add_sector(bbio, stripe, cur);
+	}
+	if (bbio)
+		scrub_submit_read_bio(sctx, stripe, bbio, mirror, throttle);
+
+	if (scrub_stripe_put_io(stripe)) {
+		INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker);
+		queue_work(stripe->bg->fs_info->scrub_workers, &stripe->work);
+	}
 }
 
 static bool stripe_has_metadata_error(struct scrub_stripe *stripe)
@@ -1970,16 +2010,13 @@ static void submit_initial_group_read(struct scrub_ctx *sctx,
 	ASSERT(first_slot < SCRUB_TOTAL_STRIPES);
 	ASSERT(first_slot + nr_stripes <= SCRUB_TOTAL_STRIPES);
 
-	scrub_throttle_dev_io(sctx, sctx->stripes[0].dev,
-			      btrfs_stripe_nr_to_offset(nr_stripes,
-						sctx->stripes[0].stripe_len));
 	blk_start_plug(&plug);
 	for (int i = 0; i < nr_stripes; i++) {
 		struct scrub_stripe *stripe = &sctx->stripes[first_slot + i];
 
 		/* Those stripes should be initialized. */
 		ASSERT(test_bit(SCRUB_STRIPE_FLAG_INITIALIZED, &stripe->state));
-		scrub_submit_initial_read(sctx, stripe);
+		scrub_submit_initial_read(sctx, stripe, true);
 	}
 	blk_finish_plug(&plug);
 }
@@ -2276,7 +2313,8 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 
 	for (int i = 0; i < data_stripes; i++) {
 		stripe = &sctx->raid56_data_stripes[i];
-		scrub_submit_initial_read(sctx, stripe);
+		/* Do not throttle parity verification reads of other stripes. */
+		scrub_submit_initial_read(sctx, stripe, false);
 	}
 	for (int i = 0; i < data_stripes; i++) {
 		stripe = &sctx->raid56_data_stripes[i];
-- 
2.56.0

