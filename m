Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13D3932E9
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301659; cv=none; b=ZCkcz0wj3dY0uwo11Pl9ZFavEhUpUIC8JZEs2S/GdYd+eZgMyhAtwJuJ5Aq/tJuBB5bMcVgIo6D32serNNG5aa4lgsg8UrHrjKGvoCs6hQLoOotzXPdTvhy5fQL/BP0OVwJYHmWYjVxeu5ew+8bm0erRBx49SQOMXgBGU7dcN+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301659; c=relaxed/simple;
	bh=vFpG4UipYw1Yc3S2YELlyi5M9EmajglOp1ZMcnCDCH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj9y6sTIT7lxTNchXQrvezCgcrSsZV/z7nqUz5a11PdubSVVX4sMxOrXk+KnXFOwJfCZZVdhf1MeKK8Tdlfq42932hFyWVRHbQVh0j+KVWb2g7WAFFKcqk7nT7suHPc5BGBh2dTFycEl1lWIUpqfFBOxm1NhfVQG5zi/XXijSOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BscZvlDt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BscZvlDt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so10394775e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301656; x=1786906456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lATJyKJivqjhXdXDn9f09DLVSUR+ZE4CAMEwlePuWO0=;
        b=BscZvlDtjgfzAQPIS4C4j/yLcXRqZ5XSn6nXxEfG9G+ky/bVNaNHmSy8WTABV6lgfo
         z2neRVzwNWF2vUM+5WxUxloWyV1O3fIkMdarA8faPJY0/9okSb2URa5vkAP9G38b+NPK
         oH6l5RcqpAjeF4fh/bR/m1ZG3AZu0wm2g/52a1cogEjdIEl5jlqbK5gyvzaYgID31gDx
         Xu1/2HX0oI2EjvNjBbFZdZrSkd1VrkMRrVktRIkIhhpJZAVSXONhPptU4RWth7flZrbe
         +A6uDvB5eJXH8UnimfRJW5egaPGHtznwbYLtMy4zcuuuRwDhMYF4gFJhBYJEJtenJbTu
         qkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301656; x=1786906456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lATJyKJivqjhXdXDn9f09DLVSUR+ZE4CAMEwlePuWO0=;
        b=pJ585eZsZQCKdulBocVJnYSXBzakjGcJ/RcmmbKDaiRInQMDOQCukS0g1E0g8M1j6D
         WlEUyL4z6K8MRWkbKMJwysyfl7oYpLFBcRapJxFuao1E2SzNROMJKJt82R/cdWAj5WDN
         73tO00ZYze1oY9P1kEwfPio2noO16K/Q0PLF5vVbEfxqGzjPrnbzyKUnr3ngGG3o3OVY
         k2DOnp4O+sMSi4VSgG6K5kSltEr45bQUYWaaCHqMV6Gqd3BZlw1EM6yY6vKpiJJ9RbrP
         MPSfg1VVqEAE6GpfC4xXwN0u6Vo1V2zb839nxysILCZWfAAqb0we6krqgLpPsbqisNJY
         2Uww==
X-Forwarded-Encrypted: i=1; AHgh+RoBHlUW34Bcx+kD68+LvTt3L7Ql/F/872PUNj1NAOopaVhdM1iqDt6bFBpd3tJYoDlup3lEgUZR+/r+vg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlvr51yhSQWkHoZ9nthrb4h6fVageP62FmqC+AuXVguRcVadKK
	l7zqVS9Yvw/0aKa+jLYbtV5Rr4DVMrTIaPrsbOA3eiL3ln7+USzIcPS1
X-Gm-Gg: AR+sD124EWvB4xHFc2x4rjIipxuNLYkSURg2eKQauVsYRZf53GmMojwCX/XTh7V+8hQ
	XaAzgrggUHm2swSPlw5oIM8el9FDgnS+s3ezVCsB60Kd2LstAKaYp+nheP+EjjyJmMByqArWsKe
	pRCiPVcQEox3vPYn/4IaVY/AW+Sc3rv+hKJczsPN9lS7Gpt12uIo6rkH1sHBJw7yKyxhQIHEKAd
	kFch5Kl4KRw4bilI+AVgubHD3ISXeADHdfHQh2NayegaQMBEY8wlabUkrQNKDp38dSkGnQH0QRw
	d89EY1zum+JogL62AWTloycm5EZZyGkAwEPMpDtf2wsiTdQwNwjVPizZcEUbyksacfA9d6BDI2K
	kgJIl5epZuHoE7m7uKIEJgS6/QVIR+EWnEvXXOIlSeogqvmrbcLcrGq/Hy0FjxU5AT6BampftOH
	Qh64/dJr+X/dfCfhLbUutiIdy/zG/isQ7slwmakOVgNgQWzSC8RtcI1T9VtHhJ3hie5Hc=
X-Received: by 2002:a05:600c:4f82:b0:495:4cb8:42b9 with SMTP id 5b1f17b1804b1-4994e7112a3mr429170635e9.4.1786301655677;
        Sun, 09 Aug 2026 11:54:15 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:14 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 1/5] btrfs: fix -o compress= level getting inherited by compression xattr property
Date: Sun,  9 Aug 2026 20:52:59 +0200
Message-ID: <20260809185303.600071-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260809185303.600071-1-koray.fra@gmail.com>
References: <20260809185303.600071-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When setting the btrfs.compression xattr, btrfs uses the mount option level
(since levels in the xattr aren't supported yet) to compress the data, even
if the compression algorithm between the property and the compress= option
are different (!!).
For example, when mounting with compress=zstd:15 and setting
btrfs.compression=zlib, the data would get compressed at zlib:9, because
btrfs would take "zlib" from the xattr but "15" from the mount option,
which would then get correctly clamped at 9.

To fix, just hard-code the compress level at 0, forcing the property's
algorithm default.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2534cd9284d5..6d7f2aa2555c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
+		compress_level = 0;
 	}
 
 	/* Compression level is applied here. */
@@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
+			compress_level = 0;
 		}
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
-- 
2.55.0

