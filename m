Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F24457B6
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663303; cv=none; b=gnl2aC9X7Zfy1XMkSoqCg0ovPV3SbsL9N92b5AMmiLYeU5fCra/fAK31nHTJBaU0qyBxh30cu0gWl9pF89EtHv5mqywh18PX2dFexrf6TxSfmwKRUa3Uan3XVGiF4GymhYd245IbnLb0eDvwYtbA6FdOUymgZVyKqKagROgkVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663303; c=relaxed/simple;
	bh=/vPbZEjwkyqH2b9E+aAXbFX40m8ODsF8iHhrJhG5lUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrqKifYN80E/xuCUyXesaJK6LWgYpzw1FJdkc+g7zY6HhmDpnr2A5TzzxtXHOQrBwuuQjqIYXPsVTYXx73tLK9J5thr9OO6KnB8Y2z1UGfcBzQPhirYRVgNKiijwImn5HdN33e5yRBTSdO0+x3JhvyKGLzZYxMpKWWB10REAZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViVGQVZz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViVGQVZz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2055573c8cso729147566b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663300; x=1788268100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REriuRH8S5Ax34nrF7Oncv8T55zDaH+A5M/sbK/OjY0=;
        b=ViVGQVZzZtvM14wo+xCkvlDK7rsTsgWtxoo7a5OmJJ6BCZY7L2+ki9SC0fOOTBl4Tw
         Nbmfzr2Rj6eFXKCpILdG2bOvBBFqh2s4Q+su9rGljPeBvWFoZyncddT10waZeFLtD3rs
         ZNwREoYo55O3/pyykB11fb3Ws5XvFioI0svxcWX/EFs5WfIqmlVHUNZjoNMuG10Tej7v
         vaZnJi/QJX116fTlpQY9KD4zE8VquqNlXV6IDKjLHAuoAvihI1Lmwpx9gtmc+2Xgksjs
         Bzkn0JhoNhK2nSsDGhZ0I3df7KoAkSjRBQlsAhA3Pe1KzDcvxkr1pFWDb0ibsA9qZI5h
         LS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663300; x=1788268100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REriuRH8S5Ax34nrF7Oncv8T55zDaH+A5M/sbK/OjY0=;
        b=DGsiZdLNhjDTBWGC7Ae3ZcPJbnPFAqKvzadu3agcDpSKBHZhDtBiwsUuUauVrnQ+BT
         rV5X3LdFp+S0wIryseQ9PFrUdLNuI0y9487/FlbfGuTwLL3c4pDvyZariMuOfnKSfGSS
         pVOKVcbd41boeJfCF8ApExnrbXKdzUiKRtvewTPpm4jE5B/LYo1W7uSn+/6sEvCcWJvf
         eaPQSqwywt8phJYJ+o2VyTjhMnJrE+SweMHtR0LZRPddYkUwBlDmzVQGd1E1ciQthwkq
         rH0/EvHAsuAZxPxQycISgOiFguf3YausGlcRq/iHPfkJEVxOJwtB9NXTaGIbJKU0lhyt
         PqkQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9zr4cIqygnJdhvNK56fTtVku1y9RLB1FXp/dWXInc/QyA4AV7BZB1kphU3Sdj2J1KG6lNzv4+1iSaNg==@vger.kernel.org
X-Gm-Message-State: AFuF++lwo3sPvFFEy8D3TgEa3NcrK4Z9H/NTUlLk5IwNV+QJflCtIOcf
	5iiUSSlA7bkf254BsV5U/8JAi/s6qed09CeznBTWtnXOj5pMOllvig81
X-Gm-Gg: AR+sD119Itfz4XFKR3i/48BgDT+ozYZ67YHazSEAneXmN1EYzAk54281DySATt05Q2D
	oYKu+TYln7zwOUuR8x8dT+ETLRL21JhVXzqn7K0qu+GcFBSfN9LlK7HVhc3XUFJy9+HiQ6V09+7
	H9d+Th9j6K58hq+zzrKy6AarW6gV/uTEXmJqAItEiICQe32rLsEOPGJrUmvQWa/LFN2pq3RSjIG
	SHesZCeC42jWA/c/Mlsnv4Da0n1HF5y4bVC5oK5QiwLyc6y2ncJaZHNZIAHvGXggGnCd3MQKn6G
	ypB/zTmBnkiEWLFsT6tcuSiQ3qT+W/5Jb8es3/rIdq9XWTdIMt9nv8GjWTbaQ3Cqr0JSekwKPlp
	PGfSwYAqLg0UROmVCf55g2esnZadnijchI4vIw8pHx4SgUsHIw/jUXcrawb+HozrJ6WYCalHKvA
	W7gF5nsb0FUjA5rNJN+z/uc88aKvq8tvqBT87LdAovjHgTr/9MsTu1sKwK
X-Received: by 2002:a17:907:3c91:b0:c21:601:6501 with SMTP id a640c23a62f3a-c249272ab1amr2976419966b.20.1787663299743;
        Tue, 25 Aug 2026 06:08:19 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:19 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Tue, 25 Aug 2026 15:07:44 +0200
Message-ID: <20260825130745.229008-6-koray.fra@gmail.com>
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

