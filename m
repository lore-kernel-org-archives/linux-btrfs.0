Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52227 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3J1NPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 09:15:17 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C60059A0645
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 07:15:16 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id xFtNPD21nqez5N81 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 07:15:16 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: take ordered root lock when removing ordered operations inode
Date: Mon, 28 Oct 2013 09:15:14 -0400
Message-ID: <1382966114-18764-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a list corruption warning from btrfs_remove_ordered_extent, it
is because we aren't taking the ordered_root_lock when we remove the inode from
the ordered operations list.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ordered-data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bbb1a38..8a5eff3 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -537,7 +537,9 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	 */
 	if (RB_EMPTY_ROOT(&tree->tree) &&
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
+		spin_lock(&root->fs_info->ordered_root_lock);
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
+		spin_unlock(&root->fs_info->ordered_root_lock);
 	}
 
 	if (!root->nr_ordered_extents) {
-- 
1.8.3.1

