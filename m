Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37389 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdIKVPa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:15:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id f4so7810005wmh.4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:15:30 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH] Btrfs: compress_file_range() remove dead variable num_bytes
Date: Tue, 12 Sep 2017 00:15:17 +0300
Message-Id: <20170911211517.22441-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove dead assigment of num_bytes

Also as num_bytes only used in will_compress block as
copy of total_in just replace that with total_in and drop num_bytes entire

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17ad018da0a2..1ff4fa461555 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -446,7 +446,6 @@ static noinline void compress_file_range(struct inode *inode,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_bytes;
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
 	u64 isize = i_size_read(inode);
@@ -496,8 +495,6 @@ static noinline void compress_file_range(struct inode *inode,
 
 	total_compressed = min_t(unsigned long, total_compressed,
 			BTRFS_MAX_UNCOMPRESSED);
-	num_bytes = ALIGN(end - start + 1, blocksize);
-	num_bytes = max(blocksize,  num_bytes);
 	total_in = 0;
 	ret = 0;
 
@@ -613,7 +610,6 @@ static noinline void compress_file_range(struct inode *inode,
 		 */
 		total_in = ALIGN(total_in, PAGE_SIZE);
 		if (total_compressed + blocksize <= total_in) {
-			num_bytes = total_in;
 			*num_added += 1;
 
 			/*
@@ -621,12 +617,12 @@ static noinline void compress_file_range(struct inode *inode,
 			 * allocation on disk for these compressed pages, and
 			 * will submit them to the elevator.
 			 */
-			add_async_extent(async_cow, start, num_bytes,
+			add_async_extent(async_cow, start, total_in,
 					total_compressed, pages, nr_pages,
 					compress_type);
 
-			if (start + num_bytes < end) {
-				start += num_bytes;
+			if (start + total_in < end) {
+				start += total_in;
 				pages = NULL;
 				cond_resched();
 				goto again;
-- 
2.14.1

