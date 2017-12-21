Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755229AbdLUXpl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfuXu083009
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2f0prs01b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjerI006344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBLNjeLc014906
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/10] Btrfs: fix unexpected EEXIST from btrfs_get_extent
Date: Thu, 21 Dec 2017 15:42:53 -0700
Message-Id: <20171221224256.18196-8-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a corner case that is caused by a race of dio write vs dio
read/write.

dio write:
[0, 32k) -> [0, 8k) + [8k, 32k)

dio read/write:

While get_extent() with [0, 4k), [0, 8k) is found as existing em, even
though start == existing->start, em is [0, 32k),
extent_map_end(em) > extent_map_end(existing),
then it goes thru merge_extent_mapping() which tries to add a [8k, 8k)
(with a length 0), and get_extent ends up returning -EEXIST, and dio
read/write will get -EEXIST which is confusing applications.

Here I concluded all the possible situations,
1) start < existing->start

            +-----------+em+-----------+
+--prev---+ |     +-------------+      |
|         | |     |             |      |
+---------+ +     +---+existing++      ++
                +
                |
                +
             start

2) start == existing->start

      +------------em------------+
      |     +-------------+      |
      |     |             |      |
      +     +----existing-+      +
            |
            |
            +
         start

3) start > existing->start && start < (existing->start + existing->len)

      +------------em------------+
      |     +-------------+      |
      |     |             |      |
      +     +----existing-+      +
               |
               |
               +
             start

4) start >= (existing->start + existing->len)

+-----------+em+-----------+
|     +-------------+      | +--next---+
|     |             |      | |         |
+     +---+existing++      + +---------+
                      +
                      |
                      +
                   start

After going thru the above case by case, it turns out that if start is
within existing em (front inclusive), then the existing em should be
returned, otherwise, we try our best to merge candidate em with
sibling ems to form a larger em.

Reported-by: David Vallender <david.vallender@landmark.co.uk>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6653b08..d386cfb 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -483,7 +483,7 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
 				struct extent_map *existing,
 				struct extent_map *em,
-				u64 map_start)
+				u64 map_start, u64 map_len)
 {
 	struct extent_map *prev;
 	struct extent_map *next;
@@ -496,9 +496,13 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
 	if (existing->start > map_start) {
 		next = existing;
 		prev = prev_extent_map(next);
+		if (prev)
+			ASSERT(extent_map_end(prev) <= map_start);
 	} else {
 		prev = existing;
 		next = next_extent_map(prev);
+		if (next)
+			ASSERT(map_start + map_len <= next->start);
 	}
 
 	start = prev ? extent_map_end(prev) : em->start;
@@ -540,35 +544,26 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
 		 * existing will always be non-NULL, since there must be
 		 * extent causing the -EEXIST.
 		 */
-		if (existing->start == em->start &&
-		    extent_map_end(existing) >= extent_map_end(em) &&
-		    em->block_start == existing->block_start) {
-			/*
-			 * The existing extent map already encompasses the
-			 * entire extent map we tried to add.
-			 */
+		if (start >= existing->start &&
+		    start < extent_map_end(existing)) {
 			free_extent_map(em);
 			*em_in = existing;
 			ret = 0;
-		} else if (start >= extent_map_end(existing) ||
-		    start <= existing->start) {
+		} else {
 			/*
 			 * The existing extent map is the one nearest to
 			 * the [start, start + len) range which overlaps
 			 */
 			ret = merge_extent_mapping(em_tree, existing,
-						   em, start);
+						   em, start, len);
 			free_extent_map(existing);
 			if (ret) {
 				free_extent_map(em);
 				*em_in = NULL;
 			}
-		} else {
-			free_extent_map(em);
-			*em_in = existing;
-			ret = 0;
 		}
 	}
+
 	ASSERT(ret == 0 || ret == -EEXIST);
 	return ret;
 }
-- 
2.9.4

