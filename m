Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760008AbdKQRpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3819AABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:03 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 1/8] btrfs: use iocb for __btrfs_buffered_write
Date: Fri, 17 Nov 2017 11:44:47 -0600
Message-Id: <20171117174456.13393-2-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Preparatory patch. It reduces the arguments to __btrfs_buffered_write
to follow buffered_write() style.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

---
 fs/btrfs/file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aafcc785f840..9bceb0e61361 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1572,10 +1572,11 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 	return ret;
 }
 
-static noinline ssize_t __btrfs_buffered_write(struct file *file,
-					       struct iov_iter *i,
-					       loff_t pos)
+static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
+					       struct iov_iter *i)
 {
+	struct file *file = iocb->ki_filp;
+	loff_t pos = iocb->ki_pos;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1815,7 +1816,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
-	loff_t pos = iocb->ki_pos;
 	ssize_t written;
 	ssize_t written_buffered;
 	loff_t endbyte;
@@ -1826,8 +1826,8 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (written < 0 || !iov_iter_count(from))
 		return written;
 
-	pos += written;
-	written_buffered = __btrfs_buffered_write(file, from, pos);
+	iocb->ki_pos += written;
+	written_buffered = __btrfs_buffered_write(iocb, from);
 	if (written_buffered < 0) {
 		err = written_buffered;
 		goto out;
@@ -1836,16 +1836,16 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	 * Ensure all data is persisted. We want the next direct IO read to be
 	 * able to read what was just written.
 	 */
-	endbyte = pos + written_buffered - 1;
-	err = btrfs_fdatawrite_range(inode, pos, endbyte);
+	endbyte = iocb->ki_pos + written_buffered - 1;
+	err = btrfs_fdatawrite_range(inode, iocb->ki_pos, endbyte);
 	if (err)
 		goto out;
-	err = filemap_fdatawait_range(inode->i_mapping, pos, endbyte);
+	err = filemap_fdatawait_range(inode->i_mapping, iocb->ki_pos, endbyte);
 	if (err)
 		goto out;
+	iocb->ki_pos += written_buffered;
 	written += written_buffered;
-	iocb->ki_pos = pos + written_buffered;
-	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
+	invalidate_mapping_pages(file->f_mapping, iocb->ki_pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
 	return written ? written : err;
@@ -1964,7 +1964,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		num_written = __btrfs_direct_write(iocb, from);
 	} else {
-		num_written = __btrfs_buffered_write(file, from, pos);
+		num_written = __btrfs_buffered_write(iocb, from);
 		if (num_written > 0)
 			iocb->ki_pos = pos + num_written;
 		if (clean_page)
-- 
2.14.2

