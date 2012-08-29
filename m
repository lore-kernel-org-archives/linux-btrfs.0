Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2H2EN0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 00:13:26 -0400
Message-ID: <503D96CE.4030903@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 12:13:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 5/7] Btrfs: fix wrong orphan count of the fs/file tree
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we add a new orphan item, we should increase the atomic counter,
not decrease it. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7131fac..cae4c32 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2222,7 +2222,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
-		atomic_dec(&root->orphan_inodes);
+		atomic_inc(&root->orphan_inodes);
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-- 
1.7.6.5
