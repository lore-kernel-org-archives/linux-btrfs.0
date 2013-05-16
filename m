Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50030 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3EPPP7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 11:15:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 04CD97C0423
	for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 09:15:59 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id zggfI8unasw2cU59 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 09:15:58 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do delay iput in sync_fs
Date: Thu, 16 May 2013 11:15:56 -0400
Message-ID: <1368717356-2299-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We get lock inversion with umount if we allow iputs from sync_fs, so use the
delay iput flag to keep this from happening.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 41d81be..14d2be0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -862,7 +862,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_all_ordered_extents(fs_info, 0);
+	btrfs_wait_all_ordered_extents(fs_info, 1);
 
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
-- 
1.7.7.6

