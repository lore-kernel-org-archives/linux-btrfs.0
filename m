Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54301 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2HMToK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 15:44:10 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id wQA1j7hE2GO0sysV (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2012 13:44:09 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: update last trans if we don't update the inode
Date: Mon, 13 Aug 2012 15:49:17 -0400
Message-ID: <1344887357-1936-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a completely impossible situation to hit where you can preallocate
a file, fsync it, write into the preallocated region, have the transaction
commit twice and then fsync and then immediately lose power and lose all of
the contents of the write.  This patch fixes this just so I feel better
about the situation and because it is lightweight, we just update the
last_trans when we finish an ordered IO and we don't update the inode
itself.  This way we are completely safe and I feel better.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d331d96..a391cba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1947,6 +1947,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			btrfs_abort_transaction(trans, root, ret);
 			goto out_unlock;
 		}
+	} else {
+		btrfs_set_inode_last_trans(trans, inode);
 	}
 	ret = 0;
 out_unlock:
-- 
1.7.7.6

