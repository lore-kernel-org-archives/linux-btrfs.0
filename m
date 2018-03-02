Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50641 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936128AbeCBHnY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 02:43:24 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F39F5AB3F
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 07:43:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove root argument from cow_file_range_inline
Date: Fri,  2 Mar 2018 09:43:15 +0200
Message-Id: <1519976595-19125-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This argument is always set to the root of the inode, which is also
passed. So let's get a reference inside the function and simplify
the arg list.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d71421ce90c1..346736e84e3f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -276,12 +276,12 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
  * does the checks required to make sure the data is small enough
  * to fit as an inline extent.
  */
-static noinline int cow_file_range_inline(struct btrfs_root *root,
-					  struct inode *inode, u64 start,
+static noinline int cow_file_range_inline(struct inode *inode, u64 start,
 					  u64 end, size_t compressed_size,
 					  int compress_type,
 					  struct page **compressed_pages)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_trans_handle *trans;
 	u64 isize = i_size_read(inode);
@@ -457,7 +457,6 @@ static noinline void compress_file_range(struct inode *inode,
 					int *num_added)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
 	u64 isize = i_size_read(inode);
@@ -579,11 +578,11 @@ static noinline void compress_file_range(struct inode *inode,
 			/* we didn't compress the entire range, try
 			 * to make an uncompressed inline extent.
 			 */
-			ret = cow_file_range_inline(root, inode, start, end,
-					    0, BTRFS_COMPRESS_NONE, NULL);
+			ret = cow_file_range_inline(inode, start, end, 0,
+						    BTRFS_COMPRESS_NONE, NULL);
 		} else {
 			/* try making a compressed inline extent */
-			ret = cow_file_range_inline(root, inode, start, end,
+			ret = cow_file_range_inline(inode, start, end,
 						    total_compressed,
 						    compress_type, pages);
 		}
@@ -983,8 +982,8 @@ static noinline int cow_file_range(struct inode *inode,
 
 	if (start == 0) {
 		/* lets try to make an inline extent */
-		ret = cow_file_range_inline(root, inode, start, end, 0,
-					BTRFS_COMPRESS_NONE, NULL);
+		ret = cow_file_range_inline(inode, start, end, 0,
+					    BTRFS_COMPRESS_NONE, NULL);
 		if (ret == 0) {
 			/*
 			 * We use DO_ACCOUNTING here because we need the
-- 
2.7.4

