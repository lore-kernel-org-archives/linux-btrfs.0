Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935495AbcLWJag (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 04:30:36 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBN9U1dC122409
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 04:30:35 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27gwmkqb8j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 04:30:35 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 23 Dec 2016 04:30:34 -0500
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fdmanana@suse.com,
        dsterba@suse.com
Subject: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Date: Fri, 23 Dec 2016 15:00:18 +0530
Message-Id: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following deadlock is seen when executing generic/113 test,

 ---------------------------------------------------------+----------------------------------------------------
  Direct I/O task                                           Fast fsync task
 ---------------------------------------------------------+----------------------------------------------------
  btrfs_direct_IO
    __blockdev_direct_IO
     do_blockdev_direct_IO
      do_direct_IO
       btrfs_get_blocks_direct
        while (blocks needs to written)
         get_more_blocks (first iteration)
          btrfs_get_blocks_direct
           btrfs_create_dio_extent
             down_read(&BTRFS_I(inode) >dio_sem)
             Create and add extent map and ordered extent
             up_read(&BTRFS_I(inode) >dio_sem)
                                                            btrfs_sync_file
                                                              btrfs_log_dentry_safe
                                                               btrfs_log_inode_parent
                                                                btrfs_log_inode
                                                                 btrfs_log_changed_extents
                                                                  down_write(&BTRFS_I(inode) >dio_sem)
                                                                   Collect new extent maps and ordered extents
                                                                    wait for ordered extent completion
         get_more_blocks (second iteration)
          btrfs_get_blocks_direct
           btrfs_create_dio_extent
             down_read(&BTRFS_I(inode) >dio_sem)
 --------------------------------------------------------------------------------------------------------------

In the above description, Btrfs direct I/O code path has not yet started
submitting bios for file range covered by the initial ordered
extent. Meanwhile, The fast fsync task obtains the write semaphore and
waits for I/O on the ordered extent to get completed. However, the
Direct I/O task is now blocked on obtaining the read semaphore.

To resolve the deadlock, this commit modifies the Direct I/O code path
to obtain the read semaphore before invoking
__blockdev_direct_IO(). The semaphore is then given up after
__blockdev_direct_IO() returns. This allows the Direct I/O code to
complete I/O on all the ordered extents it creates.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5ca88f0..f796037 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7325,7 +7325,6 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
 	struct extent_map *em = NULL;
 	int ret;
 
-	down_read(&BTRFS_I(inode)->dio_sem);
 	if (type != BTRFS_ORDERED_NOCOW) {
 		em = create_pinned_em(inode, start, len, orig_start,
 				      block_start, block_len, orig_block_len,
@@ -7344,7 +7343,6 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
 		em = ERR_PTR(ret);
 	}
  out:
-	up_read(&BTRFS_I(inode)->dio_sem);
 
 	return em;
 }
@@ -8800,6 +8798,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		dio_data.unsubmitted_oe_range_start = (u64)offset;
 		dio_data.unsubmitted_oe_range_end = (u64)offset;
 		current->journal_info = &dio_data;
+		down_read(&BTRFS_I(inode)->dio_sem);
 	} else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
 				     &BTRFS_I(inode)->runtime_flags)) {
 		inode_dio_end(inode);
@@ -8812,6 +8811,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 				   iter, btrfs_get_blocks_direct, NULL,
 				   btrfs_submit_direct, flags);
 	if (iov_iter_rw(iter) == WRITE) {
+		up_read(&BTRFS_I(inode)->dio_sem);
 		current->journal_info = NULL;
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
-- 
2.5.5

