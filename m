Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F814457D9
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663305; cv=none; b=nycq9oO4XoEW3itrccDrdGDc1Bo1RThSEeBM/e6zy8qjKJ7tXk9GsHPQkvwKWeoUw70cAc4LfhXbdQNf/F+Cbetgg+ajlVAMwBinmDOSWLa6iA/nlsdGXKn6GTaeQaShLuHsvLbgBz3lwS1aNueDescIJDUpPuxiAqapa0D7uFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663305; c=relaxed/simple;
	bh=4ercdu/wDqZJ45ep/awi8juYwx+auzICWTMihdc+o+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqPukcPqqsp8zvsd+KSYkgHgkMvlj0bgOVABmEQFDbNh8kdl040ZHJ4/C8sxy853/uPS5RYMOb+awhpFcBwvQnwDXptj2xCPxokK7IO8wKylXd+6NOa50CrL0VDIaA3ImvpcrMELD/u0AqAElr6/7nldvwwgGg57YA8L0uQQfDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqHar3YR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqHar3YR"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2055f5a993so532586166b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663302; x=1788268102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iFVojZF/BxoFrvFIPD7sfWNgTxzqQZywTcsrJ6XYjkU=;
        b=OqHar3YR4l5tGzhZDuu/wx+QEbcXH/9cSgVtiy7mjg+Ub7RQqD33E7fXohSb+HkZw7
         brG9/IqOoKeBsaDttYKWseuuKTs1LI4tA0KZCzPbydIsu4EzlblFjLSRWe+Xw4ljeEFQ
         IiV4WTLMz+ebw2Trr4poZJRHFqQ2M9uH/JX0cdCnzFzryw22cYXEkBHFP0EW3p3lgqRV
         JBSKTGwNWkC0hiHVTS79f3tiAc9nZChSyQQvZv4CKNQ+sROSmjERmmTXYOsmwOxzt/h7
         xWsOpk6z318Si+5T5gGDbGwR3PLpK5pROvZtaLCzdBR1GEqdHHQlo4vpFc08gxTNtNys
         Anlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663302; x=1788268102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iFVojZF/BxoFrvFIPD7sfWNgTxzqQZywTcsrJ6XYjkU=;
        b=KC/JoGMb2nqV9DAN9nnSQTGvgJ1W9LeF49e2jqb7+6t3qaBZbXkihrdyrTxLtFhiJB
         dE6FzB270EpWVHL5uHtho46eW8bwXCcMXFKaewpcgO7Uw5FtajuIIFK3fw2aehz8MJn2
         0BmvvLrwEbVe9kO9hPIvRhPmTbteQICLbGPHnYb5Sv8fHCpXXKRtgbp9rJpCPTG46ZnK
         SfK11wUNiWNueL3QBVVB8nuf7Erdv5hGw45IXiSYTU/SEnCK5SnFExZCh4Dn3nu7f3Il
         ufgER9XLDbx4QRold/fUL09O4DOWApuVPmocvO26pZnQNTlseNRl7TwxIVu2jbpePOf8
         V/gA==
X-Forwarded-Encrypted: i=1; AHgh+RpcPiVLbhgYBXhNuAAPjn5ONvqsAHILLf2HOeZ3v0j29jQuBLOLkj757yghGLsgPsJtZXs5CMAdqrYiAA==@vger.kernel.org
X-Gm-Message-State: AFuF++mYFY8DmcYK2n5WB1teOTbgWYuiTRrTS/mI1/wpwkQqouxFCDo5
	y8klFW9i6C3h1MO30EPxYxxr2i0rLXpHFRB05R2HHDnBLm9VaYn/zu3V
X-Gm-Gg: AR+sD11J7vynNvBgAFJ7Di6P+Fn76SqxGixc9EzdN60yuENk2hAys0EYbdDRuwgj29d
	Mc63XUagoL44AF5tOcgVAWGIrOccAxyyw1Sm7BE7vH+twRpOCbNM+vcXRCTP1rH0ZPtfuEu3uRL
	FViwYCnMosrAT0I95unA1lJRjUMWtBKxofdB9xMJx5X0zdnAp5PrQ9RMJsZ7FNd0qwB7vva2wuZ
	qk0TRXQmb0UmWI0SO0n6u6BX/S2qpSWvcu4J2u982btu6p+hnWe7RZhOyB4K7ilGiUJKF0XztRX
	kCazCBoRp1T/RWwm98R7Yw+wusOidnG/Tg/TrXCWG7haGj9j2BsZ0l8P8J9KWQ2f+LmzBGEJfdT
	rE+89CrVJ68MtwtCcdM0juyrZOXMc4WqQhOTu0RZTlpBhFMc8Oqy+EL92fo1e4i/963T/Z0/v4g
	rNHgfDcwhWHQuGx/JxI24YJNl5TQegVyQtmQzr5n1f+lz5KT9N2RmM0a3y1g==
X-Received: by 2002:a17:906:c147:b0:c20:88a6:8210 with SMTP id a640c23a62f3a-c24e5d07914mr799979066b.9.1787663301434;
        Tue, 25 Aug 2026 06:08:21 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:20 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Tue, 25 Aug 2026 15:07:45 +0200
Message-ID: <20260825130745.229008-7-koray.fra@gmail.com>
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

Any call to FS_IOC_SETFLAGS (e.g. via chattr), even when no flag bits
change, and even for flags unrelated to compression, overwrites the
btrfs.compression property with the mount default compression type.

Example:

        # mount ... -o compress=zstd ...
        $ touch zero
        $ setfattr -n btrfs.compression -v zlib zero
        $ getfattr -n btrfs.compression zero | grep =
        btrfs.compression="zlib"
        $ lsattr zero
        --------c------------- zero
        $ chattr +A zero
        $ lsattr zero
        -------Ac------------- zero
        $ getfattr -n btrfs.compression zero | grep =
        btrfs.compression="zstd"

Here, `+A` modifies only the atime flag, but the compression property
was silently replaced. The same happens even if the ioctl writes back
the same flags value that was already set.

The problem is that btrfs_fileattr_set unconditionally regenerates the
compression string from fs_info->compress_type (or falls back to "zlib")
and overwrites any existing property.

Fix this by first checking for an existing per-inode compression
property and using it if present. Only fall back to fs_info->compress_type
or zlib when no property has been set. This ensures that inode-flag
updates no longer clobber user-configured compression settings.

Also move BTRFS_COMPRESS_PROP_MAX_LEN from props.c to props.h so it can
be used by ioctl.c, since it now requires a temporary buffer to write the
property string to.

[ Commit message and code slightly adapted from Zygo's patch for this same
  issue ]

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Suggested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/ioctl.c | 13 ++++++++++++-
 fs/btrfs/props.c |  9 ---------
 fs/btrfs/props.h |  9 +++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72bc9d4f7708..17c8c164cefc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -288,6 +288,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
+	char comp_buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 	u32 inode_flags;
 	bool prop_set = false;
 
@@ -391,7 +392,17 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags |= BTRFS_INODE_COMPRESS;
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
-		comp = btrfs_compress_type2str(fs_info->compress_type);
+		/*
+		 * If compression is already enabled, we must reconstruct the
+		 * full "algo:level" property string and write it back,
+		 * otherwise any chattr + operation would reset the compression
+		 * algorithm to the fs_info one, also removing the level.
+		 */
+		comp = btrfs_compress_typelevel2str(inode->prop_compress,
+						    inode->prop_compress_level,
+						    comp_buf, sizeof(comp_buf));
+		if (!comp || comp[0] == 0)
+			comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 	} else {
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index d8830f63984a..b95a1e7a96d2 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -18,15 +18,6 @@
 #include "super.h"
 #include "dir-item.h"
 
-/*
- * Max length of compression algorithm:level string.
- *
- * For now the longest possible string is "zstd:-15", which is
- * 8 characters + 1 terminating null byte.
- * Rounding it up to the closest power of 2 gives 16.
- */
-#define BTRFS_COMPRESS_PROP_MAX_LEN 16
-
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 15d9a025c923..93b55a85a728 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -9,6 +9,15 @@
 #include <linux/types.h>
 #include <linux/compiler_types.h>
 
+/*
+ * Max length of compression algorithm:level string.
+ *
+ * For now the longest possible string is "zstd:-15", which is
+ * 8 characters + 1 terminating null byte.
+ * Rounding it up to the closest power of 2 gives 16.
+ */
+#define BTRFS_COMPRESS_PROP_MAX_LEN 16
+
 struct btrfs_inode;
 struct btrfs_path;
 struct btrfs_trans_handle;
-- 
2.55.0

