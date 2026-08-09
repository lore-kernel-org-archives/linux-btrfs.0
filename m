Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F12F0680
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786240303; cv=none; b=cKPPbc9+IuZkr9u/0d+ZhyuWIMG9OBz2GaOY4/rCIDsjDgxU0crtNa3LoISRptD+AJNQugPjTR+/5OrK/sslbBscHJBMSaJvS8B9AQhX1B+Jhzg4hDHe5o+h/UQyEwy0EYF3Y/+0K0IkKOMdCqxmweCShseffzYBcCrNciipipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786240303; c=relaxed/simple;
	bh=ht0GNMGZJTpVbySJKIY72KtutNEscwFwMnZ1W6zIkd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzAAg37IqMKB2H1kV1hcURRAfwtB7r6N7DWFjwzg8W/Yq6fY1pyY8SzxHp+LUKrU71IcAP7teQRKVG9ecmMJ/CXLvMR9fjjRvqyW5UiLV8ZTWNAoWcdNT2W9PdvlBd/7evsSJdaYWlaGqXC3AhfObF5i/s7DeLMmvb5U5S71oI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIvaM3l+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIvaM3l+"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso337554f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786240300; x=1786845100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Pc8gVZKI/WndVUfBYj8EphpKXQOrWY5AONEUyZ1kPU=;
        b=hIvaM3l+m2twPf8DbbLJWhbFLOOpiJjKxttjWWqdgGzdzw7ukV6CTEvUOcy0ygBlGO
         +4GhWJHKdFWM9cUZlAYbnz9JQzoAAeLzUj8JoPIF0qQtbOcf3/Q1Ol4WpmFFNd/WVKv3
         G0d+GcxJDAkGQHviPqP8/TH+W05cHv14ZMUgqCwej3C8xz2dULeizTjkNIw8sfgdtBdn
         vz+o/5KOX1hixBxEQzd0DGkUjaDzhkxBEmX6G3r2K2ELZRGaOMXhEPkGcqWTH7rTkyAd
         lJv3Lg99lK0MdLOAJvG8h1E6X/E3zsxe9tYmfPG6UbHav5YXaKNIc6f5ZV2B6ubLAstr
         2ajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786240300; x=1786845100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Pc8gVZKI/WndVUfBYj8EphpKXQOrWY5AONEUyZ1kPU=;
        b=W6SHvMX0LDVuDTw1VMrBdREEHjtrLzzUIgwF/DuTGcjHf6O43lq4SxO4llIjT02sQa
         94DHAQuBklq35aoF2liUyZx2Dkff8Wpcjp9H2iXzGaswAm2zrsYxmo09WXreJL1XsPeB
         Ffc4ie842I25nMivjq4yckqhGYQwVGwPP30XXFOQfOvrChqLNxShGagrIhT9tayl67RY
         zGhLSIbwmPfdqJNwm306iUnAEyN9UM3KETz2bCsJbwacH1qs8AhZp9+QwOdPrCKTMkIS
         F6wf21FY7X02DH7yMczJkdqb741Hu+GK4METi+cZJl4KqEoVSFcDDBt4GgAoNeycBb17
         Mp8A==
X-Forwarded-Encrypted: i=1; AHgh+RoiDEy5k8E/lJKE1W8TfEqnk2CFaJ5JthijcHbiijX8BWnyJgKgyLXPkCArtt+zoWSE8Obhxcueq8j/Hg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBuoED7xvMhfleFVXjxccLllbNfYPGG0uc7oxIKne78fp7Curw
	pTV4NMUMa8etF8VELTSLdo7RAGva76fxnvUV0+9PYArgW4gTKdwp+PxyDLAKXAVCmLU=
X-Gm-Gg: AR+sD10RnD62nVQZcGWFQ7Qu2vSOU2h8rI+jxynVS0KdH2hXe8yyFWEIK0Pftv/u/47
	a3vdchtmdvqYy0oZNyuZjK0RwIFMTCZpGXFwj04TQh8VzYz4fQRxxhKubFz31dbFzAKnMBV/qiS
	I9VaSanY65Md0P3+jhK/SvqAHdLsRv0HUsupyAJafRd5wCxl3e0l2iZQwVmd1zgGwjS0XgvgKd4
	+IQIqSMXAb8oN0in510fZNYHgJRJkU37RC0/besRQnD+lbAFdPGo97hgKvkWN+eD51t9Z/q4CiA
	w7p5sp2MfHrHJF02PkC3bn15sbrkqQvE4G7krZZng9BYGp2dmEhOrAyXKk0/OGZ3IgDj6NRgC0/
	gZ/Dx6zruLKIpsikzNfKUByp5qryWyemzoJou6Wn4l1iAt4c52LEl2wRvUPrbUGbnnVLqc9ssaL
	a/trj4HXcdIdPCr/+c60SEg6XDI4MnN3jFP5PHcYkIPPG5mYIlsGtCE+E=
X-Received: by 2002:a05:6000:29da:b0:47f:8112:f793 with SMTP id ffacd0b85a97d-48130eb0eb4mr8811435f8f.13.1786240300346;
        Sat, 08 Aug 2026 18:51:40 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f90f8sm17155676f8f.26.2026.08.08.18.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 18:51:39 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 3/4] btrfs: add per-inode compression levels in xattrs
Date: Sun,  9 Aug 2026 03:50:53 +0200
Message-ID: <20260809015054.779137-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260809015054.779137-1-koray.fra@gmail.com>
References: <20260809015054.779137-1-koray.fra@gmail.com>
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
NUL-terminated string to be used by btrfs_compress_str2level(). The
same approach was taken in prop_compression_validate() for
btrfs_compress_is_valid_type().

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/props.c       | 43 +++++++++++++++++++++++++++++++++---------
 3 files changed, 37 insertions(+), 9 deletions(-)

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
index 2534cd9284d5..cff4b3e97559 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
+		compress_level = inode->prop_compress_level;
 	}
 
 	/* Compression level is applied here. */
@@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
+			compress_level = inode->prop_compress_level;
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

