Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750753AbbIBHVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 03:21:38 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t827LQap014240
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 15:21:26 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix a compiler warning of may be used uninitialized
Date: Wed, 2 Sep 2015 15:19:59 +0800
Message-ID: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not real problem, just avoid warning of:
 fs/btrfs/inode-map.c: In function 'btrfs_unpin_free_ino':
 fs/btrfs/inode-map.c:252: warning: 'count' may be used uninitialized in this function
In gcc 4.8.3

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/inode-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d4a582a..e094e3b 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -249,7 +249,7 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
 	spinlock_t *rbroot_lock = &root->free_ino_pinned->tree_lock;
 	struct btrfs_free_space *info;
 	struct rb_node *n;
-	u64 count;
+	u64 count = 0;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return;
-- 
1.8.5.1

