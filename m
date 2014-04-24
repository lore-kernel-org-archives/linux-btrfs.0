Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751265AbaDXFaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 01:30:12 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O5U7kK011757
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:30:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 1/2] Btrfs: output warning instead of error when loading free space cache failed
Date: Thu, 24 Apr 2014 13:31:55 +0800
Message-ID: <1398317516-29575-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
References: <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail to load a free space cache, we can rebuild it from the extent tree,
so it is not a serious error, we should not output a error message that
would make the users uncomfortable. This patch uses warning message instead
of it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 73f3de7..a6bd654 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -831,7 +831,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	if (!matched) {
 		__btrfs_remove_free_space_cache(ctl);
-		btrfs_err(fs_info, "block group %llu has wrong amount of free space",
+		btrfs_warn(fs_info, "block group %llu has wrong amount of free space",
 			block_group->key.objectid);
 		ret = -1;
 	}
@@ -843,7 +843,7 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		btrfs_err(fs_info, "failed to load free space cache for block group %llu",
+		btrfs_warn(fs_info, "failed to load free space cache for block group %llu, rebuild it now",
 			block_group->key.objectid);
 	}
 
-- 
1.9.0

