Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751828AbdLAJTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:52 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD196AD6D
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/5] btrfs: Fix possible off-by-one in  btrfs_search_path_in_tree
Date: Fri,  1 Dec 2017 11:19:42 +0200
Message-Id: <1512119984-12708-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1512119984-12708-1-git-send-email-nborisov@suse.com>
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The name char array passed to btrfs_search_path_in_tree is of size
BTRFS_INO_LOOKUP_PATH_MAX (4080). So the actual accessible char indexes
are in the range of [0, 4079]. Currently the code uses the define but this
represents an off-by-one.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e8adebc8c1b0..fc148b7c4265 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2206,7 +2206,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	if (!path)
 		return -ENOMEM;
 
-	ptr = &name[BTRFS_INO_LOOKUP_PATH_MAX];
+	ptr = &name[BTRFS_INO_LOOKUP_PATH_MAX - 1];
 
 	key.objectid = tree_id;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -2272,8 +2272,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 					   void __user *argp)
 {
-	 struct btrfs_ioctl_ino_lookup_args *args;
-	 struct inode *inode;
+	struct btrfs_ioctl_ino_lookup_args *args;
+	struct inode *inode;
 	int ret = 0;
 
 	args = memdup_user(argp, sizeof(*args));
-- 
2.7.4

