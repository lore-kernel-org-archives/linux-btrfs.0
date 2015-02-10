Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41413 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbbBJK1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:08 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQLht000899
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:21 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs: qgroup: free reserved in exceeding quota.
Date: Tue, 10 Feb 2015 18:23:45 +0800
Message-ID: <1423563828-9053-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we exceed quota limit in writing, we will free
some reserved extent when we need to drop but not free
account in qgroup. It means, each time we exceed quota
in writing, there will be some remain space in qg->reserved
we can not use any more. If things go on like this, the
all space will be ate up.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a80b971..88b4e32 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5275,8 +5275,11 @@ out_fail:
 			to_free = 0;
 	}
 	spin_unlock(&BTRFS_I(inode)->lock);
-	if (dropped)
+	if (dropped) {
+		if (root->fs_info->quota_enabled)
+			btrfs_qgroup_free(root, dropped * root->nodesize);
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
+	}
 
 	if (to_free) {
 		btrfs_block_rsv_release(root, block_rsv, to_free);
-- 
1.8.4.2

