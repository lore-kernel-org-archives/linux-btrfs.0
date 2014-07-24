Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38895 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaGXLvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 07:51:12 -0400
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 24 Jul 2014 17:21:06 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id E5E13E0057
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 17:22:45 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6OBod9T36831470
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 17:20:39 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6OBoiak029801
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 17:20:44 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] Btrfs: btrfs_put_tree_mod_seq: Don't delete an entry whose seq number is min_seq.
Date: Thu, 24 Jul 2014 17:20:33 +0530
Message-Id: <1406202633-17681-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current code allows a tree mod log entry whose seq number is equal to
min_seq to be deleted. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index aeab453..49a0df6 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -428,7 +428,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
 		tm = container_of(node, struct tree_mod_elem, node);
-		if (tm->seq > min_seq)
+		if (tm->seq >= min_seq)
 			continue;
 		rb_erase(node, tm_root);
 		kfree(tm);
-- 
1.8.3.1

