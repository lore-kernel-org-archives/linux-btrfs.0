Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54244 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbbFIFFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 01:05:36 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 10:35:34 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 7A43DE0054
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2015 10:38:52 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5955Mwn39387194
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 10:35:23 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5955Lwv025390
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 10:35:22 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz,
        chandan@mykolab.com
Subject: [PATCH V2] Btrfs: btrfs_defrag_file: Fix calculation of max_to_defrag.
Date: Tue,  9 Jun 2015 10:35:11 +0530
Message-Id: <1433826311-3345-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

max_to_defrag represents the number of pages to defrag rather than the last
page of the file range to be defragged.

Consider a file having 10 4k blocks (i.e. blocks in the range [0 - 9]). If the
defrag ioctl was invoked for the block range [3 - 6], then max_to_defrag
should actually have the value 4. Instead in the current code we end up
setting it to 6.

Now, this does not (yet) cause an issue since the first part of the while loop
condition in btrfs_defrag_file() (i.e. "i <= last_index") causes the control
to flow out of the while loop before any buggy behavior is actually caused. So
the patch just makes sure that max_to_defrag ends up having the right value
rather than fixing a bug. I did run the xfstests suite to make sure that the
code does not regress.

Changelog: v1->v2:
Provide a much descriptive commit message.

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

