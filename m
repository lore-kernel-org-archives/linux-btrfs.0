Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34022 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbKFSgw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 13:36:52 -0500
Received: by padhx2 with SMTP id hx2so122121909pad.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 10:36:51 -0800 (PST)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs: qgroup: fix quota disable during rescan
Date: Fri,  6 Nov 2015 10:36:42 -0800
Message-Id: <1446835002-11751-1-git-send-email-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a race condition that leads to a NULL pointer dereference if you
disable quotas while a quota rescan is running.  To fix this, we just need
to wait for the quota rescan worker to actually exit before tearing down
the quota structures.

Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 fs/btrfs/qgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 75c0249..a7cf504 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -993,9 +993,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
-	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
+	btrfs_qgroup_wait_for_completion(fs_info);
+	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
 	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
-- 
2.6.3

