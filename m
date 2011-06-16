From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix byte order issue in free space cache
Date: Thu, 16 Jun 2011 09:50:42 +0800
Message-ID: <4DF96172.4020007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should convert the transaction id to little endian before saving
it to disk.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 9f985a4..740dbf4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <asm/unaligned.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -340,14 +341,15 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		addr = kmap(page);
 
 		if (index == 0) {
-			u64 *gen;
+			u64 gen;
 
 			memcpy(disk_crcs, addr, first_page_offset);
-			gen = addr + (sizeof(u32) * num_checksums);
-			if (*gen != BTRFS_I(inode)->generation) {
+			gen = get_unaligned_le64(
+				addr + sizeof(u32) * num_checksums);
+			if (gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
 				       " (%llu) does not match inode (%llu)\n",
-				       (unsigned long long)*gen,
+				       (unsigned long long)gen,
 				       (unsigned long long)
 				       BTRFS_I(inode)->generation);
 				kunmap(page);
@@ -814,14 +816,13 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	/* Write the checksums and trans id to the first page */
 	{
 		void *addr;
-		u64 *gen;
 
 		page = pages[0];
 
 		addr = kmap(page);
 		memcpy(addr, checksums, sizeof(u32) * num_pages);
-		gen = addr + (sizeof(u32) * num_pages);
-		*gen = trans->transid;
+		put_unaligned_le64(trans->transid,
+			addr + sizeof(u32) * num_pages);
 		kunmap(page);
 	}
 
-- 
1.7.3.1
