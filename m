Return-Path: <SRS0=mA8v=TP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D046C04E53
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 15:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F4B12084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557932572;
	bh=SlFkTgvCHcWHjHA95g3vYpVXMU/Ee/so9Kot6KkW3Ec=;
	h=From:To:Subject:Date:List-ID:From;
	b=HZ2ikQb3ILlS4c1ZPIsaq55PcYLTvRxyY6jRxSHX8PMFO3J4nl7CLuvBFGL9dsHG1
	 3dzCR9zRuTZuKXKgUpTpM3Q3ztjgB8Db7JX6z9mt2gR16o8SYWMeFyonXhmHfHBcRv
	 XWBwqiiYamS33TooTlLIfxTq7T3lQZJOJgK653Z0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfEOPCv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 May 2019 11:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfEOPCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 May 2019 11:02:51 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CADE620815
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2019 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557932570;
        bh=SlFkTgvCHcWHjHA95g3vYpVXMU/Ee/so9Kot6KkW3Ec=;
        h=From:To:Subject:Date:From;
        b=pU2Y7lpImYz1hvmp5Hhy+anLPBfVN202Xf6ngoD53oRhk607o7v5rEFncsGn74sep
         MzXD2w1u0JTPbPhYOlFe6JUPkt8iwKW9kjJxB12DVw7p2ZXLOz2aIpVXeE6jB2zqeD
         t8c2G30DUYouHq10k9V27xGifocaMSGokC4lHJ40=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: fix wrong ctime and mtime of a directory after log replay
Date:   Wed, 15 May 2019 16:02:47 +0100
Message-Id: <20190515150247.24776-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When replaying a log that contains a new file or directory name that needs
to be added to its parent directory, we end up updating the mtime and the
ctime of the parent directory to the current time after we have set their
values to the correct ones (set at fsync time), efectivelly losing them.

Sample reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ touch /mnt/dir/file

  # fsync of the directory is optional, not needed
  $ xfs_io -c fsync /mnt/dir
  $ xfs_io -c fsync /mnt/dir/file

  $ stat -c %Y /mnt/dir
  1557856079

  <power failure>

  $ sleep 3
  $ mount /dev/sdb /mnt
  $ stat -c %Y /mnt/dir
  1557856082

    --> should have been 1557856079, the mtime is updated to the current
        time when replaying the log

Fix this by not updating the mtime and ctime to the current time at
btrfs_add_link() when we are replaying a log tree.

This could be triggered by my recent fsync fuzz tester for fstests, for
which an fstests patch exists titled "fstests: generic, fsync fuzz tester
with fsstress".

Fixes: e02119d5a7b43 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cacde7040329..8e6d7b0bd988 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6381,8 +6381,18 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(parent_inode, parent_inode->vfs_inode.i_size +
 			   name_len * 2);
 	inode_inc_iversion(&parent_inode->vfs_inode);
-	parent_inode->vfs_inode.i_mtime = parent_inode->vfs_inode.i_ctime =
-		current_time(&parent_inode->vfs_inode);
+	/*
+	 * If we are replaying a log tree, we do not want to update the mtime
+	 * and ctime of the parent directory with the current time, since the
+	 * log replay procedure is responsible for setting them to their correct
+	 * values (the ones it had when the fsync was done).
+	 */
+	if (!test_bit(BTRFS_FS_LOG_RECOVERING, &root->fs_info->flags)) {
+		struct timespec64 now = current_time(&parent_inode->vfs_inode);
+
+		parent_inode->vfs_inode.i_mtime = now;
+		parent_inode->vfs_inode.i_ctime = now;
+	}
 	ret = btrfs_update_inode(trans, root, &parent_inode->vfs_inode);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
-- 
2.11.0

