Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3DKKcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 06:32:15 -0400
Message-ID: <5166917B.5040606@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:33:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/2] Btrfs: set the INCOMPAT_EXTENDED_IREF when the extended
 iref is inserted
References: <51669144.20107@cn.fujitsu.com>
In-Reply-To: <51669144.20107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We needn't set the INCOMAT_EXTENDED_IREF when making a new fs, just
do it after we insert a  extended iref successfully. Otherwise, we
can not mount the fs in which there is no extended iref in fact on
the old kernel, it is not so flexible for the users.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/inode-item.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 48b8fda..f07eb45 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -443,15 +443,15 @@ out:
 	btrfs_free_path(path);
 
 	if (ret == -EMLINK) {
-		struct btrfs_super_block *disk_super = root->fs_info->super_copy;
-		/* We ran out of space in the ref array. Need to
-		 * add an extended ref. */
-		if (btrfs_super_incompat_flags(disk_super)
-		    & BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
-			ret = btrfs_insert_inode_extref(trans, root, name,
-							name_len,
-							inode_objectid,
-							ref_objectid, index);
+		/*
+		 * We ran out of space in the ref array. Need to add an
+		 * extended ref.
+		 */
+		ret = btrfs_insert_inode_extref(trans, root, name, name_len,
+						inode_objectid, ref_objectid,
+						index);
+		if (!ret)
+			btrfs_set_fs_incompat(root->fs_info, EXTENDED_IREF);
 	}
 
 	return ret;
-- 
1.8.0.1

