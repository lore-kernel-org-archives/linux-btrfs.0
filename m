Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7729 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752761AbaHHFGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Aug 2014 01:06:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fdmanana@gmail.com>
Subject: [PATCH] btrfs: Use right extent length when inserting overlap extent map.
Date: Fri, 8 Aug 2014 13:06:20 +0800
Message-ID: <1407474380-13115-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When current btrfs finds that a new extent map is going to be insereted
but failed with -EEXIST, it will try again to insert the extent map
but with the length of sectorsize.
This is OK if we don't enable 'no-holes' feature since all extent space
is continuous, we will not go into the not found->insert routine.

But if we enable 'no-holes' feature, it will make things out of control.
e.g. in 4K sectorsize, we pass the following args to btrfs_get_extent():
btrfs_get_extent() args: start:  27874 len 4100
28672		  27874		28672	27874+4100	32768
                    |-----------------------|
|---------hole--------------------|---------data----------|

1) not found and insert
Since no extent map containing the range, btrfs_get_extent() will go
into the not_found and insert routine, which will try to insert the
extent map (27874, 27847 + 4100).

2) first overlap
But it overlaps with (28672, 32768) extent, so -EEXIST will be returned
by add_extent_mapping().

3) retry but still overlap
After catching the -EEXIST, then btrfs_get_extent() will try insert it
again but with 4K length, which still overlaps, so -EEXIST will be
returned.

This makes the following patch fail to punch hole.
d77815461f047e561f77a07754ae923ade597d4e btrfs: Avoid trucating page or punching hole in a already existed hole.

This patch will use the right length, which is the (exsisting->start -
em->start) to insert, making the above patch works in 'no-holes' mode.
Also, some small code style problems in above patch is fixed too.

Reported-by: Filipe David Manana <fdmanana@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c  | 4 ++--
 fs/btrfs/inode.c | 7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1f2b99c..6eb71e6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2240,7 +2240,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
-	lockstart = round_up(offset , BTRFS_I(inode)->root->sectorsize);
+	lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
 	lockend = round_down(offset + len,
 			     BTRFS_I(inode)->root->sectorsize) - 1;
 	same_page = ((offset >> PAGE_CACHE_SHIFT) ==
@@ -2301,7 +2301,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 						tail_start + tail_len, 0, 1);
 				if (ret)
 					goto out_only_mutex;
-				}
+			}
 		}
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..391dcd3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6085,14 +6085,14 @@ out_fail:
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
 				struct extent_map *existing,
 				struct extent_map *em,
-				u64 map_start, u64 map_len)
+				u64 map_start)
 {
 	u64 start_diff;
 
 	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
 	start_diff = map_start - em->start;
 	em->start = map_start;
-	em->len = map_len;
+	em->len = existing->start - em->start;
 	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
 	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 		em->block_start += start_diff;
@@ -6378,8 +6378,7 @@ insert:
 							 em->len);
 			if (existing) {
 				err = merge_extent_mapping(em_tree, existing,
-							   em, start,
-							   root->sectorsize);
+							   em, start);
 				free_extent_map(existing);
 				if (err) {
 					free_extent_map(em);
-- 
2.0.4

