Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2D376BF7
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832073; cv=none; b=kAK8Q8vL7d24XZ3bI++ygeQApF62djkdX39t7NOkizZvX+86OmWc8yoIyzZ7TJdCFlu8GItMnrpTe+/RY3hMebwxI/JPdgRJHdcJXYtSuIK1USQdmAMPuacazb86jkDNJDs1aYm3vq60UpnfXwJDk9fEwg5nvJNk/tGiwtttFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832073; c=relaxed/simple;
	bh=JgC8ipASP8UxT27wqNV8uewsZ26cI6/TCLVUfgqnqA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGlsYy4aXkkm1YrVNZcw7gRX5iMV8VfxAt6FVIbOw4og5yeyEBg3+D+dsmzewYng+KPjSEab7zipvVPZ11twutRggRu83WaDYGmR5KzvcVTnKsyzWIpB3Jkl32rhezbD+XUNnFrQzZHL5ck/XEYAPEpsSoEow6Oh7bzMweLheO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+kgnCrj; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+kgnCrj"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48afe75f055so2051922f8f.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832070; x=1792436870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=b+kgnCrjUCYy9S/UZPUYFdTnmA3XvOYTKSVv5iJoFbgrHhOFbzoNd75hHhAgWVN3UK
         TNDDeemEpKXxYuegD2zIdSUqg/pTprz2F+gO9FlmEpHnRqR/+LSRabvQi+3oPJOWW4XB
         nqstk6uSX5uQw+YmMQIZsJoPJ5RCu3BRxISBNrT1UbJLisYkgwp/KH2Z5cgHB6x//cpz
         xj+M11pNE9HbxooLZ0um+uoXWj7MLpDBH8Nr3FBnTa4wQGrSwUY+YrfTvRPAVHXoyR2P
         2sgfFUPL9prBV7CaS73tAxwzezXbAdi+AvpgCxIk0s4Vzl4IVz+GgmAFWNPHjZkzLIX8
         BlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832070; x=1792436870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=WZd6BJsWsdAvAdkSODhIQ5XfB5xTokVjpi8jPjo+d3sqwEDcgzNk0eYT3mHWWixhU7
         wWiTZ2D8oe/YklwFDGaSKGSlSE319LQyUZbdwtzM/06yvdQlGWQQ3MupWXmYYG0j1D2n
         td6OlBQl3Ez3YAroGS+9eIxDnDqJH5+DEadamJF1Q+YSaWVwLMvBE1YfrJ5PIIuzzvr0
         S9n+PB+CZV5/CvsB/rfPnfDf/BZJ5SWFAZuyegA34f2yA0UqTd0sUAIRUA8sjLuACtIp
         SRcwTIrD9DeTzo/HGLCbH8STYPjkXETMmu1p8q9wtOwnyvWZmYSg6RHCon6xtVU/vMo+
         2ATw==
X-Forwarded-Encrypted: i=1; AKwUvBxvCpx4Tu6r6pzr+7rNJtDU+zef10d34dDPvaOh//FPxhDGZJaSnCJG/+Er8+GlFi/Y5ChM6fbz9bdhGQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJDfu2ocTHozSz4LUrYs6PHsc4YrBo0Jx5fHwrX7atFjBRazjy3
	mc5BT5NAwhXuIl2GQ2TNPSUlzwTMCmRvRmwiuWTM5JmLetb1R6lqVHU/SkH/68TUB8s=
X-Gm-Gg: AYBFou0HuqazGZ5Dep8ckBKm1r05yBQfLPGkI06l6ak0IxT8YlCnI0c5Yj8piwMO+Q3
	mIdpOfLVTX0s9VgvL0PBDlOM1Fu+LPIH+7KG9FOyuVcghD6hA8Erq0PkPC3P+mgqTj0y5H0PUTJ
	bPu6/w4ond3PmA5dScB+OoqP3WMyRnGoR3f0tIjJ6/JASgH1KlfamnOOe2IcfAPU2UFYhRIEB/X
	Mrffjtb/QZRIkk9XP9/pmBE75rbHSOnFdWG1MH+THNgq29Zj87PSScSZe2I3InjRPQ6ovggURYh
	sDfcvTTynr3RkCUk+p+i82pHDIBsubzAAqCuA0xdeaioOBUReSPUYGpIR/w5zwrOcG6Q9ieOubs
	n1KFsIfmSG7g80U4puheFIFCTqfmt4lAtUuSWi9aLJ4PICr4FbngWSDEO85zwWFkWNRLrxM/SVn
	JnADPcncqTX58rzP/d9lFq5vaJJ5fVErjRJiE9i4lCWAzt269y/n1w5LYk85qvmEpc1A==
X-Received: by 2002:a05:600c:190a:b0:4a1:746e:589a with SMTP id 5b1f17b1804b1-4a18e4aea54mr220680965e9.18.1791832070153;
        Mon, 12 Oct 2026 12:07:50 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:48 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Mon, 12 Oct 2026 21:07:27 +0200
Message-ID: <20261012190731.951056-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012190731.951056-1-koray.fra@gmail.com>
References: <20261012190731.951056-1-koray.fra@gmail.com>
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

