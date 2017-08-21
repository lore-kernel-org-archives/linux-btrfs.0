Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33669 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753644AbdHUWvj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 18:51:39 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7LMpc3O022509
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:51:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7LMpbgY030625
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:51:38 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7LMpbVR008469
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:51:37 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 RESEND] Btrfs: make plug in writing meta blocks really work
Date: Mon, 21 Aug 2017 15:49:59 -0600
Message-Id: <20170821215000.2987-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have started plug in btrfs_write_and_wait_marked_extents() but the
generated IOs actually go to device's schedule IO list where the work
is doing in another task, thus the started plug doesn't make any
sense.

And since we wait for IOs immediately after writing meta blocks, it's
the same case as writing log tree, doing sync submit can merge more
IOs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c     | 6 ++++--
 fs/btrfs/transaction.c | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 080e2eb..8d097ba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1005,8 +1005,10 @@ static blk_status_t __btree_submit_bio_done(void *private_data, struct bio *bio,
 	return ret;
 }
 
-static int check_async_write(unsigned long bio_flags)
+static int check_async_write(struct btrfs_inode *bi, unsigned long bio_flags)
 {
+	if (atomic_read(&bi->sync_writers))
+		return 0;
 	if (bio_flags & EXTENT_BIO_TREE_LOG)
 		return 0;
 #ifdef CONFIG_X86
@@ -1022,7 +1024,7 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
 {
 	struct inode *inode = private_data;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	int async = check_async_write(bio_flags);
+	int async = check_async_write(BTRFS_I(inode), bio_flags);
 	blk_status_t ret;
 
 	if (bio_op(bio) != REQ_OP_WRITE) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f615d59..9c5f126 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -950,6 +950,7 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 	u64 start = 0;
 	u64 end;
 
+	atomic_inc(&BTRFS_I(fs_info->btree_inode)->sync_writers);
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      mark, &cached_state)) {
 		bool wait_writeback = false;
@@ -985,6 +986,7 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 		cond_resched();
 		start = end + 1;
 	}
+	atomic_dec(&BTRFS_I(fs_info->btree_inode)->sync_writers);
 	return werr;
 }
 
-- 
2.9.4

