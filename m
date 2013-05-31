Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43066 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3EaRGs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 13:06:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E76219A0404
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 11:06:47 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id RaMcgbpx0ZY13iRQ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 11:06:47 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: init relocate extent_io_tree with a mapping
Date: Fri, 31 May 2013 13:06:45 -0400
Message-ID: <1370020005-3157-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave reported a NULL pointer deref.  This is caused because he thought he'd be
smart and add sanity checks to the extent_io bit operations, but he didn't
expect a tree to have a NULL mapping.  To fix this we just need to init the
relocation's processed_blocks with the btree_inode->i_mapping.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/relocation.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6dbee86..1b50c41 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4081,7 +4081,7 @@ out:
 	return inode;
 }
 
-static struct reloc_control *alloc_reloc_control(void)
+static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
 {
 	struct reloc_control *rc;
 
@@ -4092,7 +4092,8 @@ static struct reloc_control *alloc_reloc_control(void)
 	INIT_LIST_HEAD(&rc->reloc_roots);
 	backref_cache_init(&rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
-	extent_io_tree_init(&rc->processed_blocks, NULL);
+	extent_io_tree_init(&rc->processed_blocks,
+			    fs_info->btree_inode->i_mapping);
 	return rc;
 }
 
@@ -4109,7 +4110,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	int rw = 0;
 	int err = 0;
 
-	rc = alloc_reloc_control();
+	rc = alloc_reloc_control(fs_info);
 	if (!rc)
 		return -ENOMEM;
 
@@ -4310,7 +4311,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (list_empty(&reloc_roots))
 		goto out;
 
-	rc = alloc_reloc_control();
+	rc = alloc_reloc_control(root->fs_info);
 	if (!rc) {
 		err = -ENOMEM;
 		goto out;
-- 
1.7.7.6

