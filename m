Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59212 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3FQRrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 13:47:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6110D7C0696
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 11:47:06 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 7OOFCTKyxWyhhgXH (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 11:47:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: optimize read_block_for_search
Date: Mon, 17 Jun 2013 13:47:03 -0400
Message-ID: <1371491223-23077-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch does two things, first it only does one call to
btrfs_buffer_uptodate() with the gen specified instead of once with 0 and then
again with gen specified.  The other thing is to call btrfs_read_buffer() on the
buffer we've found instead of dropping it and then calling read_tree_block().
This will keep us from doing yet another radix tree lookup for a buffer we've
already found.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   47 ++++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1c9dc71..c85cde7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2359,35 +2359,28 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 	tmp = btrfs_find_tree_block(root, blocknr, blocksize);
 	if (tmp) {
 		/* first we do an atomic uptodate check */
-		if (btrfs_buffer_uptodate(tmp, 0, 1) > 0) {
-			if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
-				/*
-				 * we found an up to date block without
-				 * sleeping, return
-				 * right away
-				 */
-				*eb_ret = tmp;
-				return 0;
-			}
-			/* the pages were up to date, but we failed
-			 * the generation number check.  Do a full
-			 * read for the generation number that is correct.
-			 * We must do this without dropping locks so
-			 * we can trust our generation number
-			 */
-			free_extent_buffer(tmp);
-			btrfs_set_path_blocking(p);
+		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
+			*eb_ret = tmp;
+			return 0;
+		}
 
-			/* now we're allowed to do a blocking uptodate check */
-			tmp = read_tree_block(root, blocknr, blocksize, gen);
-			if (tmp && btrfs_buffer_uptodate(tmp, gen, 0) > 0) {
-				*eb_ret = tmp;
-				return 0;
-			}
-			free_extent_buffer(tmp);
-			btrfs_release_path(p);
-			return -EIO;
+		/* the pages were up to date, but we failed
+		 * the generation number check.  Do a full
+		 * read for the generation number that is correct.
+		 * We must do this without dropping locks so
+		 * we can trust our generation number
+		 */
+		btrfs_set_path_blocking(p);
+
+		/* now we're allowed to do a blocking uptodate check */
+		ret = btrfs_read_buffer(tmp, gen);
+		if (!ret) {
+			*eb_ret = tmp;
+			return 0;
 		}
+		free_extent_buffer(tmp);
+		btrfs_release_path(p);
+		return -EIO;
 	}
 
 	/*
-- 
1.7.7.6

