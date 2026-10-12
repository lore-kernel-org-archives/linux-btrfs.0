Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C514F4D17B9
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832076; cv=none; b=WgBaDLa3pDSiCJAnYMxMhzKFBApVu4hMbi2IJbIKpyYnv6R6enXI2vL5IiA9wvB45yAurZKHunYfMsU3hH7k5zcGwALX2SiFXoVLF6WT9FbV4QvevsSXuhreYoExSZSUcGRPyTwAEcRfi7+LfBfgTr4f2IbpT3j3Tpptjrk+nHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832076; c=relaxed/simple;
	bh=V4OuHsWKulSYb8O6Y97YMTQ03/TgCCTk0mWKJeungpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxdR9zr46RVsko8wrOer9kWgvlokfc3MQcBBAa6pH+8yXBO7dYmjarOBTI2wZTFTFJdg1E1ErY+3annUHtjNgyze6ucbiaUOcjJqD+RaoWx1mwDVE4s6hZn9zNMlLO8X5FIKCkKXmsfNMxFbVyZuVy0lW0VkdjlHU2PIzRdBIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o5RJuofS; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o5RJuofS"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49ff680331aso17801705e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832073; x=1792436873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=o5RJuofSuQDuJdJ95Mb4pvYyrjY8cVPQkHbDhr5vcO/Vb5Bbqo60+vGiZWVOGCQ5JE
         yCaDs23Eoot51O/iJgcZ+rU65VIVVQc7gh2idET8TZ3IvrNp7sxi31l9Re93ikR5kJ54
         8DHJMm/Wlbg4EevcNUdivOGfCTUQjAf1QRyOjDG9wG9Dodc8iELzHE5TbbICIxoYpl2P
         y1GKJr1q3TQry52Z+ZZnP3a+7Qn5s5zIXcb5O6qcES2ONQtn6o8FeYiz0dHfVLgpU0u4
         5pgY5kFHz/7N9BqgO1UjZexPqNcOpb8xODbCPK/Sz0rSIzz3bLFi6odkdtRPwPPL7Zk8
         aKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832073; x=1792436873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=jnrkCQHgvs6/JHMXbZkKxpjVCVBAJyObvA2aaFlFryb/OA2H6Rl4lZ5zz+Z/YfQs1y
         /e7GtilNHFkFRy+WZDrVctX2cgDQkp6o93to67GQX//OyYiCZOGQUhJCh7hUZLpYeJ8s
         pQGsXR2/nFQckEheMTiyfaQ+pFYeI36vI3cYTvEAMGinD3TR/G9lYRLRjKJV8lYOEON7
         TI8pW45WONeygenmk7Bg/Vo7B/+9IJPHx2INa0J1JGH7CHJrbd9w6yyBoOnF09CDfKxh
         DKvI/X4PavI3OWGiMfKC6gsAX2OJuexKZ5vua6SN5ytqdMAi2qAufO8zouD6LY+swwlO
         x8Lw==
X-Forwarded-Encrypted: i=1; AKwUvBy9j2oY8BkYI+XlWiEyY2ULN6AV3SsvYWxdzPkrr6Yvti9CaCpXRHSEVPulXYfI0UAaDdRutWyBj+XcoQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI2ruaTb1akgbzezT8BXeRE1irD48qG91TrC57WW8Kv9Mj6IGin
	LmAa6OYXie/15ObL1t5wjTIzcjfO9SnfHF4BSQRHd8iRhFzCevY32U25
X-Gm-Gg: AYBFou3hzVWJJRsPENGyLaJMUxbp0gWhOLCISOiHabvSgZn7pU/PsX+nocJgRBD/ix7
	YQBqQ9xC72H6OOaRcY5cKqAaImHg4c4nvWag3/vaPkn/K3NxfoqVjMdJ+9IhaBbYQD7EIiE7VRO
	esVHLwMFC3rdn6kMcBELlwgdSqGJaTY3PJa4eEzkRGRpViEWbCkbocUaspahA7LMic1SnwucBFl
	A/fjQr1c6NJe9aXYAv8s491YwOeptcgchtP1GnFSGrZ87r0PcxjluiSqvspmk/bW7qA7Gn2SgYQ
	lLZycJZBYTYhxsCvqs7rynhPTngeigeGETLg3Jq7NNjFEBI2I3uxDvW7f92ifqs32YMEr5kuWCI
	ZSVC7RILArmlGht+7l16soMqJZkwoCrx5kNUh4e53UW5plgu88QTMAS5sEldKaHjoXqzy5BP6OY
	ZyUUivmFeZRNJNMwsfiEnhpbOx+cGyQqSaiI2jNvAQefxKLZhABXWsF7/CZUVOqlmIXqnztE39w
	HR7hQ==
X-Received: by 2002:a05:600c:4747:b0:4a1:77db:45d9 with SMTP id 5b1f17b1804b1-4a18e47aa9amr214821985e9.6.1791832072711;
        Mon, 12 Oct 2026 12:07:52 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:50 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 3/6] btrfs: add per-inode compression levels in xattrs
Date: Mon, 12 Oct 2026 21:07:28 +0200
Message-ID: <20261012190731.951056-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012190731.951056-1-koray.fra@gmail.com>
References: <20261012190731.951056-1-koray.fra@gmail.com>
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

