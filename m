Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57365 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3H0RUS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 13:20:18 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 944D37C06A0
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 11:20:17 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id QK5wgXqRVE2Rrz2N (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 11:20:17 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not complete ordered extents that are truncated
Date: Tue, 27 Aug 2013 13:20:14 -0400
Message-ID: <1377624014-6426-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we will do the normal btrfs_finish_ordered_io if we invalidate a dirty
page that is part of an ordered extent but hasn't yet been submitted for IO.
The side effect of this is that when the rest of the ordered extent is completed
it will still add its extent to the file and it's csums to the tree.  This
usually isn't a problem since this occurs right before a truncate, so these
csums and extents are going to be cleaned up.  However if there is an error
doing the truncate we can leave extents that point to invalid data, and as such
you'll get csum errors trying to read back this extent.  So to handle this just
set a flag on the ordered extent if we are going to invalidate one of its dirty
pages, and then once we go to do the completion stuff we skip updating the file
extents and adding our csums, we just free everything up and exit.  This is
preliminary work we need to have better orphan entry error handling.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c        |   17 +++++++++++++++--
 fs/btrfs/ordered-data.h |    3 +++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1c86f9d..d212b36 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2562,8 +2562,9 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	struct extent_state *cached_state = NULL;
 	struct new_sa_defrag_extent *new = NULL;
 	int compress_type = 0;
-	int ret;
+	int ret = 0;
 	bool nolock;
+	bool truncated = false;
 
 	nolock = btrfs_is_free_space_inode(inode);
 
@@ -2572,6 +2573,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags)) {
+		truncated = true;
+		goto out;
+	}
+
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list)); /* Logic error */
 		btrfs_ordered_update_i_size(inode, 0, ordered_extent);
@@ -2667,7 +2673,7 @@ out:
 	if (trans)
 		btrfs_end_transaction(trans, root);
 
-	if (ret) {
+	if (ret || truncated) {
 		clear_extent_uptodate(io_tree, ordered_extent->file_offset,
 				      ordered_extent->file_offset +
 				      ordered_extent->len - 1, NULL, GFP_NOFS);
@@ -7348,6 +7354,13 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 				 EXTENT_DEFRAG, 1, 0, &cached_state, GFP_NOFS);
+
+		/*
+		 * Set this so that we don't actually do the extent update work
+		 * for this ordered extent.
+		 */
+		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 68844d5..3d7fe72 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -69,6 +69,9 @@ struct btrfs_ordered_sum {
 				       * the isize. */
 #define BTRFS_ORDERED_LOGGED_CSUM 8 /* We've logged the csums on this ordered
 				       ordered extent */
+#define BTRFS_ORDERED_TRUNCATED 9 /* We truncated a page in this ordered
+				     extent, do not allow the completion stuff
+				     to occur */
 
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
-- 
1.7.7.6

