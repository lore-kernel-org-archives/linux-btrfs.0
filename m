Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA523914FD
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301661; cv=none; b=SKn/vRuCnQUDVOZueqfybEHBjcTQQqQc/2PssQgjUKy9FrBl0Aa2iMsAIcM7etWbaIWNlOh393OolweA+9MBZJgcjl5yWw+S67CCcTeMo5WfdzCxXBstHu6nxIejJeAMIaex8QTVY//LTsoYwti3umTdoGsl6RSKaJjVu0hJZpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301661; c=relaxed/simple;
	bh=3FsMcDhBYZTPMf4DQOoQJypgZEVWmM4yd/owlw1YWJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB0F21yabvOi5F6jWF0cXL87Rbs6mfxBb1XLslDtOxeHEfunI0H2XSkffxVireBMLzAvwI6ZMvlTrzy+AiPygXU8kgj4Z1X4feL/moTA4Rsif7LXsc2O86TyS1wn1Z/2cCpyP9B06IcZwdJ0ADuIonkfnQYq0pm70YH270YM1sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGmPBBjL; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGmPBBjL"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49800c6a846so10566045e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301658; x=1786906458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+4v0KgjdssN2e1msJAFqripuz3B0gqw7mLdJHYCoyBo=;
        b=OGmPBBjLnFDBbF8jGGIAUJ5TZkGIh1zeIi97+TyET5ju4kcQ2mq+9UAGSPyKAJI2S/
         W4etekMCcVhrNdEVATGZRDHikYBP4G+wlKXrDcnzHiVWZ+lQ7kSnK13BkNsGAcK8KWR/
         ntB1qxTesTM/ARMkqI/+1C6JdQZ9Cw98y4Rsg0e91lsRnfs2txDSRbFzLGoOtrDL+S8L
         ra62fsCtYzY3tiNPdU7RXVKbioYpCPQ636c/emP8+6CEGpQbheXA09xktZyftMreeB3k
         CKHpC14Fbllu/Z97TUxaIF3p/Lchgry7gNPnJ4bo5y1X083YH0pU07pTZxkY1qanpCP6
         H7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301658; x=1786906458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+4v0KgjdssN2e1msJAFqripuz3B0gqw7mLdJHYCoyBo=;
        b=Cof97MQVX8KOBnOQ/rcz0xEy/vBt0O2XxczOeYjJFpfcMlqgKAYRCrsr7uZdlqe2gD
         DECDeidCn2PjB6DT2XAP0vZ3rH5J/bT5mlN+H4oMEa+HmOS1KWyQUqV5eYLLtuWwKBPe
         olTOzefwIUTzf1sLNrv//ZWZ6NgvRm3bhymR1QLNuKS1mjfzx57mM6LZQ38jroF9xrm4
         o7IcuEUzho1CaiV1WsU5xOzvcHVdDZTvlIB071MnboT4iL8UII7azHZ5bOHQRU+do/xH
         ebolEE6JdN4QOiXX6RWV+C8tfkS7FQKi/+okfh/BHh8ij/iaVGY/ACKn7toHtlwEnsnA
         wyGw==
X-Forwarded-Encrypted: i=1; AHgh+RpXz8Gi69ZcgpsieDKsrKDh5NhnUub3egeiLlCrXyAVbRdL+dh8k2G9bZXoGH/8JHv2qBoEEOCqX+hJnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDc3k4ZxT8uR+tm50DA9RwknbofydWUCqy2YHKDOgqu/0zsNpY
	FAJ4ptBg9dXUonAhSoak43qeabwA3JuR1z9fAauTyuCbN+V5Q2qYi0+m
X-Gm-Gg: AR+sD11ETBCHV4IuVxQlN6U7VoG+zJx8UnfAwrUqzmLbmFWnIZcboS4XqYjfv487ZVK
	kyc01fFDLzQOwUc3bDpMQ4jp9RDV1CV/7RV+9ZRmFvhTieurcztLYM2j/hK28ZMZFyD8XbbxK99
	Bqa3yX2ebGsKWBg79xuj/DmhQBQjbmxHQSNcBkUngsnsQ1mfr9ehrrY3l3hI0NMRUDqlvFBMV+N
	FJfYguP0T11mapIk2ZtU+p9RXKSpuD3tga2/U3A70R8elye0THEBscTKy1CaGcKzPlJhP4z/Til
	u2mW/9Aligr3JHumo7LtfT178U7iEv373HWnqq9gA/5PT0+ZQfNJ9vxNK0CVTXVUop/CHQvTZp/
	oVeU4B8tIBK0RaP1HCUhTfsgTgaJuaINKNwDboRVcUx+aJ/uXejwNe/Xn/+5Ut3p4yOTnAZGRoK
	rYn+Rpinp4xjRdzO8mkGdNdKG8muhK3sMzaT8L4lJcjaOS5L3qPL4kHEE=
X-Received: by 2002:a05:600c:1992:b0:499:593c:3384 with SMTP id 5b1f17b1804b1-49959e08773mr303651925e9.6.1786301657833;
        Sun, 09 Aug 2026 11:54:17 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:17 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 2/5] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Sun,  9 Aug 2026 20:53:00 +0200
Message-ID: <20260809185303.600071-3-koray.fra@gmail.com>
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

