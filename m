Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B345E27F728
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 04:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783226527; cv=none; b=LJw0nmHl+HDR0DhVk459OLw0qxKb7F3ii1zTvaJQyAZ7vfIbQHJS+CWQRjCU1AW8BwG7jbm6jMH99knV0Xau8cWNW8t3MR8fohEftTnfBGf8fyovrINts4m32CHhguvkkBWXRv18NSdPQLkSLA8mllXQK/2gbz3odqJmmcZuYYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783226527; c=relaxed/simple;
	bh=XLicVvxrsv5GEevi03jCRKV9BCCB/Co+G/79Cd/uAW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=so/hxDqNgDiNr2Du9nDs766xcRS2/jFib64kHtGpuNBxRY6eclvrvN8HUZfD2V5kCvJyGst576gIV5lEFiRF+N51E2SSYZ16pHb84XBRAMIbdrUEpyZJ8xdQlREsbg0xN07KRWdeTmeFSY/Md99m3Oft4F1brnmVXA7yoLpU154=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXNUgI6F; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXNUgI6F"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e53581361so87245785a.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 21:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783226525; x=1783831325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2TC8LUxSZjfYaDFbttt5ROeXawmqiGcsqMnNwL0UQw=;
        b=QXNUgI6FwYy9g2D+Wv+HmT3/oe1otHb+3PWeVAwjElQDlp1ELKZ0BiT8skwsr5PkUS
         9tRfqKeTXy7TxMHCx0+0b1lhXdR+0+F8uWtdKqQI4Rp1TnHxRu8eJnWUjYljnQt6TXAt
         LidcLp//C5gd0GSvrAh4UXy5HCVetTQ+nl0elI5/O4VksGmv7pdTFqogT9OU9T0nqtRH
         IE7DEZFE0EK7n3AyEkMOqP0db3Af+p7KpKaxtC3+Tp3Br+D8q/SBGiEI6jAHh0QFWm56
         H2Zg5TTG3xa1qNaQKkb1YUZp7cMhdpBPkC1IvUH3kZLHhBQCi/ky+ZBm12fxXqT5dn93
         07sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783226525; x=1783831325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2TC8LUxSZjfYaDFbttt5ROeXawmqiGcsqMnNwL0UQw=;
        b=eDSNHK/EgGNgKOVhd7W7Vde4fLADw3eZ0R5OMFhC/kAm4zMGvkjD1GFjpSkX2FZfzj
         SDg9Z8U0T8TiUv7F6bTmrP/CHyqVjvOcLA++S5maAAQNr/LOUM7FLTCOT9qjqv2U+IqF
         HXO9nf5HxMc+K7EaxcxDJo8dXdZBIt/cg9f1DBmSzsAnH5TZmbJdL6TV7UCxFTeSzLq9
         e07trM7SqoKcsscWJD+l42Wtjc8XhR+uegXzez+aOwRhmwUQgKJFyj1rgW+0GkbnHaPK
         Ru2e+1RoumdB9F0vqUPpQjisJE1PQGFOP96gOTzh0jRrwk7P8vd6u5DuUSHt5AmYWBHB
         JE1w==
X-Gm-Message-State: AOJu0Yzd/52M6mUKt55oBThDVuPjEXEhSmMnJKxB9n/dR1/tc/11W5LP
	jcmvxIeRQuCSF714CuFB3/mGg30bR4TVh1/kEMDDwvj2gW+q1drPFmVEG4SJNA==
X-Gm-Gg: AfdE7cnN6xrqgml+6uMfcqIl14MxOR1ZT965CviqQjzoh1JzkQmq2Fgj9N0lK86L5QA
	cRvEWZgjr/NeCgdR+ykExAgHTK2FWilZcDi8h6dns6gcdnhAu1lvyDD1XI1DGB5UApRwiArxkbE
	9FHpLEloXlQZcWTsulQr+emjw+E7Ux4HiIphfbcTV9WxZg8yOhsKg9f88/f2DAiE/cEUT03+YNE
	ttKIczWxuzC93YegaaLqNARPE6R0lYoiXGp8pQn4PYyAm8nmRj0/NDyvs1uvMAA+qy41wXgwq3+
	8GJPzQVmISasnbnyn94UJgSjMEeyX+YgZBT4+trW4ZottqnT+AiE/vdPAn34HAnHofMrlQeViFc
	1Oq5iLuQA+S+mF4ykdCfbxGkFDREplIaDFiK1CNv8N4gkXayCtL5yCXO8RVUG9LR2Q5XZ8BmzgI
	oQRFoVi5598BwZjkT7Rmn1WKhIfUnPCgqbSp+vUAUdrQ==
X-Received: by 2002:a05:620a:272a:b0:92e:7b45:768c with SMTP id af79cd13be357-92e9a502dfbmr788512785a.62.1783226524636;
        Sat, 04 Jul 2026 21:42:04 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cfa470sm587562385a.44.2026.07.04.21.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 21:42:04 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	jbacik@fb.com,
	stable@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] btrfs: fix extent map leak in NOCOW direct I/O write
Date: Sun,  5 Jul 2026 00:41:52 -0400
Message-ID: <20260705044154.42627-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
extent map reference that must be dropped on all exit paths.

For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
keeps using that extent map and asks btrfs_create_dio_extent() to
allocate the ordered extent. If that fails, for example because
btrfs_alloc_ordered_extent() fails, the function returns the error
without dropping the input extent map. The PREALLOC path avoided this by
dropping the input extent map before replacing it with the newly
created one.

Check the error from btrfs_create_dio_extent() before replacing the
map and drop the input extent map on failure.

Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 fs/btrfs/direct-io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..2b1a55769ec6 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -281,17 +281,19 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
 					      &file_extent, type);
 		btrfs_dec_nocow_writers(bg);
+		if (IS_ERR(em2)) {
+			ret = PTR_ERR(em2);
+			btrfs_free_extent_map(em);
+			*map = NULL;
+			goto out;
+		}
+
 		if (type == BTRFS_ORDERED_PREALLOC) {
 			btrfs_free_extent_map(em);
 			*map = em2;
 			em = em2;
 		}
 
-		if (IS_ERR(em2)) {
-			ret = PTR_ERR(em2);
-			goto out;
-		}
-
 		dio_data->nocow_done = true;
 	} else {
 		/* Our caller expects us to free the input extent map. */
-- 
2.43.0

