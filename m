Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA30368276
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097641; cv=none; b=VWnmEGyX9TXVUBw+bRZXXpuPWeHk7oWVMKFxtK0/Fm1X9cLYYItRqQvT2qe+h/rev/pIZYtU31R2nGNuPsaqUO3x6QA+UpzTHoFkCjXkMKiRh63RtxN7i61kXFtL0gvyC33oRrCcEJ2emum8bb7dXH9BXOUXwr/snpeYCflft5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097641; c=relaxed/simple;
	bh=JN8TSTQTalMYOfZSamo4tVa+6OdigiCaxNSuzX02Edw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAE5uy11NAYBV0hriKwvt+k/BK+vkfb4eFy8HfOg9l3AOIuAAfshEmZefFmBm0V+IgG2uEQxJWsvusH/KY5rUz+RhUwFFb54xKDQP8PYrvTZF06RSPPZtjuj0DdOAWnD0zQcAHEvwLaWHZsqyufvqj/LaD1Yd6UxwZAULA79kJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=huXMWwTa; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huXMWwTa"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso3982245e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097638; x=1789702438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=huXMWwTaGdJG0sCzgIVdlsHwnYKvLW1jpw4+hL/960pcAaQlDYgWJTBsAJooZGLEH2
         vvWR9q4/lamId2NbB20aAugyUmP4zmDNsgDLB5ar0+ZW9PYn4Ureeb0Ia6dQRsmw9bZ/
         WEBUlYlw6MmCX6LmX7Ej+jh2AKpQr8hZDPFx9arNiFW6AkqToIHM6qBetNjx16X0W8St
         AWrBO7clBARq4Yjg4L1eKdSUfkESSVGyeIjk6AJspTK9oKfVrhYQTw+mkZ9u3r2/S38E
         /xDYFsiqhekOa8kgG5Fqzm3XLfNd0Jt93F3spHsQwbvd1U6gumNuTKH58fCYFGLxXhrg
         0RpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097638; x=1789702438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=M8UVrBswxbdnfZvFvPw8k+3hAWv78ZE3l3EfEJTxIDQz8RqXUxq0bbNAls5vlWhIB0
         j2D03U9d44G31uu4Te5T87xALRKrJaKLdAMytNLWt33/vOH7NTddmvI3P2KqOdJZeHhJ
         6jW5nfHwvex1si/4r4xcnjHGYnF6SaOsJnnXYshpG7eMPZr/wECZO4jwA355vfIBdkgK
         7V1GTG1GAoIBKi7pK4M4WtHqNQt1JN+1trFil+Rs+ZOXlMywLFIt/GhBYFEcO1aV6oX3
         8lStEja5biMJxqhWADnU1AMT2hdYnc86ofqqMdLjVbIYlIOY8TB9GTQkyA9E7dBr52cI
         XihQ==
X-Forwarded-Encrypted: i=1; AKwUvByt+ZltOjLKVahFYPwQlERx5oTECD0NNkow3w6Ka0+N9IjBQ+/X101vmfzdx0IREDywXwf6VhUY6GNHXw==@vger.kernel.org
X-Gm-Message-State: AFuF++kW6D9hSAlyf9D5tg5wZyftQr/QLhdbL9JDKMYCZwP2fEKHjfPR
	7thVvbJvgqWH2zS4HWIZk/h9m7eVhDIqmf60yNggAQ12abVoPuYggfiw
X-Gm-Gg: AYBFou1QS5gLPzgEiiUvtAAEz2wvDH7Kzc73DTBmNEplFNTKANg1GDC95vg57kR1ZVR
	NLCNBBF3wR7UrxKF9uGKRNPz43vDkbyR3RN9qWlJuZJRSrha7SRN+qGxZPF07UTuLZ5SYURDF4t
	CZ3Zohky0C9TLj4BkLQRfjv5JAbwBx0hzsU8UwKcLxjqnT+E9sOordv9EOz4bpqjj8EZMtVCx3q
	kgOsgfL7FD2S/88KaiVHZv5jTNiPnpERYN+Em5NQOLkvV17FWVQh53DIC1xJPQBs/shlepPmqXR
	yTK2LQXzMgY8FQP4xoHkjVQz1yyxErusvkJdwPakxJxTuccXn4a5hdY6QblZjPuGAA+Uae2sEeN
	XqsAHyLscMIAbHcUHIpHUUXEIhOgQz3oUc66b3lEYTY+5YBJjlq59Q8CB/2WNLCjUquRF13LRu0
	3suFFPTpzxZUVutKJohmp5yhsQvnBlFnWBoHvrGXdumAfQLEYIZbgIeIb2fO+cUPZr1A==
X-Received: by 2002:a05:600c:6296:b0:49d:191b:88be with SMTP id 5b1f17b1804b1-49e6164a26dmr21247415e9.0.1789097637585;
        Thu, 10 Sep 2026 20:33:57 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:57 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Fri, 11 Sep 2026 05:33:35 +0200
Message-ID: <20260911033336.957102-6-koray.fra@gmail.com>
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

Add the type:level equivalent of btrfs_compress_type2str() and use it
in prop_compression_extract() .

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 20 ++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 fs/btrfs/props.c       | 19 +++----------------
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index de10d96aee8a..84513d28a3ae 100644
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
index 1a6b0103bbfa..fa574fc3bc31 100644
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
2.55.0

