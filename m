Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2GDNzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:55:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q64DgqxV028818
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Jul 2012 21:42:53 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] Btrfs: fix a bug of writting free space cache with nodatacow option
Date: Wed, 4 Jul 2012 21:52:56 +0800
Message-Id: <1341409978-22423-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341409978-22423-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341409978-22423-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can set a block group readonly when we relocate the block group.

If the block group covers the disk offset where our free space
cache inode is going to write, it will force the free space cache
inode into cow_file_range(), which is not allowed due to free space
cache design.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f72817..4892396 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1245,7 +1245,11 @@ next_slot:
 				goto out_check;
 			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
 				goto out_check;
-			if (btrfs_extent_readonly(root, disk_bytenr))
+			/*
+			 * nolock means that we're free space cache inode, and
+			 * free space cache inode cannot go to cow_file_range().
+			 */
+			if (btrfs_extent_readonly(root, disk_bytenr) && !nolock)
 				goto out_check;
 			if (btrfs_cross_ref_exist(trans, root, ino,
 						  found_key.offset -
-- 
1.6.5.2

