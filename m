Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965652AbcKXPum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 10:50:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B3C0A2041A
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 15:50:40 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DD002037C
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 15:50:39 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix qgroup rescan worker initialization
Date: Thu, 24 Nov 2016 02:18:29 +0000
Message-Id: <1479953909-16332-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were setting the qgroup_rescan_running flag to true only after the
rescan worker started (which is a task run by a queue). So if a user
space task starts a rescan and immediately after asks to wait for the
rescan worker to finish, this second call might happen before the rescan
worker task starts running, in which case the rescan wait ioctl returns
immediatley, not waiting for the rescan worker to finish.

This was making the fstest btrfs/022 fail very often.

Fixes: d2c609b834d6 (btrfs: properly track when rescan worker is running)
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 11f4fff..dfd9986 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2335,10 +2335,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	int err = -ENOMEM;
 	int ret = 0;
 
-	mutex_lock(&fs_info->qgroup_rescan_lock);
-	fs_info->qgroup_rescan_running = true;
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
-
 	path = btrfs_alloc_path();
 	if (!path)
 		goto out;
@@ -2449,6 +2445,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 		sizeof(fs_info->qgroup_rescan_progress));
 	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
 	init_completion(&fs_info->qgroup_rescan_completion);
+	fs_info->qgroup_rescan_running = true;
 
 	spin_unlock(&fs_info->qgroup_lock);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
-- 
2.7.0.rc3

