Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbeF0O3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 10:29:51 -0400
Received: from debian3.lan (bl11-80-66.dsl.telepac.pt [85.244.80.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CEC208A3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 14:29:50 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix mount failure when qgroup rescan is in progress
Date: Wed, 27 Jun 2018 00:43:15 +0100
Message-Id: <20180626234315.15643-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If a power failure happens while the qgroup rescan kthread is running,
the next mount operation will always fail. This is because of a recent
regression that makes qgroup_rescan_init() incorrectly return -EINVAL
when we are mounting the filesystem (through btrfs_read_qgroup_config()).
This causes the -EINVAL error to be returned regardless of any qgroup
flags being set instead of returning the error only when neither of
the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
are set.

A test case for fstests follows up soon.

Fixes: 9593bf49675e ("btrfs: qgroup: show more meaningful qgroup_rescan_init error message")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1874a6d2e6f5..d4171de93087 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2784,13 +2784,20 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	if (!init_flags) {
 		/* we're resuming qgroup rescan at mount time */
-		if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
+		if (!(fs_info->qgroup_flags &
+		      BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
 			btrfs_warn(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
-		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+			ret = -EINVAL;
+		} else if (!(fs_info->qgroup_flags &
+			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
 			btrfs_warn(fs_info,
 			"qgroup rescan init failed, qgroup rescan is not queued");
-		return -EINVAL;
+			ret = -EINVAL;
+		}
+
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-- 
2.11.0

