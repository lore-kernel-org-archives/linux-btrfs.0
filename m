Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D07926FDBF
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301662; cv=none; b=X0yUPh0cWYo3/zCTOIyrCzaySZ7jfaP6qbMvWfHNhNifET10PyDzTfvOfYD95Z1iSCfg2yNE4dnNJIU60ehgzjPKmdj8Dv1eGs5tlcbrUDH5DNamYYSFz/h730+eWHu3tDEN3Mv0xXZIpHefSBRPgHzGROFIuPwvkAQsee6XEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301662; c=relaxed/simple;
	bh=Xze6/jiTYQEVXOXXgov6t/fi2qiC1rmsvt5W5PyAswA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUQwn7vuttc3fZKEBHkrb43a0o1Rx/GDXmKKSRVvUGlRG5ZqpjrOur1yN1rGrvSMSYcn1gvAGoUJorKnozTCCVW1jpgIf3b1QJhG0gdF/jwSMWsjam3YLaY9wOa7cX24Ii46fJA4R88ZGr+Ytgaoh+E3FixXGVb726jENBkWIJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5EJcnuv; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5EJcnuv"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4957eefd361so7914395e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301659; x=1786906459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oOPfXytRkcSKDlitfvExGF99/e4Oq+ZOz7457VnkyzA=;
        b=B5EJcnuvInzKiDyc3CzGODupmsQ13P3aq8RtFHW8iynW0VZu4HZapjYgXUKasnCbEv
         1JD3DKXtV91fuQbtxLQjhQsk5ePUM+BE3q3VFKYApFBZ5Aem4hw/q/9g0jMwLyirJ9/B
         mmr0adMAucwRgIFLHRWOQOjp9mb72EwIM3ZxWOtm6dDKiYpA7vHbVDZRGo3P5OvIwl79
         ZiqmENMWGkTy6K8sb76ktUBN93LKdJ58fqw29NoSOT3gWLNJQuALXErHTYEO9N+jCVYh
         eIdx74UAGxAMWaSUYBTatcXWupgBxCy4iEfXoAHJ/qsWI+u9qMqrP9Dp9kfu5WVJ4ZJh
         I0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301659; x=1786906459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oOPfXytRkcSKDlitfvExGF99/e4Oq+ZOz7457VnkyzA=;
        b=bfpEHI4821wVoY9UID65RCBS9HdctaAm2fr6OkqpBqUykEntmhX/PyzooEMqbU8t5d
         7UMmfQvRohviSoiU3KsKq2+rfJNgMDj7JPBjc5p2BPUi0ZVaPxJN47m53RfrcsFY2tXT
         IWgLtdqR/KyYduk3yPId6DH/2II45pdGtqW2SFsetyV+KaRVyxNxUX7lWDwIR38jclEW
         oqQ0o6ApS/92bsY2tTIaaaP31DYF3L/d4S3uSakoeAe4qw1agW+GDWfI/ycUYcTgNrwt
         8340/bCgVGvfjJmWyM8XbJznJyhMFhBRskQlFxkerIH327XaaWdroI3br92P9uzez6u+
         Jc9A==
X-Forwarded-Encrypted: i=1; AHgh+Rqbe1v/CnpZXfsDQ2u7ZmT3xCWCi7r0aNkfTqyzbNaDskG6/YnupVhyzDvGskIpBfd00mbiMR4a92M6eQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0H/o4SkiEuGKXS68w64iPXIoXBbzJFFSdd61bJjnJDzX7ozQk
	rQhUqJkfLfXnOnZzCkO+h6m9gJD16Fg4YVDPUtQop2wlzuzpec9iRhS25KEulI+grjE=
X-Gm-Gg: AR+sD13KxXzNw4hu3ZL+YbNVzwK2lU5+D/NcDcZIv0+L9tvrnYyXPAAOCHhHBsyBpOO
	qqZcO3ar3+YkfKSzgo8yuCUYpQA/zOKCLC80saLi10pzXGI/2e1cWD/GFOPVj2qyFQETOJbDGsI
	EJdQNR1/e1yp55jNymvSK0yIEmGRO3GmcC/D16YS9jtRhy9N/mx+jMjAY5sdEqGfz5EmAtyAB7y
	+JHNQD6y534n45Cco407JahQrkyJxXyTH7BmO3Aryf+qruP+v8X1H464lmgqp0gMKQBEDwfNyRu
	AdcnyAc2EHjZEkfGc6wAqYPQsR8pJ627PYeaQ9NvutoIOWX9HE+eak9CuQvcCRnzxRUNkSJSSnh
	a4f4uoiRcfsoRrlO1wk9k4k3wpZLuXy9qUPgXDULO3Q8IyKe4b4RY82Hy83UrimtF4cGajwScf8
	zQeM90Zj8pgi/rFPzeWy2ZUv/sWQaBNZNBe7W8iu7a9Y90lUw4cEWLIqZ8dCTHS1zWuQ==
X-Received: by 2002:a05:600c:1d24:b0:496:c9cd:e7ab with SMTP id 5b1f17b1804b1-4995e08452bmr233133345e9.5.1786301659145;
        Sun, 09 Aug 2026 11:54:19 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:18 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 3/5] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Sun,  9 Aug 2026 20:53:01 +0200
Message-ID: <20260809185303.600071-4-koray.fra@gmail.com>
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
index 58138f300b58..e723cef3b5dc 100644
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

