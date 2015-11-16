Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34262 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbKPHH1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:07:27 -0500
Received: from localhost
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 17:07:25 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 875442CE8052
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:24 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG77GKX42074144
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:24 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG76pb8030951
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:52 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V9 11/12] Btrfs: Clean pte corresponding to page straddling i_size
Date: Mon, 16 Nov 2015 12:35:31 +0530
Message-Id: <1447657532-9393-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index ce5a0d4..7c97c78 100644
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
index 812be32..604ac97 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4939,7 +4939,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	}
 
 	if (newsize > oldsize) {
-		truncate_pagecache(inode, newsize);
 		/*
 		 * Don't do an expanding truncate while snapshoting is ongoing.
 		 * This is to ensure the snapshot captures a fully consistent
@@ -4962,6 +4961,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		i_size_write(inode, newsize);
 		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		pagecache_isize_extended(inode, oldsize, newsize);
 		ret = btrfs_update_inode(trans, root, inode);
 		btrfs_end_write_no_snapshoting(root);
 		btrfs_end_transaction(trans, root);
-- 
2.1.0

