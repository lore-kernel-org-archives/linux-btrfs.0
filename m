Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610589;
	b=Wdxh6nIL+MVnaXhU2lanUnNSL6Hgf0bT62usbVRALMmnVpeEKd1UqZrKND7ZY9s0gwvY
	 5ReKsmlCuyKjG0g95j7Zq0SOQEcWvAVHJDv/i6U1Cva1VzyfJNHHgbnIPVNueK6WxWeJv
	 HVxiZSwDf9PBA7J764PJso6heKgUbR2FD5H4vteV+tONtGIZhMCou2WA7mMx/iVaijOmd
	 SZ5HOpd8gJ5aQMYx0SY46jWArAf3bFUZeQiqU5rCqGwjj690DfS/x07xA4eiyKnxeUlV1
	 Kd2h00uwwB/vDhnvoox68y/1HXk7nzSUP/faZvgj5c82E+28g6RNktY5/3igOgI3PFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610589;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G5q76NGFqkARnH1bsQJNcnzLpxBVz0guREiagYsrkp8=;
	b=1swJE3XXmwbGmxljeDZ2jVVmabrcAaSPVs5pTJNjTT8OChb0NzMeDJOdKC9+un9gles6
	 +ruI1mR9CHburP+C+j41eD3JwF8TdptzxvCv9yfWVFyrQy6DAotRlFsG8+LZKTzHmXorZ
	 uH/HapLx1FEhxV9aWSxaz8adButE8rQbxRJIKbUaX3aJ9UFzliWEBLvgoQ7DyWCMeQso0
	 fAlvpBjb/zKPIHNCv64W/CiGo/Nzt0QQxXUY7IND9pCgYb0hCMIpFSlW3T+yd+Nv6uI/+
	 IEZ67P/kz+t7Z7zXga6hyn//DWb/SnJhNKPZAykqK/oeyHXvSP+E4t7D5sBcS3oUzTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aeaIl+VO;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A16606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90A16606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aeaIl+VO
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so73634135e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 04:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795610588; x=1796215388; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G5q76NGFqkARnH1bsQJNcnzLpxBVz0guREiagYsrkp8=;
        b=aeaIl+VOobFFmuKXLF5Ps4eYDIAbeGOjMuF0QYeHek491yqDScm3WT8qvL5yBGztWL
         FtDqQ4hRpY9mb7G1YltHnbaHcp+TqFE4mIQvnoRZQqZzjnx1ZCVnQOVNjjJws/kGg+km
         p0iqUnPKVktI8QcimT9/H7q2ejQKZxc7zDlnkWO+y3U1VlhRpF4nHXpcNsAimUfBtfFn
         r63tqeM35ZUz2cZ885GuGgtVdRQfI3wXDSur3UJ7WkQXMfm66KgtnwBbDzrZOfQE/4bC
         USiXiI81WL6Xoq9320AmnRG2zQTmK2u4Y1ebWZza7GNwLqocITPK7aAQnsaY1OPFQmYn
         rkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610588; x=1796215388;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G5q76NGFqkARnH1bsQJNcnzLpxBVz0guREiagYsrkp8=;
        b=f7URhoykAf4zMZuFqA+kTY/FrCqnW8ywqJUTNDHF/WtfMN+n7SVRAcm6VKSx/1XJci
         iMQEd7MqH2WnZ34swSPw3b3wcnnaTnBnt+jPJgn4mPCGCG6k72MZGQaBOBtL5v4YuJZc
         Byd5DYfp7gdEZNFuaRLQb1amBX2C1rgjrOiinkbiiuay7w5qz1dkxDmOyJj1Y/mHG/kh
         GHVMEz+ZA6rWiyKr026Pv3RZU/do2ZEUU71b0JrQLvGmvNYmm++fYdw8suGnf9Eh6J5d
         1RheDB5dMJESaJXJHo5/kC+rq5lbOHH+GdDmkAy0+gnvMgG4DpuDnpFcVk8II1oxQqK/
         lm+w==
X-Forwarded-Encrypted: i=1; AL+hErFl9ZoXWzo7Oy5icZj8EFJHUxxck1WSEgntIfXRtlQpK4XwDSo8B7wDMy874vaCE5mHpQfEYSpHo4Ljsw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/waqq7hKRq5Z0ctX4KRmjbNAJFFJOZ04gXyiFv1TOCwb69qZfm
	TmpvYI1T6ZrBjroJXKrFFi9X9eMigaiPIHZVK2jAnnCK8uc05Fuwshu8
X-Gm-Gg: AZFdTZfLHdBiy5kFFY5IqhW7RR6S0F1jon3wBVXliPHAsdp5bXh3ShmDZUYGSqgfBpa
	a9h6j7O6NudGA3EMJUsvfI476p1XrO3KZdYDLqw1uGqqDGZf2e2a46upJOup18v0Vzm11dcT+cJ
	lKIglMJBGd9HNMb+KvW61ue8V5FAfsvKYCkQ4POOfzStlMR1H5llb99tR0b93wGkJGDIjPFSTCT
	cVLWZQr4yRyhJvBdHIwuAGt4j3cXmSIwfm+2P68nFTxMkeH3EkmoSTXyJEAtvd/j1Mztfj2Nw58
	q/uscaf8hvqAyd4apBkOCF8X6/a81erUSnhyZOsH1SeIui4mPkQjlqFOLNcOVXn1m0SoxxR7zoH
	nosH35yrdiMQVfmHRdYHYu4dTwq8rz+hLr2ABEBrbcAPCvj4EBA5t/Vi2XXTn1PDXHg5ZOtsxYO
	uyHOzVvwnWElr4SL662T7aX7Nq5TMLeZpB77/Vhy9fWokFwbR96yZo0fQyZCY1FJuhSrog9suwD
	LlFzlDZz4vGK7ky8TfQOy0DyyN5tqU+eTxs/815kXEj5qfkwGZDk1C/7xhGgUIDyQRnDE1qMmvJ
	pMvXh3DSM5KvZnBHqx82ZRVGGHYYyv3YL7xWnvbM/5prfwRMSrsdO3MF1GSrPPK4n4dqUNwZ3qB
	LK03rTdiuHdzZkQogJNU9C+/8RGeE60CDc/br+PfzD77SGcx2D1ZTr2OLjiCKL0la1YzjapvjCw
	rbUZUkyJXaKSEzLVlNrq9foDyuaWjp8GYChpHsKR+HK+DZ1V4gIYUTJw==
X-Received: by 2002:a05:600c:468b:b0:4bb:5fd1:92aa with SMTP id 5b1f17b1804b1-4bb888160c2mr373771605e9.15.1795610587826;
        Wed, 25 Nov 2026 04:43:07 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-7575-e1e3-dbaf-96fb.ipv6.o2.cz. [2a00:1028:8388:a84e:7575:e1e3:dbaf:96fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm536486045e9.2.2026.11.25.04.43.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 04:43:07 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	linux-btrfs@vger.kernel.org,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 5/6] fs: btrfs: Remove the unused dev.c
Date: Wed, 25 Nov 2026 13:42:58 +0100
Message-ID: <20261125124259.95636-6-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Nothing uses btrfs_devread(), btrfs_blk_desc or btrfs_part_info, which
are all that fs/btrfs/dev.c defines. On 32-bit PowerPC, GCC turns the
u64 '%' in btrfs_devread() into a call to __umoddi3(), which U-Boot's
private libgcc does not provide.

Remove the file.

Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Marek Behún <kabel@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Tom Rini <trini@konsulko.com>
---
 fs/btrfs/Makefile |  2 +-
 fs/btrfs/dev.c    | 25 -------------------------
 2 files changed, 1 insertion(+), 26 deletions(-)
 delete mode 100644 fs/btrfs/dev.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 31b426d572a..79d96c6e0ca 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -2,6 +2,6 @@
 #
 # 2017 Marek Behún, CZ.NIC, kabel@kernel.org
 
-obj-y := btrfs.o compression.o ctree.o dev.o dir-item.o \
+obj-y := btrfs.o compression.o ctree.o dir-item.o \
 	extent-io.o inode.o subvolume.o crypto/hash.o disk-io.o \
 	common/rbtree-utils.o extent-cache.o volumes.o root-tree.o
diff --git a/fs/btrfs/dev.c b/fs/btrfs/dev.c
deleted file mode 100644
index e27a032c9f6..00000000000
--- a/fs/btrfs/dev.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * BTRFS filesystem implementation for U-Boot
- *
- * 2017 Marek Behún, CZ.NIC, kabel@kernel.org
- */
-
-#include <blk.h>
-#include <compiler.h>
-#include <fs_internal.h>
-
-struct blk_desc *btrfs_blk_desc;
-struct disk_partition *btrfs_part_info;
-
-int btrfs_devread(u64 address, int byte_len, void *buf)
-{
-	lbaint_t sector;
-	int byte_offset;
-
-	sector = address >> btrfs_blk_desc->log2blksz;
-	byte_offset = address % btrfs_blk_desc->blksz;
-
-	return fs_devread(btrfs_blk_desc, btrfs_part_info, sector, byte_offset,
-			  byte_len, buf);
-}
-- 
2.54.0 (Apple Git-157)

