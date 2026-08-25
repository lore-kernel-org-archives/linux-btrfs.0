Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF53443AA7
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663296; cv=none; b=JyEGwxPLWYTtw49M83K4Adjf59aJMVcK9vkx/XGRGhhrFBDRCHldbrPj74P8ra8/Y8qAwaDsxdH409VGW0Ascro07PqOcNJqq0tNqm/Yl3qOEYjqfVWSrwiDb9FKbMyo7kp7wayud/xD4USsmvPCd59O9CJCmoFwQ+lwI00Q5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663296; c=relaxed/simple;
	bh=w9bAhlU/qn8FlMBX4Jzg0dED95rdfnFDxGqARYs0o/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ7brJxiow6AUksUEblz/lyx6tbLBM7ZyoWmw/AaK8RwQPAi1/ShV9GuL6BQ5U+OGHApZvK1Zh+sGR7Qny7qKWYxtk8pCjYQHou3gljOrhhR18TK9tVWB/LRbsGkFlYEwDoNAM2sKI/LYWBjzsC4plhgmqYIOOd2zUKMfGbLbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWlg+jKj; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWlg+jKj"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so575548766b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663293; x=1788268093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qlyy4tEQWi8wjlIjs3jWR6xb5LmzcQEpEL9ylV8tc3A=;
        b=HWlg+jKjdkAKr012c7erHeWvk6lpvK7EERVejI+u7bHXZyITavRFKBqEB0r69bQ0RR
         scHWevMkW6+F+g3tmjLY3e5ZhB6rgLuW7GCEGgrIa9wzbz9/oTXoJ3G9aAAtwvWgd+nv
         I/I4EsreAazo281p1f7UUiUR4HbLY82V0YR1+YxqTuDuy9j0H9jNXkvgsabrljFQUdNA
         vOkBbwAxX2VLIxnk1GTxHTyr/BIcKImwRIUWAw6g5u02ysljz7ZhNkvEgKKQctm44ETz
         cNRkv03EMGhbWRjEIWGUr/fVKKh3TA4a2qvkC90MDImWGTzbGxRx0adp0+SFCVnsVZI6
         qOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663293; x=1788268093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qlyy4tEQWi8wjlIjs3jWR6xb5LmzcQEpEL9ylV8tc3A=;
        b=s7tI58VAkNqd4JkmbhxfI6SJ+L4D83UCpH2E0QvtEYlyXX+j4VY3eSstFR+lFAYmL4
         57fzJ58mwXW4oPfhLbwfENH+k/9TJ4G0hOcM1pZDquLpJp74XCQTkSr3B8gA+xWYeDAS
         K0/PPstgUkm01q+vbey2Vb99+Eas+gb2KLCFM0f9icP3lur1+tennyAnuLaO4AJBPMTm
         gQ2LqbHZ7dvaZ0+oyS/F0Yf18twOOF2Sdkqjo3XAcvMoCXaUdx6T8BjO7Z5p8ET3XNxG
         HK3Y+yqhYO6MncufEdOVtekn4Wf2ftTR/fCsak0+3A/2WfMYCP/onL8mZKMUr8Bclro3
         ftzg==
X-Forwarded-Encrypted: i=1; AHgh+Rof6UFLguXzI37qNfUu7WSsuVBpazJK6KX5zhCHxIPYGWGKDDF+J61hhPrp7PFu+ygnUC7NMu3k6QovrQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lsj4Ou5TjTNmr3TWH7W3SWc9mPsZlxrmul+9WeUKFqwCPWgLEZ
	XNKxYMgOvLfHe9Kovzyqghp0wx7MuLB2X5dP4rFQ3itojyf0+2nToj0l
X-Gm-Gg: AR+sD12RRwZJILrhGgiyPWu+wOjFdujV67UvhSGrL+z0EF4NyDsF1m3wGj5vlToWgEJ
	NWCRcSVpTPbLY/il0NZVp0t/Pk1SvjYZaLJoIM34M0rCmreWErFje8dq4Enkygq8TIP8MF+lhtK
	6Znt1neO13SOHy9mxY9t4pP3YKhIioTsnj52iCIBZdhvhZekuem3RAAEUpu5GCJbz8KL5fx4Y3v
	hEPrVIi2PQDMFPmU+hdq6x+J4mSNTyeQMfl68Emhg8ftPIRZGm/p5wZlar9BwLV2tCRl4mFXK+1
	2J0wyt+0YbLH/DkNh6WnYirU00z7ssmssPMav3JH7Nc/nvUWz6IBNKu3KWSWjIdQ8aVB0BAEdps
	XRIZdmSU+Ag1U+yLv00L25ev0JOqJtZErjfiM/yV5Kr0uzefstgDAmB1sFnGVbYdTkjxPL/KIQ+
	Ti3Kucs7F6UJigzYd5ytfGwwGUdwhor2zR+gxlXAMsAq7gGR99l4CdocSJ
X-Received: by 2002:a17:907:845:b0:c20:fed2:898b with SMTP id a640c23a62f3a-c2492782dbemr2663548366b.23.1787663292366;
        Tue, 25 Aug 2026 06:08:12 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:11 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Tue, 25 Aug 2026 15:07:40 +0200
Message-ID: <20260825130745.229008-2-koray.fra@gmail.com>
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

Export btrfs_match_compress_type() from being a static and locally used
function in super.c and move it to compression.c, exporting it in
compression.h.  This allows it to be used in the next patches as
validation for compression algorithm names.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 17 +++++++++++++++++
 fs/btrfs/compression.h |  1 +
 fs/btrfs/super.c       |  8 --------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..65d8b88b9732 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1650,3 +1650,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
 	*level_ret = btrfs_compress_set_level(type, level);
 	return 0;
 }
+
+/**
+ * btrfs_match_compress_type - Check if the string matches the compression type
+ * @string:         The string to check
+ * @type:           The compression type string (name) to match against (e.g. "zstd")
+ * @may_have_level: If true, the string may have a level suffix (e.g., ":1")
+ *
+ * Return: %true if the string matches the type and, if %may_have_level is %true,
+ * has a level suffix, %false otherwise.
+ */
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
+{
+	const int len = strlen(type);
+
+	return (strncmp(string, type, len) == 0) &&
+		((may_have_level && string[len] == ':') || string[len] == '\0');
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 1022dc53ec51..e67ba47b4cdc 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -97,6 +97,7 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
 
 int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level);
 
 struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp);
 void btrfs_free_compr_folio(struct folio *folio);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..00452ed872d3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -261,14 +261,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 	{}
 };
 
-static bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
-{
-	const int len = strlen(type);
-
-	return (strncmp(string, type, len) == 0) &&
-		((may_have_level && string[len] == ':') || string[len] == '\0');
-}
-
 static int btrfs_parse_compress(struct btrfs_fs_context *ctx,
 				const struct fs_parameter *param, int opt)
 {
-- 
2.55.0

