Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3BDNPJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 08:15:09 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r14DF8ur012545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 13:15:09 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r14DF83F011687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 13:15:08 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r14DF7jk006383
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 07:15:07 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: extend the checksum item as much as possible
Date: Mon,  4 Feb 2013 21:12:18 +0800
Message-Id: <1359983538-3412-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For write, we also reserve some space for COW blocks during updating
the checksum tree, and we calculate the number of blocks by checking
if the number of bytes outstanding that are going to need csums needs
one more block for csum.

When we add these checksum into the checksum tree, we use ordered sums
list.
Every ordered sum contains csums for each sector, and we'll first try
to look up an existing csum item,
a) if we don't yet have a proper csum item, then we need to insert one,
b) or if we find one but the csum item is not big enough, then we need
to extend it.

The point is we'll unlock the whole path and then insert or extend.
So others can hack in and update the tree.

Each insert or extend needs update the tree with COW on, and we may need
to insert/extend for many times.

That means what we've reserved for updating checksum tree is NOT enough
indeed.

The case is even more serious with having several write threads at the
same time, it can end up eating our reserved space quickly and starting
eating globle reserve pool instead.

I don't yet come up with a way to calculate the worse case for updating
csum, but extending the checksum item as much as possible can be helpful
in my test.

The idea behind is that it can reduce the times we insert/extend so that
it saves us precious reserved space.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file-item.c |   67 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 94aa53b..ec16020 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -684,6 +684,24 @@ out:
 	return ret;
 }
 
+static u64 btrfs_sector_sum_left(struct btrfs_ordered_sum *sums,
+				 struct btrfs_sector_sum *sector_sum,
+				 u64 total_bytes, u64 sectorsize)
+{
+	u64 tmp = sectorsize;
+	u64 next_sector = sector_sum->bytenr;
+	struct btrfs_sector_sum *next = sector_sum + 1;
+
+	while ((tmp + total_bytes) < sums->len) {
+		if (next_sector + sectorsize != next->bytenr)
+			break;
+		tmp += sectorsize;
+		next_sector = next->bytenr;
+		next++;
+	}
+	return tmp;
+}
+
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums)
@@ -789,20 +807,32 @@ again:
 		goto insert;
 	}
 
-	if (csum_offset >= btrfs_item_size_nr(leaf, path->slots[0]) /
+	if (csum_offset == btrfs_item_size_nr(leaf, path->slots[0]) /
 	    csum_size) {
-		u32 diff = (csum_offset + 1) * csum_size;
+		int extend_nr;
+		u64 tmp;
+		u32 diff;
+		u32 free_space;
 
-		/*
-		 * is the item big enough already?  we dropped our lock
-		 * before and need to recheck
-		 */
-		if (diff < btrfs_item_size_nr(leaf, path->slots[0]))
-			goto csum;
+		if (btrfs_leaf_free_space(root, leaf) <
+				 sizeof(struct btrfs_item) + csum_size * 2)
+			goto insert;
+
+		free_space = btrfs_leaf_free_space(root, leaf) -
+					 sizeof(struct btrfs_item) - csum_size;
+		tmp = btrfs_sector_sum_left(sums, sector_sum, total_bytes,
+					    root->sectorsize);
+		tmp >>= root->fs_info->sb->s_blocksize_bits;
+		WARN_ON(tmp < 1);
+
+		extend_nr = max_t(int, 1, (int)tmp);
+		diff = (csum_offset + extend_nr) * csum_size;
+		diff = min(diff, MAX_CSUM_ITEMS(root, csum_size) * csum_size);
 
 		diff = diff - btrfs_item_size_nr(leaf, path->slots[0]);
-		if (diff != csum_size)
-			goto insert;
+		diff = min(free_space, diff);
+		diff /= csum_size;
+		diff *= csum_size;
 
 		btrfs_extend_item(trans, root, path, diff);
 		goto csum;
@@ -812,19 +842,14 @@ insert:
 	btrfs_release_path(path);
 	csum_offset = 0;
 	if (found_next) {
-		u64 tmp = total_bytes + root->sectorsize;
-		u64 next_sector = sector_sum->bytenr;
-		struct btrfs_sector_sum *next = sector_sum + 1;
+		u64 tmp;
 
-		while (tmp < sums->len) {
-			if (next_sector + root->sectorsize != next->bytenr)
-				break;
-			tmp += root->sectorsize;
-			next_sector = next->bytenr;
-			next++;
-		}
-		tmp = min(tmp, next_offset - file_key.offset);
+		tmp = btrfs_sector_sum_left(sums, sector_sum, total_bytes,
+					    root->sectorsize);
 		tmp >>= root->fs_info->sb->s_blocksize_bits;
+		tmp = min(tmp, (next_offset - file_key.offset) >>
+					 root->fs_info->sb->s_blocksize_bits);
+
 		tmp = max((u64)1, tmp);
 		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_size));
 		ins_size = csum_size * tmp;
-- 
1.7.7.6

