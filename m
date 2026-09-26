Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAD52459CF
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443862; cv=none; b=TlvDe5GLaBw6Qyo/NMPDpqIwc2pLrvypcHtQNj/GHPGd46VosYRQNkBF91KYVLxWHyYmy5+bDWqOBL/qxHwC2AGG9f+5ScA+2XMg84KedfBNX9Kxpki2fQweyc5LcgGjjnsAiE6/0Vzi0vSaDy4eTZII7ivppZNvleLS8cFUjOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443862; c=relaxed/simple;
	bh=oL16S7QrhYNVe/NqMNh5+9sHNJvfu/msZrQJpVMDNhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjumZWcIopk5DhYHCD2bevufRmr58s8QOSzMG0f9nKqr5IrwC+xzxsxWwGzMh4NIPBkPzGbV+EZ8OvZ4dUBBrXYMwWIPvycrz2gGklx6+0PUmfMCj4o19ySAsluFYHe8dx0saqno2iL7ktfLOjZeSE7a9OzmT06aGAkBayDsIHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qgqErVYi; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qgqErVYi"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48877902c99so1635197f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443852; x=1791048652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=qgqErVYi72aUnaAgW2ccJYK2oHpcP2aOAh8dF+FKfbKWIJRNpwSldArIvXpdBqvHQz
         nFtPt70hp9w58voqCIL2ynvSvEiNcNj7YkkseSg4XSYrYV1iao7+FpAIsH0GK6BQkeGV
         aLmKUbkfBOUDw6aixngqUyQKi8LLmk0vv6ZCEAO8aRY3XCXbZTnvIj1ILdK7IHrXZMdy
         zrqv3s4sUy61Nhx9eBaTxK0CUX8VYhaDoZfjugTlEX+oh96q7WusRzgpiyhlgGUkzk82
         28mPP+bhtyd5rt6vld0IcqW43kpgnNN/1oo48DUZ5wwn+Qj7m+gfTvxXWSaxxsDAwFsa
         eJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443852; x=1791048652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mo5E8eDwQ51y/ielWwKpOoxh3vRss9PXP1F/LPFPdbw=;
        b=MT1js5tKiZaYmkZg+IKOKgrsZOrcak2HiJ5Vgb0o5c8frEzwTDyzIvwILIJoewFKFC
         43sDsT3bSxF+oLV7brWiemXm/0fxzCLD3wpE8/tc+hhYTR3GXpNuY+kEmfcMNFz5JbNz
         OMxP18GkKFAYplAvt8Gwotm6WGIhlzLNMdyaOAO7nPgn9+8qjf02zo2w/PnFv1vwZWbP
         1Vu0E4WwNDnm42QcBxp/QGNDHvXOQlnjd63SxcqgwFkI+11VGqMUc7F0A0RrCbjorIXy
         cQgtXhxw/pIyfKT/LmZ1WDWDZADvLZyeHXltr0Erl8jRYgz5xd4g7OwTgdSSq3l9V+SM
         b/3g==
X-Forwarded-Encrypted: i=1; AKwUvBzsfp/jNhfgKjWnFcx3st7K1VzXGgQd4ASaj2/WKKJM88iC5PJP/j/U6HfgL+OGiM/1E4iUilMV+XCGNw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ01n2DIuL9DdskU6lcEUya8pG7fMtchsART3PeLKtRU8ViLHtQ
	t8ltlwepUd/2i41PTf3ivS0XwYZLwx7MCgH/A6u9oGcJbxpOSdmJZWUY
X-Gm-Gg: AYBFou11IaSawtQpihbbRlsPe4Iql26yLP+XfMsFTnvhYQqzFOFvbOzWXu28AAxv7zs
	8bKTrFgU3BWIz06PEp4FiJNI1zhHn7jCSWyMyRxcQpt07WFWDuLS4NFfw/noyGI6k6bXxl2K+By
	Hw+pnH894bfBcsqfdqro3CMsj+75jEDExUVfb26IEBvCLpU/YWmU3Ja7OK77x7xuHDoug+/Ix5n
	KcZ4VUAHyr6G4rDWaue8tXa2Em0JYNEonW3SUdJqYCsULSIo+mOnqeXWiQ8Ow9bdqzK+XlDhA9C
	v7EmHhRVXzKmwzaObu+KpVNcHEeqiElJfQuBmX/bDe5y85HORm1pEY29EazY6zUcErfaPbhQGe5
	GFRoOaLyv7F/VT3kBeK9euRwI5/rIVbSch0tpW0L7ZBCdWicxwJQihKPKtoeFpeF5yHLYO35vaw
	itNXOGL4++GYrJAXkENCZYt5KxUMZ1NsniwHqtiNVjvoyvO6QIYqIQBvai/N7TFxHduS8haQ+d4
	BJV
X-Received: by 2002:a05:6000:40d7:b0:488:78ea:184e with SMTP id ffacd0b85a97d-48878ea18e0mr8538106f8f.11.1790443852427;
        Sat, 26 Sep 2026 10:30:52 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:51 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Sat, 26 Sep 2026 19:29:36 +0200
Message-ID: <20260926172936.337085-7-koray.fra@gmail.com>
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

