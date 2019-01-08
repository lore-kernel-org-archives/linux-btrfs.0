Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEFCC43444
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 20:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B93F20660
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977811;
	bh=YGY7k4S2cG7uMSu/EBpXR4QRd34/KE2tWRxnOP64u/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1MOMk3USemwf0RXenSoLJhaUaYWu8IB5/S4PJ/cYsCHmUiQd58ZlucWcLrv/+t05k
	 +K+ywXtB/WF9s01QS5iVcaf4FSTMv7iCRYe4TOYvBV79fX3EPZccroMcUaAEcTvONA
	 zESW71ZgdnMzqI56NJzreyqDQTRU/lpEXwTis+8I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfAHT2n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbfAHT2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:28:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F33320827;
        Tue,  8 Jan 2019 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975717;
        bh=YGY7k4S2cG7uMSu/EBpXR4QRd34/KE2tWRxnOP64u/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcvHv1pn0r09m2HHER3jcxA4l6Go97Z2HPoYJzwsU8gxWUJi38aP1KQQaStwCaK7w
         J7qa3jtb8UipRwM8/XuYcMgLSNlpbj6O3KPzyqLFSA5XqVMPjFyNeAfZSO31Z+Kju0
         Tuje9H8ciFo2z4P6Vp4vObbIdVVSBjIUzFY2qm2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 074/117] Btrfs: fix deadlock when enabling quotas due to concurrent snapshot creation
Date:   Tue,  8 Jan 2019 14:25:42 -0500
Message-Id: <20190108192628.121270-74-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192628.121270-1-sashal@kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9a6f209e36500efac51528132a3e3083586eda5f ]

If the quota enable and snapshot creation ioctls are called concurrently
we can get into a deadlock where the task enabling quotas will deadlock
on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock it
twice, or the task creating a snapshot tries to commit the transaction
while the task enabling quota waits for the former task to commit the
transaction while holding the mutex. The following time diagrams show how
both cases happen.

First scenario:

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

Second scenario:

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
                                                 --> waits for task at
                                                     CPU 0 to release
                                                     its transaction
                                                     handle

    btrfs_commit_transaction()
     --> sees another task started
         the transaction commit first
     --> releases its transaction
         handle
     --> waits for the transaction
         commit to be completed by
         the task at CPU 1

                                                 create_pending_snapshot()
                                                  qgroup_account_snapshot()
                                                   btrfs_qgroup_inherit()
                                                    mutex_lock(fs_info->qgroup_ioctl_lock)
                                                     --> deadlock, task at CPU 0
                                                         has the mutex locked but
                                                         it is waiting for us to
                                                         finish the transaction
                                                         commit

So fix this by setting the quota enabled flag in fs_info after committing
the transaction at btrfs_quota_enable(). This ends up serializing quota
enable and snapshot creation as if the snapshot creation happened just
before the quota enable request. The quota rescan task, scheduled after
committing the transaction in btrfs_quote_enable(), will do the accounting.

Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creating snapshot")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f70825af6438..9e419f6878c5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
 	}
-	spin_lock(&fs_info->qgroup_lock);
-	fs_info->quota_root = quota_root;
-	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = btrfs_commit_transaction(trans);
 	trans = NULL;
 	if (ret)
 		goto out_free_path;
 
+	/*
+	 * Set quota enabled flag after committing the transaction, to avoid
+	 * deadlocks on fs_info->qgroup_ioctl_lock with concurrent snapshot
+	 * creation.
+	 */
+	spin_lock(&fs_info->qgroup_lock);
+	fs_info->quota_root = quota_root;
+	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	spin_unlock(&fs_info->qgroup_lock);
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
-- 
2.19.1

