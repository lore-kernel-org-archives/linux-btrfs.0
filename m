Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbbELROw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 13:14:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CC93EAABA
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 17:14:50 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make root id query unprivileged
Date: Tue, 12 May 2015 19:14:49 +0200
Message-Id: <1431450889-27968-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The INO_LOOKUP ioctl can lookup path for a given inode number and is
thus restricted. As a sideefect it can find the root id of the
containing subvolume and we're using this int the 'btrfs inspect rootid'
command.

The restriction is unnecessary in case we set the ioctl args
 args::treeid    = 0
 args::objectid  = 256 (BTRFS_FIRST_FREE_OBJECTID)

Then the path will be empty and the treeid is filled with the root id of
the inode on which the ioctl is called. This behaviour is unchanged,
after the root restriction is removed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

 fs/btrfs/ioctl.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c6518504..578ff63a9b74 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2271,10 +2271,7 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 {
 	 struct btrfs_ioctl_ino_lookup_args *args;
 	 struct inode *inode;
-	 int ret;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	int ret = 0;
 
 	args = memdup_user(argp, sizeof(*args));
 	if (IS_ERR(args))
@@ -2282,13 +2279,28 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 
 	inode = file_inode(file);
 
+	/*
+	 * Unprivileged query to obtain the containing subvolume root id. The
+	 * path is reset so it's consistent with btrfs_search_path_in_tree.
+	 */
 	if (args->treeid == 0)
 		args->treeid = BTRFS_I(inode)->root->root_key.objectid;
 
+	if (args->objectid == BTRFS_FIRST_FREE_OBJECTID) {
+		args->name[0] = 0;
+		goto out;
+	}
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	ret = btrfs_search_path_in_tree(BTRFS_I(inode)->root->fs_info,
 					args->treeid, args->objectid,
 					args->name);
 
+out:
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
 
-- 
1.8.4.5

