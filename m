Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FCD443AA7
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663298; cv=none; b=tViOCAJt3J86nsLhs5BjIaVApOzQC9Fa7VSkG5E8ZY+zjTcTXrIoCxS3yfHgflBf4q0obtBr8U/Qe88V/eup14TuMvjvAJGssrD976Esq+SiRtQk4lxWoEFC0UJdx+jR+ukJBI8C3p9g+AOhdfZjOw+S3gn6SDNOZiDoN8+VxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663298; c=relaxed/simple;
	bh=bneGdov3UTY2lRqQ/eWeU2WadBKKIYH4uNfzo8WuNJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEMerK6DQEz+qMqogGpWOjL2jH4wTLlm7D8Cpf6cxaTYtU/+W75GkW/8tt3csAhCL1GiKPC7gb9mjMOx22wi/YTSJJ5UGXLaza+P35pC9CdqG5urPnmykwOD6WbwHKWLsiImsdckMp8trovPnyJbUbvbTjvyvXG8ztKsbldnRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=raIYUHVt; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="raIYUHVt"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c207cb16cf5so746847166b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663295; x=1788268095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=25I5MnkdO2EmYSLpwCOO9PkXZFRsQgU+PCgUytSIQ3I=;
        b=raIYUHVt4Oqfg+pBL3QXgMNKBI30yVkmUku/8wTprwE2fIVQFddF7liYGKSLPd4T5e
         rholknwrMu3lauD61Irb8ZWqouGMslnzT8c8mxtvFKqMN2SjoRKS/LsRt4igEv4oyuz4
         EHsC78FlSKhgdp6g+IaeY7YDYQbmad5uiF3xTZYqLiw4aHREQ/i5p1Xgf4o9DjqdBs+T
         9p/mLKJSscpQEoJN2p9U0ViLyXXwScElFmcQTQ2KHUqBaHaEVpHxsH3bG22RH6iY1eW8
         iZGUR2QnRHD4ixF84/ff7Kf2caPEOiEtEakywZXv8GC0EuuShUWY5Nssec3FVX7bGPzx
         CYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663295; x=1788268095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=25I5MnkdO2EmYSLpwCOO9PkXZFRsQgU+PCgUytSIQ3I=;
        b=a1VKLFOkSuYyadapfmvIQd081NeQltne1d0NUEFadvhTszUhAKZUMVOyYwLsPrCBAi
         U7zxW1QkQf4dgkIjDRPq/djFszFG/Q2fY/3ZSINfXu3HsAhrFDba+Ecm4X4VSdX0KCNI
         dDhRpr4fFNwlWxr1hOp+Zay1DgGv/kl8A0wuFjHHKOYw8RVJpNH6dEBwHBL9fKvNODYz
         cPl9eIuDpbjJVRPKEqDizfw3799w40hSkBZ6tWW5DtTTWjlOgtsStkQHXMI56t16roJ0
         ymcLs4ov/bncIsLGVBMB6w8Xo/5grD85hBZKakL50m91LXcu30HtqWkQmbe358ThoS4X
         GwNQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLFy9nrQwYzIwNp97hb9KOe0QAnr1q6oH6OcoUI7mJpt3ftkRtllI5XklUBTVGvwSYNsz9NqN90c+dEA==@vger.kernel.org
X-Gm-Message-State: AFuF++lxcwccon9mkwmexogPnh6/fFmheL19o8oLKCZpwd3QGD6QMDWU
	iqokhGbQFfkB214cCZchfV5Eq8FpcIUQeSWYnnPHwdkmJds07hAEe41E
X-Gm-Gg: AR+sD13qwNey92NqcXnoDS9LS+LU/p1MIN+79NS6sdVlNjabxHoa1HFLrVydIBGHPpy
	RsvR/ot1E//yEoyt2XipaaTTHegt6PhjoRe87b2OfBhI8uYYys2FViqrNgKUXdNuxCaUBlzGCT+
	wU4kHzM0RTBvmdl9v40URQkcCK5/X83vNcc7ru+UIGjXn7F0gv4yE5YCFsdtkf3lZ9aMl6xKz2Z
	vJnyEvc3MzJexQvwFyqBPI38o5MD1nq0PVPEf7xzg1m1XALDGCuyAJoz3q0al17RibKEg8kKXr+
	EBp3XNSEdBKjB8CelkvWi5IPywuNIUy5JOd7LMzZIsOfFXZ1xh7NJY/poQcUJQtt+HhlPDMvHE1
	uXwDVTq92cVd649jIZT3+twoHzVLT3hA6WskYClp8a+gK3KxGO3gUMvGtjhS+UpM5QyqTv+E+Jw
	Df++S2gzyc3I80vNb9D31c3GmSg/4W36v31YFo0paBEaPhPb1a086+8RS8
X-Received: by 2002:a17:907:a49:b0:c21:4393:c41a with SMTP id a640c23a62f3a-c246a606cdamr3623085766b.11.1787663295107;
        Tue, 25 Aug 2026 06:08:15 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:13 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Tue, 25 Aug 2026 15:07:41 +0200
Message-ID: <20260825130745.229008-3-koray.fra@gmail.com>
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

Change btrfs_compress_is_valid_type() to use btrfs_match_compress_type()
and btrfs_compress_str2level() instead of a simple strncmp(), which would
validate even incorrect strings (e.g. "zstd:invalid" or "zstdinvalid").

This also makes the function validate levels in the same way the
compress= option gets parsed, allowing bigger or smaller values, but
still clamping them to the min or max supported.

Furthermore, remove the len parameter, since now it requires a
NUL-terminated string because of btrfs_compress_str2level(); this change
is fine because btrfs_compress_is_valid_type() is used only once in
props.c by prop_compression_validate(), which now uses kmemdup_nul() to
convert the user-supplied xattr value to a NUL-terminated string.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 18 +++++++++++++++---
 fs/btrfs/compression.h |  2 +-
 fs/btrfs/props.c       | 16 ++++++++++++----
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 65d8b88b9732..b272b2263b5c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -70,18 +70,30 @@ static struct compressed_bio *alloc_compressed_bio(struct btrfs_inode *inode,
 	return to_compressed_bio(bbio);
 }
 
-bool btrfs_compress_is_valid_type(const char *str, size_t len)
+/**
+ * btrfs_compress_is_valid_type - Check if a string is a valid compression type.
+ * @str: The compression string to check. Must be null-terminated.
+ *
+ * Return: %true if the string is a valid compression algorithm (optionally with
+ * a level suffix, e.g. "zstd" or "zstd:9"), %false otherwise.
+ */
+bool btrfs_compress_is_valid_type(const char *str)
 {
+	size_t len = strlen(str);
 	int i;
 
 	for (i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
 		size_t comp_len = strlen(btrfs_compress_types[i]);
+		const char *comp_type = btrfs_compress_types[i];
+		int tmp_level;
 
 		if (len < comp_len)
 			continue;
 
-		if (!strncmp(btrfs_compress_types[i], str, comp_len))
-			return true;
+		if (btrfs_match_compress_type(str, comp_type, true)) {
+			if (btrfs_compress_str2level(i, str + comp_len, &tmp_level) == 0)
+				return true;
+		}
 	}
 	return false;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index e67ba47b4cdc..c63bed9f4152 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -132,7 +132,7 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
 extern const struct btrfs_compress_levels btrfs_zstd_compress;
 
 const char* btrfs_compress_type2str(enum btrfs_compression_type type);
-bool btrfs_compress_is_valid_type(const char *str, size_t len);
+bool btrfs_compress_is_valid_type(const char *str);
 
 int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bb77d46376d4..a269124c3b92 100644
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
-- 
2.55.0

