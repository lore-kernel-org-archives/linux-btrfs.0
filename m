Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679D537DE9D
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443858; cv=none; b=QOj9Y80cScENQY35YHJk04mbpXJzlzcpFydn872IsIBnbS5+75182ZuE763CvO+MaYRFM54UNAidarF5bjtFikJTyzD+eX+7/6Kw+tWwOhLlN9HR0yhiseVf5PwJ8+SZDjtYVogB/kKpFOXLkul+uzdFbIVlJUNO7yS8rlppLZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443858; c=relaxed/simple;
	bh=V4OuHsWKulSYb8O6Y97YMTQ03/TgCCTk0mWKJeungpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PefYcAaAM9cb2qN4QBhHvZ49e1ss0Q6zPPo+00xfnYYt3KBxbo3awukEUGbPreMmSuYjaGSN32ltrVdrp91vcoy+Yg1550Rs6j7pV9HuvUdFqFNHJZapGa9eGSfqUtZGbD8ovqKVHtyjCGG+5Gjhhf34IJExPzPe/15mIQrPxdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5nWZcp+; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5nWZcp+"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7bcb94d3so13420295e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443848; x=1791048648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=k5nWZcp+t/XS8oAvm9ppfOeUGHXq6kOC9O2jsWPAURzZGZmcO1CWCPsRk91pqYPH1F
         f5lpAD0Cd68y/uLkIeX1LepawekD+TcD4ZAjqT32fWnLuZ0HFoUFpNzTwyl3GL0rZZEk
         0fW4z393jeYxDoQr73G6CG/VU9DZNLBvN1msENviP10LxzgLVDbHlKR2tYGhKxp2t+O/
         foamfBiAPqReTPy9tS+fPw3ctkkuKHsMkw/8/o+ByzioEHGrfz55AiizSoCczrdFcknD
         MimLV9A6SIbPaoHvWTixCm4YjL5c6O4DEca/0mGaVM9Gt9LljutMigacYmAbiFCP1J9A
         RWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443848; x=1791048648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=RZaQ0I6eeychVPsxHkCDFIa7hXbrU5Wq+qe6OUrWIo+azmVCC+ECAquycbgfvFpM0R
         M0ah0I9EvjQlMuO6xtVkLtb6EEc9kVJ9OHVH4GfxenwBma+2/q0hE7Ws2HP6EIZrBo4+
         WXp6VFSMU45rE+xe87erZnRWwPxgZZDeWT2zmT5TPcvcZDa+od8yBfslaVw8hT1fRnmc
         0+YWFnl4EJQfQwCdwMT/q6HslPc7iE76qzODVyk4U7aXpWDR8rXiVz2DfSWTTCBGbpYq
         XQB1ZZAp2gKM/dfO/m/fXmQSFIjhfCuuodVUwe27RXK0/+v1ARDdoDj6wByZGu7Pyt6H
         Yfdw==
X-Forwarded-Encrypted: i=1; AKwUvByCkl2KOxFiburyKvKmkIBlFAwRy8El7ODXHy+/ruXu4SF2cQzZ2amz9D6PwCulet3yvEp5ke5gvW8C+w==@vger.kernel.org
X-Gm-Message-State: AFuF++mJJhtt+msTrcRwLuXY54mHd8AT5PNTkDgDpg5i+WqNZrKtKyLf
	eDhUh6akZ5+aqImsPrKh4siEl+et9zHmaJ2SVRCOQxMvBUAj0MCGbqHW
X-Gm-Gg: AYBFou248E52w2JwN+iwaMg1y6mF1p11jYXu+Q+/WacrfT5M3lb+Fu2oBVcjxxXiy//
	HIYkDGTbcX3XaDtwgpEibMp/iO2QhpOz/l5T80WdKrERO9K/s7y17NgRtW4geiO9LjgQb707+hr
	YFCQHcUQRasW9kzWPaxM57bjGbLcwtC6xycpNBI+9TB8Bpvg6om86keeO4YHuXhZSvqO+ZRlVPu
	bwfy4SA7g8SEKvCelwqFevdZOKEsowIF1Nz62lJvLbT+ljH5aksgAYA8LOq8mSDvBVmUnHcfmXW
	Q2lCM0VgLqj4lLXrbHQqsy4AdjivCjlWnwaAg3wAIV1tky1Ks5ZLvvPS8uBtkkPWbD8BIaq28zk
	s+1W/NuiXXm+BJ+vNHi01ZdDaxlYCzefIobCaKta6a+sTJdxJTWsSpPdkQqCXviNPMcbltRqTHg
	knwZUDC7e8yiwnMIG6Ty2IoVO357k12cXsqz3PXpMNAFUy/YGkUOEfP9jGWR6FneV2PA==
X-Received: by 2002:a05:600c:3b9c:b0:49c:fed6:cd3f with SMTP id 5b1f17b1804b1-49fe66dfdf8mr199243435e9.23.1790443847565;
        Sat, 26 Sep 2026 10:30:47 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:46 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 3/6] btrfs: add per-inode compression levels in xattrs
Date: Sat, 26 Sep 2026 19:29:33 +0200
Message-ID: <20260926172936.337085-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926172936.337085-1-koray.fra@gmail.com>
References: <20260926172936.337085-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for specifying algo:level using
btrfs property set /path/to/file compression "algo:level".

Add a signed 8 bit prop_compress_level property to btrfs_inode, which
can support from level -128 to 127, plenty for the currently supported
algo:level(s).

Change prop_compression_apply() to use the already present
btrfs_match_compress_type() and btrfs_compress_str2level() to parse the
xattr, using a stack-based buffer and memcpy() to convert the
user-supplied xattr value to a NUL-terminated string to be used by
btrfs_compress_str2level().

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 10 ++++++++++
 fs/btrfs/props.c       | 31 ++++++++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46c62f980c24..280b45e7ddf2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -131,6 +131,7 @@ struct btrfs_inode {
 
 	/* Cached value of inode property 'compression'. */
 	u8 prop_compress;
+	s8 prop_compress_level;
 
 	/*
 	 * Force compression on the file using the defrag ioctl, could be
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85a7c561cf8..2df3eb19ee30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -942,6 +942,11 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
+		if (inode->prop_compress_level)
+			compress_level = inode->prop_compress_level;
+		else if (compress_type != fs_info->compress_type)
+			compress_level = 0;
+		/* else use fs_info->compress_level */
 	}
 
 	/* Compression level is applied here. */
@@ -2338,6 +2343,11 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
+			if (inode->prop_compress_level)
+				compress_level = inode->prop_compress_level;
+			else if (compress_type != fs_info->compress_type)
+				compress_level = 0;
+			/* else use fs_info->compress_level */
 		}
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 2e706093e186..7b966b9e4c8d 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -332,6 +332,10 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int type;
+	int level = 0;
+	int ret = 0;
+	char value_str[BTRFS_COMPRESS_PROP_MAX_LEN];
+	int level_pos = 0;
 
 	/* Reset to defaults */
 	if (len == 0) {
@@ -351,21 +355,42 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, 3)) {
+	if (len >= BTRFS_COMPRESS_PROP_MAX_LEN)
+		return -EINVAL;
+
+	memcpy(value_str, value, len);
+	value_str[len] = '\0';
+
+	if (btrfs_match_compress_type(value_str, "lzo", true)) {
 		type = BTRFS_COMPRESS_LZO;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
-	} else if (!strncmp("zlib", value, 4)) {
+	} else if (btrfs_match_compress_type(value_str, "zlib", true)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, 4)) {
+		level_pos = 4;
+	} else if (btrfs_match_compress_type(value_str, "zstd", true)) {
 		type = BTRFS_COMPRESS_ZSTD;
+		level_pos = 4;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
 		return -EINVAL;
 	}
 
+	/* Parse level if the algorithm supports it */
+	if (level_pos > 0) {
+		const char *level_str = value_str + level_pos;
+
+		/* and if user specified it */
+		if (level_str[0] == ':') {
+			ret = btrfs_compress_str2level(type, level_str, &level);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	inode->flags |= BTRFS_INODE_COMPRESS;
 	inode->prop_compress = type;
+	inode->prop_compress_level = level;
 
 	return 0;
 }
-- 
2.55.0

