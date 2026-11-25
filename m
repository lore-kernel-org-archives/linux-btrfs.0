Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642475;
	b=UnxKTmD9LpFYFMCFBQuif41nqkvCfeguOZz01veQKGaLMA6EKO3Q2yMiS0yJqTHSXGW2
	 pic60tkyZ/4XzlWU7JYBhBYT5Hv64+3r1krjxjBRBGkdoFgdrT95gPfjAVYnV/1YDfMSd
	 5OooaepZV0zB8BmeTXwRR+eKbfFo1psJd0ebDYh2ZT60+MydhRzAmTtrlAsqls93gzGOp
	 cQteG5LyGcA0tuCchA6b41wTsK1DG1gc2PG81xBxAMyZHv87cQcHFW5vctTrz62uTIum6
	 wdw3iX21JDKkBclHSbkT1lHtquYOeXsdnb6QavWYftRmJBy8bd2FAgQqqA2AxaHgwAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642475;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=SdwSdyRNMLgbAopGzApyI7Zh73sG5V5xbV1oz+AKgIU=;
	b=TVIasB74cNsO0XbmZ5uEAhn7CIIVY1zRe05m1FZIGo/caf4DXJ+Agb35IgUJko9gQbh2
	 +U9gVX4E04YJFtVQrezahyAbTDX9LeAM0cNGuVqDBhLTECYaUFqeqCeuOy4idAXNQXLFW
	 NHFBR5FCkBVfVVBBb/YTF7H5RdaZoVpyHGsfVGbnpg8u/6Ebv9O1mmyrSkF2us1ySykxC
	 sajLCSxd6suBncOqp1xN0fr0Vc5HiA/uUoxOLYPXg0qirRP6eoWjylCpqjcS8bputuHy7
	 u8xZu3iQKpW4sRoxbV0CVLyb/RPxkvK1AAFT9rKWCBBRYSsIBGNZGRgvTJIha4p53Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=bvWsaDqQ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WpQs3AtE;
	arc=none smtp.remote-ip=103.168.172.149
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9883606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 21:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9883606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=bvWsaDqQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WpQs3AtE
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id CB436EC0B45
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:34:33 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 25 Nov 2026 16:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1795642473; x=
	1795728873; bh=SdwSdyRNMLgbAopGzApyI7Zh73sG5V5xbV1oz+AKgIU=; b=b
	vWsaDqQdJ54ULJDKSqEK1qX9HrhL2cEMVN6RoO71GIXphRei1j252zd19yv9lUQW
	ICnaKvTnqkaC/hIb3cSJzlCKpopP41MbOZARDzg7hCjoeMQhZ5AOel95M9bhMMgQ
	QtxQug2Qulm+H1mnSW4sQB0oLvszL6pIOgFg8XpHk2/QYm5uhGHC6OOVkTen3ysQ
	wzEVne9ZS/xlS/F4bfR2wx11k/a3xHgQx571p30SDcUHl8CrOAMf3mSWK2gxWt4t
	eTegW/DZ4feJakakcz4mS3UnDotDWwEHwYVoTw6or5S6mQw+oHc9/+arCCjR0OVZ
	MGcKi9sUaKxE+aL8P72oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1795642473; x=1795728873; bh=SdwSdyRNMLgbAopGzApyI7Zh73sG
	5V5xbV1oz+AKgIU=; b=WpQs3AtE/MwOBGWF/2A4zjxvfxggW5fi2sRMVblfhM8v
	s/wOKjmuBSdjt9ket+SWn4hCxg60F1oeWyp32X7PR/0HroTGe20pSHTNWahbWoZZ
	rvSm7vhVKdGWzdJStK8QkWQ/Bk3wXjG8QLsgLDvOcER0PGtS3bHtWCMxGnTVXBAK
	Gkh8R37cB+hgNghG+Yp0NmaifuuuRmrW3z26TyZhkIKg+0E1M1FlciVYBewhKk4l
	GiM5VjyhcAa1R233gKfxzhTgzr0ZS/3f+Ac9Bnwyz1sCnisqlUYvR7Qe1mqcfAMT
	g+ubDq8B33C15ZM9O+syHA4DSd0f9t+aAWV/bh12/w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642473; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:ATGbDtTO4br1DyLwa6yOuellS0uSNv86D2Qf4ArSc47lkA2
	FKYu6yYrIIXvJoQCuEfKaHa3FytdvhNUORR9NF8TNXzRztxHbqxg5M/PioIJV1nt
	nmAUXTzxRFJPsczPcxSXg0wJbx/6DCr2y5IJrlCbPO+UbgxbEQrB2c/D90LtOvnZ
	IWF0wjnKd74iH/4D8q6dO5m172uc/zukutz5Q2CLfxt/gWclf071i7l82xBlxugL
	YYmNJ/3pi/oeSDWpzoA8S/C2gu/2Ch5FYLCYdFfUfquywvi1kx6GDm0663o3JriL
	TnNxbbOPG6PwZ7MpBz4ssA7YLQk5pxfkulFQ+tg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:3E0J9Ayy4F3RQzUXxrhQXflZ59XBQMuP0ZoXgeZXzvE=:D0Sq6WqEFQTga36TOlZNqYGvoRmVVR8xwPEZE5qV1XM=;
X-ME-Sender: <xms:aVQHawBlwDgnbRkkXNFy5_H9YZLzxcZEoSsWbQEuBuy5EMc2XUORkA>
    <xme:aVQHa4igPPnL6-YMDgmOBOYWDOb-DYVPX1NSJoSxzlOsa47LmuQia8loMDhrIun7j
    5FhQgZPa7gTJSWLf0wj1r6dxbbbWwAlm1UXlFaqbx9UozfY866yHQQ>
X-ME-Received: <xmr:aVQHaxOAs7j7DL2NP59uBuR2sL95JrgFiYp2tqM374b9-QagU8i5TdK6>
X-ME-Proxy-Cause: dmFkZTFzYUoc4FEZgujwUyqGfIchZ6KZQfZElxuDDZP4NsAlkpLcs6TXf4ZF1bIc4aDdV6
    AGkmXHsNe3+Pqf4EmkUXOP0oxW3+/NiFP5jAd1Of4bFlkYCaz1ATTkZIHOmICWF3dos3VK
    UHMLadrz3DQItuj/6aiPrWd1zPMw0i3x/yoH06JhYmmh8+SR2iPvbUbA1Uj/ps9JIoHv/e
    rubkzy1MKsi534kDEXv0rTkfz8jEHNdYjPVO1LNmQdyG730iza8sNeLNvOeAVMK+ERdHnw
    j/GkYsVA2jL3nniDgMffJtGE4VuGTb/8mKX+obriLeFN3u9bk6uK4Ab4YSvM+qfaXgxXDn
    Rov3PCZ4HEUt+HWZUrBQ5b7o9j31QN5RwpIOv8LSVGRD+Q+AYVwBXEj7uknXPM4NpQxMhh
    5y6z+rgvJitriK0/ipW9m8D3qeVjYOKOUcpWXVzcYnYuBiqOtR+EbCDZ6Hp2lu2SB7rm2U
    VN74L74KaVxHIjXSDazJPkp44I2bSSYh4atYf53ZSeLKJHpovsImvvFaf3uNJz+f7ufKi6
    NSBxjk8GGnEnYifpouzohJvaCZ21pXeYLo5oHEvIPuN21/VS1jhqYTSnb3TvG2pfkM0kLp
    mRnGqlWqVmrGQbSY0bIzcUFHRJdTQD8TUgGin66bMslTZbOTq5l6U7P+JBdg
X-ME-Proxy: <xmx:aVQHax7j3JyZX53mzB5I45QN2pVYpDBXbMucjnxs9tE0papxf0prAg>
    <xmx:aVQHa30liIuIkAPBqyyfnwIw59GqmlgKhWF8plxdyReXpFU7yOYKAQ>
    <xmx:aVQHa6Yvek3ktGQCwbu3X7LDJuP47H-7Z3FCFtdttTsns8sETTw5BQ>
    <xmx:aVQHa3AgcoA15EzMNrawrg2L4cZnTjCizd1G6W0Vg89mufuSlVu_3g>
    <xmx:aVQHayBqeqeZtzXj-Hm8TbjTm9VdRIgIprm-LMaSiF8E_nhkeFMgzSTR>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:34:32 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 2/4] btrfs: scrub: cancellable pause during throttle sleep
Date: Wed, 25 Nov 2026 13:34:03 -0800
Message-ID: <fdeb64e3fcf92bc8f1a69d07718dc07a23a133e8.1795642270.git.boris@bur.io>
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

scrub_throttle_dev_io() sleeps with schedule_timeout_interruptible()
without pausing the scrub, while a transaction cannot enter a critical
section without pausing scrub. Thus, a transaction commit gets blocked
on a scrub throttle, which is completely backwards.

Furthermore, this sleep ignores attempts to cancel the scrub.

Improve the scrub throttling semantics by implementing it as a cancel
aware sleep wrapped in a pause.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/scrub.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1a721623813f..a976897cea8d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -448,6 +448,23 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
 	scrub_pause_off(sctx->fs_info);
 }
 
+/*
+ * Pause the scrub, and sleep for the throttle duration. Pausing allows the
+ * commit to proceed unblocked.
+ * Scrub cancel interrupts the sleep.
+ */
+static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
+{
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
+
+	scrub_pause_on(sctx);
+	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
+					   atomic_read(&fs_info->scrub_cancel_req) ||
+					   atomic_read(&sctx->cancel_req),
+					   timeout);
+	scrub_pause_off(fs_info);
+}
+
 static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 {
 	int i;
@@ -1435,12 +1452,8 @@ static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *d
 		delta = 0;
 	}
 
-	if (delta) {
-		long timeout;
-
-		timeout = div_u64(delta * HZ, 1000);
-		schedule_timeout_interruptible(timeout);
-	}
+	if (delta)
+		scrub_throttle_sleep(sctx, ms_to_ktime(delta));
 
 	/* Next call will start the deadline period */
 	sctx->throttle_deadline = 0;
@@ -3334,6 +3347,7 @@ int btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
 	}
 
 	atomic_inc(&fs_info->scrub_cancel_req);
+	wake_up(&fs_info->scrub_pause_wait);
 	while (atomic_read(&fs_info->scrubs_running)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		wait_event(fs_info->scrub_pause_wait,
@@ -3358,6 +3372,7 @@ int btrfs_scrub_cancel_dev(struct btrfs_device *dev)
 		return -ENOTCONN;
 	}
 	atomic_inc(&sctx->cancel_req);
+	wake_up(&fs_info->scrub_pause_wait);
 	while (dev->scrub_ctx) {
 		mutex_unlock(&fs_info->scrub_lock);
 		wait_event(fs_info->scrub_pause_wait,
-- 
2.56.0

