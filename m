Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688792;
	b=cumQzqPdnVK6raiXaRqSQ1SSEomtqTJtXE4/7921N6PODkF3NuiML15oz9N+Ll0VOU46
	 37rLvzw0TyZa1fac4EoCeLXiMo3Iva37Ixt88gYhHuYe0Ns9VyP8BlgicSmfOeqo5BEOB
	 JOPYOaF03z7DyihwmRF+zRMBv/9OUDQi1lZDzD12TaFKIaM0kmkVB+2p2j/FAOShBbBa6
	 b55aitaOJS1yk/ygfwDCAk5pEv5Amkvedhg8EuqKSflgDWeLYrCxQp38Im/k8oeG/BfDi
	 1l6y7opIZVppikgRmVKM0pZJXBohij4J2y405BkNDFBHKnyVUf4CnVB/wQkUVsUSwOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688792;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Qn458vKsJL5HJKlKk+IrFKvd11bwRGzztykDFIJ/V88=;
	b=K4edsJ8Po4alYep5PQ6mkqF/Q9s2H7/VbKsF9/gnVlU+dDRwHux+Jo1xfhRxSrX8ZsJG
	 LSj5tiwux/yM3QRIaeWfPVr62D/JJdVsviEmqYmi4ZeQu6MkXWI45udS/Bzs4SRK7m6zv
	 YBQ9oCI/D+rKLyDibsYkBzxrso3MqaB5UqPsFLXF8wjEzfWtnD8twoX1W8uxebi1l0NoM
	 CHv+dS2Z96Rlh9v5hhjAC+T1vg7h8YJ2o1kCMCGMZ0+CaTyWH85VGzxTMMYfQWNAt25Wj
	 RwB6DxM8Ti9Y4VKSR8aX2u1uvl9+6m7JSL5jqrx+ZFTfiqeqVnCgdIaci/1P8/ijYJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=csF7Taym;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OSvoB3EF;
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75EE606A31F
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E75EE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=csF7Taym;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OSvoB3EF
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DF5DE14000C1
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 22 Oct 2026 13:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688790; x=
	1792775190; bh=Qn458vKsJL5HJKlKk+IrFKvd11bwRGzztykDFIJ/V88=; b=c
	sF7Taymd4eezcmNENlkDx1Tg8UIAL1EZ0NE9mKPPN8ems6IXRVhTrMe9YVXI0+Tw
	30/9h9Z3ifur1tmcqvX0hsvnad0y0WE1Mpz29D2LHxZllQn/HWfUqmrYSZtLCDV0
	1cCx47aOIM359v9LzAbcCBknwPzo6N2zMa/JHkQiZOW6/wfYf8NpUipouQXLeu7O
	dnLS7oTl9gZytSUanuqBO5JimMr4J2NvXIVNcQ0PpztF2+sphmQNyBOums7Xodc/
	b4APxdEfFdb7RVN1+f32j+QGC3+jqsZ1og+rY7caQ9C9gQ6rXBZRLTfNS6iHzA+l
	1Wa+kuz5Ym4pnVBSijimQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688790; x=1792775190; bh=Qn458vKsJL5HJKlKk+IrFKvd11bw
	RGzztykDFIJ/V88=; b=OSvoB3EFE+/m3ENo6a/kfvNEFUAP2cFXuocSFpckscZv
	FkhH8DAq8ZR3bJqZFcOsZGCf3e2S4CIu63l6rDA1elWgnWFLBqMTrMLK7U86WYil
	Xrkocnvn35W1/KdyU/QEA7J105sPIsNHVw8piD9R/uNzi7VkGXnQZ87Lo4oN9wW0
	UOL3o6x94uUkmw42GQCO1LIvEMA8hOVS1FciHNAuWusSexMKby+dZoP30gEdNheK
	XFHTOXCMy/n0x0sACC1ySLOlFeVp4rX3841A23XWCUSoIpJYbxKH9LcsvmXrARZ6
	QPe/9s21j1cCmazytdG5jtO7Q63I2HGlP1fWl8kVHg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688790; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:Q3G5Kiciw8NZfL6ao0cIbCjXqTWZ+ISiVGi6RHO17gVCmBN
	YkAcjXVmDoZbYBeuKQdXGg/IobLEJbnJufye+GlGpNQYyphF8dz+vwrnRNi1FqBH
	Vrc0Zed/vOonSl0sukuvl5NcPZGZA9cfHTW1GLQOehgd0ZWGNgRNjxiDJn2U4s0O
	CONZlb7WpsoO4ZTPQWvOZ5ESbRe+s4htzupZlJrmHzedJS6kRoKCDopupYxzzT+6
	MniOqoJJOktEHiHaZ7vQTUUdndmTmQc906owQh1wyzUb7JXsMcu8bbWFyL4ig+6G
	flOywobCpsVX6wwGrLVI6n/4XbIOHPkDrqgj54A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:OqqY7FP7P+a9aFuwdhH8JIB9X6Fnyo8ZR6S7h3mZg6U=:nm4tPT8fbHfQOBTqu9rRWXDanPQGlYB3ETAf3Zen6H4=;
X-ME-Sender: <xms:lkLaapMD62OuQ1yI-_TQJt_rswq0h_CK6LMPm30PLxGMa5T1T6WhQA>
    <xme:lkLaah83Xk6yHekKmLL33D69D7zSvW2axjPc_xFdLwOdFs72HAqkRdgBkVu5Td359
    L4HhkzgZeH7jTHJy7NhhnlkEI5n503dVu-6R-sk2oNIMt_E-By-52M>
X-ME-Received: <xmr:lkLaal5IgOpbiS2F6QX9S7So2ORV4V8481rZivfBcm0AszXVCoDd0UWN>
X-ME-Proxy-Cause: dmFkZTEe4W4ijRj8LZWD4Lo9X8GUtUjJiOBEFgPoavKCOJyoNm0WKmUICZqjwAr1fZEtzN
    wX9psAuB6tGQcZKT04iwQ+nzS1nXqKBzO4k7TataXP7fQkA2HyVZ2udM8mwy84Ds+Oxk82
    /C5tnpFc/t9o1GhxCHWBjcvs0TX5V1ixUkXuiT5gcSJTdP1VU+IXQ7UmaSJRUsfJxTTgmk
    a0eZ4LANsWxq1NCnYhrjdh0JSaR2kq3OvXMAGUryItB1L+2jmIPVcVltxBrTsxaDNpZCxy
    iGE4xsxYB+SVoTBf5HYE6bbggKmUDOCKzyfNCMaar8wuusR9vJhsSaHMSh49K56q6PNmMv
    iHuhgchRAhpgSKKC6Zlhs5NLrIb6dapdciAVEyU+wKyQTP1NRt+VMndoKPPb4MeNxyGehR
    t5nkqE/c1EdBQsNpsf/cX//RO+i/YCoXgTlAggRtBjldm3/BVBfxvG+Juub7FYCZ42JgCF
    xU6FoVOrDXrJ6dKeuknFqL7HoJNUNbMwflBqe2rCFSEGFDc8WcX1XCoR++ZC+1DBIMMEcv
    x8nJP/bhUqQDBNhwj3J38wXc3hQ9bWLpVeIYuIovN+eID5aB473YQ9vc3KOUSFD7C0Td9d
    0V1ABXfHSPfbSnhz6DuJZguvPN6WgkQwMLF8jSKj0NvEiqsXj84bo9pXrqfw
X-ME-Proxy: <xmx:lkLaag2NJXxjYXQE-lTkfs_37E6ZvNmbmp5I-6jww0TGL94Zo9O1xA>
    <xmx:lkLaakA6edD4Gp4VLsxEdL3iEKJBYTy0JYyduOD0fry97I2v_S0MOg>
    <xmx:lkLaaq04i37_FGOAO4X2XRzRhq3fviva_pzZKmuVzoKe7LavrhzilA>
    <xmx:lkLaamtCQxevW6CvlCDzqf9D2lAdsktTqx3RdRfE3rEA-OTfgktYvA>
    <xmx:lkLaavP46ybuhHZcHZUEr2scWHz0uOx1HCaMrtcAAFCxljl8-3TDytuR>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:30 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/7] btrfs: skip unhelpful size class relaxing allocation loops
Date: Thu, 22 Oct 2026 10:06:59 -0700
Message-ID: <73c0492f997f6be7ef4350e35982ca6cbbd637cb.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792688736.git.boris@bur.io>
References: <cover.1792688736.git.boris@bur.io>
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

When size class was not a factor on a previous loop, there is no real
point to running a loop with relaxed size class rules. So track whether
we ever actually skipped a bg due to size class and only do those loops
when it is relevant.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 12 +++++++++++-
 fs/btrfs/extent-tree.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..f6f4f1ce3f1f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4361,6 +4361,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 	    (!ffe_ctl->orig_have_caching_bg && full_search))
 		ffe_ctl->loop++;
 	ffe_ctl->loop++;
+	/* Relaxing the size class cannot help if no block group was skipped for it. */
+	if (ffe_ctl->loop == LOOP_UNSET_SIZE_CLASS && !ffe_ctl->size_class_skipped)
+		ffe_ctl->loop++;
 
 	if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
 		struct btrfs_trans_handle *trans;
@@ -4400,6 +4403,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 			return ret;
 	}
 
+	if (ffe_ctl->loop == LOOP_WRONG_SIZE_CLASS && !ffe_ctl->size_class_skipped)
+		ffe_ctl->loop++;
+
 	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
 		if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
 			return -ENOSPC;
@@ -4414,6 +4420,7 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		ffe_ctl->empty_cluster = 0;
 	}
 
+	ffe_ctl->size_class_skipped = false;
 	return 1;
 }
 
@@ -4577,6 +4584,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->index = btrfs_bg_flags_to_raid_index(ffe_ctl->flags);
 	ffe_ctl->loop = 0;
 	ffe_ctl->retry_uncached = false;
+	ffe_ctl->size_class_skipped = false;
 	ffe_ctl->cached = 0;
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
@@ -4738,8 +4746,10 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			goto loop;
 		}
 
-		if (!find_free_extent_check_size_class(ffe_ctl, block_group))
+		if (!find_free_extent_check_size_class(ffe_ctl, block_group)) {
+			ffe_ctl->size_class_skipped = true;
 			goto loop;
+		}
 
 		bg_ret = NULL;
 		ret = do_allocation(block_group, ffe_ctl, &bg_ret);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ff330d4896d6..ecb2a1bf2435 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -59,6 +59,9 @@ struct find_free_extent_ctl {
 	/* Whether or not the allocator is currently following a hint. */
 	bool hinted;
 
+	/* A block group was skipped for its size class during this loop. */
+	bool size_class_skipped;
+
 	/* RAID index, converted from flags */
 	int index;
 
-- 
2.56.0

