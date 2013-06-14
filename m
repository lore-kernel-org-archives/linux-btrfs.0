Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51149 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3FNVAW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 17:00:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 59C579A0686
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 15:00:21 -0600 (MDT)
Received: from mail1.int.fusionio.com ([10.101.1.21]) by mx1.fusionio.com with ESMTP id lhv1osdXBXMCi4cI (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 15:00:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: unlock extent range on enospc in compressed submit
Date: Fri, 14 Jun 2013 17:00:16 -0400
Message-ID: <1371243616-26732-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a deadlock where the async submit thread was blocked on the
lock_extent() lock, and then everybody behind him was locked on the page lock
for the page he was holding.  Looking at the code I noticed we do not unlock the
extent range when we get ENOSPC and goto retry.  This is bad because we
immediately try to lock that range again to do the cow, which will cause a
deadlock.  Fix this by unlocking the range.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 590c274..3dbfee9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -700,8 +700,12 @@ retry:
 			async_extent->nr_pages = 0;
 			async_extent->pages = NULL;
 
-			if (ret == -ENOSPC)
+			if (ret == -ENOSPC) {
+				unlock_extent(io_tree, async_extent->start,
+					      async_extent->start +
+					      async_extent->ram_size - 1);
 				goto retry;
+			}
 			goto out_free;
 		}
 
-- 
1.7.7.6

