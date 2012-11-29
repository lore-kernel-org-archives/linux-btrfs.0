Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab2K2Dt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 22:49:58 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAT3CZct020428
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 11:12:36 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs: send - sparse file support for btrfs-send mechanism
Date: Thu, 29 Nov 2012 11:11:59 +0800
Message-Id: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when send/receive a sparse file, the holes of the original file
will be filled with zero. The holes will be sent as ZERO streams,
and it's unnecessary.

So, I improved this by skipping the hole of file while sending.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e78b297..1e1d59a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3718,6 +3718,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	u64 pos = 0;
 	u64 len;
 	u32 l;
+	u64 bytenr;
 	u8 type;
 
 	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -3732,6 +3733,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		 */
 		len = PAGE_CACHE_ALIGN(len);
 	} else {
+		bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
+		if (bytenr == 0) {
+			ret = 0;
+			goto out;
+		}
 		len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
 	}
 
-- 
1.7.7.6

