Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0504388E50
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775492125; cv=none; b=HjSPOiDamrX2riYCkINAVU6SPMHG2SOEXxWowLF7hYHyJuargjfjK9ZbaTC21lPmxxYSbaZhVItE0w/DdGxRHc+6MNcpeQUNucRrC6UBbOuXwFjVHvhThVZN+pW/Ak9RPakKwuISWlDX0e5QwOdCufSJDO6fBcYt0Eo0q/+nUaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775492125; c=relaxed/simple;
	bh=KzX+zQmn2AzB+I+4nmCW6adsJLNZ0QJvQRtVfRzuPPg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TIIQIJuJe7M9jrUumlLOYfwGoPKZCXzSX4+0p9yd+sTQfQqeDG3SFkKdUD9quhbFbV26exZ3QqvP9K0sRiqXTOurO5FLnaT8TwWIqi1sCuRA/PlEB8RIDctPtlxYOQnl4z3/OGgQ0CwFFNuOZX0dJCfcPYE8mXPFmqVW5ZwY9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=h4Y1yt+O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HORC1Aa2; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="h4Y1yt+O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HORC1Aa2"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 264781400224;
	Mon,  6 Apr 2026 12:15:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Apr 2026 12:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1775492123; x=1775578523; bh=idmgiwsRk5hLP9TaX+jZw
	XgWGwECpYIqiAqqmDSpkzI=; b=h4Y1yt+O1To3sZA4eW1q9UPVeIjYUGImXAzyh
	hUfCpJZcEfcSIgbATswHWeErj+73l5FKpqvVxqGDreX8lmWGK5RZNOQx2sqrDRse
	mAkdzdQ7g7mS77xoheyKOB2+1jMrwXEL6ScZdyKj2tcq+q7rfzoe5AYA08fCMzUU
	4cmul4F7tF5wOeXdVgr8KgECIuCrlMpoub4gpmiVYueWlKGFClUSFLlN/IhzaSuv
	FtjdWW0VctE/ITiDv7ncJHZ4m6/XNL/v4xVX8PiNGJUl/Fhh1TTkJGnqugKStRNR
	OR5tCV4B0KHuF2QX+tUgDCz5ZiRMy3KMrPwsWdAJZstRhIoNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775492123; x=1775578523; bh=idmgiwsRk5hLP9TaX+jZwXgWGwECpYIqiAq
	qmDSpkzI=; b=HORC1Aa2Ped4VIyD8ziNVi7mZ0dkJLa9T4zfpijEC1/VRH99Mzk
	XOCf41J7y98njotVydcSyzsy7rAIy6RYRT5WEGmLHAaK66cEosynIc3HsmUT+orC
	skjc+3sf7KKBGHkkFUFnZ2kUIGAGiJzimzBnRRfZaWXQSyWII5uvAzOnHO1OVXY2
	cXdU917fCDDc/hWGJ50zNuUYIgxn6zVlDDctF9CZZXF55QHY+0K7lw0be+2398y0
	vJU8F4kHaUGZW0daULfozZflOoIMF6aXW+Bc8JtEF5MAVH+X+s9wTbBMzz6FuCT2
	fs4+438B0m+kk2FIC8mSxfv/pAeeb7cMj8Q==
X-ME-Sender: <xms:G9zTaQxirsO5Ztw1zlF6hh6-p8xdHrV22hP5q-TpSUgRHxWYWswBDg>
    <xme:G9zTaaQm-qCZ1fS6S3j3ZEVHVIBQpog_vRFB8h62DfqBUkXCyvRH7AbO7-Zm-Zw6o
    0mY0xphe1sFpKWVtv5U3VDTimaEbAa6cvKrt1MFVJqrzIjSZKlaxtye>
X-ME-Received: <xmr:G9zTaf_BslS2zbAviitLywoKrDSlkm9DNfYM00Y2VOp9uqeUne9EtraofriNFrL_4wtrSzH3E9RWAxi8QUKxe1TP3jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddukedukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecu
    ggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekudduteefke
    fffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:G9zTaZr8VcvMq9TPK4EZVQflKWmpOycWgllpKxFBD1ZlzXv4ZnF2Uw>
    <xmx:G9zTaUlnTSgWv4Ftk6YkgwJoESBr3hgRKFHUGkIrDLxC1b_QjIqBJg>
    <xmx:G9zTaYJ7pNY0L_fIc4BJ48R_KX7QQq5yXrT7T84kf2UdmOhi07bxBA>
    <xmx:G9zTaRwVbJ6nPv7vOnTaVobCJF8qOI4oRlLotUtmYY0zy9Kpq3a2ig>
    <xmx:G9zTaRUIvrRirglG5RgLVZJZupgFqQsYyyzKj9AQtuJF2PEQVOmDa55k>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Apr 2026 12:15:22 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3] btrfs: btrfs_log_dev_io_error() on all bio errors
Date: Mon,  6 Apr 2026 09:15:15 -0700
Message-ID: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
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
v3:
- actually do the change stated in v2...
v2:
- proper bdev err logging for expected block errors
- btrfs_warn_rl for all other errors

---
 fs/btrfs/bio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2a2a21aec817..9c3cd6978880 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2022 Christoph Hellwig.
  */
 
+#include "linux/blk_types.h"
 #include <linux/bio.h>
 #include "bio.h"
 #include "ctree.h"
@@ -350,11 +351,18 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 
 static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *dev)
 {
+	blk_status_t sts = bio->bi_status;
+
 	if (!dev || !dev->bdev)
 		return;
-	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
+	if (unlikely(sts == BLK_STS_OK))
 		return;
-
+	if (unlikely(sts != BLK_STS_IOERR && sts != BLK_STS_TARGET &&
+		     sts != BLK_STS_MEDIUM && sts != BLK_STS_PROTECTION)) {
+		btrfs_warn_rl(dev->fs_info, "bdev %s unexpected block io error: %d",
+			      btrfs_dev_name(dev), sts);
+		return;
+	}
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
 	else if (!(bio->bi_opf & REQ_RAHEAD))
-- 
2.53.0

