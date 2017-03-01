Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38732 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbdCABFv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 20:05:51 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] Btrfs: remove start_pos
Date: Tue, 28 Feb 2017 17:04:40 -0800
Message-Id: <1488330280-22678-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@pos, not aligned @start_pos, should be used to check whether the eof page
needs to be marked as readonly, thus @start_pos can be removed.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0be837b..ef88e6d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1814,7 +1814,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 start_pos;
 	u64 end_pos;
 	ssize_t num_written = 0;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
@@ -1822,7 +1821,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	loff_t pos;
 	size_t count;
 	loff_t oldsize;
-	int clean_page = 0;
 
 	inode_lock(inode);
 	err = generic_write_checks(iocb, from);
@@ -1860,7 +1858,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
-	start_pos = round_down(pos, fs_info->sectorsize);
 	end_pos = round_up(pos + count, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (end_pos > oldsize) {
@@ -1870,8 +1867,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 			inode_unlock(inode);
 			goto out;
 		}
-		if (start_pos > round_up(oldsize, fs_info->sectorsize))
-			clean_page = 1;
 	}
 
 	if (sync)
@@ -1883,7 +1878,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		num_written = __btrfs_buffered_write(file, from, pos);
 		if (num_written > 0)
 			iocb->ki_pos = pos + num_written;
-		if (clean_page)
+		if (oldsize < pos)
 			pagecache_isize_extended(inode, oldsize,
 						i_size_read(inode));
 	}
-- 
2.5.5

