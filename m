Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2K2GGd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 01:06:33 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAT66VDJ031766
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:06:31 +0800
Message-ID: <50B6FB48.9060300@cn.fujitsu.com>
Date: Thu, 29 Nov 2012 14:06:00 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: send - pre-allocated file support for btrfs-send mechanism
References: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
In-Reply-To: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From 4222aa3a32cf4db161fcbbb87ad29b714f1bfaf2 Mon Sep 17 00:00:00 2001
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Date: Thu, 29 Nov 2012 13:22:09 +0800
Subject: [PATCH] Btrfs: send - pre-allocated file  support for btrfs-send
 mechanism

when send or receive a file which has pre-allocated part,
the pre-allocated parts of the file will be sent as ZERO streams,
and it's unnecessary.

So we can improve this by skip these EMPTY parts.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
this patch is based on
"Btrfs: send - sparse file support for btrfs-send mechanism"
---
 fs/btrfs/send.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1e1d59a..2d23184 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3732,13 +3732,18 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		 * sure to send the whole thing
 		 */
 		len = PAGE_CACHE_ALIGN(len);
-	} else {
+	} else if (type == BTRFS_FILE_EXTENT_REG) {
 		bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
 		if (bytenr == 0) {
 			ret = 0;
 			goto out;
 		}
 		len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
+	} else if (type == BTRFS_FILE_EXTENT_PREALLOC) {
+		ret = 0;
+		goto out;
+	} else {
+		BUG();
 	}
 
 	if (offset + len > sctx->cur_inode_size)
-- 
1.7.7.6

