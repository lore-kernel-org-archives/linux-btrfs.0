Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50761 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab2JEUcv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:32:51 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id GHaQODtZA5xJTbcP (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 14:32:50 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup pages properly when ENOMEM in compression V2
Date: Fri, 5 Oct 2012 16:38:26 -0400
Message-ID: <1349469506-6767-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were freeing non-existent pages which was causing a panic for a user who
was suffering from ENOMEM.  This patch fixes the problem.  Thanks,

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: Actually free the page we allocate
-set faili to nrpages-1 in case we fail further down

 fs/btrfs/compression.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 43d1c5a..c6467aa 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -577,6 +577,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_start;
 	struct extent_map *em;
 	int ret = -ENOMEM;
+	int faili = 0;
 	u32 *sums;
 
 	tree = &BTRFS_I(inode)->io_tree;
@@ -626,9 +627,13 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
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
+	faili = nr_pages - 1;
 	cb->nr_pages = nr_pages;
 
 	add_ra_bio_pages(inode, em_start + em_len, cb);
@@ -713,8 +718,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	return 0;
 
 fail2:
-	for (pg_index = 0; pg_index < nr_pages; pg_index++)
-		free_page((unsigned long)cb->compressed_pages[pg_index]);
+	while (faili >= 0) {
+		__free_page(cb->compressed_pages[faili]);
+		faili--;
+	}
 
 	kfree(cb->compressed_pages);
 fail1:
-- 
1.7.7.6

