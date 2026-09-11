Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DA1370AE5
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097637; cv=none; b=OSpwGQnRfDgWLIdHboUOk9n94tn8aqy8spBUhxzj3Kxf5M0+LHSGDD/71B3FTiHDlJteW5/vNdqJQXfVrI8oePNXIJaj02OaUSKGv0XjCen/WTccQaZixq0k93k05dMZmEi4Pfidvam48govEcRiv5TeEkCB+teXvVfqHmA0YPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097637; c=relaxed/simple;
	bh=JgC8ipASP8UxT27wqNV8uewsZ26cI6/TCLVUfgqnqA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3yS1oRe5zWE6AWL3/lvWMJsSZaQQqN6ucmNBPO/z8B0whHsCbByZqZAZimgKYS5HLpyv3lOu7kjopO3yW6bcNsPhOTdYUNpiYc5gYwMTlKWkLEoU+/S/zhhssFW8cOV+uWr/cloUxF5iqRljDP5yH4fO1DTIx8KBzgKRAJTSBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FP97JOLK; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FP97JOLK"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so2615245e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097634; x=1789702434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=FP97JOLKyE3uMNUMj8mmJgsPMooPA02hZia0rJtIu6Emk1dwNq5ULCrPfc6+Tz/hzA
         yWOru3AmdKSHEpPD3MxZkya4tzcXwo6GjZBurmpu/riAYDRuMPPONojTSuvli3bHxA4H
         PVICTc6Kei8HxsxXynKg/3SrRADTaLtmb3peNsi1mimLxK11LZ0blqwGOzmdRmXn16LH
         UaE2x/8gU7Hse4qJnf0loTZsHzACef2WiJp+NJHVNtar8Y3Nxay/BYW/Jf8uU9vZ0Nor
         /uCkMnHSsbk3sXvg8mdF88nmqAffZNx7ZcFm6fYmHqrkgaeOlNv/IP+RlDZz8sQ5cG1+
         UD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097634; x=1789702434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RZcPPOi3jZFQ92Ad3mtbn+Cvm7ez/H9rrX3qhXdjVRs=;
        b=jzPErjNTM2H37707BElq5MbzxFga2q5/TpG0EdbHYbEYXdtkX0pBMPLDX0fL6/rB+8
         K1JEebr/O4q/iVYRLXFWWSdc86tvv+ZNxTIDFFVtQgwgG10Vs+HOvZCiUPqA7nEj8A2T
         cl2F7aUFGHbE+twv2/aPlaEvFkN179flvF4UGZfvbNg00WpOBHJYCHc3swBYYZnjiD2t
         00ce+blaYxeW5ecabGB+oS2SehOB07SRd/O9MiDmEgcb8LX7DIEJQ2bvlbV77yAdUjL3
         INOKjXUicEe6pC7B9rvcQ2Lbvj4wkQmp/0WlniHmPLD+8GcvZr9XX1anz59gL7yw8swF
         t56g==
X-Forwarded-Encrypted: i=1; AKwUvBw/28HXbvDIVUUg8/kjOzicNTI+3dKNPzEfHS9h0QVdMZtVrSp1rnPP/gdGUH+c6awehN/EdceE4uv9Ow==@vger.kernel.org
X-Gm-Message-State: AFuF++nH379ZbM2exIZ5Vb7HQjWWisYeqdrPbtxtY9xWhJRk7jlzGF6Y
	n5viHvW2Y/hkKx5l3+6o6kGnL48hepdJfLkntpqXFrsCGdQC1LxZ+5a6
X-Gm-Gg: AYBFou37DJ9PqGtZRMpbLltYlHLIeymyaRXg+mMwImi9k/7waH/LhJXGlNFTfGILQNr
	/eo1SpiuGMSK0sXTnDfga31UWyFMAPIDSQAS/C8tDKmwMPDsa87OivWyeR70xKCnH8QH1IDCdYT
	6uvV7yrdr9Xz8SUPnkV5IEQHFzaEmzWAonhmrQzZNCHQhxN1NWzpIT4/uA6y8Ql/kleOjjselQt
	t/65rlnn2vaXTvXj9e4bTJbmZI6jJ/qsWJ3DQYipsAwlG3j6RkPAxaoAQZFdbiLASOuoNAcqpHj
	R+KKin8VdhiZHETQaOoN2yHPuxL85LwlMvlrQh37EqyQeXeADkID1+s1rucAed2BlhvFK3akvga
	LYgZnCd5UmilcmHHdkR8Wy2IAC+mKGztdEAEfbK1qrL1vpVR1DH567QTxweyZRCL48S/Id87elb
	UfTamW06pDdPRLChoIUYFjZoAMuyyiJhti3nPY5oozDJ1SuDqb3usI0doA2OYRLDZ4pA==
X-Received: by 2002:a05:600c:4fd4:b0:49d:870:7a69 with SMTP id 5b1f17b1804b1-49e619b8a83mr36217245e9.12.1789097633949;
        Thu, 10 Sep 2026 20:33:53 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:53 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 2/6] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Fri, 11 Sep 2026 05:33:32 +0200
Message-ID: <20260911033336.957102-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911033336.957102-1-koray.fra@gmail.com>
References: <20260911033336.957102-1-koray.fra@gmail.com>
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

