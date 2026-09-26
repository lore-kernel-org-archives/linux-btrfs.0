Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F499381B0A
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443862; cv=none; b=LVS9JlzSxaiHE7LLO9DV8q11Mu3B1lZE5ZsZWYnqfr913+KfH6JF69kPPvhB4rdWdrl/eHPiYhgV7KXJUOmDIZFDp40C7eErX4JET+5v+LE7Orss0Hylz8pVDtzsI2xxCCavPjLymCF4VXrjCsIqmRSjiGFCFPr/VFF+bw1tqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443862; c=relaxed/simple;
	bh=JN8TSTQTalMYOfZSamo4tVa+6OdigiCaxNSuzX02Edw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za1Al1CRMi4908O4yFvarQcsUqLISqFxK7se+bz8MyNHapk0pn+G1qIzj2zOK8GZroT8irbx0Dl+vGXNgjpl0cJQsqQ5u7qASvdmgdsJt0HesZrVz+hTfmcJIzk3xobaTW9NgUV9Ye3PPmmzbd8c+xBxqVV2i22nJPUdHKpzkZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlagSJeh; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlagSJeh"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48439feca17so1356921f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443851; x=1791048651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=IlagSJehPLnvtKvMYXeIyV/iJ6t7HVD/av9gAsxqj0o6HGPuI9TEXBGRO42Xjf6Gbx
         q+4LrZRX/F1E5kcHEpOFxxWf1XizolJ8wigfiXRmeJvWA0mcgR+gvnG1y9tdULiAXWuL
         5VVS4csc6CSQv/DH1R8tAGH9SrmMCUmU8N16kCugI/ilfBB2epSKAjn98/+qDdwq6ZFA
         pb0NrJbUZUFmCBbycnOIZNhkpgxSLfD59uPzo0T+9gaDHTluVYjxi8lUju+/Xu4ybHbI
         Ss+FOCan9ewIBD3pvIlyLbfNuyPcexCl90cXILMtgT9qx/AvxFnINlsCuSE9Ni9j0rO3
         c1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443851; x=1791048651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=z1eq14MiENXOEKn+VliqCwY4i9s7sEcdZbShEZwCEPzhGWlmfodC2cRttfIgNLLvc7
         oqYaNrJPu+B/QWHtz1Vv8pqdyCgNqBjpdWSTxhZUolJe6FZDfd9BIrtftSQlLyoV1Vsp
         ksyXlv8dH0Gsw03pFR+6hXkTrMYaPyNDHlF7xBFxDuaSrODSoOw7ePuGNnVQ+bsHYI2o
         HfmOSluX11ReDZT4L7Lo0QH5OYk6RGbVXe3U4a7UKGAGf+8orPDylEdZ77yZ3J4zLDgg
         X/y0iZ63iBcmv915ALuO/b1u3Tcjy/lCQdKIUhvYRLghUMP9pEyCR+3A0/CTE4JYfq15
         yJWw==
X-Forwarded-Encrypted: i=1; AKwUvBxBoPtlV2znfOhZfsum85snKkSHpcVQeucbpoea/LpNdfu/uRAWoCyUwyCfyykpEpLzXQyVhyhICNm0Hw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIWRusuftbaCsbEnM+xSbCqSXqo8QkGJf4pntLSpvpjCt656g7c
	WlvvUIZ1zIp3R5NDOrpnAL64xzh0IR2neXqv3ZZjvkUZIg4HBxf6YBnP
X-Gm-Gg: AYBFou1u3aEbwYq15be/uIHjNDizHbpnSQSigee0dTYbb+xpTrrM3VezBh3Y5CwCXyI
	5JSeDPbcOob3C1McdPogEZrUlXEYzRgkwIfPluZMMhQhXJVkzjfGbi+Mn83eMqkmwAOAyYnSyVK
	9RRnKKKOZslX7M3eKFgPyvi7MXW/ZP7NO/vj+Cur0W1IC72FLuI0NweFJOA3+BYost8RbPZuivk
	gnpsENNNxlrtekfWVKfwoanWu99ZkxGVwnn9uve/2ViYdrJgtGYStPddvxAJhFfpL5X4Df1MLl/
	PfnnNU8OxM2bcjugy+3atVTzBYbaiXIx8HONHbsKkIS+n5Ce5ndbYAsbhgGNgf3F7+frEa1I/A4
	mT9eICgHz5zGO9RnDTTo9MI3n12pjuRfcRhMHqvQfP3C6t/H5ackFi5t5HT+Rxfw0DgFVUVpNsr
	ctaGs94a07d5NawH0hxlXgdlvcUlZ+1O9ZK2VvkMx8SnZKcuJzHUa5hUlBPolmmSDvfLja5pU+N
	rH+xA==
X-Received: by 2002:a05:6000:2008:b0:487:169f:d341 with SMTP id ffacd0b85a97d-48871714187mr17075186f8f.12.1790443850781;
        Sat, 26 Sep 2026 10:30:50 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:49 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Sat, 26 Sep 2026 19:29:35 +0200
Message-ID: <20260926172936.337085-6-koray.fra@gmail.com>
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

