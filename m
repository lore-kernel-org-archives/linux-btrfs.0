Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F1C1A9F83
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097636; cv=none; b=ga0RVKMiNFH6kCxMU9SXj5CgZuNOWCDs3ERbWy/r189nc8KECgSb5mzA4s//2ZLs6T9I3KWqkH4krFTMx/+w09U0GSJo5v2WV/RI801tK7S3IbCFRuOwtVC8jExv3II1puw1tol4WEBsPR17xeTt2JcGrkWDBbD6/420cKKcuQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097636; c=relaxed/simple;
	bh=e6LC3tUQXXCwZtdgcEjCOU0TcX3Mg7qaGsXLelZ4uJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUI34YXJmfTUk8OxXVr7lWQ7KheKWEzF52c4u+jM00T+U9vk8BeD2nUw5Gv5Wlzptwmhpfa6DRDeQTcJ5R/zHu4KCJZtBN41le4C2e6fNTcJtJqX8f44OnY+bkyfFXSvmrgZscZ7QW7f/bjudSkxc7iTIydxToZYnOg2AFL63go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLvEwUeU; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLvEwUeU"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd6185db7so2519705e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097633; x=1789702433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=kLvEwUeUkanOwzGkGU9V+i7d4WcYj3PlZ3hWstIN9hp978SXLVRwz7m2p4FWIrXpcu
         Cc5FWWRQPzI4FoAbOx78fuJpc+Mna2Ubc0FmcqfdALZ+chqn3VI6c2oe4fEhEDCCg8Zj
         2ZokjYDhK9ylpCwn93TYP3LHJTcjQ7Wrdmtj2UCJld8u39PNcX4UrOGSushXb76H9OPb
         Vxlsk5+gACv+4quRsoJFYtO/kXighPlyuAOzb6yCua9Be3Bjs3BA9gfM/YH6yumkggfN
         iKQuKPZYXZz/Ie+fLxDSXQ9iHxwQyk4NOnjzDzsapfxWPXWKv+jOmcucogzfkXkYvxCe
         5kEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097633; x=1789702433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=UF7yPHJmaywudZWENs41HGLrUngsifZvANaZzBioAfAR/pga1/dOwQ6W4UfBNbRyml
         PCbnHShceqvCm596pV8umTauB5fx4QPTsfJFIXMbeZX2z7V6CHs1+fgD1J+GqmW/5GxB
         xWUHURZXtz8zOSlTnzNlUpv3Fhf04Lw79vpRX67oGSn8WLu/TeMYfiNm04Wrwu2uXEqP
         J+7LCj4IQFwJH8Cy+v5QzqVV29pbjY67+4c1lcqTMOLxOjsT4sr2uKmYrbUkdnjbg4dl
         Je3nRc53aWO5NkeUuz4jG2rZUl78ju02c6pGhLGIpBo1N92PmUfnoNcV4RR2n1+f25TU
         uR7w==
X-Forwarded-Encrypted: i=1; AKwUvBz4QiLKRAtjZEq5rzSLU2RGDhmyEO1UfYVSK1PkGROpox2Q6IUs7lGUbh5io1ABV2Htt7LOPnCwynm2Qw==@vger.kernel.org
X-Gm-Message-State: AFuF++mYKD+3NbpAVyauPlWhgQeIEZF2VHHJISejt43oNQJRit5Onf+o
	uKHXDj4fFbqthxmf5IZt+mHdU38bdiR3RNTS+r42fWFKm9EJwskR7Cfv
X-Gm-Gg: AYBFou0IH9R6s8ZAHfi4OJJw3rkKSZGNajUNoZnaUir8iWn+QdRb1XmjZyR8/w/md+J
	gm7/fLGHbz7lCsD+vJ7gqKP5EHZjGo/MycVqcfVy8r6FFUXyjzUZ82txTyAYtemLGDUDy41P0Dm
	AdFLcLWKd62NZj5aePgF7QG5lmdAH1anWpWget2CgMFwttXapuUHJgzffx++3wWaM+K5LktzIk+
	nDbaj75zxRBcrb5BKnifT0czVY6LwvQQFpcoGh/KIa+iDrvTY2eWgjws1M9ihZ7PG/yGR9DTE6e
	z1B8rXWdvMwMNS8N1dbJCvfJsEfC2GGNvto/RMVQOpaicQpO2m3WWw26gTCP7uz4iMS6m8tc9dS
	wYfsHLe/P80pMM/bML5GuM4Le/JulkVK+4GCRG6JlhxXT7ZgNFu6X+7AveRp5EpJeBWt5D/DUAr
	OqISUAIpwYTCspGEDVA4PKI5fpeDupPl8g0tE2j+Q0hPq+/n8nfF8wdVd20U5IdbKstw==
X-Received: by 2002:a05:600c:348a:b0:49d:29ab:67f8 with SMTP id 5b1f17b1804b1-49e6108ad2amr25299455e9.12.1789097632706;
        Thu, 10 Sep 2026 20:33:52 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:52 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Fri, 11 Sep 2026 05:33:31 +0200
Message-ID: <20260911033336.957102-2-koray.fra@gmail.com>
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

