Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36065 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3JRPsY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 11:48:24 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0649C7C06B0
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 09:48:24 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id ks9JMyhkyBRXLgSY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 09:48:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix up seek_hole/seek_data handling
Date: Fri, 18 Oct 2013 11:48:21 -0400
Message-ID: <1382111301-3116-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Whoever wrote this was braindead.  Also it doesn't work right if you have
VACANCY's since we assumed you would only have that at the end of the file,
which won't be the case in the near future.  I tested this with generic/285 and
generic/286 as well as the btrfs tests that use fssum since it uses
seek_hole/seek_data to verify things are ok.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file.c | 93 +++++++++++++--------------------------------------------
 1 file changed, 20 insertions(+), 73 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d12107e..728f56f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2405,14 +2405,12 @@ out_reserve_fail:
 static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_map *em;
+	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	u64 lockstart = *offset;
 	u64 lockend = i_size_read(inode);
 	u64 start = *offset;
-	u64 orig_start = *offset;
 	u64 len = i_size_read(inode);
-	u64 last_end = 0;
 	int ret = 0;
 
 	lockend = max_t(u64, root->sectorsize, lockend);
@@ -2429,89 +2427,38 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
 			 &cached_state);
 
-	/*
-	 * Delalloc is such a pain.  If we have a hole and we have pending
-	 * delalloc for a portion of the hole we will get back a hole that
-	 * exists for the entire range since it hasn't been actually written
-	 * yet.  So to take care of this case we need to look for an extent just
-	 * before the position we want in case there is outstanding delalloc
-	 * going on here.
-	 */
-	if (whence == SEEK_HOLE && start != 0) {
-		if (start <= root->sectorsize)
-			em = btrfs_get_extent_fiemap(inode, NULL, 0, 0,
-						     root->sectorsize, 0);
-		else
-			em = btrfs_get_extent_fiemap(inode, NULL, 0,
-						     start - root->sectorsize,
-						     root->sectorsize, 0);
-		if (IS_ERR(em)) {
-			ret = PTR_ERR(em);
-			goto out;
-		}
-		last_end = em->start + em->len;
-		if (em->block_start == EXTENT_MAP_DELALLOC)
-			last_end = min_t(u64, last_end, inode->i_size);
-		free_extent_map(em);
-	}
-
-	while (1) {
+	while (start < inode->i_size) {
 		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
+			em = NULL;
 			break;
 		}
 
-		if (em->block_start == EXTENT_MAP_HOLE) {
-			if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
-				if (last_end <= orig_start) {
-					free_extent_map(em);
-					ret = -ENXIO;
-					break;
-				}
-			}
-
-			if (whence == SEEK_HOLE) {
-				*offset = start;
-				free_extent_map(em);
+		if (whence == SEEK_HOLE &&
+		    (em->block_start == EXTENT_MAP_HOLE ||
+		     test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+			break;
+		} else if (whence == SEEK_DATA) {
+			if (em->block_start < EXTENT_MAP_LAST_BYTE &&
+			    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+				break;
+			if (em->block_start == EXTENT_MAP_DELALLOC)
 				break;
-			}
-		} else {
-			if (whence == SEEK_DATA) {
-				if (em->block_start == EXTENT_MAP_DELALLOC) {
-					if (start >= inode->i_size) {
-						free_extent_map(em);
-						ret = -ENXIO;
-						break;
-					}
-				}
-
-				if (!test_bit(EXTENT_FLAG_PREALLOC,
-					      &em->flags)) {
-					*offset = start;
-					free_extent_map(em);
-					break;
-				}
-			}
 		}
 
 		start = em->start + em->len;
-		last_end = em->start + em->len;
-
-		if (em->block_start == EXTENT_MAP_DELALLOC)
-			last_end = min_t(u64, last_end, inode->i_size);
-
-		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
-			free_extent_map(em);
-			ret = -ENXIO;
-			break;
-		}
 		free_extent_map(em);
+		em = NULL;
 		cond_resched();
 	}
-	if (!ret)
-		*offset = min(*offset, inode->i_size);
-out:
+	free_extent_map(em);
+	if (!ret) {
+		if (whence == SEEK_DATA && start >= inode->i_size)
+			ret = -ENXIO;
+		else
+			*offset = min_t(loff_t, start, inode->i_size);
+	}
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state, GFP_NOFS);
 	return ret;
-- 
1.8.3.1

