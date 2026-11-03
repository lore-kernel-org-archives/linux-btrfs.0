Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735269;
	b=NCenxnORa2DSnI4b6J8qimOdJvxiShM617/9IerwSmL5hHKJ6LyFDR9GkQVYeS+YQnzv
	 cKRK/pLuEOyu0/rUSbGgJOkn5BpIUnG81gaiwJRmyo26SglcicIsAa4/FiN1hq6yMtj3t
	 +ZG8lFio5XILzgaTb4r4UKmNCrzUUDFW0tM+zMonxnySKJ9YywyuLF4/Mujy4t42vrS/+
	 14N3Ks1hCORvv+JWbkEIz+d7CCC19n7S/7pzCC1yzSM7+H/hODh5nwelCosJyYBoI76ZP
	 3GqiRjC280Y4OYHmIaB+JTVxvF7y/bNTpu896k1ld8wX6fzMEl2z8Um9T/3agc8C7oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AdI/eon8A/CzNBGX83JVE2YSRlHTuYUC+ShbS+v5DuM=;
	b=rcUeELO9sAKw0dmoIGukMdQZdgf6O7/Y6acH8EBZ6YYrtCh1IvXI+E7wrQtn5KHenUMm
	 Robgw07k50jMmrxxPz+l6pdRchytj1H7FN68DpBMSkH8KaELXKEJJP26rBKIQmMWGmUoa
	 oka32NByUxFqdEKDkKQ2/4Zf16wOsKu83QFZrDn5yifbv03pkzjjmXKipXJJ84JdGjtw0
	 zj2naR/kAbasqWYkPdQF7WXjZhkifs6RXRQQ6n7gQlV0W8gPJkDZP4dbY5FAmVmrgySj3
	 RLnTtwqASskhJO0O964ol0hSL9aU5NBcw0Z8fY/HqxnOm/xUS/35DDQ87oLj10qBrOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a16w0zyC;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E81606D803
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00E81606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a16w0zyC
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so29492215e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735267; x=1794340067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AdI/eon8A/CzNBGX83JVE2YSRlHTuYUC+ShbS+v5DuM=;
        b=a16w0zyCw79/j7omGB3aSW05poacNK14z+rXpopirW7yn1/uP0Uuzkf4LSL7nMu04l
         TLZFL8s4vSdYT0NM9+U+9Pr7xkGTLcwzPKdkeCE0tLG/RZ+t26OL+Rcy7Hfb/74t6e76
         6GIccmgCL1EyZyFpH27Lw+0r1Y1dJ05PRiUxa+CdaCAo3WJkMXhEpFVXKTW32HDUOkNi
         HdJYsiTghUDy9IVlgpNiInwd67w99dStrtEApLTOJElG4st2YFbRTLiBHbH8WSmjAGaU
         Im5Lmw++KpzDr4Jbaa2JwOL+xLbmAUEbOOARg+okd7CiJfVenRgf5w8dLEK4t9e4RXyA
         ApeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735267; x=1794340067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AdI/eon8A/CzNBGX83JVE2YSRlHTuYUC+ShbS+v5DuM=;
        b=YDreWYhLdNw83uq93bHtuxyCRzAl31RUKV6x3qVvA/0LaEH62p+NMpBqKeAqoUUyGn
         Bj6N2Gs7e+W69isfQPNFLBJM3PMZ10j0itDERCBYV3MLtMVxpY5NkrLIr1frwia4Kg/F
         rUKUoK9n4HH72S2lf7QvqusFLRwh4YKtqS+kdQeXsAH1A7Aa9nIRBdjsfLYPg63o+oq4
         5ndMcDC/Eb4ByEKSj4PcftGVEQ3Tu3TYvy1DE2inyiazpA0n5OhA64ZTo6xYtw7Mz/hR
         YYmViHtUknmn+BzAKCVleSJS/DRjbjOF4eLugmyqmQK4Z3PKVd48kG3bAOzg5cCbDtPa
         eK5g==
X-Forwarded-Encrypted: i=1; AKwUvBwkdcLRxWT8pnMiWzs2QEbId0W6nZVbeV5fa0LNi3EGupHunb1M3qfLPrSUPUtU1E8ojHK1ig6IugL80g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9T1QQIhFaCL6/q99QgCigNKqCG4QpxRdPvHkxGjsN1piIGQ3JC
	+MY7GijzVLCuhlC8SF+/mKe0ZFc6/0xO9n8siXaf0hhNKhdz1lXxtKMv
X-Gm-Gg: AYBFou0PPn2VEFdO6ezjTL7U435HSl0bKsW2xQTrs4gSph7J27gCEHiWNZj3Dq5x3/n
	h+63rEYiSq+TUfw94zkyOQm/RovlRMY8svhZTYvo3628AOwa/6UytF2zE/IVda8eI4HAKPNxeLi
	KOg7ihyLtHYTXQr9nCVt23ol4jxwFyIhxtMBgrzvWYoG1uqEKGf0zf9FimkNjnkiu5R/uBmEYM2
	HZjbly6pv0FAdU7YxEKpnKX7jCEuXxk1QtEAf+mdRoTs4O3ZEgT5+S4Z+rBQSAM4I3+cx29upaO
	YRVx1LtoshWIX8zdd6S34rieBUIGLjG1YHW2jWFF3NgiTk4welkKibE9EoYSjHq8YhD2BJXH2oN
	udIJ/w69OaannZT2wQwtlPtXh41aZiSHcWKJlTd9CD2Xyki4jpl0wbVAITQQr+ktc9kRmQ4hLo5
	Zng+xVUFumnI/UmomkevK4tDScl2LOuHTtlDmVgyTxpBbRoqBgEmyXX9W7babVW/7dMDjjJbyZE
	nAfP1qY1pxsO/l5lcUdsx1iibaguxAA1+y481mySUzaFvoAKpZmAWYKXJvVBsAVl+wnK7Dw+QXF
	OnjuXMPJf3zpPSD+mypAFxhS
X-Received: by 2002:a05:600c:1909:b0:4a5:26b8:4507 with SMTP id 5b1f17b1804b1-4ac18b7dff9mr320918635e9.21.1793735267091;
        Tue, 03 Nov 2026 11:47:47 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:46 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Tue,  3 Nov 2026 20:47:30 +0100
Message-ID: <20261103194734.598182-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103194734.598182-1-koray.fra@gmail.com>
References: <20261103194734.598182-1-koray.fra@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
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
index 9f0e42424e86..b1f8323fffe7 100644
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
index 7cc82366a1df..d196b73f4ffa 100644
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
2.56.0

