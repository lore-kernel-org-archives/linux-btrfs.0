Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58753 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281AbaLLIrV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 03:47:21 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v2 1/2] Btrfs: qgroup: free reserved in exceeding quota.
Date: Fri, 12 Dec 2014 16:44:34 +0800
Message-ID: <1418373875-2921-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <548A3A5A.2070206@cn.fujitsu.com>
References: <548A3A5A.2070206@cn.fujitsu.com>
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
index a84e00d..014b7f2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5262,8 +5262,11 @@ out_fail:
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

