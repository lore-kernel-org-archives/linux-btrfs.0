From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: use checksums_len instead of first_page_offset
Date: Wed, 19 Jan 2011 21:19:24 +0200
Message-ID: <20110119191924.GC1358@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Minimizes the number of (sizeof(u32) * num_checksums) we have to do,
removes now useless first_page_offset variable.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/free-space-cache.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ee0af41..46f7541 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -224,7 +224,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	u64 generation;
 	u32 cur_crc;
 	pgoff_t index = 0;
-	unsigned long first_page_offset;
+	unsigned long checksums_len;
 	int num_checksums;
 	int ret = 0;
 
@@ -298,8 +298,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	/* Setup everything for doing checksumming */
 	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
-	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
-	disk_crcs = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
+	checksums_len = sizeof(u32) * num_checksums;
+	disk_crcs = kzalloc(checksums_len, GFP_NOFS);
 	if (!disk_crcs)
 		goto out;
 
@@ -321,7 +321,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			break;
 
 		if (index == 0) {
-			start_offset = first_page_offset;
+			start_offset = checksums_len + sizeof(u64);
 			offset = start_offset;
 		}
 
@@ -349,8 +349,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		if (index == 0) {
 			u64 *gen;
 
-			memcpy(disk_crcs, addr, sizeof(u32) * num_checksums);
-			gen = addr + (sizeof(u32) * num_checksums);
+			memcpy(disk_crcs, addr, checksums_len);
+			gen = addr + checksums_len;
 			if (*gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
 				       " (%llu) does not match inode (%llu) "
-- 
1.7.2.3

