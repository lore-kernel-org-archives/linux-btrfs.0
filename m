Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcDZKoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 06:44:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 516F6ABF6
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 10:44:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: btrfs_read_disk_super: PAGE_CACHE_ removal related fixups
Date: Tue, 26 Apr 2016 12:43:56 +0200
Message-Id: <5c61e260fb302cc607a338600575a23e5728dfae.1461666893.git.dsterba@suse.com>
In-Reply-To: <cover.1461666892.git.dsterba@suse.com>
References: <cover.1461666892.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The PAGE_CACHE_* macros and page_cache_* helpers are gone in the next
merging target (4.7), so we have to fix that before the "delete device
by id" branch gets merged. Fixed only instances introduced by this
patchset.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ceacd9dca9c0..0da9522a3dd8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1006,7 +1006,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 void btrfs_release_disk_super(struct page *page)
 {
 	kunmap(page);
-	page_cache_release(page);
+	put_page(page);
 }
 
 int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
@@ -1016,16 +1016,16 @@ int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	pgoff_t index;
 
 	/* make sure our super fits in the device */
-	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
+	if (bytenr + PAGE_SIZE >= i_size_read(bdev->bd_inode))
 		return 1;
 
 	/* make sure our super fits in the page */
-	if (sizeof(**disk_super) > PAGE_CACHE_SIZE)
+	if (sizeof(**disk_super) > PAGE_SIZE)
 		return 1;
 
 	/* make sure our super doesn't straddle pages on disk */
-	index = bytenr >> PAGE_CACHE_SHIFT;
-	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
+	index = bytenr >> PAGE_SHIFT;
+	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_SHIFT != index)
 		return 1;
 
 	/* pull in the page with our super */
@@ -1038,7 +1038,7 @@ int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	p = kmap(*page);
 
 	/* align our pointer to the offset of the super block */
-	*disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
+	*disk_super = p + (bytenr & ~PAGE_MASK);
 
 	if (btrfs_super_bytenr(*disk_super) != bytenr ||
 	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
-- 
2.7.1

