Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF842C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77E220823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRHGTTiV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A77E220823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbeKSULd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbeKSULd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:11:33 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10E320823
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542620906;
        bh=15ev4iIdYslmPr36wY1Nu2GAr/oBt5txkeAL8Hf/ewQ=;
        h=From:To:Subject:Date:From;
        b=oRHGTTiVpkOKDwTv2z6bz/x4DS1qp42w+LCZ18xBeLNnM85JSiPNz4h4cCM7Q+2w9
         9vzSmSQJc65PeEpmDlaNGAfBjFR11zxBC+RLz42TbZfmbfR0KlX+7fq3uRCXmb8Lvl
         6/ljuh2dR6E1zIp7gO5Z8nKdPdbG+c1+QvIZ1leM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix deadlock when enabling quotas due to concurrent snapshot creation
Date:   Mon, 19 Nov 2018 09:48:23 +0000
Message-Id: <20181119094823.27346-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the quota enable and snapshot creation ioctls are called concurrently
we can get into a deadlock where the task enabling quotas will deadlock
on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock it
twice. The following time diagram shows how this happens.

           CPU 0                                    CPU 1

 btrfs_ioctl()
  btrfs_ioctl_quota_ctl()
   btrfs_quota_enable()
    mutex_lock(fs_info->qgroup_ioctl_lock)
    btrfs_start_transaction()

                                             btrfs_ioctl()
                                              btrfs_ioctl_snap_create_v2
                                               create_snapshot()
                                                --> adds snapshot to the
                                                    list pending_snapshots
                                                    of the current
                                                    transaction

    btrfs_commit_transaction()
     create_pending_snapshots()
       create_pending_snapshot()
        qgroup_account_snapshot()
         btrfs_qgroup_inherit()
	   mutex_lock(fs_info->qgroup_ioctl_lock)
	    --> deadlock, mutex already locked
	        by this task at
		btrfs_quota_enable()

So fix this by adding a flag to the transaction handle that signals if the
transaction is being used for enabling quotas (only seen by the task doing
it) and do not lock the mutex qgroup_ioctl_lock at btrfs_qgroup_inherit()
if the transaction handle corresponds to the one being used to enable the
quotas.

Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creating snapshot")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c      | 10 ++++++++--
 fs/btrfs/transaction.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d4917c0cddf5..3aec3bfa3d70 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -908,6 +908,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		trans = NULL;
 		goto out;
 	}
+	trans->enabling_quotas = true;
 
 	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
@@ -2250,7 +2251,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	u32 level_size = 0;
 	u64 nums;
 
-	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	if (trans->enabling_quotas)
+		lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
+	else
+		mutex_lock(&fs_info->qgroup_ioctl_lock);
+
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		goto out;
 
@@ -2413,7 +2418,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 out:
-	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (!trans->enabling_quotas)
+		mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 703d5116a2fc..a5553a1dee30 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -122,6 +122,7 @@ struct btrfs_trans_handle {
 	bool reloc_reserved;
 	bool sync;
 	bool dirty;
+	bool enabling_quotas;
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info;
 	struct list_head new_bgs;
-- 
2.11.0

