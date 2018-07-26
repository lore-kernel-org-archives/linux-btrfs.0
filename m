Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:37695 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbeGZChd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:37:33 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1FE8CAC021B
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 10:23:06 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 4C311328990
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 10:23:05 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: backref.c: Use ERR_CAST() to return error code
References: <cover.1532568195.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <936a6171-4c1e-2bda-af79-9be9ebe6a8fd@jp.fujitsu.com>
Date: Thu, 26 Jul 2018 10:22:58 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1532568195.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use ERR_CAST() instead of void * to make meaning clear.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7ce0b5f9e99e..9f231bbccb1e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2231,7 +2231,7 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 
 	fspath = init_data_container(total_bytes);
 	if (IS_ERR(fspath))
-		return (void *)fspath;
+		return ERR_CAST(fspath);
 
 	ifp = kmalloc(sizeof(*ifp), GFP_KERNEL);
 	if (!ifp) {
-- 
2.14.4


