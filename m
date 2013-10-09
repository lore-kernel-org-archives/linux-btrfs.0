Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46497 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3JIQ0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 12:26:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E37437C06B1
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 10:26:44 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id uHElAMHMtV9ZL6HD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 10:26:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use right root when checking for hash collision
Date: Wed, 9 Oct 2013 12:26:42 -0400
Message-ID: <1381336002-3016-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rename was using the root of the old dir instead of the root of the new
dir when checking for a hash collision, so if you tried to move a file into a
subvol it would freak out because it would see the file you are trying to move
in its current root.  This fixes the bug where this would fail

btrfs subvol create test1
btrfs subvol create test2
mv test1 test2.

Thanks to Chris Murphy for catching this,

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1d7ef37..d468246 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7993,7 +7993,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 
 	/* check for collisions, even if the  name isn't there */
-	ret = btrfs_check_dir_item_collision(root, new_dir->i_ino,
+	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len);
 
-- 
1.8.3.1

