Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:47221 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbbI1Nlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 09:41:39 -0400
From: Yaowei Bai <bywxiaobai@163.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] fs/btrfs: remove unnecessary new_valid_dev check
Date: Mon, 28 Sep 2015 21:39:00 +0800
Message-Id: <1443447540-5098-1-git-send-email-bywxiaobai@163.com>
In-Reply-To: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As new_valid_dev always returns 1, so !new_valid_dev check is not
needed, remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 611b66d..0946790 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6268,9 +6268,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
-- 
1.9.1


