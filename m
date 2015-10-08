Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:15337 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754173AbbJHLCt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 07:02:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t98B1AUi030407
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Oct 2015 19:01:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 3/3] btrfs: Use fs_info directly in btrfs_delete_unused_bgs
Date: Thu, 8 Oct 2015 18:59:55 +0800
Message-ID: <cffab2f9d9e394568bdd21de211b171516d61c49.1444301652.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444301651.git.zhaolei@cn.fujitsu.com>
References: <cover.1444301651.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to use root->fs_info in btrfs_delete_unused_bgs(),
use fs_info directly instead.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 00c621b..c93a77a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10020,7 +10020,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		}
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		mutex_lock(&root->fs_info->delete_unused_bgs_mutex);
+		mutex_lock(&fs_info->delete_unused_bgs_mutex);
 
 		/* Don't want to race with allocators so take the groups_sem */
 		down_write(&space_info->groups_sem);
@@ -10144,7 +10144,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 end_trans:
 		btrfs_end_transaction(trans, root);
 next:
-		mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
 	}
-- 
1.8.5.1

