Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35206 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab2JVTuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 15:50:06 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id goeRa3poT7r0dBXx (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:50:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not bug when we fail to commit the transaction
Date: Mon, 22 Oct 2012 15:55:51 -0400
Message-ID: <1350935751-3155-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We BUG if we fail to commit the transaction when creating a snapshot, which
is just obnoxious.  Remove the BUG_ON().  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3b8b509..8fcf9a5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -571,7 +571,8 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		ret = btrfs_commit_transaction(trans,
 					       root->fs_info->extent_root);
 	}
-	BUG_ON(ret);
+	if (ret)
+		goto fail;
 
 	ret = pending_snapshot->error;
 	if (ret)
-- 
1.7.7.6

