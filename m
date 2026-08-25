Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7EB4483AD
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663302; cv=none; b=SZV99mcxIjDrCwPxfP3iVQPcR6DJ3ivKVN9onb81jzzwJuk/d6QZyEgemlNp3onPCbJAnfixyOaOWfiSCkaYcKEKk3goBJOAnKsg7eR/ZvEgczn09/6ODMjsXeqlXQzr3+HjsxVVJjk4Ja4KKU+eHDRmYYI8Lq8Ud8/UjMgJvhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663302; c=relaxed/simple;
	bh=776VZdn2cLbEV3iEoLWm4I2DsST/QQxHIRC3Ikg4DRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luID88dQ61r1SNBSJk8BCcKispN37FnTET2lP0iZYSTR3mMKxJXYtshSKIgzei+FXPpZwnxnYyKlwZCRUyNK5sairYe+eS8esuE5GHp//g5Dfalj7uVQcUE+Yvn6iIktb5b/A4gSMDIDfToeqXjOCVeRi6viuDHd1ZrIRSDY5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EMuJXnEC; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMuJXnEC"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c207cb16cf5so746861666b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663299; x=1788268099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3Wc0K9D7FDaJ8ZbDoFwF6rf1ztRd/fK2RwoAuMD9mU=;
        b=EMuJXnECGINe+8Qpp3dJPXICAIj0TD7UaSvS+Poo/JdQel3L+itRCztzUtwtSI9hpE
         w2jdiSd++sN8ClymTIMt6xzD9hDw6ojIG3QyFnUzlX/EDDFz9A6Ol5WB1lrS0jy0KkSY
         /BnhtRldwgJExltskToHkJiFobDhymXEXtBUotnYdQlcnzhkvQE1osMUIdyOmlhc5xHb
         bG5sHVbFL047q1rNwVAwUA0iwsH5QvGULROqZo4Au2uTnVdGxeDn/Oua6KC4saoljXRe
         +Ipu8IPmdF5ZpUlX8RwrL2+l6FBVfwS9Xu9XpyOk6llFxTtkIcJ1nRfLQBFYVA5+vVK9
         7Smw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663299; x=1788268099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3Wc0K9D7FDaJ8ZbDoFwF6rf1ztRd/fK2RwoAuMD9mU=;
        b=SeopU547EycSdHpZBeKXh19VeQlSpePaNtWAv9ZH/DfMo9e/8Z2qhxc00EXv/VcxXr
         OF3CRO9eQ1QV/0bdfoJ5hV+sjg8DAC20X89ftMI1pe16o3PfcQO8EbEBisLq/u8gJkAz
         7inw60B7wISMLEJKjLumv4oqOo1wY1E+Ih3FvLF9VYRu8s5ArTelUjWk0730gd5ZxMhG
         WsUKad9DUAHfPNb2h36hAc0R9cz0IKM7lq9vrpAyuU9djlQeh4l7jPq/fshTIHTqJH8+
         Hdtoh6MEXQqSmsYgTYZy8tLPmfFDbl4CZnN6i3paDxBycd66H5y9hhjqGCR19bX2Rk6L
         LluA==
X-Forwarded-Encrypted: i=1; AHgh+RrHJubM/d5iP6Dr2It9C6G6X+yH1bZ4ls1aAxcQ+U0TgOdm8VPMQtmsQphkmYvfqGn3dnFNJ8b9VclS0w==@vger.kernel.org
X-Gm-Message-State: AFuF++me3IiChuAVOr+h5HAIdtof4avOxv41/EsCpvu+ZQYOW9UHCpcz
	yjlyGFSEFyE1HA4gyV7chr84Rm1spx6h2VXdJ6aJ02zdYAldhKb/Dgte
X-Gm-Gg: AR+sD11sp3Vlu9tDn5jSyrfdbxC0045k3e2x1wkGRcPsCLway66cItxr3eyKwzw8rMI
	h4HgiSEbxJamJ4/lcBNC/Vqp7pxFRVuTnduPYjTV9aIP0I+B59hYt6Bp7rat+WHvq8kDFl/kGBo
	3RqaaM3FA5Lm1LZvVCsZSy+LHi/Xh+XBwWMHZV8s/fodnBg/DRH72jBDdxJjpa14ZWu4bf14yRB
	D8PeejciVYEd4Ux0kLIaUq04D+8Xpi6WZYEmPyS2/sYi8RzuTWZY7LzLykPJqISfUVbanh/+yeF
	21OTTxtNryHO1H6ZcMwJjE8LnM0cdihUMliecXZSdEhvasDGdXr9AyIdRddcIk66fM4FTlcxiVa
	dGT9TqMl1PmSfobCwnKlQP91K6BwaTk5cNW4HRtViZSB3FVOlVPUcssRxjCostqZsSkpV8JoM9s
	+bTYRU5qhCZiLjFGduV21RE5MDlqsCvbra1GFOg6IO7S45BzosBBHAbjblMLbUaX3upsya
X-Received: by 2002:a17:906:f58b:b0:c1f:8021:deef with SMTP id a640c23a62f3a-c246a390c73mr3607276366b.10.1787663298455;
        Tue, 25 Aug 2026 06:08:18 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:17 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 4/6] btrfs: support inheritance for per-inode compression levels
Date: Tue, 25 Aug 2026 15:07:43 +0200
Message-ID: <20260825130745.229008-5-koray.fra@gmail.com>
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

Change prop_handler's extract() signature to take an output buffer and
its length. This allows for the algo:level string to be generated
dynamically, but now the caller is in charge of managing that buffer
memory. Before this patch prop_compression_extract() would return only
the address of statically compiled string without being able to add the
level, now it concatenates the level to that statically compiled string.

This signature change is fine because the only currently supported prop
is compression, so there is only 1 extract() function.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/props.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index a495a5d04f9e..740a05ade942 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -18,6 +18,15 @@
 #include "super.h"
 #include "dir-item.h"
 
+/*
+ * Max length of compression algorithm:level string.
+ *
+ * For now the longest possible string is "zstd:-15", which is
+ * 8 characters + 1 terminating null byte.
+ * Rounding it up to the closest power of 2 gives 16.
+ */
+#define BTRFS_COMPRESS_PROP_MAX_LEN 16
+
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 
@@ -27,7 +36,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -404,12 +413,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
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
@@ -446,6 +462,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 
 		if (!h->inheritable)
 			continue;
@@ -453,7 +470,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

