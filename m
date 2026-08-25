Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2464457B6
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663300; cv=none; b=l1TSFt7hlc8gtnM3gM1IHG8RDPzqdjT9g/RMW8e8qi0jfRWbmEpMaEETxoMIR3IkL8CpXod600hYN3u3djPSVnxNU9Ul6Ob2fYjjBybm6JMAxRlQHev0s3K5lC5eBsk/HRuUS0needzZkT9EkcKheObVyQ+c8sbp++OYam0qHqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663300; c=relaxed/simple;
	bh=HyR7ThwEUO0oBX2YcFe9I+OYDIt+CfCwigq3GosTTTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edN2s+yr5CXY7k+bsiVXVPvebwtwsaEY3ATZ1SzNx1UDpUnzSvZ3T49ciZxTBXiFilORsaUmTcFQj/sqeg1ekXt+Mz1f5FCCy817raCHCscfqMPmyzIux85JpnBgXQHhGXtbwYG+E5ZxMt6oo4Ay/MGtBRdLJ/0hXKUVqweh5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MntTEGWm; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MntTEGWm"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1c50c1e29bso764944566b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663297; x=1788268097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGE3+a3mk0YoxmWdMS4T6r4WYEB24jvNZvdD4kpDCRY=;
        b=MntTEGWm0UdaXgkujlV5KiyAng97PKwWpXi9OiNPioykyX+79DqhPPfCDgm24Vj+rt
         N/wgFywgGxaTJVaPw4HR062WFtsFID70IpPjuN9jkN3t9hpX5SUqbuX7ii7q0iFhz/6H
         GkZSkTYJbZCePR6h+XcCb5DrdZzJDcVRZBJSjLJLgP4MPYiPro1/wDua60IPhYsxZ7cC
         8v4WqL0h9vdJI2PnjAFVpTZ6CF7WRnZWFaEdGAWtHJi8S/kGv3UNp7lsThWKEc0q1548
         Gwz6joCyjXDqkk/4ZbkGvUaAiZOLvcmlTjUM7Cgzu9Ua8yfmBBd/KtMEe10C0eLZAgMe
         fmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663297; x=1788268097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LGE3+a3mk0YoxmWdMS4T6r4WYEB24jvNZvdD4kpDCRY=;
        b=Q1sdskTB6RYM8mJgZNqrW9CLPayIDjWv+93DOLHN1H6s41PrBeY0bbWYrVj7656Kjj
         eQk562QBzrSWoB8lVi32sHc4v9n7TUDnfVW+Obhd1LjSasntBbluaROoZpEki62C30DO
         EYJyCev+GYsLcW2tckQ7ZhkLHFojnlZ0YesD5nsYqZsdCLqNOWH0Q5hCazeLBRH0NTF8
         bizElP80kpRHCT8Fz6MRxn1CWVMOO0sCt1sO8djKiCM+8wwDpQKSymfCmeVeqD8+b1wO
         ON7PoSv92d6OLMejRC4tLy8lwL6wTNrcsJMXA5PdPtWp1x4hPxW4Ur3wKHyfhvIo09/n
         8yag==
X-Forwarded-Encrypted: i=1; AHgh+RrDGkxTLuJ9t6P2giX8La4w7FhWxQmhUPf3DyZ6QZJBszjYoJf+2P3MtAZB/HWUcBG++cFyqd0LOczRBg==@vger.kernel.org
X-Gm-Message-State: AFuF++kv0yFCGQdrspo3qygCWupUWO8y55zBbgq1r/umqmSyVyj7H9hC
	wY4xXo959N6fXM7WP+IGvuo5LbVILSzzWwlHxnfmdQUC6v2IYGu+apgJ
X-Gm-Gg: AR+sD13SSB/F5u8vmZRS6z0YjHtnRvIJZaZ5pjnFdJ2c7tAxttJav357vdxVsqVgc43
	gPEYXfevGgiug6dwrp/3nNz0ZQjrepfGanC1YUSzUiJxXNiRimliJQIcCepFXYZ6Mg0Fx2+kaEQ
	VvUiCTareKX9m6bz9goyloB31Hdr2/9AUnO7POPWamSJy8yEANOvIQiLUj3O0xvAmZ9KHK35GS3
	bNPyI1dC4vBHFXNFtoO+ZVn1KSCEAURt1EuYsFe6WB7AVhmYI58CjYHIJM2kdm25Dio2bKI8V7g
	K6jcKxYyB/W5XN1KRvXycpyTe7F2CF0KrkosuwR2hEmVV0xncYv/5doWnQgUjedwyAvh9zg4Vxo
	MC3bTcAv+2q2OyxLU7AKrq5deD8kndtAsweUpoqXGeTEwAcheEHRS2WUe2JHzlVrDgYFqKb0GJm
	XxjGvUx7QMoZvHLx6Tdg+9SB117iTgv8I6+FiZD33pmoBwDAJUHX+27f13S1g51Mns2Mc=
X-Received: by 2002:a17:906:8d8b:b0:c20:f913:9337 with SMTP id a640c23a62f3a-c24e5bf20bamr765751066b.20.1787663296536;
        Tue, 25 Aug 2026 06:08:16 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:15 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 3/6] btrfs: add per-inode compression levels in xattrs
Date: Tue, 25 Aug 2026 15:07:42 +0200
Message-ID: <20260825130745.229008-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825130745.229008-1-koray.fra@gmail.com>
References: <20260825130745.229008-1-koray.fra@gmail.com>
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
xattr, using kmemdup_nul() to convert the user-supplied xattr value to a
NUL-terminated string to be used by btrfs_compress_str2level().

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 10 ++++++++++
 fs/btrfs/props.c       | 36 +++++++++++++++++++++++++++++++-----
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1082fa92c145..0a4e567d0109 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -130,6 +130,7 @@ struct btrfs_inode {
 
 	/* Cached value of inode property 'compression'. */
 	u8 prop_compress;
+	s8 prop_compress_level;
 
 	/*
 	 * Force compression on the file using the defrag ioctl, could be
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3c10a0ef0002..0319018864cd 100644
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
index a269124c3b92..a495a5d04f9e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -324,6 +324,10 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int type;
+	int level = 0;
+	int ret = 0;
+	const char *value_str;
+	int level_pos = 0;
 
 	/* Reset to defaults */
 	if (len == 0) {
@@ -343,23 +347,45 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, 3)) {
+	value_str = kmemdup_nul(value, len, GFP_KERNEL);
+	if (!value_str)
+		return -ENOMEM;
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
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Parse level if the algorithm supports it */
+	if (level_pos > 0) {
+		const char *level_str = value_str + level_pos;
+
+		/* and if user specified it */
+		if (level_str[0] == ':') {
+			ret = btrfs_compress_str2level(type, level_str, &level);
+			if (ret < 0)
+				goto out;
+		}
 	}
 
 	inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	inode->flags |= BTRFS_INODE_COMPRESS;
 	inode->prop_compress = type;
+	inode->prop_compress_level = level;
 
-	return 0;
+out:
+	kfree(value_str);
+	return ret;
 }
 
 static bool prop_compression_ignore(const struct btrfs_inode *inode)
-- 
2.55.0

