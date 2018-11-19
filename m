Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8759BC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5055320851
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5Sk/axg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5055320851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbeKTAj0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 19:39:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbeKTAj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:39:26 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A9E20851
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542636940;
        bh=gpiLLYQNh52lMldv3UO3+O6toPkLNxjqmJfF8uQYsFo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=O5Sk/axgMCgMDLiTUF+FqKji/LNzBH96Ta/fdT2V9RZtPWQfCZM37VJovYCf5JJny
         yMXGgQ4fAHHsh4whFyZWNWYJndA5+x3bFFh4r5enEhiluOZ+Pm8+1mnaNgjY0IBxOY
         7mypE95LmH/nQB5IG/rsX3RdAmOr9RalQnsD+ok4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to concurrent snapshot creation
Date:   Mon, 19 Nov 2018 14:15:36 +0000
Message-Id: <20181119141536.20748-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181119094823.27346-1-fdmanana@kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

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
---

V2: Added second deadlock example to changelog and changed the fix to deal
    with that case as well.

 fs/btrfs/qgroup.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d4917c0cddf5..ae1358253b7b 100644
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
2.11.0

