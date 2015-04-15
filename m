Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55382 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbDONRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Apr 2015 09:17:01 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 15 Apr 2015 18:46:58 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 5A5CCE0045
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 18:49:28 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3FDGsEk19071158
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 18:46:55 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3FDGsJE013402
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 18:46:54 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: Allow creation of inline extent whose size is equal to blocksize.
Date: Wed, 15 Apr 2015 18:46:27 +0530
Message-Id: <1429103787-21888-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the current code, the following command (executed on a filesystem with 4k
as the block size) creates a file with a regular extent:
$ xfs_io -f -c "pwrite 0 4096" /mnt/file-0.bin; sync;

This commit fixes the issue by checking if 'actual_end - 1' is on a file
offset which is a multiple of block size.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 97bc1ff..b0925ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -259,8 +259,8 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	if (start > 0 ||
 	    actual_end > PAGE_CACHE_SIZE ||
 	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
-	    (!compressed_size &&
-	    (actual_end & (root->sectorsize - 1)) == 0) ||
+	    (!compressed_size && (actual_end > 1) &&
+		    ((actual_end - 1) & (root->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
 	    data_len > root->fs_info->max_inline) {
 		return 1;
-- 
2.1.0

