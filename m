Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728690AbeGZKbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 06:31:04 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15C7FAE06
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 09:15:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable time
Date: Thu, 26 Jul 2018 17:15:04 +0800
Message-Id: <20180726091504.5833-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Between btrfs_quota_enable() finished and rescan kicked in, there is a
small window that quota status has (ON | INCONSISTENT) bits set but
without RESCAN bits set.

And transaction is committed inside the window and then power loss
happens, we will have a quota tree with all qgroup numbers set to 0, and
not RESCAN bit set.

At next mount time, qgroup rescan will not kick in due to the missing of
RESCAN bit, user needs to kick in rescan manually.

This patch will fix it by setting RESCAN bit at btrfs_quota_enable(),
so even after power loss we will still kick in rescan automatically.

Suggested-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c25dc47210a3..13c1c7dd278d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -930,7 +930,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
 	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VERSION);
 	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
-				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
+				BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
 	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
 
@@ -987,7 +988,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
-	ret = qgroup_rescan_init(fs_info, 0, 1);
+	ret = qgroup_rescan_init(fs_info, 0, 0);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
 	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
-- 
2.18.0

