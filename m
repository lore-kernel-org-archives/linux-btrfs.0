Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36469 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JRQKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 12:10:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AA2AD7C06B4
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 10:10:41 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id 1ytad8CNABplZk0v (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 10:10:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: release path before starting transaction in can_nocow_extent
Date: Fri, 18 Oct 2013 12:10:36 -0400
Message-ID: <1382112636-13603-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can't be holding tree locks while we try to start a transaction, we will
deadlock.  Thanks,

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 974323a..30bdacd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6452,6 +6452,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 
 	if (btrfs_extent_readonly(root, disk_bytenr))
 		goto out;
+	btrfs_release_path(path);
 
 	/*
 	 * look for other files referencing this extent, if we
-- 
1.8.3.1

