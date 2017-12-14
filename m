Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:60897 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdLNI0E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:26:04 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CB7ECAC009C
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:57 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id F240F32884E
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:56 +0900 (JST)
Subject: [PATCH v4 4/4] btrfs: remove unused setup_root_args()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Message-ID: <2c50988d-49ab-6eae-bcaa-3fe81bce60dd@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:25:54 +0900
MIME-Version: 1.0
In-Reply-To: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since setup_root_args() is not used anymore, just remove it.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0ecba7a1190..7da78cb8a946 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1409,42 +1409,6 @@ static inline int is_subvolume_inode(struct inode *inode)
 	return 0;
 }
 
-/*
- * This will add subvolid=0 to the argument string while removing any subvol=
- * and subvolid= arguments to make sure we get the top-level root for path
- * walking to the subvol we want.
- */
-static char *setup_root_args(char *args)
-{
-	char *buf, *dst, *sep;
-
-	if (!args)
-		return kstrdup("subvolid=0", GFP_KERNEL);
-
-	/* The worst case is that we add ",subvolid=0" to the end. */
-	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1,
-			GFP_KERNEL);
-	if (!buf)
-		return NULL;
-
-	while (1) {
-		sep = strchrnul(args, ',');
-		if (!strstarts(args, "subvol=") &&
-		    !strstarts(args, "subvolid=")) {
-			memcpy(dst, args, sep - args);
-			dst += sep - args;
-			*dst++ = ',';
-		}
-		if (*sep)
-			args = sep + 1;
-		else
-			break;
-	}
-	strcpy(dst, "subvolid=0");
-
-	return buf;
-}
-
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				   int flags, const char *device_name,
 				   char *data, struct vfsmount *mnt)
-- 
2.13.6

