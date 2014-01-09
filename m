Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaAICEw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 21:04:52 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0924o9O027323
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 10:04:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 1/2] Btrfs: fix the race between write back and nocow buffered write
Date: Thu, 9 Jan 2014 10:06:10 +0800
Message-Id: <1389233170-27573-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <52CD6A46.2030802@fb.com>
References: <52CD6A46.2030802@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we ran the 274th case of xfstests with nodatacow mount option,
We met the following warning message:
WARNING: CPU: 1 PID: 14185 at fs/btrfs/extent-tree.c:3734 btrfs_free_reserved_data_space+0xa6/0xd0

It is caused by the race between the write back and nocow buffered
write:
  Task1				Task2
  __btrfs_buffered_write()
    skip data reservation
    reserve the metadata space
    copy the data
    dirty the pages
    unlock the pages
				write back the pages
				release the data space
   				  becasue there is no
				  noreserve flag
   set the noreserve flag

This patch fixes this problem by unlocking the pages after
the noreserve flag is set.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- rebase the patch to the btrfs-next tree
---
 fs/btrfs/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 453e43c..0218288 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1555,9 +1555,10 @@ again:
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
 					     GFP_NOFS);
-		btrfs_drop_pages(pages, num_pages);
-		if (ret)
+		if (ret) {
+			btrfs_drop_pages(pages, num_pages);
 			break;
+		}
 
 		release_bytes = 0;
 		if (only_release_metadata && copied > 0) {
@@ -1571,6 +1572,8 @@ again:
 			only_release_metadata = false;
 		}
 
+		btrfs_drop_pages(pages, num_pages);
+
 		cond_resched();
 
 		balance_dirty_pages_ratelimited(inode->i_mapping);
-- 
1.8.1.4

