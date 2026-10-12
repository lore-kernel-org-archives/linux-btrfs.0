Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5194D6C55
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832079; cv=none; b=jnSq8i1zEzhEP+ye9cUl1V3Ut+yu8DafYpHPm2hDwXjZW9VzY0gnGyMGT4KWSR6Pxsww7cJAJgVPbACzzsUz9+h580w24emr9NHYZm+EgT8qHErNJHEN5gUv2/Ts1hMkmRj3lh2jkkANcnjUsl+wjQMUmAS9RJrp55b9JTS4RX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832079; c=relaxed/simple;
	bh=JN8TSTQTalMYOfZSamo4tVa+6OdigiCaxNSuzX02Edw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf0496C3xT/wCR5T4dgpS0s3m50cMK38EJK5tmBB5SrF76AkhEVAEkMHK10aj11aIGd7dAXyDzOCA0FqlDQ9NesrQT9UXc01GWTFZ67oalDv6w0bxmq7vPudOXik8q2DBmHN1CyjrgUksRN7GI4WMPqGWQcAH6oUidQk2OKLY1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aa42e6ft; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aa42e6ft"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so17700975e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832076; x=1792436876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=aa42e6ftne7XUW/HW8OrQc85+rFsbkfSesh0EcYVUNps4v3tFwuFua9VRuWtPh3r7I
         8gAeSlb7eOARq9hFWeUIrPXKQ6DXG8lsJLgkVXtCBO0fGb0RU9q1747sijazlaGAprDo
         mmnuCKJ+yyxU8VkJdfo2PNUHkCd876QSv/8xjC/b4IIC42/rlIkAjWPONYgDQ8GVLjAh
         5CfS4vR6y0xQoMye31Zv3ZhZsROvs6kCIVKU+fr3Db+XnUhgkzrHpSY6SYq+Sa4SAidX
         P/Hkwea60Ibtc4B1Vny7VbkeaEhyumVqlmBRJ+SEKG8kQkFC376n5UJcQY2SegctgOVu
         AcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832076; x=1792436876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eiqooAwHWDJaclG+vph1A9JiNIdTus8fziGxiibxRQs=;
        b=XhAyOungZY/gj2ECXaSDnF1r7gkPRJMWaS5uvr0wK0AcUhdj3oD4B9U/v/vr3cWPxt
         yDdV5KYdoF15BjfltJcJjvgDO4lwZJRQ+aw3p867eqOqPzIl2P9ocRcm4sLfGu/T9BR1
         /rbt42wmJCEAdKK/hx4AZ+sjcsPPKg0SXdqtFuZ8TqRYxHzMFbiUzNuiW2UIUTBsvC5c
         lt6SPQHtTGY6mjBgGXX5PGK6y1SGof5mYyV44Was60pDuE+3KbZTCjsV24r0+ojbgjI/
         4obBFMQTXf47YlA+oTmL6kAwC9ftn1CZpssOyPon1UGAmiAmv3DcJ0AjsgWL1zsqdHwa
         apyQ==
X-Forwarded-Encrypted: i=1; AKwUvByAWwRCdiXKDrZivqK7S3doIh+rmwuDaHd5WRM9r0n74cfIoaN90LvuIYIQXXZW2MuVayOZQbNbsYhdpA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKLDyaeIa77BLOjsOA1brGOO27SJoeUUJHORRsiIeNdM7poEukE
	yWMsfTcLXaQyO0aUAJSPIKnU1XE7LVKWCVR+tjPGloeKFpAru3CV7Qwb
X-Gm-Gg: AYBFou2dOGQfo+Ef7KtQTUZz7PhQP3qfra4/TgoMLCevWrO5ZxNHAk9JvfGASNQOSPC
	cZTGuFpc7pn9L026xw4qLYjaZeDye9So7pBejgxwhD1IQj1VBA16bxK8YHSglfe3dMz9Xibh5Ib
	arJFRQgya1nfiNv5jOW2ejGSm2CJUZ39MLardDPoh66Xhsh06ujZ4ifl9Dnp2G8/fkFdM/VV/+k
	D8G29IxtrTIXfnExebJR+VzUFgz8HgLIyq1B4+HjGjmZFKx+u+YWgP/txbYDyXpPRmp/HJWOR4t
	ZpW4sBVfmaJMYNloBIS/Q2/LpV2+drgoVKtJPRNVxj1o80bbaGti+gggKsRnkGHsOQkjZHWa5Uj
	c5OUpWydlEhzNkxjkPoNU4eR50WFP2T2BJ6CYFWVG0JEL5/Qth1Zl2SdhI4Tvm02zDD4EDcsCRC
	Aa7FAih7hEDAyTEjcVerhS8/jUhxuMUaDNPO91X22H54jePg05CWk2mblXM9XFyOo8cg==
X-Received: by 2002:a05:600c:c16f:b0:49f:ed8c:6cad with SMTP id 5b1f17b1804b1-4a18e4ca869mr178681405e9.19.1791832076605;
        Mon, 12 Oct 2026 12:07:56 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:55 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 5/6] btrfs: add btrfs_compress_typelevel2str() helper
Date: Mon, 12 Oct 2026 21:07:30 +0200
Message-ID: <20261012190731.951056-6-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012190731.951056-1-koray.fra@gmail.com>
References: <20261012190731.951056-1-koray.fra@gmail.com>
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

