Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F2525A85
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811587; cv=none; b=BWJkHUs/4ErqLGzF09BsoGkQTSQ6pQjEI6/wwE4yrMjjlb2yXfzAn/Ujz0jBQfq6lBFr6OW+ZFa8fdw06EfwFzZUCV8I49Hf4lo26LKGvp5KfTUd3dWqrD9UKsUl00JFWaXq/wq6WCzO2vpsq/1PapVEYhfggstfdE2uXQwDVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811587; c=relaxed/simple;
	bh=776VZdn2cLbEV3iEoLWm4I2DsST/QQxHIRC3Ikg4DRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I46UM72u3+5cdCJmUpmBDFWOiVd/sNKU6aLdZrjZMejxjWnCJDRoZZiQmInlXiK3VpCsaXnBkd+tK26CeeRw97HjePO/fGRX7g2jI7Ak/kHmwkJdQc/EdjQeEKQaKSFuUcULN0wAxK8zlTQIoj1pLH2Kj9xHdeY7AnZVMHZ1cbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VDrylG1+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDrylG1+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-495590dde14so55845155e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811584; x=1789416384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3Wc0K9D7FDaJ8ZbDoFwF6rf1ztRd/fK2RwoAuMD9mU=;
        b=VDrylG1+s+eAEZGgXFQJZ1PyDKsHwPhTPfN/XaSdxM4hih6GLmusMYcFua+7CpCXok
         qj1/zlq3DQpV1NbtyaIooKvXPiUSHd6x4NK1g97TBBhWqodCE5TE749hj1LHNNH46GFf
         Bqhr8xtfObx6w0kFPIqJ5WXlX0RLxnuC9MBdEJiWwS4eLLwIa1roRaZkXMzWRlQK93xs
         wjzuWk+qDWrKNEUdg+J5AwLs1TftW6fikCBZBMduVrtVQojEsMkIi916FBTARSDMPUpg
         Dococ7GlZ5clPzxkfW+nCsr2K7BcjkgCFJshyQp7+LYDJtN7Zspn48wVGUqJFsEW4Y6y
         d6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811584; x=1789416384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3Wc0K9D7FDaJ8ZbDoFwF6rf1ztRd/fK2RwoAuMD9mU=;
        b=b9Sqdixs/lbRR6qGIbWc/Cqbw8Rnfg5/bVwuRUtjzNJ2AjtWOsqzZ32YBByjWc1Wq2
         0wrKxAlx4OioMJutpEaisbcnFRS2ckSLH8Pjx5qhjCuaV1AR++QQ9Oe3ELQkGYTv63kf
         7FBm3l6lqe3n4DiJ8s4KA7Ynlzoa5Vqs27sZFrsOxlRUzQmKhrZnZFFSTgd4P9ooIVK4
         wFBb84e08Cyyvvs4X7GJVoYwaSsTcQjE7qY85tAvwepVFYy6ddgm/zVYB8eRm3Rvun31
         lSeJWPB8ciV/Sd/eed5en7VTDGvNLSCoQGP2fCMFEMfWAdA2kmb15ADwg8+DiLYHrsY+
         ISqA==
X-Forwarded-Encrypted: i=1; AKwUvBy0z4YfPKRU8kxVnaZR+sqCBtzuerhfm9hPIx9LK4OaJQjzJVhLSka0Vz4HBn31ns/DTtHPdCDFl5jYMQ==@vger.kernel.org
X-Gm-Message-State: AFuF++n20FXVN2UwRWprggtgHFNgCY6/VivDwiMW2+/7vloq2WfrPjn6
	tFuMhvEjQm8CKkghgN98MEkdLhuzrg/MO9UOO+1VSh+OhVkOdD3ytsvHGlhW7lA3zsw=
X-Gm-Gg: AYBFou0N3zP1uqmO+hx2E/Qd/GnDH9l839hp8fvKUuGlP9ZD6xAe/kuDEKW49LGuWGi
	WZzQRIDYRz8iaiwLmMIksnIgG2ux2HWN6DkpMNgv+yF6jbsCmjh5Za1NTyDNIQK08op9fJb5WwG
	opUxkLi4/HgExi1+g2kX0Z6MMK4vTyeBAooEwEXMYnQSpZlBHqa5aRbhUIgnZan320Rmc3kB2Mc
	0ESZZ/b4BAqQm0t8Tyo6INxC2Huws3pp10hTCjYnpEFFvdm3+G0Z5DmurzAZMd1C48/8UeBWhMD
	dxeR9K2gXVVSQFqF/itntYF2+TlRjd5qlWEfmvWNCGcwx/6nMXuxj+Rtzya/2+AytysxurxJ0Cl
	nZTTFKdd4uPMMkBrgOqICSLZtRIB74lhSmpeJ/jbTe2OLQe82vvsHsy09QqIzjrQaVyiOrsgrHG
	ME5zmBe7N8DzzHFEA9McsxQklUhRe8CbTzmh8MNq5K9yrCeAvwIdUkqbs=
X-Received: by 2002:a05:600c:a00a:b0:49c:ed94:cdd8 with SMTP id 5b1f17b1804b1-49cf81f6736mr511712525e9.6.1788811584229;
        Mon, 07 Sep 2026 13:06:24 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:23 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 4/6] btrfs: support inheritance for per-inode compression levels
Date: Mon,  7 Sep 2026 22:05:16 +0200
Message-ID: <20260907200518.428277-5-koray.fra@gmail.com>
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

