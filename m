Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11743 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab2KAHec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:34:32 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qA17YVNO031258
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 15:34:31 +0800
Message-ID: <5092261E.2020702@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:34:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: fix unprotected extent map operation when logging
 file extents
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to protect the modified_extents list, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cbb544e..f7e9387 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3525,8 +3525,10 @@ next_slot:
 		struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
 		struct extent_map *em, *n;
 
+		write_lock(&tree->lock);
 		list_for_each_entry_safe(em, n, &tree->modified_extents, list)
 			list_del_init(&em->list);
+		write_unlock(&tree->lock);
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-- 
1.7.6.5
