Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9F03EC68E
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097638; cv=none; b=gV1THZOA/Yk5HUjXnyqp+KxVURGpOTFOwahySgm5mrZJ12LavGL7dJQCxIVlHndOI34rmYC76kpFns7fN4Ti94SRAWut/m/QJP4pruN7tBjpXnEusKbvjdNUutjFlOP/D2nYv+z9cwHDuE/XysaYajMzmDjARruODWaeLu14564=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097638; c=relaxed/simple;
	bh=V4OuHsWKulSYb8O6Y97YMTQ03/TgCCTk0mWKJeungpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scGxrhg7R+0C/uHcur7BHuc84C1H1wAuLrZsB6bFLWzoFio+2Br35yMS/cm4ESaL0Mt47+HPmg6fOhONsLFGY3YysVUXkgmRg3XHjvH5Zb21Dd5fCU3nXaeuHt2Voa2UTc1Q2SwXOLvMWhJ0AHZsFIK7XpstzQcd8bUFkf3Ku68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JbgSt7Tp; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbgSt7Tp"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso4268375e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097635; x=1789702435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=JbgSt7TpL1QsH9H7DiOWgXboOHjMH+t3e2OZpelMFcCxEEIfOpi/1b+JCR75Tqq/AB
         CsePaxV//KHGLRJXJu10fp3mb56FbJBfEsLDKD6iN2Ba273grQP4Ejk3LS2pGi0m71WH
         ItglGgugn34390DITW3vba7A66s1TS1049oZxAA3+C8s4qn1uMLs9Yk5qTwQYv2Qd8yi
         V3PPVDcd6ww2GLvkvbu8xNE69PxZW5nuHksqQBO23kS2Oo18QXxpzxlVcb9GUlMmHINF
         m5T86RnXiZjiWJbXuHrt6kfxmqt/HtXMH09/3fUhpqZvs80oZ3jkMhRRgvaM2fHFtgfp
         UvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097635; x=1789702435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n5vttS/GeukupuyOPBqheepG3TnkKa4hX3b/vaFm6uI=;
        b=Mbs/7UdvppB7/xQI603pvi6jImZYgtSoqyohrDjeP3qUMlry7Z40scxuqrxIRgQ6OG
         SPvB2pJVjbm5BWgf/kN33AW8BBiEaKxk7teVPpI/oyONlvThFrHCH+NcN2+TIutNdpF7
         p0kzL5ffMweoi646FPeR/DRmAUOUeAhpEdUHvd+7Rptxbnco8hWbwviDweKQAWK22QEU
         5v6a7pc/l3tL0gWtsNCiIn15oRUglWGvRdQFLd/j31iDZcK/5nx2wcqXMgPYzUprAuB0
         eyDeTuQrGXxIQ35ZndQXgduo03adfil7nDsGcJ4M5VbAswLEZ7Lc3RascNq4GuFTcrno
         PWJw==
X-Forwarded-Encrypted: i=1; AKwUvBw6daS9+3v0SedBe4voGKb7OyPCVcTYEdh1jwtddVEl9xb0gNItKbljiNmawj2WjMLZtF7Req+CiU2YFA==@vger.kernel.org
X-Gm-Message-State: AFuF++me7LmnBO1RAW544MSluBGSm5TYTmDtg6fMkuVudfU5kdkKuCB5
	VddD/2pFmiM9KbbUJEA2sKYuoyKEn9z6nhflN2Na9rJ06duPV61+8CySvuYpNgIPKqY=
X-Gm-Gg: AYBFou0KoZ4u5YULG4/M/cZaXz3GcqhZZM7KPVyQu9nPstazOII+Q/gVJGLUmPymIyZ
	nXB1Je8LzHagsht9RWbcE/YSLAOoMmug+ecg+xF1biYe6zTcufYD/tu97oOnG4gMCl0+Uo1ACxD
	WPuweTRCd9JA52uBDpWKc7j1Fv2rLuAGKcRPe+9TiZlPgf4Wg9830RW7QmO0KLihKn6WQssjU1V
	XYKS4REL8qh7rK/Qw0qeHoSaXcPsaR6JvhmwNGU7opw+eHw0BMODzNgmVSclgIXQqAqNeJyk6ln
	a7dBiUhUygEAYcy3yQVUQLDeZGqnrhDtjC3h0f2lNYen8XxUHN1ed5s7N9v2HrskMDhHIwghxVY
	9JczOiMazv37j6iNGSMHimWgLhiG8hdV/bHlkIAekXFizlyUee+UMH7w/HSsPxL73rda6Guol5E
	+UcmGYBivkZSF1tKQyd0/HkHOd1bGc1dRGIb4atGu+eAdE8134OVFzfF9Idoa74f6oZrM=
X-Received: by 2002:a05:600c:34ca:b0:499:9240:9a1c with SMTP id 5b1f17b1804b1-49e619a09d3mr21158435e9.15.1789097635151;
        Thu, 10 Sep 2026 20:33:55 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:54 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 3/6] btrfs: add per-inode compression levels in xattrs
Date: Fri, 11 Sep 2026 05:33:33 +0200
Message-ID: <20260911033336.957102-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911033336.957102-1-koray.fra@gmail.com>
References: <20260911033336.957102-1-koray.fra@gmail.com>
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

