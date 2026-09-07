Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23950385D7C
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811586; cv=none; b=CZbAUSOAmR3MmkoT8RS6dx7DF+Pq3ipxn/1kSzzLKGeSIjW+RQm8Qlt1mMJhyuH5PDWQCDwh2LZiNPiEr029/oRxY8dogoazW0eF7mBeoDCiygdcjR8Fk68QFrJoLyLQfvvQHxyXo30eZwxE8UmrSvMPfXDhw4LqZKeOs5g5pLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811586; c=relaxed/simple;
	bh=bneGdov3UTY2lRqQ/eWeU2WadBKKIYH4uNfzo8WuNJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7l+b8ygON+riIpgyF2sisOgi3k7IWX/BepfANUFq7BQLw3PhgdYivU46t6uHpwrKvjFSquMv4a/tDRrpVkgmM7qhriA0YD10Iqgdsa7oazo6uSOiH2cp6Z0ZRjzrVJHrbIjMElzIJ1LbmSk7KtQjXVVPeOpRVreg1HAS2BjmXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PxQKV9UB; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxQKV9UB"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso37554785e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811581; x=1789416381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=25I5MnkdO2EmYSLpwCOO9PkXZFRsQgU+PCgUytSIQ3I=;
        b=PxQKV9UBZ00YUGykpRLf3rSEW5nXw/oDKDmt/wOgwD369kT9RYfKWZ45nwe4Fqq2ZP
         G6GPwf5r9l7p49lVsNBiUH2Vlui0XeD1DdXzREcoSGVp1q4BCMXteRig8soie8mZzpjU
         jXRTnYywihTihkD6zqz/0VRvcb2B2ZtXXo3u07uInxx0RQTlDA7TbKLgd0l8KWyirrJD
         rW8LDUsLiJzLAZjoja7b9rBGiiCDBlqeKcLv6rXpRFRh8sCKyRgedaseOe6TBYKExRs9
         0HSLQCmocSrlieNubzXghknIb2eMGS9JKP6RHq+uesIpbTjhJtxkqyZ/JNWRuTi8fH6E
         ef0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811581; x=1789416381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=25I5MnkdO2EmYSLpwCOO9PkXZFRsQgU+PCgUytSIQ3I=;
        b=jEwrkIgbT2lPcUhgze+QJ5Z2uURzodxkW3yIr1og1GTEU848GHKXn9gRnQMUvMwXdU
         0fHtYQp22Lp32ch+s+l02wsKZjcv+q8SDzMT86UFk+Q0h0VPRMDpmiUF7EbiylNWdmrM
         //uVG+F7SaO1md86kBjx/xvirMcACXkK2a7JCcwXcOkgRCYBQ4uM+zj3Kx6cLeZqc7YR
         ptA2pk+ZWcaY3fpNHhXFyplDE99BMtxhXHjqSpYil/JSwsib3C0X7Dmr40ci4MasoakZ
         mwVhqlqTqkTrVtlwAWE0WiIV4R4IQ85qCESag2fWRv+uy5PIwpgMnGKSIiLAZcSEDHVt
         saXA==
X-Forwarded-Encrypted: i=1; AKwUvBz/eIVIDZiqKXszhuKFoS/Ogg73IhiJtNd2ZizzjVd8NnA1oYBIIOKh+A795mf60eHaYTwdvXA/jrpKKw==@vger.kernel.org
X-Gm-Message-State: AFuF++mbW7WuaC9TMRPk0zEawkoI0iBVX0oKM0Uv4uJrDYpR4oBnfPPQ
	iRiPhoYzm6yHhU11czPCS1IPfzsU9sdVZK348MvXZuG7+ITUt4SncDFt
X-Gm-Gg: AYBFou07kybQxSwo8diAASvQCopS7XuxNaqJcT29kLzyPTtJS+Aks9LKmDNbnMVHSbu
	FuylBJ6RdmHZwloi7QADbberHKtftT4W322kRbJPyCRfF5sKjgmWvyIGyZMkKgjo6lgoS85+PTt
	nkOF661sSAoD4A9hWw2TOr7Yjg3KTgDF1fK460fbNrKic9Vl6yL+suvG6nnBAnAfoXuVFQDECR6
	Y6Hs98f09P6bE3rS1+CHOIddjiikM5rTgKkokifDdTBsodmODYz2yWKz8+xhJ18HcbnAln5gVb5
	HG+qGq6n8Wpq2lO111qmLgKDfTUlDCh3X1+jSJJNzgoVX8we5h+W8KwXTyU5psG8Xmf+pVFbW7d
	K5jDnTwH3WFUTgoLK0PJQgxsYnhUbLYsyOdYdY1q2kDxSIbS0PNxEIIynmIuDL47i944UTGhrud
	6gRqQq9IB4Hl40nCHdu+nU18liG+6azPgAK8D2moveOMt9rjTpiDR29iQ=
X-Received: by 2002:a05:600c:4e45:b0:49c:f504:2af5 with SMTP id 5b1f17b1804b1-49cf81dc3ecmr280248335e9.1.1788811581002;
        Mon, 07 Sep 2026 13:06:21 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:20 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Mon,  7 Sep 2026 22:05:14 +0200
Message-ID: <20260907200518.428277-3-koray.fra@gmail.com>
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

