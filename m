Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:61148 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbeEOHwI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:52:08 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5A045AC0136
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:52:02 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 809F446E791
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:52:01 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: property: Set incompat flag of lzo/zstd compression
References: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
Date: Tue, 15 May 2018 16:51:26 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Incompat flag of lzo/zstd compression should be set at:
 1. mount time (-o compress/compress-force)
 2. when defrag is done
 3. when property is set

Currently 3. is missing and this commit adds this.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/props.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 53a8c95828e3..dc6140013ae8 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -380,6 +380,7 @@ static int prop_compression_apply(struct inode *inode,
 				  const char *value,
 				  size_t len)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int type;
 
 	if (len == 0) {
@@ -390,14 +391,17 @@ static int prop_compression_apply(struct inode *inode,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, 3))
+	if (!strncmp("lzo", value, 3)) {
 		type = BTRFS_COMPRESS_LZO;
-	else if (!strncmp("zlib", value, 4))
+		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
+	} else if (!strncmp("zlib", value, 4)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	else if (!strncmp("zstd", value, len))
+	} else if (!strncmp("zstd", value, len)) {
 		type = BTRFS_COMPRESS_ZSTD;
-	else
+		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
+	} else {
 		return -EINVAL;
+	}
 
 	BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
-- 
2.14.3


