Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76501379C5D
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301665; cv=none; b=M3G3O8LrFtNtNqKGmD13QNui4X6jxJAeW1RxqtNipZ1OO5KFDc0YNFzDX8y1pCMnUVfXJ1/HYeu1tlnzrKBJ6XJDY2sAqPPdNXDkRgxPqQF5b6uOoXwUvQIYIf1q1y/hTy5+hZjy05Hr2mpWagyFy7Lms/Cwm2hdXCeTs98zi+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301665; c=relaxed/simple;
	bh=7MJhhwlZdVGwBYKWcQ9f3mR4QCop7AXdmb0DLu/S6/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWY+IS/aHlzjE64vkc4sls/wL1UrdLXLIUg79k9s/0MOTQwEp/wKIx9DNUuc04X1oTS0J7+XaWp/lbTgYIf/IBi/QjGnc+2AYU++2P29ujwuRHmns5iXl4MpzNHK0B36Y1v/OAvi9NajjSxcTzktvNKyxCYGcl2Mna0ZEyp91wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fjH3vzzg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjH3vzzg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so14225045e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301662; x=1786906462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOqmzXnJiUTqrfjBEH534Jft4Dnys4pzBqbWk4LcYT8=;
        b=fjH3vzzg9+ck9jbtQPVcCHIgGtV4t7CRgjiEoJvtqwsMFHhvzZUr5JFEl+zkyv5WAy
         EQ773b/mAUiL4dvzXS8J8cmZnBFnxgV/brfT/vj8TOfxBjRcwDSx/2GzWBJoG48Ob9yB
         RwKraPU5mgV+KKM+AV4oGfj2397PFjZ45f1CzTtYpLuXwH7xcdzTkhiaajIhfmE5KFA5
         +ZX+DE4T73Os97D1Lerqz1Oc/w5JF3F2AklpSrjimP8tjpUvnmkOWrhJbI9SnRFPQqtg
         QOOuPYL8r4K+Rz4G7RJFDqsWOin23w8hOWICZlGpptXcYQmTtSu4omnPnkB2tT3TvHQ8
         BwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301662; x=1786906462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bOqmzXnJiUTqrfjBEH534Jft4Dnys4pzBqbWk4LcYT8=;
        b=A79q1rmpzI3OgH4sl7DfMAG0R/IVWtSeohnkO/znA6wA3QKUBtiGIoZS7kj9BFhNcl
         3YG8jFGWh5CNxgoBg1X2BTGHTOLx6Ddus/O2cHz2MG1k2H2Uht89k+bfi2U3bAGGhyFY
         r/K+BYeapiJeoUMbTlPZzH2AWran94hINZGgvprL4WyVTjg/3ApE8+reY5SgmS0/zp4C
         xIxVnqU7cXbc6ua9KGitgHrBHdCRFX1Ipd3qcP+zB3J8C2are/0P4JTkfEcmEUrnD3z3
         /91D5Tv9vKICITiqLDutEjhx85BIDAg+lnbLP2gKMgOKNdI8dFpL1YjpbR7aFP8RdGMQ
         YfTA==
X-Forwarded-Encrypted: i=1; AHgh+RqeCaeRfVZFu2C5QNApKyTDatrW1XXaH6ob1We8XPtX4DDts9hXqkUxZv6Betzz2Jti22/25BZKAJAukA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJoWk+m4AYF/7ZO3qkAavJujGHHY+z68pec/wrsydgjp789+VM
	wkq9Kt3EtDN+sMgVv6FkXMcLsGeteCjCUzvkWnGfFw3NyMksXYVc3uU4
X-Gm-Gg: AR+sD11clP66lkOwSSVGgADsUTUNxmblOgg7bqIfX8AEe6vikNMO33EULxKeCeURzPF
	OPlztcoxBxUmMBrv7eWQdtuhDajqEyjmQfyKQSqX9Bc+cEMj4+lLmNXdqxxA1jEeviEVrutASiB
	ZsCIP0otKcksH1WoKNKD9U6m2jsxND4knXmaWT4C+6jfUedoBvTuf1iUH+mcztjXwNTdZkrPFUw
	SwwLGEk5bo9q3fKcPcsC8Q+fNPzBp1Tkqeq+cPbr5Up3FDGuHoWVbiprI1TVQvzooWrfkyLDyMY
	hvHJBNwSgaZVbpMYnj1BJ2I2YC5tL16KYAaePfXGDSfeHdf/+Qpt0bAhwAFXhGmoXaEBi1WT7Vq
	LyBrrJ3OkQBWCOHUiStevfcrcSvHZQEcc/oM2t1RUeysrxQ/BYtnPixDjCdJ3ZMZ+drOlgDEL/X
	ByBcKJMCugLXkYKhu+UDzkf/rlUQfhuQEK4rIwAcv2yvSMvsjuZ2lYn/Q=
X-Received: by 2002:a05:600c:3b0a:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-4994e71d7b0mr475081035e9.5.1786301661625;
        Sun, 09 Aug 2026 11:54:21 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:21 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 5/5] btrfs: support inheritance for per-inode compression levels
Date: Sun,  9 Aug 2026 20:53:03 +0200
Message-ID: <20260809185303.600071-6-koray.fra@gmail.com>
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
index f79a61a2759f..5ca728375d35 100644
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
@@ -395,12 +404,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
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
@@ -437,6 +453,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 
 		if (!h->inheritable)
 			continue;
@@ -444,7 +461,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

