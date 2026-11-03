Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735273;
	b=DQPO4paifv3tVUYSB7s4cRdsOtRV/4Ry+gkl9BDp6cFtsZnHL66eJzkJyTR08Db9XSlh
	 uyMQiaYDyX/Nb4U4bAXDz2z7Ry3X54xtXWWkycuk/AhZS2eccInd2r8ygYejhrYWRnO2E
	 SyCvv5Sd/ADm4nxfrr70SvTZV6EEsDVkURGvzs0MUnXm2HvOKXh+M0VxTfR3rlrhf6mTM
	 fwzUx/XP2f3ri8b8hvxriZz0urFP4DAiFzJLQqHJ13xSjmtUbnmKc2IkluwLnpBwSyx34
	 nTLxVIlTW5QGtzy7Sm3Os7DksalajKqJBjdnFo907ZQMVhNetWdmynFK//eAsSs9r3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735273;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3JHvyCGv2J3UpD7OgArEWVY10BzVs+9MgsTlTIe4z/Y=;
	b=LXlYKdlyLpOQdEzmEA36mHthZ+O45dmxfVhs2fkJ08yBHnOdy0+hPqP2FPbLBtDnxOpK
	 wnlgp3T2NveXjILTDR+y1X1v1FWIrFgSFmEi0oLdCOGIEgLeVel+GAR8PZlP2n9WpMnMB
	 g8xIsQsga5qcyIYeUxJM1Ab/SixL11IVEGhdXaBZjrENW4hcWCWkwEjACcnPpssGJLobC
	 coMYYcGgT2ZdaQNVlVqZ44/n++RaTUhkmIVd1O9vS+JY+faxfFI9N7wftnvuBW6HpK+4z
	 sNaBJLtk0U9IsqadkQt5AQu2O0b4kKgr56cl18b2PoXUvoIQyX8D6LQh1JlOBAmnJzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBHhtm7A;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B83606A31B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16B83606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBHhtm7A
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so46047415e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735271; x=1794340071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3JHvyCGv2J3UpD7OgArEWVY10BzVs+9MgsTlTIe4z/Y=;
        b=lBHhtm7AJRMdYHdyRLP5GnhQMKZEDUeVkUj690lntFdvVYqmnzVqUM4h/2WBzvZ7b/
         lJtoUzQ+Ht4aDbUDZABPqEVC57x436ogsUp2KRIQZQ5Q35znlDxsICIVphNmzrfDSB7E
         EjcUA7QlnR5s1fox7yKZES2jLqdWo0qo8HyRDmJmC/o9/I+pyI51E2cg34s5hel/yAp4
         4vdaxCOJ+/GX+OtDKbdm7LtIZHivFCpW+nSAxOWQX4ZrrRphhhPXi4733AoiweBCKGJC
         TXndO3ncbAYq6D3e3KDPSF7G0TDqy/L5hX0Yr4IxVcWPHOn7IKLTUprbQrKYmuHZS/OQ
         5IUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735271; x=1794340071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3JHvyCGv2J3UpD7OgArEWVY10BzVs+9MgsTlTIe4z/Y=;
        b=T39OB1LQnSvLc1SE51K0Kli4Q5ZaAjinywt9A3KKEG/pKewGZ8iYDR4W57sLFrJhvE
         +wqkV774FW19N5asA7exQeKcI1oxbiqokbaZCA7ltLQKePjB9/6MK9pPspwchQ3Zbs/7
         mcnVBRunHfbpMqxyKQTj34kqT3B0slQzWvurryTrY2dcE/k7DSbWjqMAHtiuTJm8cQVH
         jDX42jWJR3of4PLghzWU9uszq5SEym8gg9yo9c8a4LOID96iyWzfCmWmyBc/wJJw4vgB
         aVJoC1kyghhuq244R6EuZ0Puq0vwEazQdNt9k6k9A4nLxYyXL3skBTPnrfKe/9CdR7Dn
         hUmA==
X-Forwarded-Encrypted: i=1; AKwUvByk9o7khbqy9Z7RVDFkN+AxOVJuk0umFusRACazt0IF8JMyPsE2xmzI4h/L8IcpuyPQIBAiWnU/biASwA==@vger.kernel.org
X-Gm-Message-State: APuU4Z89RuoKv+gv+/v23YAUK+dOyevxP0cja/pl/o9rkVcTljBo/Uxy
	HV0nwDCmffqd6ALeKKU3FmCfve+tZbjaGjqWBjEjdRZ+qMZvWFajR8159pKFqaKaEO0=
X-Gm-Gg: AYBFou3EujKsidbj+zwc3xr60TqMIrhs7gtEYZUUJnx/vaXBMwaxn9JspHCazjKTnex
	nYqGkaCTJniHjz5Lg0xb/RsFHwd6PpoXDfPUnuUH7qGsv4Xdd+nLolm9R0A72WdCLeIOc/fwzie
	j8vacBUmEYGjKeGELVqdtFvYJvVQQn8cq3nH1dtn50qORRfjrsYyan/OGpFhNEcc8wBpXC21OHJ
	WMuTkuaxGvAQud3uLemDXbS4QzA2IKHZV1XC/UQ48jRHZcteOvhLyFPa3O0mXuC3gImWI1KGR6z
	j9ucOBUOyR1BKY8TMCcpqIsMTXnJrGiV/wwoj9pBzw0Dm7Ia8KNAP7R3daI2BDSg7i6Bf7RzgT9
	TGxiSXgTyOEwl7zzbuOW7byFxKy7fYIGqkXrdKi1IRTiJ2tKXV/u+aYIyEst1js0nPTfeK+MfH8
	PyLuWtrzifRTaXMJ5L5Bymc8lrZIdnR9G7HREZeD+ZWqgnYEdwFufKjGBI3iMXne1BvXKGQtawo
	u0WGr1HQypays+M13RVLHOXKyxWhsEneR3+cuVbq1UtWVFCpKlj5NeFAtSm5W7oqU4TLpHQZUQw
	vtuc7Swq6Bv1dKy/1hatkssDh1yXudLZ+1TPj8itahrPcA==
X-Received: by 2002:a05:600c:8706:b0:4a1:e0d5:293e with SMTP id 5b1f17b1804b1-4ac1765d3ddmr345729265e9.21.1793735271443;
        Tue, 03 Nov 2026 11:47:51 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:51 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 6/6] btrfs: preserve btrfs.compression when setting inode flags
Date: Tue,  3 Nov 2026 20:47:34 +0100
Message-ID: <20261103194734.598182-7-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103194734.598182-1-koray.fra@gmail.com>
References: <20261103194734.598182-1-koray.fra@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
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
index 651a780dd7b1..56aad3f98859 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -288,6 +288,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
+	char comp_buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 	u32 inode_flags;
 	bool prop_set = false;
 
@@ -397,7 +398,6 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 		inode_flags &= ~BTRFS_INODE_COMPRESS;
 		inode_flags |= BTRFS_INODE_NOCOMPRESS;
 	} else if (fsflags & FS_COMPR_FL) {
-		enum btrfs_compression_type comp_type;
 
 		if (IS_SWAPFILE(&inode->vfs_inode))
 			return -ETXTBSY;
@@ -406,22 +406,23 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
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
index 3edda1f11a74..05e594ce613b 100644
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
2.56.0

