Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26119 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756686AbcLUHiy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 02:38:54 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/2 RFC] btrfs: btrfs_defrag_root() doesn't defrag extent root tree
Date: Wed, 21 Dec 2016 15:42:08 +0800
Message-Id: <20161221074208.32597-2-anand.jain@oracle.com>
In-Reply-To: <20161221074208.32597-1-anand.jain@oracle.com>
References: <20161221074208.32597-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_defrag_leaves() does not support extent_root,
remove its corresponding call. The user can use the file
based defrag to defrag extents as of now.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bd1bb7fcea8a..112456baffe9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2613,9 +2613,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 		ret = btrfs_defrag_root(root);
-		if (ret)
-			goto out;
-		ret = btrfs_defrag_root(root->fs_info->extent_root);
 		break;
 	case S_IFREG:
 		if (!(file->f_mode & FMODE_WRITE)) {
-- 
2.10.0

