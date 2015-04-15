Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25587 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964862AbbDOSdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Apr 2015 14:33:24 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3FIWeci025433
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 11:33:24 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1tsvqb85fr-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 11:33:24 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: log entire range for FULL_SYNC
Date: Wed, 15 Apr 2015 14:33:21 -0400
Message-ID: <1429122801-3096-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My log writes test uncovered a corruption that could happen with fsx'es mmap
write.  It does an msync(MS_SYNC) after every mmap write, which turns into a
vfs_fsync_range() for the range we wrote.  However if we've truncated before
this we will set FULL_SYNC on the inode, so if we've truncated up and then only
log up to the range we've inlcluded then fsck complains because i_size is > the
last extent in the flie.  Fix this by making sure we log the entire file and not
just the range requested.  With this patch we now pass the log writes test.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 23b6e03..46c7227 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1901,8 +1901,13 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		 * start and finish before we start logging the inode, so that
 		 * all extents are persisted and the respective file extent
 		 * items are in the fs/subvol btree.
+		 *
+		 * We also need to do the whole range, we set FULL_SYNC if we
+		 * truncated, and we could have some previous version of the
+		 * inode in the log, so we need to write and log all the things.
 		 */
-		ret = btrfs_wait_ordered_range(inode, start, end - start + 1);
+		end = (u64)-1;
+		ret = btrfs_wait_ordered_range(inode, start, end);
 	} else {
 		/*
 		 * Start any new ordered operations before starting to log the
-- 
1.8.3.1

