Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbcBMCB6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:01:58 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/13] btrfs: pass the error code to the btrfs_std_error and log ret
Date: Sat, 13 Feb 2016 10:01:28 +0800
Message-Id: <1455328900-1476-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will log return value of add/del_qgroup_relation() and pass the
err code of btrfs_run_qgroups to the btrfs_std_error().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: fix the forgotten git commit amend, to take in compile fail, sorry

 fs/btrfs/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 293ecd0..e54a4e9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4841,10 +4841,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 						sa->src, sa->dst);
 	}
 
+	if (ret)
+		btrfs_err(root->fs_info,
+			"add/del qgroup relation failed, assign %llu ret %d",
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
2.7.0

