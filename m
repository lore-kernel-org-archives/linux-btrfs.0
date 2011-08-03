From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix byte order issue in free space cache
Date: Wed, 03 Aug 2011 16:12:12 +0800
Message-ID: <4E3902DC.4010105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should convert the generation number to little endian before saving
it to disk.

We've just changed to use the normal checksumming infrastructure for
free space cache, so it's the perfect time to fix this bug.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6377713..9277d65 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -325,7 +325,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		addr = kmap(page);
 
 		if (index == 0) {
-			u64 *gen;
+			u64 gen;
 
 			/*
 			 * We put a bogus crc in the front of the first page in
@@ -335,11 +335,11 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			addr += sizeof(u64);
 			offset += sizeof(u64);
 
-			gen = addr;
-			if (*gen != BTRFS_I(inode)->generation) {
+			gen = le64_to_cpu(*(__le64 *)addr);
+			if (gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
 				       " (%llu) does not match inode (%llu)\n",
-				       (unsigned long long)*gen,
+				       (unsigned long long)gen,
 				       (unsigned long long)
 				       BTRFS_I(inode)->generation);
 				kunmap(page);
@@ -636,7 +636,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 		orig = addr = kmap(page);
 		if (index == 0) {
-			u64 *gen;
+			__le64 *gen;
 
 			/*
 			 * We're going to put in a bogus crc for this page to
@@ -647,7 +647,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			offset += sizeof(u64);
 
 			gen = addr;
-			*gen = trans->transid;
+			*gen = cpu_to_le64(trans->transid);
 			addr += sizeof(u64);
 			offset += sizeof(u64);
 		}
-- 
1.7.3.1
