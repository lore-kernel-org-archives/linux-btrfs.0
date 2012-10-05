Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52664 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2JERnq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 13:43:46 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id gDgiRPe22P0A3RHo (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 11:43:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup pages properly when ENOMEM in compression
Date: Fri, 5 Oct 2012 13:49:19 -0400
Message-ID: <1349459359-2298-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were freeing non-existent pages which was causing a panic for a user who
was suffering from ENOMEM.  This patch fixes the problem.  Thanks,

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/compression.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 43d1c5a..36eb5f2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -577,6 +577,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_start;
 	struct extent_map *em;
 	int ret = -ENOMEM;
+	int faili = 0;
 	u32 *sums;
 
 	tree = &BTRFS_I(inode)->io_tree;
@@ -626,8 +627,11 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS |
 							      __GFP_HIGHMEM);
-		if (!cb->compressed_pages[pg_index])
+		if (!cb->compressed_pages[pg_index]) {
+			faili = pg_index - 1;
+			ret = -ENOMEM;
 			goto fail2;
+		}
 	}
 	cb->nr_pages = nr_pages;
 
@@ -713,8 +717,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	return 0;
 
 fail2:
-	for (pg_index = 0; pg_index < nr_pages; pg_index++)
-		free_page((unsigned long)cb->compressed_pages[pg_index]);
+	while (faili >= 0) {
+		__free_page(cb->compressed_pages[pg_index]);
+		faili--;
+	}
 
 	kfree(cb->compressed_pages);
 fail1:
-- 
1.7.7.6

