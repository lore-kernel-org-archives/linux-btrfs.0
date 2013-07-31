Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49418 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3GaO30 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 10:29:26 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F289B9A06A4
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 08:29:25 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id kXO1j8FvCOHPVi9x (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 08:29:25 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't bug_on when we fail when cleaning up transactions
Date: Wed, 31 Jul 2013 10:29:23 -0400
Message-ID: <1375280963-2043-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no reason for this sort of jackassery.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/transaction.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 18f7e71..ea8d522 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1942,6 +1942,5 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	 * If we encounter a transaction abort during snapshot cleaning, we
 	 * don't want to crash here
 	 */
-	BUG_ON(ret < 0 && ret != -EAGAIN && ret != -EROFS);
-	return 1;
+	return (ret < 0) ? 0 : 1;
 }
-- 
1.7.7.6

