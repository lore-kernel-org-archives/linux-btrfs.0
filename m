Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:36883 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbeFGCuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 22:50:21 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 36620AC00D5
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 11:50:14 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 5DD5658425C
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 11:50:13 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: check: Initialize all filed of btrfs_inode_item
 in insert_inode_item()
References: <cover.1528339598.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a9e2495c-6085-4efb-5257-f58a5019e2b7@jp.fujitsu.com>
Date: Thu, 7 Jun 2018 11:49:58 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1528339598.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Initialize all filed of btrfs_inode_item to zero in order to prevent
having some garbage, especially for flags field.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 check/mode-common.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index db9e4299..15e2bbd1 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -379,18 +379,14 @@ int insert_inode_item(struct btrfs_trans_handle *trans,
 	time_t now = time(NULL);
 	int ret;
 
+	memset(&ii, 0, sizeof(ii));
 	btrfs_set_stack_inode_size(&ii, size);
 	btrfs_set_stack_inode_nbytes(&ii, nbytes);
 	btrfs_set_stack_inode_nlink(&ii, nlink);
 	btrfs_set_stack_inode_mode(&ii, mode);
 	btrfs_set_stack_inode_generation(&ii, trans->transid);
-	btrfs_set_stack_timespec_nsec(&ii.atime, 0);
 	btrfs_set_stack_timespec_sec(&ii.ctime, now);
-	btrfs_set_stack_timespec_nsec(&ii.ctime, 0);
 	btrfs_set_stack_timespec_sec(&ii.mtime, now);
-	btrfs_set_stack_timespec_nsec(&ii.mtime, 0);
-	btrfs_set_stack_timespec_sec(&ii.otime, 0);
-	btrfs_set_stack_timespec_nsec(&ii.otime, 0);
 
 	ret = btrfs_insert_inode(trans, root, ino, &ii);
 	ASSERT(!ret);
-- 
2.14.4


