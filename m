Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60E5C10F0B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 12:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C5E21852
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 12:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551182780;
	bh=jgKi5ePaQkVJZHJjY1giBwluAmfoWWtTBzNZhFv+QLU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=F/uUhssV+xk0hvwDMXE5BZlXFts0pwQgMa9bxdpe73mVr8VAhmM8bDEhNEUMpSTBl
	 7esxRbb+pdqlA/r6NMtZTbmeijiCCt/h7TdzDZvfp25CxtKLfqlSgqpbwJIZ6Boag2
	 8QqawypOrrFdVfD4ILwgF0uuUn+INR+oOMbDSreU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfBZMGT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfBZMGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 07:06:19 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B3C217F9;
        Tue, 26 Feb 2019 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551182778;
        bh=jgKi5ePaQkVJZHJjY1giBwluAmfoWWtTBzNZhFv+QLU=;
        h=From:To:Cc:Subject:Date:From;
        b=L9ll3GDvj/R+eNUVQxBYw4TgeZxu/PzbjXPnK8BFD/v5QRCAIBeoy7uf16PeVEcN2
         zCfnWQ/jEkP+SSGFZNP4v3LU/RkwmQFzeMhkiFq1+Sl0SV4aTFcw5PC0vAYkPE1Cw+
         JBDMRW4fGYP+RDiwD5UtqvXssiv5wcJU0TDfmDPU=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ce3g8jdj@umail.furryterror.org
Subject: [PATCH] Btrfs: fix deadlock between clone/dedupe and rename
Date:   Tue, 26 Feb 2019 12:06:09 +0000
Message-Id: <20190226120609.14450-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Reflinking (clone/dedupe) and rename are operations that operate on two
inodes and therefore need to lock them in the same order to avoid ABBA
deadlocks. It happens that Btrfs' reflink implementation always locked
them in a different order from VFS's lock_two_nondirectories() helper,
which is used by the rename code in VFS, resulting in ABBA type deadlocks.

Btrfs' locking order:

  static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
  {
         if (inode1 < inode2)
                swap(inode1, inode2);

         inode_lock_nested(inode1, I_MUTEX_PARENT);
         inode_lock_nested(inode2, I_MUTEX_CHILD);
  }

VFS's locking order:

  void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
  {
        if (inode1 > inode2)
                swap(inode1, inode2);

        if (inode1 && !S_ISDIR(inode1->i_mode))
                inode_lock(inode1);
        if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
                inode_lock_nested(inode2, I_MUTEX_NONDIR2);
}

Fix this by killing the btrfs helper function that does the double inode
locking and replace it with VFS's helper lock_two_nondirectories().

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Fixes: 416161db9b63e3 ("btrfs: offline dedupe")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c8e1734429c..6e1119496721 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3206,21 +3206,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static void btrfs_double_inode_unlock(struct inode *inode1, struct inode *inode2)
-{
-	inode_unlock(inode1);
-	inode_unlock(inode2);
-}
-
-static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
-{
-	if (inode1 < inode2)
-		swap(inode1, inode2);
-
-	inode_lock_nested(inode1, I_MUTEX_PARENT);
-	inode_lock_nested(inode2, I_MUTEX_CHILD);
-}
-
 static void btrfs_double_extent_unlock(struct inode *inode1, u64 loff1,
 				       struct inode *inode2, u64 loff2, u64 len)
 {
@@ -3989,7 +3974,7 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (same_inode)
 		inode_lock(inode_in);
 	else
-		btrfs_double_inode_lock(inode_in, inode_out);
+		lock_two_nondirectories(inode_in, inode_out);
 
 	/*
 	 * Now that the inodes are locked, we need to start writeback ourselves
@@ -4039,7 +4024,7 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (same_inode)
 		inode_unlock(inode_in);
 	else
-		btrfs_double_inode_unlock(inode_in, inode_out);
+		unlock_two_nondirectories(inode_in, inode_out);
 
 	return ret;
 }
@@ -4069,7 +4054,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (same_inode)
 		inode_unlock(src_inode);
 	else
-		btrfs_double_inode_unlock(src_inode, dst_inode);
+		unlock_two_nondirectories(src_inode, dst_inode);
 
 	return ret < 0 ? ret : len;
 }
-- 
2.11.0

