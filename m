Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:47233 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704AbaEIVPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 17:15:15 -0400
Received: from f18.lab.localdomain (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 75255720036C
	for <linux-btrfs@vger.kernel.org>; Fri,  9 May 2014 14:15:14 -0700 (PDT)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: fix inline compressed read err corruption
Date: Fri,  9 May 2014 17:15:10 -0400
Message-Id: <1399670110-3335-3-git-send-email-zab@redhat.com>
In-Reply-To: <1399670110-3335-1-git-send-email-zab@redhat.com>
References: <1399670110-3335-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

uncompress_inline() is dropping the error from btrfs_decompress() after
testing it and zeroing the page that was supposed to hold decompressed
data.  This can silently turn compressed inline data in to zeros if
decompression fails due to corrupt compressed data or memory allocation
failure.

I verified this by manually forcing the error from btrfs_decompress()
for a silly named copy of od:

	if (!strcmp(current->comm, "failod"))
		ret = -ENOMEM;

  # od -x /mnt/btrfs/dir/80 | head -1
  0000000 3031 3038 310a 2d30 6f70 6e69 0a74 3031
  # echo 3 > /proc/sys/vm/drop_caches
  # cp $(which od) /tmp/failod
  # /tmp/failod -x /mnt/btrfs/dir/80 | head -1
  0000000 0000 0000 0000 0000 0000 0000 0000 0000

The fix is to pass the error to its caller.  Which still has a BUG_ON().
So we fix that too.

There seems to be no reason for the zeroing of the page on the error
from btrfs_decompress() but not from the allocation error a few lines
above.  So the page zeroing is removed.

Signed-off-by: Zach Brown <zab@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c0bb45..f75ba53 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6082,16 +6082,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	max_size = min_t(unsigned long, PAGE_CACHE_SIZE, max_size);
 	ret = btrfs_decompress(compress_type, tmp, page,
 			       extent_offset, inline_size, max_size);
-	if (ret) {
-		char *kaddr = kmap_atomic(page);
-		unsigned long copy_size = min_t(u64,
-				  PAGE_CACHE_SIZE - pg_offset,
-				  max_size - extent_offset);
-		memset(kaddr + pg_offset, 0, copy_size);
-		kunmap_atomic(kaddr);
-	}
 	kfree(tmp);
-	return 0;
+	return ret;
 }
 
 /*
@@ -6292,7 +6284,10 @@ next:
 				ret = uncompress_inline(path, inode, page,
 							pg_offset,
 							extent_offset, item);
-				BUG_ON(ret); /* -ENOMEM */
+				if (ret) {
+					err = ret;
+					goto out;
+				}
 			} else {
 				map = kmap(page);
 				read_extent_buffer(leaf, map + pg_offset, ptr,
-- 
1.8.1.4

