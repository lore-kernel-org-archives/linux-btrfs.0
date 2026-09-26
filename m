Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8A38A73C
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443856; cv=none; b=awElfeR0P6a/qTQG3wvM1KDTkXKRglwsrxlVmvdCmBUm0TQ7i04dx5IyuAd53H3zEhmrll9gKtBYGwVHrFX64Gh9wynWUnqj6oBU+eYUHVtCnTnGK+X111ufx8UobCCKAEVbiKVSRdLArxdURRA5LFlP6/Y5Zjf+fBpqnrdwCsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443856; c=relaxed/simple;
	bh=JgC8ipASP8UxT27wqNV8uewsZ26cI6/TCLVUfgqnqA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc0okyNYGZPur37DbZQtaDOQyrxAMpLA0fmN1VplPTa21Ye8FcDRvqL3Uv3m1XYXGMkpaERrg3B9V8JgMtclHzk1AqyKvEFXbLY2sqLDH4PisedA8vuAftPafl72nBGEZ0gBg6s4sQQTh6DpEqo/GFeDJsf9EjeWqnQyF7bY118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pH0gQVUG; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pH0gQVUG"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffbd83a92so3943785e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443846; x=1791048646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=pH0gQVUGYLT3+5IwfYthsSne3RAfZRWj3WPzvuO1OjO/Fde0TQLendCIRHGp+n0OTL
         bxXprG4eTQX2KNmd2aqamzz6STfT1R479l0oNJsSF0JW6fiKoTs1QhhexYZOsNckTRr/
         omzL5pAv09P1YUE+7WTZnflhOQ6J3Hjxoo5yNslOv68AX2O+iPG9AatwC1BdOM+9/o/9
         iAN7EF0fAC6FzCO60we8qiAdWxKBEIXvW9KuwLONWVgwbcHJP01kl+Txa59xgCFDIpGU
         NVmxmISJmcNZOtWQgtgdjH6dXPHE8DMVrCOgCav+yNxRxeTeyxNevR4zVkbIl6oG6j3K
         F06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443846; x=1791048646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=l9oQwGSQ/cAsoqNs9i4KOGVal/i6kE1byto11LjhYP+/aL0gJmIdAfd910H+Qjmzxm
         E1ZgkVolscs6VRSAQ6Suhusd6S/dUCQHgwEnEJ/FEJCXtLeFdoV9+4gbZ7n72ROFbLtA
         rhRuPW0JdPY/7J8Lq7whpxfIFu1QHpZtC58w/xlAFqQZT9QgdvFG9JUQO/O1z7BzBK4f
         my/wgLUEH6TOeJzeusfuD46KZDtt7pDWo9MDs1IJMR1or1woGay8pGhzSKAsaLfdw6zo
         vrFM/CXrjxcTj4R8rhb1D0XhpLi8WM63r3ZT1zlXsa01frqtb2a5YreAFOM+eq/9CIrg
         oZKg==
X-Forwarded-Encrypted: i=1; AKwUvBx2T9Fl5x3vQbt69l8QWx7QoHUSR8q2ZQ0snISTvAErfp5IbU4Gnzad7f7K+g3MIVyK4JjlqTKBYrW3qQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kbn/ofZlORJp9JcFZ0b8MtZUTpvfXURdkxb3XD0iBsnH4ldJVs
	sbDbCZsPaG81slZbfq3k9mzjAiMXwZgvkvzwjQeyfLy7DqgwN4oTAMud
X-Gm-Gg: AYBFou2709PPIcDGdM2osRXaw+oRozXIxZ80giVO52nyva86AqkUH90z2zdPdC2YKUY
	ZNp/UyEJjLcUaJB6z5QC0TFKZhnBkSh6OFfKTvdw6OsrWYk8S0LO/UQs7HtZk13S920KRJvWMdB
	yJjG1YB79WNflb4im+B4fcuoSeH3uCMA2q4WYQAY3wysJua1uzJownAPBhGSVoDcCjbEFoUIG+s
	kXF80HeqD8l7inXGiFZY/5in1PMqYGKKPlI2F6V+FtdZgVwXJkovFnPWHbxDjxfx5SsnSpQSzCL
	0G69zfCg+xL+sZ8f0BYzej/eH1HV3OaltWWFIf9OfAaPLBGLDCUWpI3NCCjfPw03CY7q1FCiVrT
	4V2DFAlS70vXQj3plFchYPzOtjQ6kZwCSJEyDbTFlA3KSZbjBSwSEgCi2t3YT9kh+6vugKrzvJJ
	Vxa+GAQHuB0f7+kXUm5QOyhl6GOW0a5siO0KySl1AICHuBfuqBQT+kSvww1QqCFjBAzXvezc5pw
	g8lzw==
X-Received: by 2002:a05:600c:198a:b0:499:b65e:49c9 with SMTP id 5b1f17b1804b1-49fe66d2d24mr167838595e9.10.1790443846155;
        Sat, 26 Sep 2026 10:30:46 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:45 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Sat, 26 Sep 2026 19:29:32 +0200
Message-ID: <20260926172936.337085-3-koray.fra@gmail.com>
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

Change btrfs_compress_is_valid_type() to use btrfs_match_compress_type()
and btrfs_compress_str2level() instead of a simple strncmp(), which would
validate even incorrect strings (e.g. "zstd:invalid" or "zstdinvalid").

This also makes the function validate levels in the same way the
compress= option gets parsed, allowing bigger or smaller values, but
still clamping them to the min or max supported.

Furthermore, remove the len parameter, since now it requires a
NUL-terminated string because of btrfs_compress_str2level(); this change
is fine because btrfs_compress_is_valid_type() is used only once in
props.c by prop_compression_validate(), which now uses a stack-based
buffer and memcpy() to convert the user-supplied xattr value to a
NUL-terminated string.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 18 +++++++++++++++---
 fs/btrfs/compression.h |  2 +-
 fs/btrfs/props.c       | 18 +++++++++++++++++-
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2880ee1f80d1..de10d96aee8a 100644
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
index bb77d46376d4..2e706093e186 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -18,6 +18,15 @@
 #include "super.h"
 #include "dir-item.h"
 
+/*
+ * Max length of compression algorithm:level string.
+ *
+ * For now the longest possible string is "zstd:-15", which is
+ * 8 characters + 1 terminating null byte.
+ * Rounding it up to the closest power of 2 gives 16.
+ */
+#define BTRFS_COMPRESS_PROP_MAX_LEN 16
+
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 
@@ -295,13 +304,20 @@ int btrfs_load_inode_props(struct btrfs_inode *inode, struct btrfs_path *path)
 static int prop_compression_validate(const struct btrfs_inode *inode,
 				     const char *value, size_t len)
 {
+	char value_str[BTRFS_COMPRESS_PROP_MAX_LEN];
+
 	if (!btrfs_inode_can_compress(inode))
 		return -EINVAL;
 
 	if (!value)
 		return 0;
 
-	if (btrfs_compress_is_valid_type(value, len))
+	if (len >= BTRFS_COMPRESS_PROP_MAX_LEN)
+		return -EINVAL;
+
+	memcpy(value_str, value, len);
+	value_str[len] = '\0';
+	if (btrfs_compress_is_valid_type(value_str))
 		return 0;
 
 	if ((len == 2 && strncmp("no", value, 2) == 0) ||
-- 
2.55.0

