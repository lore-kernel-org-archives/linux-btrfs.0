Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735272;
	b=dtNXlloYWeaCAyMWeAvmi2mrWsm59OH/IWZKZwA/6mD08fahONuS6sR6DzqiZnqPhgAr
	 BcMFRykv4CZ0XIZeQCUPNY3nh6vK/5K76jV2mnc7kuNzLTwFPJ9oXFuRpRJx6blfy/9pF
	 89lQgcvIToKT/p3QcA546djANbwwJ2UJXo9voR6CWl/mx07H2Reh3XH60pAIdryftwDWV
	 TIMhPG7DIpx84Nryfeh3zJNWoiHMvpndm6ri8GIJvMM7cTz7TbunCsutbrcoXu81zsYrh
	 JJqvypS3I0c3xd8KlJ0FkYeewdDGt2r/49q9StOXeSVjYM2HfYbB0GLeWAVr04Xq10A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735272;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/7r7P3YMoBGWCUUonasZDrZPyrkJPF1x9FqYUOS92s=;
	b=ePCL4SM7dI/M/K/wJVlXEoidkg4mUieqdKH+SuAiucU5PGzVyNMMD6AMO0Wv53xlArhG
	 wtc58Ggq7saDMtIfSqdesFDtlqEyMcRB9wqKUaov5k6NKWOr0vQLsPphCkH8hmSHaz4n+
	 n+E8pL1qe7uDaUNss9WjIY6EMfaPG9H6i0GiOtxvE3mglpD1umIu616pPIuljK302lu1w
	 49CF/u4egynWrXhLWyEQlzh38jUpHm3a/kJYD8xIn7i2vqMIJNreplYhfgoNyCH2qRsh6
	 HvJ1hE9Vh6sNxSLX7m7VoeRBXzCjyFLDZJ/C6V+Eja0eMQQ+e8Uq+8an+LEipfwOV2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TXeJis67;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C7B606D806
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07C7B606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TXeJis67
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so50725625e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735270; x=1794340070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0/7r7P3YMoBGWCUUonasZDrZPyrkJPF1x9FqYUOS92s=;
        b=TXeJis670QchV43WLUb1upV4NRnd4LG435neJ+Sl3shBtbVwY4gtBi5codSAdEZLPS
         sYXk2IXgY0yv9HAkysM5rJyGrrlGl8fSOhzXwbV1NwOyW/4KqlbiBwfbV0vMGqQ8dEGn
         ZET2/zgIn6bF9qoOFqN+GR+I5hrcGfCuQDh6m7aGEA/YFf64YQxzk8W9TgCaeSo1oOaL
         cfZsxRa+3zBG1j8+hQ9h3/60GioJfzu6A5aglO7/xJmHECzC6ofpxYeLCk8TqjLn8iTu
         vUXEgYPv4lIOeiuyL/zLZcZ2iRUOzimdsaUuLz9pHntYKGlqRbwYfNAnYyqVemVK3rLg
         07mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735270; x=1794340070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0/7r7P3YMoBGWCUUonasZDrZPyrkJPF1x9FqYUOS92s=;
        b=HOpsEr4dsIC34gY9Sh8KQMruSTp7Bx2/UIoUdb7TVte5GPemjeeWzcCt8efGdw9Ekt
         0mP5EP49/1IzG1tBfj51cQ6eLTVFSXTw0hhm60Hw5L3gJ7LeYRUzF08GwioJKznKyITS
         494KwawxKXFq3X8HDpBZ20BCByYoPwJCZmqMKMY1w8VVojR2Dwcc+27s+I4TO+0mf8NC
         YZsFHBOxGf40yC/ptDyfreBpCB4cKiHDrYu/g2x3qMncYuyrJqqyzqBt+I73mV28kDkK
         X1IxwqWxhzu19N9Co0QRcT+By5gy8OK03+ZN98DI8lHfiPbOODFhLchp+vHlZ0IVwUF7
         dziw==
X-Forwarded-Encrypted: i=1; AKwUvBz9iDVqhKE/jorQPAngSpDW6SPYCEF6umnwf/ylQGxTtdZaMj9l2cqWA9n4Kbpaq4wHflWpVVtslq701w==@vger.kernel.org
X-Gm-Message-State: APuU4Z8V2CfDt+tvXU9DSW3mHCoKWprTvlbAY9kB0Gi7MLnEDaOYNF+g
	wUra9wNGMWmisa7DH4ddk18HYOrWrR9AL3hFDMtO/886tarqIDrhxtUi
X-Gm-Gg: AYBFou0u66YMLiSyC8dMycTMyHxa4+8wMPT/IMsfdeKRdLch3IYlPSobxcz5mYW76KZ
	AEpRjAC/SmuadSuDstl45JKoZLOaJgXi/v4ov4WI3nO70AwDpTtP3e4ufH4MmSanrZ13loRTiBB
	X7VuwHHbaLQm9CIuTK/spQenfm6eOZGjPB9vMkkdLhuqWa3Y4L+ZUHAdJcNm5Le8ESE8bnh3f7z
	uD6ParsbtUebpJaV9OLo3xOj7lr+gJ3zkI1wXFgbp3MoZvpJaqNB3Ws+lXbH3zGLxYiNDr4DlwL
	UHUIWmzFtreB5FX9FfpFtnVANdNxycpl4Lyp+B1SHODVjhn6K0zW+sD+aHRW53sqnCjHxwpH1+0
	9u7HMiBhrIq+nIcf0uDKveKqvDqJpxkdm7L73MmyJKlCn72xfJUOoINBx9/Hes8xLNY6TT+uvJo
	FQBAsNhC/azh61/RdkYkmDUn0Mny19bE11XHFDEnRg8FMLrSf9NwHSHmIunvlR9uDY7iuj09aQt
	ly+4dj2jB7zakOFa1ssZqvJHAf6hr1KPyx8fIBQak/aTqnZvuuJcjgCpQzwXfbAy3pNP/VZOuAr
	weqzfVO9GeYeDsv0b/gLDfgJ
X-Received: by 2002:a05:600c:1d07:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4ac150b229cmr337791755e9.2.1793735270451;
        Tue, 03 Nov 2026 11:47:50 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:50 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Tue,  3 Nov 2026 20:47:33 +0100
Message-ID: <20261103194734.598182-6-koray.fra@gmail.com>
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

Add the type:level equivalent of btrfs_compress_type2str() and use it
in prop_compression_extract() .

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 20 ++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 fs/btrfs/props.c       | 19 +++----------------
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b1f8323fffe7..068c24576b71 100644
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
index 9427be2f28e0..3edda1f11a74 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -414,22 +414,9 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
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
2.56.0

