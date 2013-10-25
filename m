Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38146 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3JYUUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 16:20:13 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 883D29A0371
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:20:12 -0600 (MDT)
Received: from CAS2.int.fusionio.com ([10.101.1.41]) by mx2.fusionio.com with ESMTP id glqozSuEr1XycQjf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:20:12 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not bug_on if we try to cow a free space cache inode
Date: Fri, 25 Oct 2013 16:20:10 -0400
Message-ID: <1382732410-11444-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can just return an error and we'll bail out properly.  We still want to catch
this case to make sure we don't have a bug somewhere, so just warn if this pops
up.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 961ae6f..db6e11f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -843,7 +843,10 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
-	BUG_ON(btrfs_is_free_space_inode(inode));
+	if (btrfs_is_free_space_inode(inode)) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
-- 
1.8.3.1

