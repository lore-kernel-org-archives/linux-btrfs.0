Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35835 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755199AbbB0IYg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:36 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Nitw019793
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/7] btrfs: quota: Update quota tree after qgroup relationship change.
Date: Fri, 27 Feb 2015 16:24:28 +0800
Message-ID: <1425025468-29749-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previous patch modified the in memory struct but it's not written in
quota tree until next commit.
So user will still get old data using "btrfs qgroup show" after
assign/remove.

This patch will call btrfs_run_qgroups in assign ioctl so it will be
updated to in memory quota trees and user will get up-to-date results.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f93ca4b..62145ff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4631,6 +4631,11 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 						sa->src, sa->dst);
 	}
 
+	/* update qgroup status and info */
+	err = btrfs_run_qgroups(trans, root->fs_info);
+	if (err < 0)
+		btrfs_error(root->fs_info, ret,
+			    "failed to update qgroup status and info\n");
 	err = btrfs_end_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
-- 
2.3.0

