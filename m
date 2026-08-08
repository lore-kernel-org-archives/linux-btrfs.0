Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8797368291
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 02:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156536; cv=none; b=gMtN7bLUiOBhX173M62W4HuG6D+X/oqONtlfFkcfJ/kOyGy3QYrGRAtMT4YOmP8GLPH9EcGgfyg6zunrDvLdxY/JeibVIkShN9xJwRZuMxCC/W4mGgF3DVmV1xfG64glDpq9LjPJuvTFXtwgzo3tNchgeHwfh1VmzANg/P+//QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156536; c=relaxed/simple;
	bh=NAEW7RNYYPSMwey6efMgs4A26ZeEn1OIHhOuQsQjVhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqjRbALNFxt45kjOJtJANmNXa3VFGWDEk6S4FY+zLQoO40fgUzcIjzNZor+JvbquNV6yqkfg3QmdOgbF/BQv9MqCt326jftPYTLVIbUk+LBDqywMxjG4zsyScw+TY9+u0Tmbt93S4UikpEll8XMmaO5xY09mz/nnrh9CpUVCoEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=olQXRyHy; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="olQXRyHy"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso456235e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 19:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786156521; x=1786761321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T1/Vj4IQ8y8WgNyjByJce3DWqVpPwaF9u96SYJiI0ds=;
        b=olQXRyHyV2Rvet31XOMlrPo6wk1vx6Uco2rflEVYtjPpIxETmXwamXIrrM2zdcFDvd
         /gWhXy9R3zlVRT4GFXdC7Sjs1Gyj6fRz/jm1p5mYXmBXKemyKPqw9JVWr5c1LBhL35pS
         S+g/d1t6yNjZTGLZAWDVSW9RYzg99tkHcYEpp3zqGYc2dpQGW8JL1g1eweFdQkRNRKTn
         gcCCKMSfR5XHL4wSt+SmtaX5irhkaXdSyEHtXoO+JXDNSEKXmI5iJZijlht9ndhiJXqW
         l1hkNo110OdK9yYQEKyR4xCdcV4gyb0nPdq7hNSe0kAt8zRYRNIHbiB2KfcxtgeLOKSH
         /8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156521; x=1786761321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T1/Vj4IQ8y8WgNyjByJce3DWqVpPwaF9u96SYJiI0ds=;
        b=Aq2p5R6avwTzaWAVl8rihUOCxa0+TKLvKqhMhCBLdOq5oOZA4NK+AHT3MJC974PZHZ
         O5rhNzIFu0F+lYCezWuXmLOobGlsVqYefB1sHdOSdH1EHysUOFN191xATm/vziIz4vLj
         JwC8l6BcjbkA2PYS+8o42s6fn24wTia9/xqwlwBcN43ReLZqafxvuFzC7c0cP/WNl+jL
         5mDy4Z51hMUsYqYmricUHdIYIeto68sojA2kSn71KqwbiPDyEwtzMWobnElIzxW6e3+O
         EZFgRUBcIpeiWI95wY/ZFDG5xXRwR2W26iDnhTUR8zNXBL6o5qB9tNJWqNh8NT0UQsVp
         XEUA==
X-Gm-Message-State: AOJu0YzK2XPoJNfqa+iGEPIG0W5QsHOHdsAoqDQWzDiJecIuE9mfrptD
	SbhgtyGllpok33QnfEVWGYc/QpXsCh8MOGqARz7uhF1Oij069awsSPG5
X-Gm-Gg: AR+sD10ATmBWOzYJxKHnJ0RyGaLXZbM894pU1jeI4yiWhR2QpeQS6psn6hS3yJ2Tm4R
	6zl5hyswZM4b9d8Z68/akHRiUL2ZSKVvT2gnjPKG0oHeMLyZNx5XJIaE0jU1lBbSjGOhmxw/AjK
	5soMFDvbmc0+tBSlNoVW0W2tsLjFeYWxV3gpEav0VhavDIL33HoJLN1NbtlaDpNRqE0RJgHQ8lH
	gv8zb7KyQ2CFcJWirI6id4vGqMsQvoh6gGnX4McvuV8pvkAURJIzcI8ciIGALkfODrt4+MJPxAt
	wRCAlblXiJQO9XT69KWVrv45gzvDP/uDPhAvWyj8b4mLjVXs/KFgNk0x+pKvwrxuujNMvg3g+bD
	bUzENKUVeHzigXnL0zNSTabAGRqaUhV38h7DOaxM10nR84+NrRCSYs1JJ0Oql4Jows/IN95lYQM
	X18i0r2lLJQ3n99eR3xlnPx6/WRn5sQNQw42r3blKya+IDVflNRuNRzME=
X-Received: by 2002:a05:600c:8b35:b0:493:c634:952 with SMTP id 5b1f17b1804b1-4994e79e668mr337453325e9.7.1786156520889;
        Fri, 07 Aug 2026 19:35:20 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm10571244f8f.2.2026.08.07.19.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 19:35:19 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 4/4] btrfs: support inheritance for per-inode compression levels
Date: Sat,  8 Aug 2026 04:34:59 +0200
Message-ID: <20260808023459.1494928-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808023459.1494928-1-koray.fra@gmail.com>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change prop_handler's extract() signature to take an output buffer and its
length. This allows for the algo:level string to be generated dynamically,
but now the caller is in charge of managing that buffer memory. Before this
patch prop_compression_extract() would return only the address of
statically compiled string without being able to add the level, now it
concatenates the level to that statically compiled string.

This signature change is fine because the only currently supported prop is
compression, so there is only 1 extract() function.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/props.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f79a61a2759f..9c97792800fb 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -27,7 +27,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -395,12 +395,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
 	return false;
 }
 
-static const char *prop_compression_extract(const struct btrfs_inode *inode)
+static const char *prop_compression_extract(const struct btrfs_inode *inode,
+					    char *buf, size_t len)
 {
 	switch (inode->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
 	case BTRFS_COMPRESS_LZO:
 	case BTRFS_COMPRESS_ZSTD:
+		if (inode->prop_compress_level) {
+			snprintf(buf, len, "%s:%d",
+				 btrfs_compress_type2str(inode->prop_compress),
+				 inode->prop_compress_level);
+			return buf;
+		}
 		return btrfs_compress_type2str(inode->prop_compress);
 	default:
 		break;
@@ -437,6 +444,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[16];
 
 		if (!h->inheritable)
 			continue;
@@ -444,7 +452,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

