Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab3EOHsl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:41 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 07/17] Btrfs: don't invoke btrfs_invalidate_inodes() in the spin lock context
Date: Wed, 15 May 2013 15:48:21 +0800
Message-Id: <1368604111-25073-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_invalidate_inodes() may sleep, so we should not invoke it in the
spin lock context. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 642c861..724a0da 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3685,8 +3685,11 @@ static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
 					 ordered_operations);
 
 		list_del_init(&btrfs_inode->ordered_operations);
+		spin_unlock(&root->fs_info->ordered_extent_lock);
 
 		btrfs_invalidate_inodes(btrfs_inode->root);
+
+		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
@@ -3808,8 +3811,11 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 		list_del_init(&btrfs_inode->delalloc_inodes);
 		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
 			  &btrfs_inode->runtime_flags);
+		spin_unlock(&root->fs_info->delalloc_lock);
 
 		btrfs_invalidate_inodes(btrfs_inode->root);
+
+		spin_lock(&root->fs_info->delalloc_lock);
 	}
 
 	spin_unlock(&root->fs_info->delalloc_lock);
-- 
1.8.1.4

