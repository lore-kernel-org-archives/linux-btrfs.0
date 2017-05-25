Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1036568AbdEYTSO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 15:18:14 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4PJE7fQ001793
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 12:18:13 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ap4s203js-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 12:18:13 -0700
Received: from facebook.com (2401:db00:2120:20db:face:0:33:0)   by
 mx-out.facebook.com (10.212.236.89) with ESMTP id
 e507b0e6417e11e7a0df0002c95209d8-1f3c8f0 for <linux-btrfs@vger.kernel.org>;
        Thu, 25 May 2017 12:18:12 -0700
From: Vinnie Magro <vmagro@fb.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Vinnie Magro <vmagro@fb.com>
Subject: [PATCH] btrfs: Use kvzalloc instead of kzalloc/vmalloc in alloc_bitmap
Date: Thu, 25 May 2017 12:18:02 -0700
Message-ID: <e507b0e6417e11e7a0df0002c95209d8-1f3c8f0@d8a20777635a6c1f43e7500017a6a474ea839660ad72b5b09d455997e9681205>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace alloc_bitmap with call to kvzalloc. kvzalloc preserves the
same fallback heuristic.

Signed-off-by: Vinnie Magro <vmagro@fb.com>
---
 fs/btrfs/free-space-tree.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index fc0bd84..9e87129 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -151,25 +151,6 @@ static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
 	return DIV_ROUND_UP((u32)div_u64(size, sectorsize), BITS_PER_BYTE);
 }
 
-static u8 *alloc_bitmap(u32 bitmap_size)
-{
-	void *mem;
-
-	/*
-	 * The allocation size varies, observed numbers were < 4K up to 16K.
-	 * Using vmalloc unconditionally would be too heavy, we'll try
-	 * contiguous allocations first.
-	 */
-	if  (bitmap_size <= PAGE_SIZE)
-		return kzalloc(bitmap_size, GFP_NOFS);
-
-	mem = kzalloc(bitmap_size, GFP_NOFS | __GFP_NOWARN);
-	if (mem)
-		return mem;
-
-	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_ZERO, PAGE_KERNEL);
-}
-
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
@@ -189,7 +170,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 
 	bitmap_size = free_space_bitmap_size(block_group->key.offset,
 					     fs_info->sectorsize);
-	bitmap = alloc_bitmap(bitmap_size);
+	bitmap = kvzalloc(bitmap_size, GFP_NOFS);
 	if (!bitmap) {
 		ret = -ENOMEM;
 		goto out;
@@ -330,7 +311,7 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 
 	bitmap_size = free_space_bitmap_size(block_group->key.offset,
 					     fs_info->sectorsize);
-	bitmap = alloc_bitmap(bitmap_size);
+	bitmap = kvzalloc(bitmap_size, GFP_NOFS);
 	if (!bitmap) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.9.3

