Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAF04D37C3
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832082; cv=none; b=DLjFteRQuGFYh+ROgDmu0SULNqJ2AVXromJ9KLVTQ6etpjJWSfxHl2nA7AF0PVy/5d6vodzM82D1grdwOiwhJoQ0rfj6a78dJBO0xCWjNbdsc5/cXizt6VjJ4GsCM5QCmvF01KVu6Mtx9goAodQcEMKzE/eF86QZJHVAKL/kNmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832082; c=relaxed/simple;
	bh=oL16S7QrhYNVe/NqMNh5+9sHNJvfu/msZrQJpVMDNhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1ZCk9xV6F+CueIWUReDlBnUVul6vPVbUOaxj8YWs7XG0uYKYHm1rtldFb8grhbTN+x1SGjMSUdQumAOyMKLXzy6gNuZNeFEnj6W7OFPIr20pEWOcna1a0zJPPD/2+5JmaVWi2JXU9AG+uxz2PdUx+WFOuIdLQNgn5YUt8pVw0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=smazP8ZS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smazP8ZS"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1688d7769so18386575e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832079; x=1792436879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=smazP8ZS6DGGrXy4Lxi8uA/ApOTO2Zq1ZbiBCNKDhPANh6oBEK/rOpJWNYnDYsZoLw
         CMSTueX63T6v52rnYAko3DTfZRYcOZJJ8H6oFCmOdD8BshLJP4heGU57eo67BqcFV6Vn
         +4HutgbaWg4kNrHsUryqyZQKHUFzdPDi5iWSdqBGcnUbiyFITvVvGxgE9WqKSfURjlgO
         WnA+JhB4ZsF25RsDtZXN44TCL2uEeXBKqypvav3Gr1+LD2cvHxzKYfkx35P2ZbtehH7E
         nr+eV0OATdEq6KEn46WhdiQ8YEqr0kJ5Zm1nStKtgI6IXGyY4DGC24I3tn0ABllOkUA5
         KQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832079; x=1792436879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=K9j/JNKqW+Z8TfZT+Cl5zEphS0loX/DUkX3fVqD8CNVFiaa329rn0tUyNn+5RwP6HS
         tA2MF1SiM175wBAzFR7H0qU+SoF+6OnsZBCZig9+DwaLaOF/8xtEnRgFGWcY8i+RJyDD
         Jp6IhMesMmiCzf5nXBaxiaVkvmRjBNfqzrbqWI4S9/JIH/ZmogZTD4KRX+4R7a6+WXkV
         IFClrfN05v+0N6Kq/6l+n0xzFf0ZkB/PfM+820dIi+e0M+Kgb/ZSpQSDf0nUag6gXZpH
         MkbIJ9bAbx6GcuMETJaDCvKxmUk5gwJMBAqSCcCk43b7a9EUZxuoMLbcAiNJJcVKRDra
         KxEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxzEN/8gO8d8KwOYnFVpyWDprcpgEegWBCRohDnd+Cmgifi2uao08iRbkOLoL1cZsL4F+EnwBUp7fmZxQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLLqdBjkRC7PaV0B1bQfshMuB6Nzi2/QZkd1TKqVFo+s3wg81Eu
	+ryonsb+lKvmUg5vVI4YvlhVDGztc0RdVehYBDzXZEcZoBzNN4w5oISI
X-Gm-Gg: AYBFou0+ziCrpu+tS3nsZE0+wDpDAqy5jBMDvIjmgBX7go9ks6f5FE5z8u6xPLojAW2
	8yFxvvSXJ9t/8WHnrYU7P5P6OB/OUBQ9H3rm4lXbuYC5s25N/d0yKLpC4k2R6qJ4jwB8zJmOIJ+
	ytmu6gW8jt6lOGF6Ft5/pzjnuPWkJgUCIXtNgexsfBm83TiHNqb/cSOKYD8lV9ZjhrFEj8NbRhM
	ndyDS1PPcEMpVcJIvM6Gi+aS5i+beeND+y9LmMRqUwYfHUJ91e74e/E9sEMmCYb/S2ZNU6aqzTF
	BryMEDgtq1oWtX5Jmy6RLmI8CBnLS96v2n8tdpJnY+0OTVyUG52wOqMjRZAWMVkh4VQvsCfFlyG
	21HL0ZkGJdGtO6rVzlRDGoRl93rYAhlZck0NrxA9Aus2Q5RTJdxTEzxA1eu1RcWrJWNwzB15pEj
	zlFBib1iNMFBsyGYe2ERQ4TNKdCFl+q6OLnJteFq/tFfabm5va30SavzLxJIyQL0wIxIZ6FGIc9
	5FW
X-Received: by 2002:a05:600c:3144:b0:4a1:70b2:8dbb with SMTP id 5b1f17b1804b1-4a18e4b0347mr190831905e9.19.1791832079042;
        Mon, 12 Oct 2026 12:07:59 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:57 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Mon, 12 Oct 2026 21:07:31 +0200
Message-ID: <20261012190731.951056-7-koray.fra@gmail.com>
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

