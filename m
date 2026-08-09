Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257393914FD
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301663; cv=none; b=EA/EUPW3E0rZH7kUZnQQCOLxhbdW5z1J3mSWww1ljA0h3b7v5xz/upmgbIvybRbWUjuMdY0DDtjnjpdjhnyfmEu03zj8dsP3yekqGbPm/Uewn9+Q47cgjci8o9lUhnBIbaUZRm07ZOixJmidOsviciBgG27JU6TJyGGAuQBzdWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301663; c=relaxed/simple;
	bh=bhqY0IWV+kzz8OYaRHWSg0GXNWe8d0GbEY2IZJWmCyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqDrrwfDr/CRqsepN6Pe5V7ymJq4b0t9rynQUWSrTteNQnf6xvjm2rxoFe/0GlOu89+a9ycXoEH3Q5KDRaD0++xw+w/Jync50n6OeFgyacodhbQCZVEaU7OskH1a6ORPSHn1XT3Q+ao7Ts2kl/9QlvWWJ7ttWAMLquRSg4LU31w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4jej0q4; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4jej0q4"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49553515a8bso18205175e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301660; x=1786906460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6qOuBzBzBZwXxiQ5zIdmop/qIr8XRdkpDg0FhBj9tkI=;
        b=l4jej0q4SRhQ3nUWEVYLDCjXTUQEpyy93qRO+P+g8lx9p79Qy2c7RqDH3c+feYI9el
         52s4l7bs+uc50YwoBF8D1RgsNJi5cabTVHJ017dp1jHUhHxc/xiPBX8iz62brHhXNfDC
         GdAyc+3spIKC5imza/q1cP5qC9qRLIDPxAEmjuPd2SJBQkVZUq3r0DOZitiUC1mCjtLn
         c8faTcCcVcGpJJAFBc2h1NUFEdegJpMQexF9f6mrUjIbYbcP8PeMfh0WDFVfDJ9otiko
         STg7LS10n7FHhrAWIZUCwxtqorAqfa1Cb+QiPr27RpBHiQ93tCjz/N+yYBfum4xdVHAG
         /QAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301660; x=1786906460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6qOuBzBzBZwXxiQ5zIdmop/qIr8XRdkpDg0FhBj9tkI=;
        b=YXDaPBxmsRZWSVVAJPllZrwkOyv9mIEIKuJfr5tStK4qPNne/b8UN7tkHI5OSyKd0r
         vqjwnj0y+2b+nhKu4oNVBs4aBN26umykbdVAku6YKwcfnuGHV6BoyLyzHr+nPzPPOeJR
         XRCi6J/gw2syGuq4j8Nxq6itbAEYt90Q/Et6uwtziy824CiPPNl4RXSqT8s3T0ukogqX
         QUazeJ/+gFbF6rqG1NFu1Kunzpf3NvWRZ6W/NZzvPWUD2pJ548Hm87XqTIdAnqyTe5cx
         zSsl0wBO6eEMdlgQYz/BlwRfWUEJAtTsprUD7nOtYCY7j3oHnnxhujKLmbgR638J1zRV
         r0gQ==
X-Forwarded-Encrypted: i=1; AHgh+RqwdoBOXoN2p/b0xzgwYDAnMJVwCo+G9IZPFyTTq7B1QQVukUbl8+Hn4WIWfFV4jy6KhLK4yXL0S97wBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW3jgoNp9Y7qKW9DIFJEw9MFVXzzZ9X5q7iLb2nJhUYwx2eqQx
	gi90Is1c8PmI7IbspDvHFyGP22SSVH986UNWfObk8sHXGJVcWbI7CrCr
X-Gm-Gg: AR+sD12dL4+46K7Rc2esrmMpuuWT7nOLzGAXiYxkpFVi81Fx3a3MXSt8dapoBf/jxHz
	2IQeN/0hs1Lw+npS2v7jpShiavjazRsB9YUwti2euPIidbTDeQFtFRGGzHHot9lfAGIU4q5s75Z
	s6sugoLVHwWGFcmDjXIlqUPXslQ/NlMlNFohZ8IRS3/PzvJTZbYa8VC2E4B/l4IzCqthMHkBgqv
	awK9DpdrXMM+eLVVTHyHOhFJpCyFgY10l9z7ObGNs+O1nrh7N1hN/9+9WkjRU1Xt0vTWspLS8Gk
	3I+Rfgaa+jmT4U2+qFJ+PMvtzIi9MfmQxz3Kj73EFSWBVEED8iIuHrIgILes0No802rxLVVfDAv
	V4LtXNxBl3+ZdHWbwBtIDRuB3Vgjm05Jdxne6F2Xl6DHIxBJ446hdrn7md0CFunrItIDFEt1xrM
	+qEEz5KlyyeNIvwLEo1FfwocaNctn+KN9wUfJRW6/8psDg9g0X5myw/Ts=
X-Received: by 2002:a05:600c:a206:b0:493:bb29:af40 with SMTP id 5b1f17b1804b1-49959e35b49mr233761835e9.14.1786301660396;
        Sun, 09 Aug 2026 11:54:20 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:19 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 4/5] btrfs: add per-inode compression levels in xattrs
Date: Sun,  9 Aug 2026 20:53:02 +0200
Message-ID: <20260809185303.600071-5-koray.fra@gmail.com>
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
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/props.c       | 27 ++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 7 deletions(-)

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
index 6d7f2aa2555c..cff4b3e97559 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -938,7 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
-		compress_level = 0;
+		compress_level = inode->prop_compress_level;
 	}
 
 	/* Compression level is applied here. */
@@ -2327,7 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
-			compress_level = 0;
+			compress_level = inode->prop_compress_level;
 		}
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index a269124c3b92..f79a61a2759f 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -324,6 +324,9 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int type;
+	int level = 0;
+	int ret = 0;
+	const char *value_str;
 
 	/* Reset to defaults */
 	if (len == 0) {
@@ -343,23 +346,37 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
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
+		ret = btrfs_compress_str2level(type, value_str + 4, &level);
+		if (ret < 0)
+			goto out;
+	} else if (btrfs_match_compress_type(value_str, "zstd", true)) {
 		type = BTRFS_COMPRESS_ZSTD;
+		ret = btrfs_compress_str2level(type, value_str + 4, &level);
+		if (ret < 0)
+			goto out;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
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

