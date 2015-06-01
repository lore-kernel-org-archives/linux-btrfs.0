Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59279 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbFAPYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:24:52 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:24:51 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 578DB3578052
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:48 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FOeXs56950908
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:48 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FOFDO027815
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:15 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 15/21] Btrfs: subpagesize-blocksize: Revert commit fc4adbff823f76577ece26dcb88bf6f8392dbd43.
Date: Mon,  1 Jun 2015 20:52:50 +0530
Message-Id: <1433172176-8742-16-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize, we have multiple blocks in a page. Checking for
existence of a page in the page cache isn't a sufficient check, since we
could be truncating a subset of the blocks mapped by the page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/btrfs_inode.h | 2 --
 fs/btrfs/file.c        | 4 +++-
 fs/btrfs/inode.c       | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0ef5cc1..2bf8043 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -323,6 +323,4 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
 		  &BTRFS_I(inode)->runtime_flags);
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end);
-
 #endif
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9600410a..cc9feed 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2419,7 +2419,9 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if ((!ordered ||
 		    (ordered->file_offset + ordered->len <= lockstart ||
 		     ordered->file_offset > lockend)) &&
-		     !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
+		     !test_range_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_UPTODATE, 0,
+				     cached_state)) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bfffc62..03faff0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7281,7 +7281,8 @@ out:
 	return ret;
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
+static bool btrfs_page_exists_in_range(struct inode *inode, loff_t start,
+				loff_t end)
 {
 	struct radix_tree_root *root = &inode->i_mapping->page_tree;
 	int found = false;
-- 
2.1.0

