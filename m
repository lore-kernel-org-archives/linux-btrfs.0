Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3975D400995
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811592; cv=none; b=j6ghuPcOzRDiei/dsWQGlTnjrG7712wD1PXsmAtGsd8GGlOORk2ZiIPKpJHe8I38okhggS5Os78fD/Wm5mJzngsHm/8JGCiDgrqUDTbd8MlSWHZhCdGgTEECHA6oF8YAyeusBwZXr2ToNZk1BXeaU5vYQ0nU+F1dAfx7redAM9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811592; c=relaxed/simple;
	bh=WZfPEHAWnWow8HxPK09kP1T41spLK56kd//3fRNFGFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+NrfdXyLZAGqyhDtLakpWn6eO2Z2nmHbQPEBZMONHEzS0L1E+LLsfV4IuOiPsdvInbqpl2aoCjMSdxArKRQGkQHgJ8N7KjXFBT+Xmr4ChjOCP5MhqPzla65Pt1UotJBQW0zc+wV3/NmuhflbeYmuJiGYHc+uSGCH/GytDHLAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP5Zm7yq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP5Zm7yq"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso37042295e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811587; x=1789416387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lfclzGIg0Yvz6HX+NUyrc+WBK5OnBJsKAKxkT9F3Opw=;
        b=DP5Zm7yqOU2UvUJum/TDFxlhTH45JrucFsnoeaVV6HFkFz/7+x9SjKdYVbqzRLMtpv
         vUWz/t0c8bS9ROSdgMyQqeDDhQsLhxwGircB+bkIkyHGlba0AnuXz4UqrxudvQjLJ/R8
         EFfCjqI4JCB4nPn64RkY1kW1bvslXNESggSG9psiFJPW3xLA+YRklUjLIX1AUbnpOWcP
         Srrxd7l4xs2A2e6rbgOWb13Y0OxT6e024+HjDHTgPMHdsIuARGZu+lqLmV4ZX8eYykcw
         2ioNrrK6rRU7Og6WqcSZJUiNaRkbE5dZ5SYbwEihWWraAZ2A4UkiGmdlI8tJqSpDCkC3
         5Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811587; x=1789416387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lfclzGIg0Yvz6HX+NUyrc+WBK5OnBJsKAKxkT9F3Opw=;
        b=X0E4DDy2vFhx46ahz9f/RfGlipPGCAfrfwYG1tKV/vM1JqoQ75p7lxbj84/4O6QGlf
         WdpjRZ5suRURUaJ+hRFDqxNfyRL9g5EkdZZgGumQQBmWiHvpArYiKO6TMSxD42LEKvNk
         nOn3Pp2KjwWDgE5jj6mtIiywmrN/iwYPFsFCU/P7oTqDJIBkXXyLwPCjGHZQfVok9/Ug
         7bwxUwEwJ0OU0qJmKCgUxXuR2Nxhpt9MhNj3ytfDzkKmhFU5e5oJHoehEwT7F0uKJ/Ao
         3kMN9rkdJyx9TuqLWN9ODUV3lgzDqJZGqvacmASk829Fasp6Luw+nIu1i3Q5z+eJJFCC
         3axQ==
X-Forwarded-Encrypted: i=1; AKwUvBziO3WYJpzGBwC6Ms5002xvOBAyy28dBC7ST6faALkmnEVtWU8wbwvNg9Ki/xDdfZzvx2XjYJ37RXviUA==@vger.kernel.org
X-Gm-Message-State: AFuF++mauJbR/arpHFcevpJwuvRx5k74jQIqMSIhMCM3/RIAP8n5EXU/
	OQXgCNmiHbuoXkGDjX88ezh04+7LgBAw4C+v4W4fXW+UEMknfVbiwCw4wEKOQmOBqAk=
X-Gm-Gg: AYBFou1YbveuxRThI9yPIRVG4hJnHD/j3BF5oIbLeNkuuDdTKsOiwWfWoq7bJuGfVwX
	XvCeG5GPi25tIW4CeYnxTlxXbn2FCNqs1pRL3xt4IEbPEz0RuUdzQl2g5COUpyb6XJ1jFs9a0qg
	SAxeC8UW9HNzQfuuQQF/SlX+02XrN7MXYczyv/cfdOgDnC15ickGV9MJ2pCRhzY7fYOZLEmQCQB
	xQJ9r3j6Etd+C/JzLEgrI18jpWYS0/ao94tYTgWj1ue0cyWXubRTCsp+XHywrA9p3rkqn1nmv31
	gHZKqs+5jjf07QOLrmZ/Oxt9yjl9aGw4V1RE4C1MXHISifKEB5QHIRWj2ZlgL4J5cwRe0EPEElX
	AKgacFpHBSSGhg57bmoPEXOnUzp042t8K7ILMWtzLqGzjwMnrqy2fs/Mj7fKgj5P+iZW0IWjtpY
	epz8s/QTzpY75UzJyfHQc1KsvNL726ppyou5EP6v8Cj/baKDpjAC/OyMUd
X-Received: by 2002:a05:600c:3495:b0:49c:dadb:18a7 with SMTP id 5b1f17b1804b1-49cf8244260mr247554055e9.10.1788811587020;
        Mon, 07 Sep 2026 13:06:27 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:26 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Mon,  7 Sep 2026 22:05:18 +0200
Message-ID: <20260907200518.428277-7-koray.fra@gmail.com>
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

