Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36028 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3AGKM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 05:12:28 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r07ACQ2L010517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 10:12:27 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r07ACQhG003532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 10:12:26 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r07ACQF7003479
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 04:12:26 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a bug when llseek for delalloc bytes behind prealloc extents
Date: Mon,  7 Jan 2013 18:10:12 +0800
Message-Id: <1357553412-8771-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstests case 285 complains.

It it because btrfs did not try to find unwritten delalloc
bytes(only dirty pages, not yet writeback) behind prealloc
extents, it ends up finding nothing while we're with SEEK_DATA.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c  |    9 ++++++---
 fs/btrfs/inode.c |   11 ++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1e16b6d..f76b1fd 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2308,9 +2308,12 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 					}
 				}
 
-				*offset = start;
-				free_extent_map(em);
-				break;
+				if (!test_bit(EXTENT_FLAG_PREALLOC,
+					      &em->flags)) {
+					*offset = start;
+					free_extent_map(em);
+					break;
+				}
 			}
 		}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16d9e8e..7ac41aa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5572,10 +5572,13 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
 		return em;
 	if (em) {
 		/*
-		 * if our em maps to a hole, there might
-		 * actually be delalloc bytes behind it
+		 * if our em maps to
+		 * -  a hole or
+		 * -  a pre-alloc extent,
+		 * there might actually be delalloc bytes behind it.
 		 */
-		if (em->block_start != EXTENT_MAP_HOLE)
+		if (em->block_start != EXTENT_MAP_HOLE &&
+		    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			return em;
 		else
 			hole_em = em;
@@ -5657,6 +5660,8 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
 			 */
 			em->block_start = hole_em->block_start;
 			em->block_len = hole_len;
+			if (test_bit(EXTENT_FLAG_PREALLOC, &hole_em->flags))
+				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		} else {
 			em->start = range_start;
 			em->len = found;
-- 
1.7.7.6

