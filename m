Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2013A1E81
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097642; cv=none; b=n9ufhkJcUBAJfj4qp7tTNP+BbSm6MZa+zFZk4HKFV8/9SoB9FTo6v7R0qeGEoydb+YHTnvkBtm2tFq35ExCO87bF/zUsq4B9AsVpeqHq5qDjm2We1IXJEj8Nve4kMkRHMXSINm7nDqVa1Rjumbv1JfbSrqRiSHAdyYlltgKcRj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097642; c=relaxed/simple;
	bh=oL16S7QrhYNVe/NqMNh5+9sHNJvfu/msZrQJpVMDNhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPP2Gx8WWs4wcuPQazOmFHiWSdD7B7lDh8aTy5fF7rCsx5hdpe9XFAPr00uBeFOHsHbnNAJdRw7iWmUgCg0U1wsbuMtejAp/ZAV2k3Ci/IFIFqKUrRYtt0UHgoUrg5ttD0WKyIw+M9OmegyfyjZoyNU30Te/ti0yDnW1ETlmTrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sPQxpcLg; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sPQxpcLg"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso6103245e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097639; x=1789702439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=sPQxpcLgT7uQsd8ICulc+VJlbJn7ZuDP42sXqEArzkKvvxuRN/7a69F4+sPwQtonOk
         uqwX0EwKbj9u7tdcHdm2M+UPTrTeXSV6ca+2EByrNPQXypt48i8GFBRj+msKcv9jhBHo
         PLuFhSiBT2tyIc5SbXAmv2RzJ9t91nESLS5bK9UrU8sGRdRSY/CJMqborFByyOhlbGGi
         VlqjXoJwKD3euyjNtkHE/mRMfyw/18mNcj+DKW58aTQXBqBtWVARp8b3KxaIO0hvSZRi
         3/wJCFbKb0TU0vP/Rw71y2zSOMuM8vJox0RWZxVb1VKwUxMZ6oBJVSpn119+qfZxvguR
         qDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097639; x=1789702439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=gPlM5RP/4CknkIpCiv/Kx/mrfXaFuNRXQeltUKR20GmhhQhE2QLF/DcQxZw075sFFd
         L4m6B9yi5H/sHzM4mqSmRzcxSaIzSZiaMp5zW6tW/jK4yYYWSFUDrVwl6MQGP/IMnWAX
         Dl+/U2UmSrrjlH/Xkh3HQNd34uvhbYwrHduCZggz4SX67lRIk02u+uPGCRzL4GcHU1sO
         HQr8bFzxgmFXKVoVHPuLO2pw2vSeAKdgbEG7z/55ucFuQEp7yjAn1VsRz2qoZoeIZwbF
         AeHOOgyEKmagh9gfC1gaakcQLraWzYxPKngoAkov3oBR2cfpL228ws0zmgAHpU36l50H
         1b3Q==
X-Forwarded-Encrypted: i=1; AKwUvBz28FNur0PJhc+6CfPDi7tZmRBm0pD6L8CYOf+bndhHy9Tfov+36YiYNzvkrYyHkpp4CntIXRGaGzlgZw==@vger.kernel.org
X-Gm-Message-State: AFuF++mzZCHM+gdR7/x1zV4n+EV2+v0ogDjeIvQ6ljU9MIGK6bPgSWs6
	AUGoQyAJPBbbqKiJ5KztcGe+AVmsllEm0lYCHcoTTk5KS9JCjt9xeTXA
X-Gm-Gg: AYBFou1/riGizNkGSn99/3n7235mz9VzYPzK4ahLaOb+7ZDmRkgwxlzwLoU/ipnfnfD
	UEeog7qRdIFDGkvtcr5xGiPf9Ak5Yp83ABy8kdawuYhWNk4zEqWLw/DTArZ9mNZpSpBfOSNgc8J
	x9Yx197l8enHz9IZAhfVEjydDxzNWL8YGTy4IEjNHaOylDrde3XCCQcrF2X81wdWmKQ1yDwr62E
	6+EVV9q3os1qxq80NnIEe9Rw/d7E5M4DMach4zF5bfij+UeJzeHBwER26ziIsjPeeuQbGVLH5P9
	x3VQlKdABPfjTcCa+Z1jwXP+1i+wOuBvLUHf1b4KjhbWjBFnwsrGtueh057mBcoK6BOlpCgqGoQ
	fjm/u830Zf6iWWJWytTIB3ck1yNsk7eEbHxrLBxwD/+QL9qBYkyAZimTTkbBXK4NhpJ9VJnphL9
	zL4wX1RZoID5WaNvOBhf/KQX0v+HXWd8tSLS7BG59l8JqH5fpu5gZcMTv+mIJmK1xcyHlpJ7JiD
	0biSw==
X-Received: by 2002:a05:600c:6095:b0:499:db27:7b1 with SMTP id 5b1f17b1804b1-49e61993590mr22209995e9.15.1789097638783;
        Thu, 10 Sep 2026 20:33:58 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:58 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Fri, 11 Sep 2026 05:33:36 +0200
Message-ID: <20260911033336.957102-7-koray.fra@gmail.com>
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

Commit e8a0095c7df170 ("btrfs: preserve the compression property when
other inode flags change") fixed an issue where any call to
FS_IOC_SETFLAGS (e.g. via chattr) would overwrite the btrfs.compression
property with the mount default compression type, even when no flag bits
change and even for flags unrelated to compression.

Update the fixed code to also preserve the newly introduced level
specification by using the new btrfs_compress_typelevel2str() helper.

Also move BTRFS_COMPRESS_PROP_MAX_LEN from props.c to props.h so it can
be used by ioctl.c, since it now requires a temporary buffer to write the
property string to.

[ Commit message and code adapted from Zygo's patch for this same issue ]

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Suggested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/ioctl.c | 27 ++++++++++++++-------------
 fs/btrfs/props.c |  9 ---------
 fs/btrfs/props.h |  9 +++++++++
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 54960351fbd1..af685205b7e9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -288,6 +288,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
+	char comp_buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 	u32 inode_flags;
 	bool prop_set = false;
 
@@ -384,7 +385,6 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags &= ~BTRFS_INODE_COMPRESS;
 		inode_flags |= BTRFS_INODE_NOCOMPRESS;
 	} else if (fsflags & FS_COMPR_FL) {
-		enum btrfs_compression_type comp_type;
 
 		if (IS_SWAPFILE(&inode->vfs_inode))
 			return -ETXTBSY;
@@ -393,22 +393,23 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
 		/*
-		 * Keep the algorithm recorded in the compression property,
-		 * otherwise changing an unrelated attribute would reset it to
-		 * the mount default, since FS_IOC_SETFLAGS callers write back
-		 * the whole flag set they got from FS_IOC_GETFLAGS and that
-		 * includes FS_COMPR_FL for any inode carrying the property.
+		 * If compression is already enabled, we must reconstruct the
+		 * full "algo:level" property string and write it back.
+		 * Otherwise changing an unrelated attribute would reset it to
+		 * the mount default and drop the level, since FS_IOC_SETFLAGS
+		 * callers write back the whole flag set they got from
+		 * FS_IOC_GETFLAGS, and that includes FS_COMPR_FL.
 		 *
 		 * Inodes with the compress flag set but no property keep using
 		 * the mount default, so they behave as before.
 		 */
-		if (inode->prop_compress)
-			comp_type = inode->prop_compress;
-		else if (fs_info->compress_type)
-			comp_type = fs_info->compress_type;
-		else
-			comp_type = BTRFS_COMPRESS_ZLIB;
-		comp = btrfs_compress_type2str(comp_type);
+		comp = btrfs_compress_typelevel2str(inode->prop_compress,
+						    inode->prop_compress_level,
+						    comp_buf, sizeof(comp_buf));
+		if (!comp || comp[0] == 0)
+			comp = btrfs_compress_type2str(fs_info->compress_type);
+		if (!comp || comp[0] == 0)
+			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 	} else {
 		inode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index fa574fc3bc31..eaa569e88036 100644
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

