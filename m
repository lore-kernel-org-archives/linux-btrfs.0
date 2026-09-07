Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9BB525A97
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811589; cv=none; b=PGJG45f+gGS5U/J3mEVzAjgzGk7j2ZiBBMFTsYtK8MHtn8MArdvmq7xbnu9KGNUh5XWF42uvRcEKIb2GgVyoitTufubyYAc6GjJ4MeS5WWDUlK+R5iHQ1CwKCYBJ4XfSo4Mk8txWS5io4MUgXY7HeQK62E5SoVoPGYFgiYQBeOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811589; c=relaxed/simple;
	bh=/vPbZEjwkyqH2b9E+aAXbFX40m8ODsF8iHhrJhG5lUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFU73bVzIlHNRQ6mKXpZYKP72sWvhJnia3m3d1xsrZh+5dg6jAh1TNavm3bDsnJF1vHsbhDmlibcqHJxaFAT3ou9BLT9VPUhB8NubnX+C/IN7Xez3FOLmkGZOvr8LFTAJIOR6grtyKI7MCs7p/22y79AgRqePgOK8LX61BK+K70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDaoyR60; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDaoyR60"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49d036e0e99so13512435e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811586; x=1789416386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REriuRH8S5Ax34nrF7Oncv8T55zDaH+A5M/sbK/OjY0=;
        b=RDaoyR60V9oMjjz5n4bWlUzHLGAOtnp7cXxw40Uj4Kpb6pLqUpijbm5fQhhJJKNTK8
         viQFuNqX/vOiSn1lVA2lvR9+TyhyGSilh5vhuG7FcehtMxZmQfthX8pkk9iL3dGvSUFf
         NSSz8xNOmjSrecVzwtTQixbbZM+W1k5CJouyn11a7HMdusWOqvrA1bKupGYWduj4gaAU
         S2lORb6Lo4nIOkWJo5cRu8GF5RCtzRrqb0o9vswyTfSJc82HjE+7MxeOIMi8ymCw6/kp
         mhd51qqDB9ChGKSTAMkKGGewCT8AmpZ78JK3S0zqMnQ+J58byYlyLQJrI1I4txQixW+f
         m/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811586; x=1789416386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REriuRH8S5Ax34nrF7Oncv8T55zDaH+A5M/sbK/OjY0=;
        b=X0V9v1sBY7nLY3K9pRmxM6oXYlrEzweRyBzhxBaicgxniaoFtz/8CQMn1V0rBugWxH
         LuF66QIs2FqbdaJzQQd6VKqSXr0I1IHqYY0fr4h47MFfkgr9VxV6x84GcBWOJ9HHdGL2
         pt9qNPQcmV/0d7pMGbjjYpPr+373hbWXpw5DRGNBeJr8hMxBSHqJhvRl79D63z/ncmbD
         DAgMAGEocB3ZyFFCTDXMQKv1IG24o3C0fHbcXBor1rsYX+PIy+Dt4Fp3xiTVyGPFMc5n
         4vzjlOUNM0SVlgZJdWD4msz/5Wx7sxodo+lH5B9OnUC8oIZ21IRbtSnEPbObSK7+dDWY
         GwWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzIf4R8rDrFfem8OeCmvQFDDIGLrcBL+7+xWJ53fwnSxnWvk5kyvbfZgunn1K2/pi5mBKNKLaud0hAEDw==@vger.kernel.org
X-Gm-Message-State: AFuF++lJyU0z+Vz5L1tUuxDD5F8eOkqdr4l+05sMsJORHnkSNzUE8Fk5
	h19olr74M8I1XloOcitNtvEpDZEe/A+PiigD12OtBaEi5bJJOWA4qfpK
X-Gm-Gg: AYBFou1MwZBn61dqHugFuZ0YuPb1LetLnCLs0yOQZxd3Y9GnAYt1z+VYyiJafpDgw2s
	cU1t2zDRWRH9gKLJHAL5Q16p5LjYNaw+avcnCnwapMoBgrloPlgLm6xu30RvD3vyE8rLgn6T5vM
	Q1sjgoZmub7aR4uxzaRbOQ+7cBY2ufJAraB1llo2iIwPE7PttAP3KxtVNGqWQEFubrBLEM6tFSc
	fftZjIAeg+i0ELA8dJrpeW+OlfH+QvGWBdv8z//Xp5NIQLIIDa55uBgoleAGjEoZNKa3J4ul2Uk
	b8rw1JPbRKcdyKvcRH/b78uUU8KJBA/vKPy+/XipORJzrkeNdBCxbJq3iU/W7fqPsa6uNuwyI8m
	DvJJxH7cfsU6LOHGWn1nX5fycKRMsybh3EEcuZ3Yg7zx4y55LhG46NCwqWacKxw6OjYBCvHIsS4
	7dFgMKK0n4NL/TaUO1KAnD313bnNmkuCcJSWSuZvabqaTyr1DxV/SeKDQi8XGQsYSO8g==
X-Received: by 2002:a05:600c:4fc8:b0:49b:5521:785d with SMTP id 5b1f17b1804b1-49cf81e6783mr261119335e9.4.1788811585554;
        Mon, 07 Sep 2026 13:06:25 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:24 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Mon,  7 Sep 2026 22:05:17 +0200
Message-ID: <20260907200518.428277-6-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907200518.428277-1-koray.fra@gmail.com>
References: <20260907200518.428277-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the type:level equivalent of btrfs_compress_type2str() and use it
in prop_compression_extract() .

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 20 ++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 fs/btrfs/props.c       | 19 +++----------------
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b272b2263b5c..240e4c765b3a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -53,6 +53,26 @@ const char* btrfs_compress_type2str(enum btrfs_compression_type type)
 	return NULL;
 }
 
+const char* btrfs_compress_typelevel2str(enum btrfs_compression_type type,
+					 int level, char *buf, size_t len)
+{
+	switch (type) {
+	case BTRFS_COMPRESS_ZLIB:
+	case BTRFS_COMPRESS_LZO:
+	case BTRFS_COMPRESS_ZSTD:
+		if (level) {
+			snprintf(buf, len, "%s:%d",
+				 btrfs_compress_type2str(type), level);
+			return buf;
+		}
+		return btrfs_compress_type2str(type);
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
 static inline struct compressed_bio *to_compressed_bio(struct btrfs_bio *bbio)
 {
 	return container_of(bbio, struct compressed_bio, bbio);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index c63bed9f4152..b9cc1bdd3ccb 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -132,6 +132,8 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
 extern const struct btrfs_compress_levels btrfs_zstd_compress;
 
 const char* btrfs_compress_type2str(enum btrfs_compression_type type);
+const char* btrfs_compress_typelevel2str(enum btrfs_compression_type type,
+					 int level, char *buf, size_t len);
 bool btrfs_compress_is_valid_type(const char *str);
 
 int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 740a05ade942..d8830f63984a 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -416,22 +416,9 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
 static const char *prop_compression_extract(const struct btrfs_inode *inode,
 					    char *buf, size_t len)
 {
-	switch (inode->prop_compress) {
-	case BTRFS_COMPRESS_ZLIB:
-	case BTRFS_COMPRESS_LZO:
-	case BTRFS_COMPRESS_ZSTD:
-		if (inode->prop_compress_level) {
-			snprintf(buf, len, "%s:%d",
-				 btrfs_compress_type2str(inode->prop_compress),
-				 inode->prop_compress_level);
-			return buf;
-		}
-		return btrfs_compress_type2str(inode->prop_compress);
-	default:
-		break;
-	}
-
-	return NULL;
+	return btrfs_compress_typelevel2str(inode->prop_compress,
+					    inode->prop_compress_level,
+					    buf, len);
 }
 
 static struct prop_handler prop_handlers[] = {
-- 
2.55.0

