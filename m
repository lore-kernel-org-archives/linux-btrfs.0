Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:47228 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbaEHXYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 19:24:39 -0400
Received: from f18.lab.localdomain (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id CED89720036C
	for <linux-btrfs@vger.kernel.org>; Thu,  8 May 2014 16:16:24 -0700 (PDT)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: fix inline compressed read err corruption
Date: Thu,  8 May 2014 19:16:19 -0400
Message-Id: <1399590979-15331-3-git-send-email-zab@redhat.com>
In-Reply-To: <1399590979-15331-1-git-send-email-zab@redhat.com>
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

uncompress_inline() is silently dropping an error from
btrfs_decompress() after testing it and zeroing the page that was
supposed to hold decompressed data.  This can silently turn compressed
inline data in to zeros if decompression fails due to corrupt compressed
data or memory allocation failure.

I have no idea why uncompress_inline() is zeroing the page for an error
from btrfs_decompress() but not for the earlier ENOMEM from kmalloc().
Can someone explain this?

The fix is to pass the error to its caller.  Which still has a BUG_ON().
So we fix that too.

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

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c0bb45..fc89fa7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6091,7 +6091,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 		kunmap_atomic(kaddr);
 	}
 	kfree(tmp);
-	return 0;
+	return ret;
 }
 
 /*
@@ -6292,7 +6292,10 @@ next:
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

