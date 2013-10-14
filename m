Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57200 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3JNNPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 09:15:50 -0400
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 14 Oct 2013 23:15:48 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id E0E502BB0040
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 00:15:44 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r9EDFXv010092802
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 00:15:33 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r9EDFi1Y023162
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 00:15:44 +1100
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com
Subject: [PATCH] Btrfs: btrfs_add_ordered_operation: Fix last modified transaction comparison.
Date: Mon, 14 Oct 2013 18:44:39 +0530
Message-ID: <2154670.aaEungM0qy@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Comparison of an inode's last modified transaction with the last committed
transaction is incorrect. Fix it.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ordered-data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c702cb6..1a36a0c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1076,7 +1076,7 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	 * if this file hasn't been changed since the last transaction
 	 * commit, we can safely return without doing anything
 	 */
-	if (last_mod < root->fs_info->last_trans_committed)
+	if (last_mod <= root->fs_info->last_trans_committed)
 		return;
 
 	spin_lock(&root->fs_info->ordered_root_lock);
-- 
1.8.3.1


