Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235B5C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E88AA206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977086;
	bh=0/vwCuiFG09HiZLLEXiJCJ99HVK5QoFCpjq3xTiBbnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Wf2TUs5C3k/IMhiUdZspQw0z9wbe/t9Dq9I5OiC1eJKe5BTFPlIuAnRPVRLuGIZH8
	 awJPW6+mX4y+OAXdJZydtjJ7RT2hBNhOiorhnoJ5b1iKPwWaQanI2WfnheDfB8Fm3m
	 c3UghpOCCFnscGLBEFT2TcH5LphO1SzXh8tu+9yE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfAHTbZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731066AbfAHTbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C0120827;
        Tue,  8 Jan 2019 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975882;
        bh=0/vwCuiFG09HiZLLEXiJCJ99HVK5QoFCpjq3xTiBbnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neJqLYwoi3lxVb8kczEvaNGHXWevSsDoliGJZyr/E+zpWdwh7y0SBErAYr7yMAnQR
         NBPiBo+PIFqipllTIC6mZ1eeGlYoW1TiHofiCCXdWX3KlYyLENsBUGPuzeDfCE+Z1J
         ow4iKk1EmI5KOlnIFeh5XZx5lcLAUE7oiDC+1E/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 59/97] Btrfs: fix deadlock when enabling quotas due to concurrent snapshot creation
Date:   Tue,  8 Jan 2019 14:29:08 -0500
Message-Id: <20190108192949.122407-59-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
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
index ff434663d65b..e1fcb28ad4cc 100644
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

