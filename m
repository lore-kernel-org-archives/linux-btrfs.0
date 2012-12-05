Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54479 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2LEKxB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 05:53:01 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qB5Ar5Ni019298
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Dec 2012 18:53:05 +0800
Message-ID: <50BF27A5.8070603@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 18:53:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] Btrfs: fix missing reserved space release in error path
 of delalloc reservation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to release the reserved space in the error path of delalloc
reservatiom, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..1cd71b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4572,6 +4572,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		ret = btrfs_qgroup_reserve(root, num_bytes +
 					   nr_extents * root->leafsize);
 		if (ret) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			calc_csum_metadata_size(inode, num_bytes, 0);
+			spin_unlock(&BTRFS_I(inode)->lock);
 			mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 			return ret;
 		}
@@ -4607,6 +4610,10 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 						      btrfs_ino(inode),
 						      to_free, 0);
 		}
+		if (root->fs_info->quota_enabled) {
+			btrfs_qgroup_free(root, num_bytes +
+						nr_extents * root->leafsize);
+		}
 		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 		return ret;
 	}
-- 
1.7.11.7
