Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593C6372B57
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443855; cv=none; b=hb69J3lqWIQQXZfzWczStIDXws1eyKit178ukeyLuDb9ldSaBydAR36IdUO2NZFRs7m2KTkJOPCg/ir6Sqe03KS8n6nvEoxR5YOQWD6pmW4sAXitTjFa+PAduodhqcmJrTcVIK7JWnbHEo7gBztMBNi+QdZ09mmi7eNbf8W1rxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443855; c=relaxed/simple;
	bh=e6LC3tUQXXCwZtdgcEjCOU0TcX3Mg7qaGsXLelZ4uJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omB81v2XpM4Z9suHxqxbuIhH0m/HTQmIXMBwM2TT5uexFdiJw9n/NOmTeIXPh6qVkUuR6EivKWhvrg+OYsa24/GLWO4+Q1ow3qVlZkyp5j6TAd1p1xcs0adPy7OzkNzsFoQ6aTVETwg2utG+yY7vdr6zv4SYrlQAGXZ1yGMfDRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7+Cqihl; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7+Cqihl"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff9621c5dso4444055e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443845; x=1791048645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=j7+CqihlAADZnzG3W0T1xpPp8ot1HWDRuzi6/mC2PBu2BAkj5ZEBdtJIBKh0ibt7P+
         Du+vOF0SETuH9k3boBSKITMjz0z/WrkCYDs9VH2ueluOplU5iQrz+rEDlFfioazhMz3I
         9kC/ckkApPaYOdoPaBP6dxdxZEv7IL2ITRhfJcHR23+ik9jNvlGn7GKMo+g0vtVqNl9m
         V75c/Asf943lC2v6WUs60kULaDBlO03ie7WagmnpRdq9c3OyXWj0pDhJbeY7kTTDylmD
         BAHEPuR7gKqJrqVw7DGrMGFV61IxA3/961m65a6mL1KJ5iH7++CAqZ1MG0MNdP8M1Tai
         xpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443845; x=1791048645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=zcH/sK2Emi7gWSALL3PNLm6Js47RK178q2fjLMEX9myN4XxqbyYtzigUyL5KRFHrYv
         gteaupXqiDmRX0quKICA1w3MbU7vq4o6zcoh4lemwIJYb0Nmw4It5qJQ/39Sh01znOdi
         wz/S9oh6hh0/jjF73E4aNQZifavM0kyRo0v4v0aNycLqyXYjXDp2Ur2EqBqN6cAd8hAI
         HMLJzSbhPEdYKe13GjEB1TpsAiQtr6mVMHMyK8coQCKAK6zLMn2/EJMKritYU6G94cHM
         iK2Cr/3vf2tU/4Tf3x6POzH0MpGz4pWqMIB6TrpdrDz3VhWSwN+kYlB4CmEEoc5klTWw
         6B5w==
X-Forwarded-Encrypted: i=1; AKwUvBy+H3zjUeSjq/uBmltPTsUlCiB65s3RFzd8fTd2M2RrPz10HwAE5uW2xgoNplGugJ3OQ76dobDNR9QCuA==@vger.kernel.org
X-Gm-Message-State: AFuF++mcmdebe7uZDWfNQ2c8pey2DtwYOdLZ2cpqqOt+kDdZ2Ou/kI6D
	LqAa5rQmxXHhbd10coGUdc/QvkSdCezInTupPes8q92CQ1mOEGdwwR/R
X-Gm-Gg: AYBFou3ZmyHOE8y/j+tILLYvG6LxBphqSVDJ++AcQZeLDB2eoqjMvznm1N+s9YDJnRf
	1NFcPzjrc+74ykgcUcBdJKHIhq28mJHCHD3+8oiuUTW7+EIto2ojtBR1agv5Z5B6mhOW9YNOHNz
	h8vDKyCz2L00IKH2Zu7LO+7qI/PxeYW8iK6VKieW63Ibp7mIt4n58vgXwwXIf7Rv3+TMJbPDfjR
	0j0lgXJjzBxFdNmouPzA8NmxlS34yvw1quaLwVzOeMaGqLlrpbdivtj7ZVNm+R60YxPWO5F9JfH
	IzFHsdot9JjZUo0y0imzvgc6Dq+ArNmgIN7yyS018+VnZndaB4IKxKsbNACKDLsN3pLjngpM2wf
	cj5RmMWHvzV3KM/L58XMD8ST7tMe7ri3lOtiwTHv2i95kBiCNu68klfsbJFpL9io1+WEUOtLtPy
	vEGZTkSGprP95n5irGPpZOuW1x4mu0szzYUBnnvCmzK4hMEeBlnPRRD8N1t5M9VBYOMw==
X-Received: by 2002:a05:600c:628c:b0:4a0:f4:1c76 with SMTP id 5b1f17b1804b1-4a000f41d51mr173695e9.4.1790443844798;
        Sat, 26 Sep 2026 10:30:44 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:43 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Sat, 26 Sep 2026 19:29:31 +0200
Message-ID: <20260926172936.337085-2-koray.fra@gmail.com>
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
index 20169d028961..2880ee1f80d1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1652,3 +1652,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
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

