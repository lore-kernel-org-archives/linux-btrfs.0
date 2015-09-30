Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40421 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbbI3KaI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:30:08 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:30:06 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 9B5042BB0055
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:30:03 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UATtH662128348
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:30:03 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UATUj5023975
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:31 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V5 11/13] Btrfs: Clean pte corresponding to page straddling i_size
Date: Wed, 30 Sep 2015 15:58:30 +0530
Message-Id: <1443608912-31667-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When extending a file by either "truncate up" or by writing beyond i_size, the
page which had i_size needs to be marked "read only" so that future writes to
the page via mmap interface causes btrfs_page_mkwrite() to be invoked. If not,
a write performed after extending the file via the mmap interface will find
the page to be writaeable and continue writing to the page without invoking
btrfs_page_mkwrite() i.e. we end up writing to a file without reserving disk
space.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c  | 12 ++++++++++--
 fs/btrfs/inode.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 360d56d..5715e29 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1757,6 +1757,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	ssize_t err;
 	loff_t pos;
 	size_t count;
+	loff_t oldsize;
+	int clean_page = 0;
 
 	mutex_lock(&inode->i_mutex);
 	err = generic_write_checks(iocb, from);
@@ -1795,14 +1797,17 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
 	start_pos = round_down(pos, root->sectorsize);
-	if (start_pos > i_size_read(inode)) {
+	oldsize = i_size_read(inode);
+	if (start_pos > oldsize) {
 		/* Expand hole size to cover write data, preventing empty gap */
 		end_pos = round_up(pos + count, root->sectorsize);
-		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
+		err = btrfs_cont_expand(inode, oldsize, end_pos);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
 			goto out;
 		}
+		if (start_pos > round_up(oldsize, root->sectorsize))
+			clean_page = 1;
 	}
 
 	if (sync)
@@ -1814,6 +1819,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		num_written = __btrfs_buffered_write(file, from, pos);
 		if (num_written > 0)
 			iocb->ki_pos = pos + num_written;
+		if (clean_page)
+			pagecache_isize_extended(inode, oldsize,
+						i_size_read(inode));
 	}
 
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c937357..f31da87 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4853,7 +4853,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	}
 
 	if (newsize > oldsize) {
-		truncate_pagecache(inode, newsize);
 		/*
 		 * Don't do an expanding truncate while snapshoting is ongoing.
 		 * This is to ensure the snapshot captures a fully consistent
@@ -4876,6 +4875,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		i_size_write(inode, newsize);
 		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		pagecache_isize_extended(inode, oldsize, newsize);
 		ret = btrfs_update_inode(trans, root, inode);
 		btrfs_end_write_no_snapshoting(root);
 		btrfs_end_transaction(trans, root);
-- 
2.1.0

