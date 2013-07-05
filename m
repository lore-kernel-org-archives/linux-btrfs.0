Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53025 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3GEVHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 17:07:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 884717C069D
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 15:07:55 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id ePBwFcwRyK4hJiFN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 15:07:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set lockdep class before locking new extent buffer
Date: Fri, 5 Jul 2013 17:07:52 -0400
Message-ID: <1373058472-13834-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've been seeing spurious complaints out of lockdep because the lock class name
changes.  This is happening because when we drop a snapshot we will lock a block
before we've read it in, which sets the lockdep class to whatever the default
is.  Then once we read the thing in we reset the lockdep class to what it is
supposed to be, which blows lockdeps' mind.  This patch should fix the problem,
it appears to be the only place where we do this sort of thing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..d275681 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7173,6 +7173,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (!next)
 			return -ENOMEM;
+		btrfs_set_buffer_lockdep_class(root->root_key.objectid, next,
+					       level - 1);
 		reada = 1;
 	}
 	btrfs_tree_lock(next);
-- 
1.7.7.6

