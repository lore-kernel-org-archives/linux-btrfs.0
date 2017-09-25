Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:65103 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932135AbdIYH3S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:29:18 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9C20EAC00E3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 16:29:15 +0900 (JST)
Subject: [PATCH 4/4] btrfs: remove unused setup_root_args()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <anand.jain@oracle.com>
References: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
Message-ID: <27005af2-b895-86f5-92d6-fb2d6aacb1f2@jp.fujitsu.com>
Date: Mon, 25 Sep 2017 16:29:10 +0900
MIME-Version: 1.0
In-Reply-To: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since setup_root_args() is not used anymore, just remove it.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7edd74d..f589c5b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1367,41 +1367,6 @@ static inline int is_subvolume_inode(struct inode *inode)
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
-		return kstrdup("subvolid=0", GFP_NOFS);
-
-	/* The worst case is that we add ",subvolid=0" to the end. */
-	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1, GFP_NOFS);
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
2.9.5

