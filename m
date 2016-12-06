Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40623 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbcLFEkJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 23:40:09 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: use BTRFS_COMPRESS_NONE to specify no compression
Date: Tue,  6 Dec 2016 12:43:07 +0800
Message-Id: <20161206044309.3450-2-anand.jain@oracle.com>
In-Reply-To: <20161206044309.3450-1-anand.jain@oracle.com>
References: <20161206044309.3450-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e3a5a266917..96e5f8a49d4c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -540,7 +540,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 * to make an uncompressed inline extent.
 			 */
 			ret = cow_file_range_inline(root, inode, start, end,
-						    0, 0, NULL);
+					    0, BTRFS_COMPRESS_NONE, NULL);
 		} else {
 			/* try making a compressed inline extent */
 			ret = cow_file_range_inline(root, inode, start, end,
@@ -969,8 +969,8 @@ static noinline int cow_file_range(struct inode *inode,
 
 	if (start == 0) {
 		/* lets try to make an inline extent */
-		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
-					    NULL);
+		ret = cow_file_range_inline(root, inode, start, end, 0,
+					BTRFS_COMPRESS_NONE, NULL);
 		if (ret == 0) {
 			extent_clear_unlock_delalloc(inode, start, end,
 				     delalloc_end, NULL,
-- 
2.10.0

