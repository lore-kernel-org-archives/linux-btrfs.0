Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDCF3630BE
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 02:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156542; cv=none; b=ePI5vupqArYUwK5HSaaZZAAUmI0npX9oipxTLAXJ5v/IcNB1K/EihfOGbHSqIlH0zte4WCXHI+q/X8i/wv1W47AMLGtHsCI9BAU9IkHftiHwfpxSaItpQ9ia3+VJ2H/Ldt+kIVKs26xiGdm94PsRep42aOMQoWYokcm07EIIF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156542; c=relaxed/simple;
	bh=H6UyzMmW77aDd7xKQ1yhSu3q5AZMKkGQEZHQ6qkHFw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2fJUJsALthd47189Ag8KhOoVQjkRNp7vnG5uPuo4ynkYVU++j3I7XbDp0H5dY0DQQtDunolbKrXCJ4ZNk9aMqmJZDwh84yUlnqlzVGN45X5doejxE+fxFyx+Z65bfKUa/u0kZ7iPiHnZ6k2FFUVLMiW8B0w8oM5H18WA8CEiCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEw6cK/9; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEw6cK/9"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so121497f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 19:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786156519; x=1786761319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JXGoQqcQQcR1U1pq371BL06rUsK53Ije/YtdgMaKFcE=;
        b=JEw6cK/9F0nHxqZ35b04XXBoRf1xrUCndbP5wC0Gx0nDsE20168iUdV2vcKctHy1G+
         wg9U8n35QZH0snKaeWBhgO0YDrGa6TsEQMccMJqod0VtSCipUTIWriULSNUmHQSL7In2
         OR2gR4dvEKNBkwP7GJIcRyt6KcI6vbSy5bpkw6F3xR4n/kxXz8chwLja4vrrdlZZnaMj
         12NgT/9owvs0LLHw5HsxPVImCcOKXGkdr6o7Pnpzyhvkt4aly5PJvLBhu/dMtMTvjtlR
         0reT67ZVqoKcIMk4JGw0tc2Z5AMs0U8wrpKbC49NvL3ta+Ze+rczPzIfoZbEA4sSyrfO
         7Yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156519; x=1786761319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JXGoQqcQQcR1U1pq371BL06rUsK53Ije/YtdgMaKFcE=;
        b=TuxpzUgrNEPQGlaykGngsgylfUWIGoBV4nXMQJdA/2hk/1USw9PNtKu6htFEa+Lyuy
         o6xqc0AkDJBv/s9RqVILHozS/VpPwoEzmYsHA7PGQifhrpFN6Bxdzz3TKQozyk6Qj/HB
         eYG0zeArxmNzkWjplhqk17vZbNO5zAbaw7fPVOpAVA70mcKZ9Nwf/zVsE7LXakkiEPRg
         W7tS/icTX6ZGvZ4HKlWUmHFHNWFxT1ebWbwXD4CQz9DODFaNA9rijqKrBRAQS0tLt+X0
         UgaxJYEVKdvilCrXEBFxogXyYGDzFpNg0UQCl4KWIhjnGG1imerokDorrC7k61c1n4WP
         6OAQ==
X-Gm-Message-State: AOJu0YwO/K/wQO+Q5Vj07qLLkuvICO0n6CU4fhE+LigbspqIV9AjE82/
	b8TQGa9sikuR+GxOunHSDm95uy50zUYfYLgCORLvTz+KTt8hphsD4gsr
X-Gm-Gg: AR+sD13a3wenCaaWvwabUo9v837ZfmOVd6WWGwxF8/Fp8E/vIbo41jKMOWL6YhUBKoC
	Tssz+flh6qKoBTR3DYtQZvHrXfVJzVzDISAjEmyJkuI+pTqu2RovBDYjGikPGEmlw4m8ePaFpuv
	iOoBCxy6aNFHE4Hn9GAChmQvgVl15/WcCtKNQT3hd3fKRsH6/phHiKU3rCC/MGMwfJNO52/Egw0
	E8znwjAeyOZ6N7IkBkXstLRHD5dU9Gwh+c+JUcuofK7gs9gE/o/sSTPPebM9krhrxgoXd9/GdmC
	WSThY/0qRtGr9sHRZfof+QiFbrLy/49cO5UGZXyb0FSU1kK3J1YMivosxpsgYqerKvdyylh4Zqp
	nC/W33rOmhgnS0oRtfqkMaS53K3YLTOsRaGEr/tTuQRYwQUAwFcGFyMb6Wo2COUU1ZYUl+9ZRUR
	CfhJt4tLFRxzpSus459j8goPztiuV/KCg8Fkm6cujWMPYkqjAVMccbw7H0YxcmX6sBng==
X-Received: by 2002:a05:6000:2212:b0:47f:773f:2d68 with SMTP id ffacd0b85a97d-47ffd9185a0mr20345871f8f.16.1786156519018;
        Fri, 07 Aug 2026 19:35:19 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm10571244f8f.2.2026.08.07.19.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 19:35:18 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 3/4] btrfs: add per-inode compression levels in xattrs
Date: Sat,  8 Aug 2026 04:34:58 +0200
Message-ID: <20260808023459.1494928-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808023459.1494928-1-koray.fra@gmail.com>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for specifying algo:level using
btrfs property set /path/to/file compression "algo:level".

Add a signed 8 bit prop_compress_level property to btrfs_inode, which can
support from level -128 to 127, plenty for the currently supported
algo:level(s).

Change prop_compression_apply() to use the already present
btrfs_match_compress_type() and btrfs_compress_str2level() to parse the
xattr, using kmemdup_nul() to convert the user-supplied xattr value to a
NUL-terminated string to be used by btrfs_compress_str2level().
The same approach was taken in prop_compression_validate() for
btrfs_compress_is_valid_type().

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 14 ++++++++++++++
 fs/btrfs/props.c       | 43 +++++++++++++++++++++++++++++++++---------
 3 files changed, 49 insertions(+), 9 deletions(-)

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
index 2534cd9284d5..b63b5006fd78 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -938,6 +938,13 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
+		/*
+		 * If level not specified (i.e. is 0), use the fs default. If
+		 * compress_type is different, keep the level anyway and let
+		 * the rest of the code clamp it.
+		 */
+		if (inode->prop_compress_level)
+			compress_level = inode->prop_compress_level;
 	}
 
 	/* Compression level is applied here. */
@@ -2326,6 +2333,13 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
+			/*
+			 * If level not specified (i.e. is 0), use the fs default. If
+			 * compress_type is different, keep the level anyway and let
+			 * the rest of the code clamp it.
+			 */
+			if (inode->prop_compress_level)
+				compress_level = inode->prop_compress_level;
 		}
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bb77d46376d4..f79a61a2759f 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -295,20 +295,28 @@ int btrfs_load_inode_props(struct btrfs_inode *inode, struct btrfs_path *path)
 static int prop_compression_validate(const struct btrfs_inode *inode,
 				     const char *value, size_t len)
 {
+	int ret = -EINVAL;
+	const char *value_str;
+
 	if (!btrfs_inode_can_compress(inode))
 		return -EINVAL;
 
 	if (!value)
 		return 0;
 
-	if (btrfs_compress_is_valid_type(value, len))
-		return 0;
-
 	if ((len == 2 && strncmp("no", value, 2) == 0) ||
 	    (len == 4 && strncmp("none", value, 4) == 0))
 		return 0;
 
-	return -EINVAL;
+	value_str = kmemdup_nul(value, len, GFP_KERNEL);
+	if (!value_str)
+		return -ENOMEM;
+
+	if (btrfs_compress_is_valid_type(value_str))
+		ret = 0;
+
+	kfree(value_str);
+	return ret;
 }
 
 static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
@@ -316,6 +324,9 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int type;
+	int level = 0;
+	int ret = 0;
+	const char *value_str;
 
 	/* Reset to defaults */
 	if (len == 0) {
@@ -335,23 +346,37 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
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

