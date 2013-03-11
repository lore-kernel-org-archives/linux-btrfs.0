Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34935 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3CKJVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 05:21:44 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2B9Lfqg000502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 09:21:42 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2B9LeWA009985
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 09:21:41 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2B9LeWN003055
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 04:21:40 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: update to use fs_state bit
Date: Mon, 11 Mar 2013 17:20:00 +0800
Message-Id: <1362993600-30072-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we use bit operation to check fs_state, update
btrfs_free_fs_root()'s checker, otherwise we get back to
memory leak case.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02369a3..e388e39 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3253,7 +3253,7 @@ void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	if (btrfs_root_refs(&root->root_item) == 0)
 		synchronize_srcu(&fs_info->subvol_srcu);
 
-	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
 		btrfs_free_log(NULL, root);
 		btrfs_free_log_root_tree(NULL, fs_info);
 	}
-- 
1.7.7.6

