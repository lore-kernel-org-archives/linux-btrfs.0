Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51548 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932716AbdJ3SRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 14:17:06 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9UIH5q5014997
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9UIH5BZ012881
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:05 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9UIH5VE006145
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: bail out gracefully rather than BUG_ON
Date: Mon, 30 Oct 2017 11:14:38 -0600
Message-Id: <20171030171440.27044-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file's DIR_ITEM key is invalid (due to memory errors) and gets
written to disk, a future lookup_path can end up with kernel panic due
to BUG_ON().

This gets rid of the BUG_ON(), meanwhile output the corrupted key and
return ENOENT if it's invalid.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
The diff doesn't show the logic well, 'goto out_err' will return with
assigning 0 to location->objectid, and the caller already has a check
for (location->objectid == 0) to return -ENOENT.

 fs/btrfs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d94e3f6..916cdc9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5500,6 +5500,14 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 		goto out_err;
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
+	if (location->type != BTRFS_INODE_ITEM_KEY &&
+	    location->type != BTRFS_ROOT_ITEM_KEY) {
+		btrfs_warn(root->fs_info,
+	  "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
+			   __func__, name, btrfs_ino(BTRFS_I(dir)),
+			   location->objectid, location->type, location->offset);
+		goto out_err;
+	}
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -5816,8 +5824,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		return inode;
 	}
 
-	BUG_ON(location.type != BTRFS_ROOT_ITEM_KEY);
-
 	index = srcu_read_lock(&fs_info->subvol_srcu);
 	ret = fixup_tree_root_location(fs_info, dir, dentry,
 				       &location, &sub_root);
-- 
2.9.4

