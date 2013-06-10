Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34376 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJPxs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 11:53:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 0EC6A9A0320
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 09:53:48 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id DzoKSERIkxa6BQrN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 09:53:47 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: wake up delayed ref flushing waiters on abort
Date: Mon, 10 Jun 2013 11:53:45 -0400
Message-ID: <1370879625-5136-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a deadlock because we aborted when flushing delayed refs but didn't wake
any of the other flushers up and so everybody was just sleeping forever.  This
should fix the problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f84d53b..ca1893e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2629,6 +2629,7 @@ again:
 			spin_unlock(&delayed_refs->lock);
 			btrfs_abort_transaction(trans, root, ret);
 			atomic_dec(&delayed_refs->procs_running_refs);
+			wake_up(&delayed_refs->wait);
 			return ret;
 		}
 
-- 
1.7.7.6

