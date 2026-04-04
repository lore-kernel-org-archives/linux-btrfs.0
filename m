Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D65F3290DB
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Apr 2026 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775318287; cv=none; b=cN9BUahMynwKPkZ7wp9Cs3FS9sZuOP6KSD7XyvkkPLb7dV272sDWgqABvkO7Ewq2uIG7KSn57fs7wQyDz/i5ekveDjZR4H5R8Nbbv/2Rfqom8/+p4z52zb7vyOKLg8GXOQeutuj8qiH/NBZgAj79dPo99uI+mQFmUxcZP+/73TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775318287; c=relaxed/simple;
	bh=c4TgmJFIT7XBehOL4KvZc0nryh1fOTcjEklNtd5lrwI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GKu1atZB0Po82ythVbaT5xGxgeDQoLnJODWowA+RcQUW3jOQ7yn9nHsBQuimdwwnxq1YYx58i7+Wl5P/fYSTvtEfQu7BYeUVSgpDThS0bh8L09Mg6ucbQGLVC4jX0q+aXF0kS+KfaC9fejvXkN5R9JwN/mM5YmyI4ur08Pyo7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=zT6mw9jQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WX7i9ET2; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="zT6mw9jQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WX7i9ET2"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 42015EC01AF;
	Sat,  4 Apr 2026 11:58:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sat, 04 Apr 2026 11:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1775318283; x=1775404683; bh=AonG/s3xqGFSta7q+av2L
	SuhqSGHs3zteNsL0AbQzjY=; b=zT6mw9jQHVzP1kEw5I+PjnO8ALVC7RyE1Nqih
	cch/VOiYWE/Y01Ynd+Wyzy4/qJTbkwGFHj9l8Mc5p4V4X3DRs4mKtTmItmFZnttz
	At35fy6ZWeSuAnovlfRXDJgfsA/4ZYb8ZVqUsr6aQqkMwZGm0fHGramM+uO7Lm0w
	sfk938V79QHC1MQp8PSE0sC//v7miflN9te0tz7zIsyJ7WBV4uHFJgFZkWPG2Nwj
	GUnlIC2O+ZLo7rg06tTG5/2pkwV69S0HOM0bC8kA4UUJb535c2W5M+UVfOl0x17h
	X4NBjNKldQd12B3jWrkhWFaXkfuYzm9dgKz60MGp3V6fSfA1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775318283; x=1775404683; bh=AonG/s3xqGFSta7q+av2LSuhqSGHs3zteNs
	L0AbQzjY=; b=WX7i9ET2Wf7415v2k8jxtKJ202c5hCfhcmptilNhelMqfTbQXZN
	9reDCWsp3+WtLPs8I8VXQz9mHiZK+G+n/aOrpRecIsQ0K95d0l8zU4v/9EG2qvzp
	bFiJuZ5lkONzQHVInY510UfPSlAn5rc8woRTWeFe4Qim1FJxRjuNXfeegBnjxLPh
	KUT2a5ldnZzmhxkcLE4NcswL+Es02sRBKvAvgmZQEUNV4T+G7HPDqHpNwmI25NtV
	wYEHUm6/Qss2x8d/Us770KDXh/F6Axda4YWEE6/lUoFHzikHtVr41R5VeD5K4JzV
	8ilq1rbo8JhlIC6rCA48y/Jjf8Rp/HiERZA==
X-ME-Sender: <xms:CzXRaXc6_XvZpb0jgP5vOnILJ5TmT-w_MUdPiFegs8SS_q4DpClnFw>
    <xme:CzXRaTNuoD1mdETYqtiWWVrtdIBxLZYRh5BzyVkxAsFsQHkTq8XISuf4Oocnc0i34
    cSWh3g3I498cxQy1z6Gqr-SSOT3PmktmCztCZAxQ0gpkFG0DO3ZX3U>
X-ME-Received: <xmr:CzXRaeKznWVJm4SpKBR4OGg9MLoEPjNU8OHGvSiPg_yPcPtlnQgAApEXRZab2NhUIgr5_3xQ0vZQ2FQug-js_sNNNQM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecu
    ggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekudduteefke
    fffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:CzXRaUHs9OvbLBOz9cV3xwMIYP-1J325_iPlCxKrsY0TB8l2iBF2cw>
    <xmx:CzXRaWR7PZd3IIdOWxk1KTHo5HSs_r5FY3B175gCF1rikhw-VSSRHg>
    <xmx:CzXRaQFN0belT2Iw-vXanGuksFB3gV-w8alogguYwCr1VdIndiNctQ>
    <xmx:CzXRaS9izQX5Wht24OqGfA41eyoFkqOVG5a0XAU_yWLmOfZhcOnrcw>
    <xmx:CzXRabBFSUiyn5AB2QMhIjWRW_1W4e6hCPQsjJgIyvbfgePz7OKCiVDD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Apr 2026 11:58:02 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2] btrfs: btrfs_log_dev_io_error() on all bio errors
Date: Sat,  4 Apr 2026 08:57:53 -0700
Message-ID: <f91b3827c56947e58b4606f142bef022b54da70e.1775318158.git.boris@bur.io>
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

So handle the known expected errors and make some noise on the rest
which we expect won't really happen.

Signed-off-by: Boris Burkov <boris@bur.io>
---
Changelog:
v2:
- proper bdev err logging for expected block errors
- btrfs_warn_rl for all other errors
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

