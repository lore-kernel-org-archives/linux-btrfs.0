Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab3L0NKj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Dec 2013 08:10:39 -0500
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH 1/2] Btrfs: fix the race between write back and nocow buffered write
Date: Fri, 27 Dec 2013 21:11:49 +0800
Message-Id: <1388149910-31499-1-git-send-email-miaox@cn.fujitsu.com>
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
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 82d0342..f6960c2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1523,7 +1523,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		release_bytes = 0;
-		btrfs_drop_pages(pages, num_pages);
 
 		if (only_release_metadata && copied > 0) {
 			u64 lockstart = round_down(pos, root->sectorsize);
@@ -1536,6 +1535,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			only_release_metadata = false;
 		}
 
+		btrfs_drop_pages(pages, num_pages);
+
 		cond_resched();
 
 		balance_dirty_pages_ratelimited(inode->i_mapping);
-- 
1.8.1.4

