Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3F0KyT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 06:54:19 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5RAsHo3013964
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 18:54:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs: fix oops when recovering the file data by scrub function
Date: Thu, 27 Jun 2013 18:50:58 +0800
Message-Id: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We get oops while running btrfs replace start test,
------------[ cut here ]------------
kernel BUG at mm/filemap.c:608!
[SNIP]
Call Trace:
  [<ffffffffa04b36c7>] copy_nocow_pages_for_inode+0x217/0x3f0 [btrfs]
  [<ffffffffa04b34b0>] ? scrub_print_warning_inode+0x230/0x230 [btrfs]
  [<ffffffffa04b34b0>] ? scrub_print_warning_inode+0x230/0x230 [btrfs]
  [<ffffffffa04bb8ce>] iterate_extent_inodes+0x1ae/0x300 [btrfs]
  [<ffffffffa04bbab2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
  [<ffffffffa04b34b0>] ? scrub_print_warning_inode+0x230/0x230 [btrfs]
  [<ffffffffa04b3b07>] copy_nocow_pages_worker+0x97/0x150 [btrfs]
  [<ffffffffa048eed4>] worker_loop+0x134/0x540 [btrfs]
  [<ffffffff816274ea>] ? __schedule+0x3ca/0x7f0
  [<ffffffffa048eda0>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
  [<ffffffff8106f2f0>] kthread+0xc0/0xd0
  [<ffffffff8106f230>] ? flush_kthread_worker+0x80/0x80
  [<ffffffff8163181c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106f230>] ? flush_kthread_worker+0x80/0x80
[SNIP]
 RIP  [<ffffffff8111f4c5>] unlock_page+0x35/0x40
  RSP <ffff88010316bb98>
 ---[ end trace 421e79ad0dd72c7d ]---

it is because we forgot to lock the page again after we read data to
the page. Fix it.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 63144e4..c1647f8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3258,7 +3258,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 				ret = ret_sub;
 				goto next_page;
 			}
-			wait_on_page_locked(page);
+			lock_page(page);
 			if (!PageUptodate(page)) {
 				ret = -EIO;
 				goto next_page;
-- 
1.8.1.4

