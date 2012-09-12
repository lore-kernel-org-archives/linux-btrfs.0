Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab2ILF1v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 01:27:51 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8C5Rmm1016428
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:27:48 +0800
Message-ID: <50501D47.7070308@cn.fujitsu.com>
Date: Wed, 12 Sep 2012 13:27:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix unnecessary warning when the fragments make the
 space alloc fail
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we wrote some data by compress mode into a btrfs filesystem which was full
of the fragments, the kernel will report:
	BTRFS warning (device xxx): Aborting unused transaction.

The reason is:
We can not find a long enough free space to store the compressed data because
of the fragmentary free space, and the compressed data can not be splited,
so the kernel outputed the above message.

In fact, btrfs can deal with this problem very well: it fall back to
uncompressed IO, split the uncompressed data into small ones, and then
store them into to the fragmentary free space. So we shouldn't output the
above warning message.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b69779d..2135899 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -663,7 +663,7 @@ retry:
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
 					   0, alloc_hint, &ins, 1);
-			if (ret)
+			if (ret && ret != -ENOSPC)
 				btrfs_abort_transaction(trans, root, ret);
 			btrfs_end_transaction(trans, root);
 		}
-- 
1.7.6.5
