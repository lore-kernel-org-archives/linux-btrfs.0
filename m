Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41650 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3IQP1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:27:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 46D8B7C06A0
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 09:27:50 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id orOqpxgDF12rr5Wr (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 09:27:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: iput inode on allocation failure
Date: Tue, 17 Sep 2013 11:27:47 -0400
Message-ID: <1379431667-7176-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't do the iput when we fail to allocate our delayed delalloc work in
__start_delalloc_inodes, fix this.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85a4900..7988113 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8211,6 +8211,10 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 
 		work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
 		if (unlikely(!work)) {
+			if (delay_iput)
+				btrfs_add_delayed_iput(inode);
+			else
+				iput(inode);
 			ret = -ENOMEM;
 			goto out;
 		}
-- 
1.7.7.6

