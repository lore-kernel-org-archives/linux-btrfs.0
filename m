Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642477;
	b=KVvADFmukhblAF+8o7kPT01W5Gwt8XvWpg+uXOPM5xTcsjgswMFWmN+ZQMUhZDjhltOg
	 QmNtUduvBs2hWxp0SSo4xq1SJPSQPfHI2BbWRyLHXkdHyYGg+sTUOlM9RMsnm5eflumvr
	 LOJz+SA34SPEUtGMfZTUcW7SRjeQ8WIJWSGaEHT63ti6+2e30oiWlUGZqQjx4V1WV8G1R
	 cnk/d7D6lY2RxEW43uPjJSOXmlWR2vLiEIpWCfYip2uHQL7/M2ETLIZ0Lm0PFeMCWNDrX
	 cxLSxyBa3dbgvF2SorzvbYmy6lcPUpthCZtUz8vnD4KH8wIRkB6cWUZ9Z6ITfSwuUhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642477;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Igm5wcrDD5sumTzrm2vjun9UFg7LPpIrHqNydp3olts=;
	b=FmTY4GCwssCl0rdFpyjzaqHSQ9dkcLYjSuYjNeyJhCbGcNkxliW7J8UB/zBwFYQE787t
	 mvkqPa6SSO1CAfE7iXKyvkeNbRm+ByGHf/u1fxjNLRPrWjHuYatyAOb9H7LD0u7seIyWx
	 22a1tf10EU5Frp2oWKrPwEPD5Imca1/N+KCULwNJXgOwkvysyNTNFC8n5361RU3ndFEOs
	 Zjtd1dBm5QlJWr2xdSan9CgmQwQkmtU5M6SN1KiHhx8L3UgkJB7Msw+dfXwjMSGd+HdA8
	 YScqr6XHzEA850NNMrXZYmNnRZDZmNU0tZ+z/z02DwlLmabQoFp3d2QYsGh4IFIoNHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=CsTSIqqZ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=e3FKec5R;
	arc=none smtp.remote-ip=103.168.172.149
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579E0606A334
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 21:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 579E0606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=CsTSIqqZ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=e3FKec5R
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 5AE95EC0B4B
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:34:35 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 25 Nov 2026 16:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1795642475; x=
	1795728875; bh=Igm5wcrDD5sumTzrm2vjun9UFg7LPpIrHqNydp3olts=; b=C
	sTSIqqZx3mokPUfpEj3oA3e580hoip2+VVnVYe1+6Y/X+5FnfCHeB1rEGCtGcyeM
	XLeR9CB3Mtwcl9lyJEmDbO/CUMJfIaqV4sRlRKboFAmaewSE1pvgsbBvoauv/U+p
	9TSQwb+m7VpVaRU+LyUkkVgrEda9JjFPMgbKajuLyL07Th6JFWzfsY9mkInEjrRe
	545J0sMmoSNXHXF4gJu3J05pfQKqSXSLt8qCK1rMUA58pq9LkxzM5YSC3c9dQ1WW
	Dk6CemzHiZwrA4VfZpgMHAV5dJPqdLRIrg/b3hohWM6K1CDBK97xkdX0wu50dlQ1
	HNeb1oTdqOAJOUdlJXODQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1795642475; x=1795728875; bh=Igm5wcrDD5sumTzrm2vjun9UFg7L
	PpIrHqNydp3olts=; b=e3FKec5RvIImpCRdR8zyNBfPLjOWkQ88quBRbu8UHDi0
	P104pNNpaJRGxDFBBUINGualAIoYZlyT57v2xSx55UlW7Ssozjuo5b1eVrAmpNWm
	9NrZuqspLDjtha2ui/2NMDLhsR5cC8e5GWjCq8w5Al7rfMvP7Us5LT7ycpf0cWbu
	j0UVCabr1+Vz1jlk0vEy5K4wcfjvfb3vOKkjSxuKOg0VO7v8ht+LQhiz6K9bpPlW
	rI/OV9LdNh004JajZ8lUpae8TqIy0tXSBL1/1pNVPw7X5vwe7s4lVBi0Xzb8UkFY
	PexEnLOpVmSj8OBvKxj1tgaq2LgBkKYiZOwqGy+NNQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642475; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:JHyDbsYi/8SQhiJ7yM3/0dut1ZG1jsxvGGXgPYDEwVE1QXk
	92rKrR5QBZtX4YU86fsfSNY76j9zF7gKYmb8BXtikJXwiP64DCbXqssQWLXHFcVL
	vuaqVTOtYJ5vGNYhgDx3MQOva6XNkzbxohY6RPm6G+pZ7Wjz/UVUN4Z+L306nkVX
	LlgshfSDzj4t/hFrFTsY/CaAyQfp2qvGOE+bwamONOkRtDhx4sxsW9pWFkLqXvzz
	DbcP4ZfgbW8FoRrfXglF/cnU3xT+g7lO9x3lajBX7IODP/wAqAbp1jA834JuT1LY
	0NhaaCPZKmsTvo3lvzGP3DtL7KBWbjxT9Kv6icA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:18PD1n/f29bHS8MfvmU3wg1fFKIIx3+050FHV4xYRkY=:ApeaCTEDU9N3fpJwzXYpYl36WcJlhoQubFLrS0OfNvY=;
X-ME-Sender: <xms:a1QHazKqo8uXHJApDIqLlSWkpReU2QVJwSenV9DgW2CssU1GkewBfw>
    <xme:a1QHa9ICRNow_B2-lBQbmvpeSqeK4khIr43eXKgy4F9ilSK7AcGWobWnEZfhyCGXp
    qQcXD1GFjwUKobusjtb6qr8YpK-a7qe3GAP1hfSzMzAlWOGNEZcZtE>
X-ME-Received: <xmr:a1QHa5XVXvPuvuX3-ErEYWnX7c94KnoNnGj5GR1hzP4sIAeafVOQ3XmE>
X-ME-Proxy-Cause: dmFkZTEyYCe47wiGvORAIaEpsifHa4nJDkCQilR7NQ1yRlQlQm57jqDsIEOZakeQIEFhRS
    LlRIgFT6njKwA23ZuZLvCxVfYRJdWHiGH3CKtgKa8sJCMAZnS4qRPS2LYVx0j2Z8NUwqlU
    +Dt5Qqs03kB/eIOHbcT3Fw7K/GUKTX0GANsVh0sD/9bVifSlnbdl5ERcSq//QmY7BMdcAJ
    9tytTIgW6zbBmyCdAmfcSwP8lC/WBRhxKnThAJ95BwCMWy2ZWzPBY8OH+RKv4H1XHCiyWU
    p0UNxyr5ovXAub55M7fOnOxdiCU9lQll3XLstR5g3RG4gI/X4UgImAceUzHBj9wKQUHJlF
    iP8hVIhuGiAfxmnsAaduIZgsLFQFaUn5YXxZYbbQXUH6IrDtz3Ds90tjmCxyniXVjaNl39
    YNN6YwJKnNB4jZFji2LtYTg63k47X9NLsZCUt0V6aTZxYvZvtIDMAu0AQt60P5bofqN3VH
    Dkn+rlSshVhSE6pe0snnqOhrtLENBHZkc6FcjyaUDwKRGCKWnugx3pEqDwtZ/4WV1r0Rj0
    IAthXmBiGaUaapcXAY6urVZ1o0MHqUL7Pz7bRbxe9QWb0JieBjMYCOxFCsVXTkHJ72LIT3
    IOCMkU/qwc4nG+BDh5F26T+M9h8dHfbBaCpzJijlMzaQiGWTVyAWh7S2UD7A
X-ME-Proxy: <xmx:a1QHa3gXexbSPOCVOrvvfa_GH09HpPVdhLt0ozcYXDny4t0v5RnSlw>
    <xmx:a1QHa89L5cXDjQ4H6_U5m_0fxwWqkwwAyfB2qMZJNvKmL4PtEmrYwA>
    <xmx:a1QHa5AsKUdrcBYHIizqzEMekjuZnywR2cpJzYKqCg-EO5vbpuloGg>
    <xmx:a1QHaxIM5hqWiH7wmkzTk0iis2tYLBFCZIL_E7Hl426Qi6rQCkgkGA>
    <xmx:a1QHa9Ig2Dw-w-yRwj4JpuOMJjSXEymM6ieSB-sora3eEWy9y4idj-e8>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:34:34 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 3/4] btrfs: scrub: handle bwlimit below 512KiB
Date: Wed, 25 Nov 2026 13:34:04 -0800
Message-ID: <dae911ee8e0d50741fd4d92b7df57e0ebc2707f4.1795642270.git.boris@bur.io>
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

scrub_throttle_dev_io() divides a time slice into up to 64 intervals
with the computation
  div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
So at bwlimit below 16MiB/s, the time slice is unitary and above 1GiB/s
the slice is split into 64 intervals.

Each interval represents an opportunity to schedule IO and we set a
throttle deadline to now + time_slice / div. time_slice is 1000ms or 1s.

At each interval we count bio_size against bwlimit / div, or the portion
of the per second bwlimit for that interval. If it is under, we send the
bio with no throttling. Otherwise, we throttle till the end of the
interval then send the bio.

This ensures that we have a hard cap of 64 sleeps in a second which
ensures good throughput for typical unbounded or high limit scrubs.

But because bio_size is always 512KiB and we send at each interval, the
practical minimum limit is 512KiB/s, as we will send at least 512KiB
every second (the longest possible interval when div = 1).

To support lower limits without ruining throughput at higher limits,
change to a model which can sleep for an arbitrary duration to properly
amortize the data sent and acheive an average IO demand below bwlimit
for bwlimit < 512KiB/s.

However, at higher limits, because the unit of sending is still 512KiB,
sleeping between every IO for a naively calculated limit would be far
too many sleeps and adds unacceptable sleeping overhead, ruining our
ability to even submit at those limits. Therefore, we need to allow a
"burst duration" as a floor for the sleeping duration. 10ms is a
reasonable value: it is a similar number of sleeps at high limits (100
vs 64 per second) and is a responsive duration relatively commensurate
in scale with disk latencies and intuitively seems like it would not
be "too bursty" at any speed.

Now that we might sleep for a rather long time rather than at most 1s,
although the sleeps are cancellable, also add a wakeup/cancel path from
changing the limit again. If the user tunes the limit higher, they
should just start running rather than needing to cancel.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/scrub.c | 71 +++++++++++++++++++-----------------------------
 fs/btrfs/sysfs.c |  2 ++
 2 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a976897cea8d..d68e8d2f766f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -57,6 +57,9 @@ struct scrub_ctx;
 
 #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
 
+/* Length of a burst of throttled scrub IO, see scrub_throttle_dev_io(). */
+#define SCRUB_THROTTLE_BURST_MS		10
+
 /* Represent one sector and its needed info to verify the content. */
 struct scrub_sector_verification {
 	union {
@@ -195,9 +198,8 @@ struct scrub_ctx {
 	atomic_t		cancel_req;
 	int			readonly;
 
-	/* State of IO submission throttling affecting the associated device */
-	ktime_t			throttle_deadline;
-	u64			throttle_sent;
+	/* Earliest time the next read may be submitted under scrub_speed_max. */
+	ktime_t			throttle_next;
 
 	bool			is_dev_replace;
 	u64			write_pointer;
@@ -451,16 +453,19 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
 /*
  * Pause the scrub, and sleep for the throttle duration. Pausing allows the
  * commit to proceed unblocked.
- * Scrub cancel interrupts the sleep.
+ * Scrub cancel or a change of the limit the sleep was computed under
+ * interrupts the sleep.
  */
-static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
+static void scrub_throttle_sleep(struct scrub_ctx *sctx, struct btrfs_device *device,
+				 u64 bwlimit, ktime_t timeout)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	scrub_pause_on(sctx);
 	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
 					   atomic_read(&fs_info->scrub_cancel_req) ||
-					   atomic_read(&sctx->cancel_req),
+					   atomic_read(&sctx->cancel_req) ||
+					   READ_ONCE(device->scrub_speed_max) != bwlimit,
 					   timeout);
 	scrub_pause_off(fs_info);
 }
@@ -514,7 +519,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	atomic_set(&sctx->cancel_req, 0);
 
 	spin_lock_init(&sctx->stat_lock);
-	sctx->throttle_deadline = 0;
+	sctx->throttle_next = 0;
 
 	mutex_init(&sctx->wr_lock);
 	if (is_dev_replace) {
@@ -1409,54 +1414,34 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 }
 
 /*
- * Throttling of IO submission, bandwidth-limit based, the timeslice is 1
- * second.  Limit can be set via /sys/fs/UUID/devinfo/devid/scrub_speed_max.
+ * Throttling of IO submission, bandwidth-limit based. Limit can be set via
+ * /sys/fs/UUID/devinfo/devid/scrub_speed_max.
  */
 static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *device,
 				  unsigned int bio_size)
 {
-	const int time_slice = 1000;
-	s64 delta;
+	const u64 bwlimit = READ_ONCE(device->scrub_speed_max);
 	ktime_t now;
-	u32 div;
-	u64 bwlimit;
+	ktime_t ahead;
 
-	bwlimit = READ_ONCE(device->scrub_speed_max);
 	if (bwlimit == 0)
 		return;
 
-	/*
-	 * Slice is divided into intervals when the IO is submitted, adjust by
-	 * bwlimit and maximum of 64 intervals.
-	 */
-	div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
-
-	/* Start new epoch, set deadline */
 	now = ktime_get();
-	if (sctx->throttle_deadline == 0) {
-		sctx->throttle_deadline = ktime_add_ms(now, time_slice / div);
-		sctx->throttle_sent = 0;
-	}
-
-	/* Still in the time to send? */
-	if (ktime_before(now, sctx->throttle_deadline)) {
-		/* If current bio is within the limit, send it */
-		sctx->throttle_sent += bio_size;
-		if (sctx->throttle_sent <= div_u64(bwlimit, div))
+	ahead = ktime_sub(sctx->throttle_next, now);
+	if (ahead < 0) {
+		sctx->throttle_next = now;
+	} else if (ahead > SCRUB_THROTTLE_BURST_MS * NSEC_PER_MSEC) {
+		scrub_throttle_sleep(sctx, device, bwlimit, ahead);
+		/* Woken by a limit change: the debt was accrued at the old limit. */
+		if (READ_ONCE(device->scrub_speed_max) != bwlimit) {
+			sctx->throttle_next = ktime_get();
 			return;
-
-		/* We're over the limit, sleep until the rest of the slice */
-		delta = ktime_ms_delta(sctx->throttle_deadline, now);
-	} else {
-		/* New request after deadline, start new epoch */
-		delta = 0;
+		}
 	}
-
-	if (delta)
-		scrub_throttle_sleep(sctx, ms_to_ktime(delta));
-
-	/* Next call will start the deadline period */
-	sctx->throttle_deadline = 0;
+	/* (bytes * (nsec / sec)) / (bytes / sec) ==> nsec */
+	sctx->throttle_next = ktime_add_ns(sctx->throttle_next,
+				div64_u64((u64)bio_size * NSEC_PER_SEC, bwlimit));
 }
 
 /*
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 89b0a4ef4063..4c7f486c2924 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1928,6 +1928,8 @@ static ssize_t btrfs_devinfo_scrub_speed_max_store(struct kobject *kobj,
 	if (*endptr != 0)
 		return -EINVAL;
 	WRITE_ONCE(device->scrub_speed_max, limit);
+	/* A throttled scrub sleeps on this under the old limit. */
+	wake_up(&device->fs_info->scrub_pause_wait);
 	return len;
 }
 BTRFS_ATTR_RW(devid, scrub_speed_max, btrfs_devinfo_scrub_speed_max_show,
-- 
2.56.0

