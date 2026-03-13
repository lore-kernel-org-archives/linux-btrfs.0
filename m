Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57B3DA7EA
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 19:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773429942; cv=none; b=WAdD2BZCxQIfRE+A2ih8SPuglliWsfapTbCa/OKKBBfbY2dTaU18Yy3+KQLRytFIDsKjqEeN1+y59Y5PDZA8+TjqKahouxorIKTrJLddwIf/ZZZLHS1s4QND684434Jg7+0+8kMoLNpwG+sHXRdV1gmwUFkrwNuKoEqCgSxlD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773429942; c=relaxed/simple;
	bh=lygcFcQbRiSGZorzkJTYBWxNpbxAIe/aps/q1vAYeGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QTUzHSS2/G0mRtpHV8aQLWbum44r7R4FW1RytZ7RMJpEdFaxLcrwHy4DXyI5k5mnzJQUBtftGyywm61MAnEPF2xquNLgiyOe+WN8XuaoAZkdYcz2xB4iyy5JkOFKd8HtlKQhrpmnqPgjt9t7w/sG1f5BsTzOw2qiwBC9GUQM8Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=F+A/Ned/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=zAQrGtzJ; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="F+A/Ned/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zAQrGtzJ"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 6E770EC0317;
	Fri, 13 Mar 2026 15:25:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 13 Mar 2026 15:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1773429940; x=1773516340; bh=xeBR+2i120raimUlOmeE+
	sj+INC5aVsoOYChaYJwF2U=; b=F+A/Ned/7b/IFkZaWubP/FzQM21XJzxR/Rq32
	WsuiLxLqWcblEiy1HFblbiKQYxiKP+lGUwIiuAB5EhyfliOHEG0P0eZtnX2h9hnC
	qv16Dt/vBI7i1MsyyvCPSSAulkpGlnSfoe+NBP06k1MKYKIUNXVt7zPlW8wYgI/9
	IneslrGRz+3McWti/EMpdG5Ym7M6hSjMpW6+E43NeWilrJifn6mOaSwDunHsYjWc
	uz/LJeKKCf3vobqdO7CFFZwv8YbnSgugAJNu+2RU2bwlwlcXMeeeRqm8TdK3OOsH
	2/qpvHVqTdKeO1cmwI0XP0gUYsBVX2Ayc2ICZ8rRyQxfaDzuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773429940; x=1773516340; bh=xeBR+2i120raimUlOmeE+sj+INC5aVsoOYC
	haYJwF2U=; b=zAQrGtzJHPZQi28RrD+oaqOMb0pQ+qPs9d5qqvAhT+9LEue3DhA
	rtDB54aDcXSBW9duYreImtqf7cVDqyinLU/J4rg7VB4XQ4LQr2Rk4yXetkTPPOzl
	0Dhmxsao0TAaXumJnqX+yNw/zL26jFxJ4MCcbj9cffXYlqsbBcun8JJyX2DX7B77
	WaroWKswd2WPHAqpu1TxEu+oXKAp7Ie1bxdL6HGP5OBstLBaNDFxrR85xhugZu7Z
	OnMHDv89Pwel1RynljquSKBmOCucZMOE1M22dB6AZMN67SDq2Rxn980+Uygj7vh4
	o5m0AjIW9YONonNWCF/fz2rr8KqfVAoYsKA==
X-ME-Sender: <xms:tGS0aa26ngC9KITQiBfSn8zDtNgbsYHzKZE35gEoa7cIOVXjRrXA0w>
    <xme:tGS0aUjhmq4zwuRsLrWeC3EJv6-eM98N4Zp1lsWmSD0P6srZH96scYWFNeCK7v95p
    GXIp_E6U_o2BSwI40h4W9wAbaG7m1mGRf9nD1Rhr3b-fcZIf5hC0Q>
X-ME-Received: <xmr:tGS0aQSkNtHP_QIeawBuyXU2ZBVN9oydYE1wPH8ghN2yAkP9svuVLlFgrCAlq-b7hDSJmL-QEav6fQVnzVitA6uvB58>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvledtgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudduhfevvddugffggefgkeeggfdvieejgfegkedvudetke
    ehhfdvffeugeevfedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpd
    hrtghpthhtohephhgthheslhhsthdruggv
X-ME-Proxy: <xmx:tGS0aVjxGcAiMpajlLx2B1ch_AFc9NvYkaZeMh8E1D0vNdKkucia2A>
    <xmx:tGS0aQ5OYlGXR-mEkkPzzjaK7eFsoemVtH9XlZWEtS1ljMEstB3SOw>
    <xmx:tGS0aSBRdRwnVGnrYDY-ovyvM-COUZ2Jhg89zbiqYysPsqIb6QkkkA>
    <xmx:tGS0aXZUKXwm2Ehb9Q8-cBJ3fgADV-mxsoVVSudpTXx_ryfGsC4U-g>
    <xmx:tGS0afEultuZgsylaaCROCZp2kZ01_K5r9-L4tl2nAJVCCWeQGf-ccuZ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Mar 2026 15:25:39 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: hch@lst.de
Subject: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Date: Fri, 13 Mar 2026 12:26:05 -0700
Message-ID: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As far as I can tell, we never intentionally constrained ourselves to
these status codes, and it is misleading and surprising to lack the
bdev error logging when we get a different error code from the block
layer. This can lead to jumping to a wrong conclusion like "this
system didn't see any bio failures but aborted with EIO".

For example on nvme devices, I observe many failures coming back as
BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
BLK_STS_* status values in nvme_error_status().

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/bio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2a2a21aec817..08b1d62603d0 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -352,8 +352,7 @@ static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *d
 {
 	if (!dev || !dev->bdev)
 		return;
-	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
-		return;
+	ASSERT(bio->bi_status);
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-- 
2.53.0

