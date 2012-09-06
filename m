Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab2IFKos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:48 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A2LSo017560
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:02:24 +0800
Message-ID: <504874A1.5000500@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:02:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 05/12] Btrfs: fix wrong orphan count of the fs/file tree
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

If we add a new orphan item, we should increase the atomic counter,
not decrease it. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- No change.
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6ba80b9..e954737 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2224,7 +2224,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
-		atomic_dec(&root->orphan_inodes);
+		atomic_inc(&root->orphan_inodes);
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-- 
1.7.6.5
