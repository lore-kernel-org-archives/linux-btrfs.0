Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34297 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNOm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 09:14:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3413A9A06A8
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 07:14:42 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id FnYxnVwmAIwDVFE1 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 07:14:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't bother autodefragging if our root is going away
Date: Fri, 26 Jul 2013 09:14:38 -0400
Message-ID: <1374844478-5531-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can end up with inodes on the auto defrag list that exist on roots that are
going to be deleted.  This is extra work we don't need to do, so just bail if
our root has 0 root refs.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 94413af..36ddd20 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -310,6 +310,11 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 		goto cleanup;
 	}
 
+	if (btrfs_root_refs(&inode_root->root_item) == 0) {
+		ret = -ENOENT;
+		goto cleanup;
+	}
+
 	key.objectid = defrag->ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
-- 
1.7.7.6

