Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58892 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965222Ab3DQQTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 12:19:20 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9D1569A033F
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 10:19:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 0XIP91giuBLmgfaL (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 10:19:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix lockdep warning
Date: Wed, 17 Apr 2013 12:19:16 -0400
Message-ID: <1366215556-8586-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The locking order for stuff is

__sb_start_write
ordered_mutex

but with sync() we don't do __sb_start_write for some strange reason, which
means that our iput in wait_ordered_extents could start a transaction which does
the __sb_start_write while we're holding the ordered_mutex.  Fix this by using
delayed iput in sync.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bb60fe5..2a0bece 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -866,7 +866,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_wait_ordered_extents(root, 1);
 
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
-- 
1.7.7.6

