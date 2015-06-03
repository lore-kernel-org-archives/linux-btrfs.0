Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44079 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbbFCJbE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 05:31:04 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 3 Jun 2015 19:31:00 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 127822BB0059
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 19:30:57 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t539UkRS34799860
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 19:30:55 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t539UMTe010289
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 19:30:23 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: btrfs_defrag_file: Fix calculation of max_to_defrag.
Date: Wed,  3 Jun 2015 14:59:54 +0530
Message-Id: <1433323794-10045-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

max_to_defrag represents the number of pages to defrag rather than the last
page of the file range to be defragged. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ca5d968..2a45026 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1318,7 +1318,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		i = range->start >> PAGE_CACHE_SHIFT;
 	}
 	if (!max_to_defrag)
-		max_to_defrag = last_index + 1;
+		max_to_defrag = last_index - i + 1;
 
 	/*
 	 * make writeback starts from i, so the defrag range can be
-- 
2.1.0

