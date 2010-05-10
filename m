From: Zhu Yanhai <yanhai.zhu@linux.intel.com>
Subject: Author: Zhu Yanhai <yanhai.zhu@linux.intel.com>
Date: Mon, 10 May 2010 11:54:42 +0800
Message-ID: <1273463682-4355-1-git-send-email-yanhai.zhu@linux.intel.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

    Make csum_tree_block_size complain about the right thing.
    
    It dereferenced a wrong pointer before.

diff --git a/disk-io.c b/disk-io.c
index addebe1..c1ed8c8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -86,7 +86,7 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
 			printk("checksum verify failed on %llu wanted %X "
 			       "found %X\n", (unsigned long long)buf->start,
-			       *((int *)result), *((int *)buf));
+			       *((int *)result), *((char *)buf->data));
 			free(result);
 			return 1;
 		}
