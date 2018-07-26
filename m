Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727790AbeGZIO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 04:14:29 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB2C1ACF3
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:59:04 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is initialized without rescan initialized
Date: Thu, 26 Jul 2018 14:59:00 +0800
Message-Id: <20180726065900.8469-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Under certain case, btrfs/166 could cause power loss just after quota
tree initialized but rescan not kicked in.

In this case, since flags of qgroup status item is just ON |
INCONSISTENT, without RESCAN flag, rescan won't be kicked in in next
mount.

Now kick in rescan automatically for such situation, so user won't need
to do rescan manually.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c25dc47210a3..e62598fc354f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -392,6 +392,17 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
 			rescan_progress = btrfs_qgroup_status_rescan(l, ptr);
+
+			/*
+			 * Qgroup is enabled but rescan hans't kicked in and
+			 * power loss happened, kick rescan in
+			 */
+			if (rescan_progress == 0 &&
+			    (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
+			     BTRFS_QGROUP_STATUS_FLAG_ON) ==
+			    fs_info->qgroup_flags)
+				fs_info->qgroup_flags |=
+					BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 			goto next1;
 		}
 
-- 
2.18.0

