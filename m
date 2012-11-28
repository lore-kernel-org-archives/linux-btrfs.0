Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2K1K1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:27:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qASARhFg030403
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 18:27:43 +0800
Message-ID: <50B5E737.1010204@cn.fujitsu.com>
Date: Wed, 28 Nov 2012 18:28:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: use existing align macros in btrfs_allocate()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel developers have implemented some often-used align macros, we should
use them instead of the complex code.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7aaae56..641bbaa 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2067,12 +2067,12 @@ static long btrfs_fallocate(struct file *file, int mode,
 	u64 alloc_end;
 	u64 alloc_hint = 0;
 	u64 locked_end;
-	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
+	int blocksize = BTRFS_I(inode)->root->sectorsize;
 	int ret;
 
-	alloc_start = offset & ~mask;
-	alloc_end =  (offset + len + mask) & ~mask;
+	alloc_start = round_down(offset, blocksize);
+	alloc_end = round_up(offset + len, blocksize);
 
 	/* Make sure we aren't being give some crap mode */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -2153,7 +2153,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		}
 		last_byte = min(extent_map_end(em), alloc_end);
 		actual_end = min_t(u64, extent_map_end(em), offset + len);
-		last_byte = (last_byte + mask) & ~mask;
+		last_byte = ALIGN(last_byte, blocksize);
 
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
-- 
1.7.11.7
