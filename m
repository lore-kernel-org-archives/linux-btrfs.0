Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8618525A8D
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811586; cv=none; b=Whfy2oEy0EEDOlLd+SxmwzrTjCDzWbvK1jVsKTwiQmhoUpB3Rds1JND+dEZZakU/1ns7g+s6526IGcFzvDa02sWBWTc142tbAI98gSo3KXwpagi+hYKcBvh/INiQwS6vDHkcY/oTSGHXvnWW0B8lnzxZAmejWMOrYVA6RPIwXPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811586; c=relaxed/simple;
	bh=RFGGZJ29YPfwMCn+36QB7FGLlfCde980j/yse2Hw5Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzAqeGGhFg3KibKlUntbeZnSHB5il4b8oj+Hi4mBuDbVXn/uQI5mLWWUYRpDNVgPTAA1uiPCoGshm658Itq2l2Z8TVr+7HpXKUUIcGaZPsk/QJ3crPi6XqwTDxMOheNrAYv+zALKu6jhS9hGK6qZwThKXyiAstk9shSab9MP8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sl31snhz; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sl31snhz"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso41602755e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811583; x=1789416383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vut00+zMCi+SmsHAOSR+ULx9TwbMjK4dpC4Sr49eo1M=;
        b=Sl31snhzU2E9Lg34sooNg+RRLlE+B8SoJRFUvdXb9AQsPDxkzQVmc4hUS+RGx5uYJA
         t7VhlmJKfBPmtcxEf8DkJGy8sUzJ62W5H08dygcpb4YQgMytLkNZ5Mhg4MjHC26X5yP8
         3fw8uXhaFVXVehsj2pQ3LqC2poF05DwBUJg5h91xjOsG7b10r5Sn+rh9gVkEb9jHqPX0
         H2D6Tlb5PlPdG76oi6GYy2c+QSlgCAb1LYiC48LoD+Oo9dZOEagqcvz/MNiSWbVOOCAy
         Q5Qc3Q2MhcWimQz/RazvPE+slvISPXjpj1ELxhpvSYw04HL4rXiyOjkOGlFNPpOFmWkv
         FMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811583; x=1789416383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vut00+zMCi+SmsHAOSR+ULx9TwbMjK4dpC4Sr49eo1M=;
        b=rye62QnEQcCCQ7T62M2L9vdH/ESJyN35wDiERjsq7ZtQmlfF9eiHFk0+SK07WjBnaP
         6dhbWyTqJWKz7Y1c+dhhZmekO59nfyBCdUKlf7qqhxdFnrxJ+3uZQTFIc9HiCU5kZEH6
         EzRoTfZKQrFjgW7Pby5YnGCVtAUdaxxZnceiRRKtoQvRBXizMiTu3Fhu2oCMq+volm5W
         wpUNMJ/a4rztCETotqULsG48A4Z1uZd9zfP8x/nUsb7nmOnc1O9U6wP2tmHJHxjr3sgn
         DtLFWkSvLrH9CIgegWXwAcuFaL//kXRJmRuP5rBhqVKUu+05GSqbyT9VOCYi19SYKo3E
         pkAw==
X-Forwarded-Encrypted: i=1; AKwUvBwuaJtb+GpCNP6SSDPMuO0JmGNUloMMNOq0qo6se+v4hCb9rqA/sN0sIU3WtEqRxoVRzHuwGvOF0iB58Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kGcM5UY/B+kKc+QYpUJPYIK4hyJfhtdaaDSSaAeREzsnDqNd9V
	Re519LyoupsmWkcH30uJ2DaiwKAZB60iGqRwQwpDY9bg5ssi+aOQuKD3
X-Gm-Gg: AYBFou02PJ5bM6ICQxN9h1SEdHKdYqA95XmkzvcmU1FMF70nuN4rYjHoRc23dZ/hSY6
	b6XYdo+EcZqwI+Mj3HZzsJ+YJuzuEG/xCY4ljpIUDcWdlVMcffeK2J77c63S+ngVSPXosHsjuY2
	tfhtjZZVcayO63tf9oiXO5LziHp8TiWOtnrrXgVSNeFUCvo+Vyxfa3GoAJRf4vuz7Lxn1tj1Qyo
	sGFBtslhCrKvls7rqXwRnxWnP0yzM2H7PPxAonsUKhxU6gWtc3qM8S9h/bck55QkT2Gwtbi/tmV
	O6smS/GePHmEY03OBjDcUg5Z6lBle39EvTRRGQXSFPtfwaZ43MsXbgT8XBhBD/6VqDtaNvxTGuq
	rkFiL2p99BuyAJ3tpOVfv2oUkkP7kepvONzun0LXeI6TdW8dNfB2QnFZOrdo40bJqju9x7JhoYP
	331mjEVyS8++3mOat1bJ84Ku7V83i5f9OCVFreVGvIgosr43nUnzcvJbM=
X-Received: by 2002:a05:600c:4f89:b0:49c:f617:7cf with SMTP id 5b1f17b1804b1-49cf7f32d0amr385089255e9.0.1788811582639;
        Mon, 07 Sep 2026 13:06:22 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:21 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 3/6] btrfs: add per-inode compression levels in xattrs
Date: Mon,  7 Sep 2026 22:05:15 +0200
Message-ID: <20260907200518.428277-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907200518.428277-1-koray.fra@gmail.com>
References: <20260907200518.428277-1-koray.fra@gmail.com>
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
index 89e5e9c0c904..a96cdaf1ebf9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -130,6 +130,7 @@ struct btrfs_inode {
 
 	/* Cached value of inode property 'compression'. */
 	u8 prop_compress;
+	s8 prop_compress_level;
 
 	/*
 	 * Force compression on the file using the defrag ioctl, could be
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2967a307d8f0..51af56fb7c18 100644
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

