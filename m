Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BCF2E7F3E
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786240300; cv=none; b=q3OLiX4mU9JKP+wa/p4PiTN2paHE8gzui04PqtEdaDZ4XVpKWDcleS8L7a0yG1tNQSIJZhOw+zFRY0GVMFyovAtKi/qVasAuKzZIb+k0AgCka9R5yowkLExSMlUcaQi9y7DCZol//opIyU6l8bq0YaG/60aqUvmvKsv/cc4dCWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786240300; c=relaxed/simple;
	bh=3FsMcDhBYZTPMf4DQOoQJypgZEVWmM4yd/owlw1YWJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeMWkNH8yccaK2DFup992yN7I0BwW8rgtTm1IMNsQW0mUOpKfr8VbSvYFjws4Fy5lPiA4lk5BKsbOUSf4J3TDHoIvftT48HQEI0f27tX3AO/EEaJM33lw5nFZDWQScqszjo1ZJjrpEej2BrP2urjQfx9r7h8btAmB/bGKnvjfBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T46q1WAI; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T46q1WAI"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48000c5d6d3so244328f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786240297; x=1786845097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+4v0KgjdssN2e1msJAFqripuz3B0gqw7mLdJHYCoyBo=;
        b=T46q1WAInchiiv0GraJ4INiza5HQFMOV7YuXGyl1rh0GNJOGISs1LPSdoH+H7ByfgA
         FWw995jH8AG6rjLnfC2HoMdDtV4F6W60Zp323kdPUhSIoV2trC9jefnJR19hAQ6cr3tB
         0/QQ6fQSuxizbjXKBq+vHZpoRP7S5lHLpeWCLIA3QIpAgseEqrJJJmpdxRmvm5drJ55U
         Sxzv0cWOYo635QMi7VHSRuA9ZcmtCy33kMpwxLC4LUzjsL2vSQBkJa/BPyiCjTBmB/cO
         QyZLcTfkUjnEd+EOOQupMMkPAFOeMQjlvlmS7hSx5Wy1F3hUfJVwKsJtPBNhG3ceOUfn
         KrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786240297; x=1786845097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+4v0KgjdssN2e1msJAFqripuz3B0gqw7mLdJHYCoyBo=;
        b=LuJeuLtAyNbNMes3Sf41J6Y7+XmGVCGWDN4NDYST6iuzHadBtzRbJ7pzFPdiUpl45p
         3rfaZkaVRg7V7N1fmlDacvH+kallWEkok1/pKEEcng6Gr8SRFvWJiRZE6LbvbaU63/MY
         PoBgJYTa7T86RsyE6fBjfxYSz3/09M8P1hBRjcxIW2vJPvommLKKd2/WHZIVOWHKl8N5
         4GfPPlwJq/jHYIRzGtc8oM6dN6NvkoD6XetFsOf9wc3mpFZ036P9Cwh8qiPCt+E2dmTD
         eoUnowchW1mu79xNqtYpJ5dq6b7iGzKfbG7fT9EC2jzhSfmAV/DCCPqmhstVUVw2C0BT
         4Lew==
X-Forwarded-Encrypted: i=1; AHgh+Rqrj+R+oTVbQedIbrf7zDDD8hnGCqPBQG8HGA2s4DgCLHQOM+dOPE5NLFc8fpZJAuSe5R2A+UGni/7auA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwFZTc3VYu8Uvqy0dfB8B7bQZmm6cEYAE6ZmlDdNfULysOdGMC
	lTNeTxabB2904OsNhBlwfsVkyGyFdmr7SQ1/OdejEIBPbH18+YtQqmD9
X-Gm-Gg: AR+sD13EjHODVCBO5aqJxM3i9h+mLlZ3b/5cF3+5FTTFY9fKrVf8FYpQGQ05dxeQ6xH
	7p8d0+gHh7CVNT7nDwQfSgr7etqeItBj5HXgs9a0CefvPMWaF9yQN51ZIBjDC+HH7oCYeHe7KOh
	gCBrLI2va1qJTIXQrx7wGuayXT/DJOVG9IDNZDewmWH5fUcDakVKGEO/DKdN1zkQJSvg2I7OLRz
	yjVxkG91XmvJpHN9zOVEOg26z74ZFiG2dskf9cwOTXonB8iiOHSp2XiIgzvTsLw0SpVyKE/Lc1o
	JswtJ9LusXJ5CdsBQaMzgBIGlshltAwONE0Balo8OzFCACDNYcg3gYQxn2tl5ulhGGATSmjGPwM
	P78xXav/K01cGkTAfHH4qrTwutrf5xiu0rgjq3lMowcJBPIaA8bJMxQzOLbUDU+zMxp0j8KnWkq
	E6zPaeSMaq5Mf2AvTaySCNoXKiMccX82gRgt6Lks4eyO6/gS6yuU9NMvA=
X-Received: by 2002:a05:6000:4813:b0:45e:73eb:5119 with SMTP id ffacd0b85a97d-480026d7fa6mr19615503f8f.22.1786240296684;
        Sat, 08 Aug 2026 18:51:36 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f90f8sm17155676f8f.26.2026.08.08.18.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 18:51:36 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 1/4] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Sun,  9 Aug 2026 03:50:51 +0200
Message-ID: <20260809015054.779137-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260809015054.779137-1-koray.fra@gmail.com>
References: <20260809015054.779137-1-koray.fra@gmail.com>
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
index ffb6b52863a7..58138f300b58 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1660,3 +1660,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
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
index f4e34898d581..7a21085c33c5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -264,14 +264,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
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

