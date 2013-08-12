Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55550 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLTji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 15:39:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 773287C065C
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 13:39:38 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id zVKbeHB1z7zzRARw (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 13:39:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't allow a subvol to be deleted if it is the default subovl
Date: Mon, 12 Aug 2013 15:39:35 -0400
Message-ID: <1376336375-20631-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric pointed out that btrfs will happily allow you to delete the default subvol.
This is a problem obviously since the next time you go to mount the file system
it will freak out because it can't find the root.  Fix this by adding a check to
see if our default subvol points to the subvol we are trying to delete, and if
it does not allowing it to happen.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ioctl.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2312c0f..107c5f4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1726,13 +1726,28 @@ out:
 static noinline int may_destroy_subvol(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
 	struct btrfs_key key;
+	u64 dir_id;
 	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	/* Make sure this root isn't set as the default subvol */
+	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
+	di = btrfs_lookup_dir_item(NULL, root->fs_info->tree_root, path,
+				   dir_id, "default", 7, 0);
+	if (di && !IS_ERR(di)) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+		if (key.objectid == root->root_key.objectid) {
+			ret = -ENOTEMPTY;
+			goto out;
+		}
+		btrfs_release_path(path);
+	}
+
 	key.objectid = root->root_key.objectid;
 	key.type = BTRFS_ROOT_REF_KEY;
 	key.offset = (u64)-1;
-- 
1.7.7.6

