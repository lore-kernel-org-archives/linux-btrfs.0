Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51005 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbKPHJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:15 -0500
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:13 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id D3B43E008C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:36 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78wKk4850064
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:59 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78uj2027342
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:58 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 10/14] Btrfs: subpagesize-blocksize: btrfs_punch_hole: Use EXTENT_UPTODATE bit to check for the presence of block in page cache
Date: Mon, 16 Nov 2015 12:38:37 +0530
Message-Id: <1447657721-10025-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize, we have multiple blocks in a page. Checking for
existence of a page in the page cache isn't a sufficient check, since we could
be truncating a subset of the blocks mapped by the page. So if the blocks that
are neighboring the truncated block exist in the page cache,
btrfs_page_exists_in_range() would always return 1. Hence check for the
existence of EXTENT_UPTODATE bit on the file range mapped by the block being
punched out.

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
index 386299f..2c0fd01 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2439,7 +2439,9 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
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
index fea4693..bd96bac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7434,7 +7434,8 @@ out:
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

