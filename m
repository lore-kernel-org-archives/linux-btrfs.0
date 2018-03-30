Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:43017 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752282AbeC3WMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 18:12:07 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: clean up resources during umount after trans is aborted
Date: Sat, 31 Mar 2018 06:11:56 +0800
Message-Id: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if some fatal errors occur, like all IO get -EIO, resources
would be cleaned up when
a) transaction is being committed or
b) BTRFS_FS_STATE_ERROR is set

However, in some rare cases, resources may be left alone after transaction
gets aborted and umount may run into some ASSERT(), e.g.
ASSERT(list_empty(&block_group->dirty_list));

For case a), in btrfs_commit_transaciton(), there're several places at the
beginning where we just call btrfs_end_transaction() without cleaning up
resources.  For case b), it is possible that the trans handle doesn't have
any dirty stuff, then only trans hanlde is marked as aborted while
BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.

This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
all resources won't stay in memory after umount.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21f34ad..643bd69 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3735,7 +3735,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
 
-	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state) ||
+	    test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state))
 		btrfs_error_commit_super(fs_info);
 
 	kthread_stop(fs_info->transaction_kthread);
-- 
1.8.3.1

