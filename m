Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54467 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330Ab3BGVVw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 16:21:52 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C43987C04D5
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2013 14:21:51 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id KyAReRvEvPLkPZcF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2013 14:21:51 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup orphan reservation if truncate fails
Date: Thu, 7 Feb 2013 16:28:44 -0500
Message-ID: <1360272524-19548-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed we were getting lots of warnings with xfstest 83 because we have
reservations outstanding.  This is because we moved the orphan add outside
of the truncate, but we don't actually cleanup our reservation if something
fails.  This fixes the problem and I no longer see warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 73e9409..905297f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2538,6 +2538,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				goto out;
 
 			ret = btrfs_truncate(inode);
+			if (ret)
+				btrfs_orphan_del(NULL, inode);
 		} else {
 			nr_unlink++;
 		}
-- 
1.7.7.6

