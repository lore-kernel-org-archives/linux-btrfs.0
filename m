Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:60846 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2GJG7I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 02:59:08 -0400
Message-ID: <4FFBD2B2.6010001@huawei.com>
Date: Tue, 10 Jul 2012 14:58:58 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: zero unused bytes in inode item
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The otime field is not zeroed, so users will see random otime in an old
filesystem with a new kernel which has otime support in the future.

The reserved bytes are also not zeroed, and we'll have compatibility
issue if we make use of those bytes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/btrfs/delayed-inode.c |    1 +
 fs/btrfs/inode.c         |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 21d91a8..335605c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -62,6 +62,7 @@ static inline void btrfs_init_delayed_node(
 	INIT_LIST_HEAD(&delayed_node->n_list);
 	INIT_LIST_HEAD(&delayed_node->p_list);
 	delayed_node->bytes_reserved = 0;
+	memset(&delayed_node->inode_item, 0, sizeof(delayed_node->inode_item));
 }
 
 static inline int btrfs_is_continuous_delayed_item(
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b189dd8..3a612f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4688,6 +4688,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				  struct btrfs_inode_item);
+	memset_extent_buffer(path->nodes[0], 0, (unsigned long)inode_item,
+			     sizeof(*inode_item));
 	fill_inode_item(trans, path->nodes[0], inode_item, inode);
 
 	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
-- 
1.7.9.7
