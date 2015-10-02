Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbJBKjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 06:39:51 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH] Btrfs: pass the error code to the btrfs_std_error and log ret
Date: Fri,  2 Oct 2015 18:40:41 +0800
Message-Id: <1443782441-31233-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will log return value of add/del_qgroup_relation()
and pass the err code of btrfs_run_qgroups to the btrfs_std_error().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f704d1c..043ad64 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4803,10 +4803,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 						sa->src, sa->dst);
 	}
 
+	if (ret)
+		btrfs_err(root->fs_info,
+			add/del qgroup relation failed, assign %llu ret %d",
+			sa->assign, ret);
+
 	/* update qgroup status and info */
 	err = btrfs_run_qgroups(trans, root->fs_info);
 	if (err < 0)
-		btrfs_std_error(root->fs_info, ret,
+		btrfs_std_error(root->fs_info, err,
 			    "failed to update qgroup status and info\n");
 	err = btrfs_end_transaction(trans, root);
 	if (err && !ret)
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
