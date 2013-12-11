Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:59701 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3LKXkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:40:52 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:40:52 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 1739C3E40044
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:51 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLcgjp5964062
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:38:42 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNeoSO031175
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:50 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/7] btrfs: subpagesize-blocksize: Handle small extent maps properly
Date: Wed, 11 Dec 2013 17:38:38 -0600
Message-Id: <1386805122-23972-4-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes sure that the size extent maps handles are at
least PAGE_CACHE_SIZE for the subpagesize-blocksize case.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c79c9cd..c0c18ca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6036,7 +6036,11 @@ next:
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		em->start = extent_start;
-		em->len = extent_end - extent_start;
+		if (inode->i_sb->s_blocksize < PAGE_CACHE_SIZE &&
+				em->len < PAGE_CACHE_SIZE)
+			em->len = PAGE_CACHE_SIZE;
+		else
+			em->len = extent_end - extent_start;
 		em->orig_start = extent_start -
 				 btrfs_file_extent_offset(leaf, item);
 		em->orig_block_len = btrfs_file_extent_disk_num_bytes(leaf,
@@ -6077,6 +6081,8 @@ next:
 		extent_offset = page_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
 				size - extent_offset);
+		if (inode->i_sb->s_blocksize < PAGE_CACHE_SIZE)
+			copy_size = max_t(u64, copy_size, PAGE_CACHE_SIZE);
 		em->start = extent_start + extent_offset;
 		em->len = ALIGN(copy_size, btrfs_align_size(inode));
 		em->orig_block_len = em->len;
-- 
1.7.12.4

