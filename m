Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54322 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2FTBJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 21:09:19 -0400
Received: by qcro28 with SMTP id o28so3893442qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 18:09:18 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH] btrfs: ignore unfragmented file checks in defrag when compression enabled - rebased
Date: Tue, 19 Jun 2012 21:08:32 -0400
Message-Id: <1340154512-9402-1-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <20120619150148.GA1705@localhost.localdomain>
References: <20120619150148.GA1705@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rebased on btrfs-next and retested.

Inform should_defrag_range if BTRFS_DEFRAG_RANGE_COMPRESS is set. If so, skip
checks for adjacent extents and extent size when deciding whether to defrag,
as these can prevent an uncompressed and unfragmented file from being
compressed as requested.

Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..9ec23b9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -832,7 +832,8 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 }
 
 static int should_defrag_range(struct inode *inode, u64 start, int thresh,
-			       u64 *last_len, u64 *skip, u64 *defrag_end)
+			       u64 *last_len, u64 *skip, u64 *defrag_end,
+			       int compress)
 {
 	struct extent_map *em;
 	int ret = 1;
@@ -863,7 +864,7 @@ static int should_defrag_range(struct inode *inode, u64 start, int thresh,
 	 * we hit a real extent, if it is big or the next extent is not a
 	 * real extent, don't bother defragging it
 	 */
-	if ((*last_len == 0 || *last_len >= thresh) &&
+	if (!compress && (*last_len == 0 || *last_len >= thresh) &&
 	    (em->len >= thresh || !next_mergeable))
 		ret = 0;
 out:
@@ -1145,7 +1146,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
 					 extent_thresh, &last_len, &skip,
-					 &defrag_end)) {
+					 &defrag_end, range->flags &
+					 BTRFS_DEFRAG_RANGE_COMPRESS)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
1.7.10.4

