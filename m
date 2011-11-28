Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45932 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754779Ab1K1UBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 15:01:41 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJxX3F024269
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 18:00:34 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWZlc012419
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:36 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWZVB020369
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:35 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWZ5d020368
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:35 -0200
Message-Id: <04a998fedc7cf6ee9d16b450c1a77ea19916c643.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 12:22:14 -0200
Subject: [PATCH 11/20] Btrfs: note when a bitmap is skipped because its list
 is in use
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bitmap lists serve two purposes: recording the order of loading/saving
on-disk free space caches, and setting up a list of bitmaps to try to
set up a cluster.  Complain if a list is unexpectedly busy.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..dd7fe43 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -904,6 +904,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			goto out_nospc;
 
 		if (e->bitmap) {
+			BUG_ON(!list_empty(&e->list));
 			list_add_tail(&e->list, &bitmap_list);
 			bitmaps++;
 		}
@@ -2380,6 +2381,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	while (entry->bitmap) {
 		if (list_empty(&entry->list))
 			list_add_tail(&entry->list, bitmaps);
+		else if (entry->bitmap)
+			printk(KERN_ERR "btrfs: not using (busy?!?) bitmap %lli\n",
+			       (unsigned long long)entry->offset);
 		node = rb_next(&entry->offset_index);
 		if (!node)
 			return -ENOSPC;
@@ -2402,6 +2406,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bitmap) {
 			if (list_empty(&entry->list))
 				list_add_tail(&entry->list, bitmaps);
+			else
+				printk(KERN_ERR "btrfs: not using (busy?!?) bitmap %lli\n",
+				       (unsigned long long)entry->offset);
 			continue;
 		}
 
-- 
1.7.4.4

