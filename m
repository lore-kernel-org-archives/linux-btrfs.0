Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34159 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3JNQKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 12:10:46 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 425307C068C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 10:10:46 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id qFfJ8nPDNQtzoGGt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 10:10:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle a missing extent for the first file extent
Date: Mon, 14 Oct 2013 12:10:43 -0400
Message-ID: <1381767043-4582-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to kill our hole extents I noticed I was seeing problems where we
seek into a file and then start writing and then try to fiemap that file later.
This is because we search for offset 0, don't find anything and so back up one
slot, which puts us at the inode ref or something like that, which means we goto
not_found and create an extent map for our entire search area.  This isn't quite
what we want, we want to move forward one slot and see if there is an extent
there so we can limit our hole extent.  This patch fixes this problem, I will
add a testcase for this as well.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 09c950b..974323a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5982,7 +5982,14 @@ again:
 	found_type = btrfs_key_type(&found_key);
 	if (found_key.objectid != objectid ||
 	    found_type != BTRFS_EXTENT_DATA_KEY) {
-		goto not_found;
+		/*
+		 * If we backup past the first extent we want to move forward
+		 * and see if there is an extent in front of us, otherwise we'll
+		 * say there is a hole for our whole search range which can
+		 * cause problems.
+		 */
+		extent_end = start;
+		goto next;
 	}
 
 	found_type = btrfs_file_extent_type(leaf, item);
@@ -5997,7 +6004,7 @@ again:
 		size = btrfs_file_extent_inline_len(leaf, item);
 		extent_end = ALIGN(extent_start + size, root->sectorsize);
 	}
-
+next:
 	if (start >= extent_end) {
 		path->slots[0]++;
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
-- 
1.8.3.1

