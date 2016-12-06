Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40636 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbcLFEkN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 23:40:13 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: cow_file_range() num_bytes and disk_num_bytes are same
Date: Tue,  6 Dec 2016 12:43:08 +0800
Message-Id: <20161206044309.3450-3-anand.jain@oracle.com>
In-Reply-To: <20161206044309.3450-1-anand.jain@oracle.com>
References: <20161206044309.3450-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch deletes local variable disk_num_bytes as its value
is same as num_bytes in the function cow_file_range().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 96e5f8a49d4c..79f073e94f2d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -944,7 +944,6 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 alloc_hint = 0;
 	u64 num_bytes;
 	unsigned long ram_size;
-	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
@@ -960,7 +959,6 @@ static noinline int cow_file_range(struct inode *inode,
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
-	disk_num_bytes = num_bytes;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < SZ_64K &&
@@ -989,16 +987,16 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 	}
 
-	BUG_ON(disk_num_bytes >
+	BUG_ON(num_bytes >
 	       btrfs_super_total_bytes(root->fs_info->super_copy));
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
-	while (disk_num_bytes > 0) {
+	while (num_bytes > 0) {
 		unsigned long op;
 
-		cur_alloc_size = disk_num_bytes;
+		cur_alloc_size = num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
@@ -1055,7 +1053,7 @@ static noinline int cow_file_range(struct inode *inode,
 
 		btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
 
-		if (disk_num_bytes < cur_alloc_size)
+		if (num_bytes < cur_alloc_size)
 			break;
 
 		/* we're not doing compressed IO, don't unlock the first
@@ -1073,7 +1071,6 @@ static noinline int cow_file_range(struct inode *inode,
 					     delalloc_end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     op);
-		disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
 		start += cur_alloc_size;
-- 
2.10.0

