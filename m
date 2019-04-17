Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE4BC10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986FD2173C
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555497037;
	bh=d5zRrsaK9PC/9ViGMEw2Khfe1//gCYswslCpZrx/sSY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=u+GnoKSe4xrg49qlxEZMajjgPxIvR9lfkZeq6Ot3Zm4j1uyLGx0PrfOoYuakjVUV+
	 Ef+AqJ3lvTcNNNwyffQvfqWWMJfxQbkoSnYY3vEBnMl06b5RT/8INEosk9zTwlYE0a
	 6XE6dE4k9o+Iy2ej/iKi1ITOHq15k8WLByD6FaRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfDQKag (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfDQKag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 06:30:36 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4D521773;
        Wed, 17 Apr 2019 10:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555497034;
        bh=d5zRrsaK9PC/9ViGMEw2Khfe1//gCYswslCpZrx/sSY=;
        h=From:To:Cc:Subject:Date:From;
        b=nU7bUNOCpJIxZtm7o5Pgd9TZTAj6IdN33W5JJPNoiU+7/o8Mc3lDp5rkxv2oRNX/G
         b3d6X458Iu6XErbURvwILnlB5rSk6KsDsPOgfdsowdFmwJMTjXZnWFEvWgyl98JuHt
         RFFBrwSX2onOIxJyhAyZXMdvKPJKk445m9NiWTlw=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ce3g8jdj@umail.furryterror.org
Subject: [PATCH] Btrfs: do not start a transaction at iterate_extent_inodes()
Date:   Wed, 17 Apr 2019 11:30:30 +0100
Message-Id: <20190417103030.24883-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When finding out which inodes have references on a particular extent, done
by backref.c:iterate_extent_inodes(), from the BTRFS_IOC_LOGICAL_INO (both
v1 and v2) ioctl and from scrub we use the transaction join api to grab a
reference on the currently running transaction, since in order to give
accurate results we need to inspect the delayed references of the currently
running transaction.

However, if there is currently no running transaction, the join operation
will create a new transaction. This is inneficient as the transaction will
eventually be committed, doing unnecessary IO and introducing a potential
point of failure that will lead to a transaction abort due to -ENOSPC, as
recently reported [1].

That's because the join, creates the transaction but does not reserves any
space, so when attempting to update the root item of the root passed to
btrfs_join_transaction(), during the transaction commit, we can end up
failling with -ENOSPC. Users of a join operation are supposed to actually
do some filesystem changes and reserve space by some means, which is not
the case of iterate_extent_inodes(), it is a read-only operation for all
contextes from which it is called.

The reported [1] -ENOSPC failure stack trace is the following:

heisenberg kernel: ------------[ cut here ]------------
 heisenberg kernel: BTRFS: Transaction aborted (error -28)
 heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tree.c:136 btrfs_update_root+0x22b/0x320 [btrfs]
(...)
 heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not tainted 4.19.0-4-amd64 #1 Debian 4.19.28-2
 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS Version 1.21 03/19/2018
 heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrfs]
(...)
 heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
 heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 RCX: 0000000000000006
 heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff8ed6bda166a0
 heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R09: 0000000000000007
 heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff8ed63396a078
 heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R15: ffff8ed6bd03d068
 heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda00000(0000) knlGS:0000000000000000
 heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 CR4: 00000000003606f0
 heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 heisenberg kernel: Call Trace:
 heisenberg kernel:  commit_fs_roots+0x166/0x1d0 [btrfs]
 heisenberg kernel:  ? _cond_resched+0x15/0x30
 heisenberg kernel:  ? btrfs_run_delayed_refs+0xac/0x180 [btrfs]
 heisenberg kernel:  btrfs_commit_transaction+0x2bd/0x870 [btrfs]
 heisenberg kernel:  ? start_transaction+0x9d/0x3f0 [btrfs]
 heisenberg kernel:  transaction_kthread+0x147/0x180 [btrfs]
 heisenberg kernel:  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
 heisenberg kernel:  kthread+0x112/0x130
 heisenberg kernel:  ? kthread_bind+0x30/0x30
 heisenberg kernel:  ret_from_fork+0x35/0x40
 heisenberg kernel: ---[ end trace 05de912e30e012d9 ]---

So fix that by using the attach API, which does not create a transaction
when there is currently no running transaction.

[1] https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net/

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/backref.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6d616737f349..fd4d968f1b41 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1916,13 +1916,19 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 			extent_item_objectid);
 
 	if (!search_commit_root) {
-		trans = btrfs_join_transaction(fs_info->extent_root);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		trans = btrfs_attach_transaction(fs_info->extent_root);
+		if (IS_ERR(trans)) {
+			if (PTR_ERR(trans) != -ENOENT &&
+			    PTR_ERR(trans) != -EROFS)
+				return PTR_ERR(trans);
+			trans = NULL;
+		}
+	}
+
+	if (trans)
 		btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-	} else {
+	else
 		down_read(&fs_info->commit_root_sem);
-	}
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
 				   tree_mod_seq_elem.seq, &refs,
@@ -1955,7 +1961,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 
 	free_leaf_list(refs);
 out:
-	if (!search_commit_root) {
+	if (trans) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 		btrfs_end_transaction(trans);
 	} else {
-- 
2.11.0

