Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935272AbeF2I4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:46 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC8EDAD6B
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/14] btrfs: use copy_page for copying pages instead of memcpy
Date: Fri, 29 Jun 2018 10:56:44 +0200
Message-Id: <25ae929250e40bd6abab1545c7d8c20ab9d080d1.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the helper that's possibly optimized for full page copies.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c |  4 ++--
 fs/btrfs/raid56.c           | 12 +++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 38ad5e9f0bf2..15732be6bd56 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -547,7 +547,7 @@ static int io_ctl_add_bitmap(struct btrfs_io_ctl *io_ctl, void *bitmap)
 		io_ctl_map_page(io_ctl, 0);
 	}
 
-	memcpy(io_ctl->cur, bitmap, PAGE_SIZE);
+	copy_page(io_ctl->cur, bitmap);
 	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	if (io_ctl->index < io_ctl->num_pages)
 		io_ctl_map_page(io_ctl, 0);
@@ -607,7 +607,7 @@ static int io_ctl_read_bitmap(struct btrfs_io_ctl *io_ctl,
 	if (ret)
 		return ret;
 
-	memcpy(entry->bitmap, io_ctl->cur, PAGE_SIZE);
+	copy_page(entry->bitmap, io_ctl->cur);
 	io_ctl_unmap_page(io_ctl);
 
 	return 0;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5e4ad134b9ad..27ed47a23f26 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -260,7 +260,7 @@ static void cache_rbio_pages(struct btrfs_raid_bio *rbio)
 		s = kmap(rbio->bio_pages[i]);
 		d = kmap(rbio->stripe_pages[i]);
 
-		memcpy(d, s, PAGE_SIZE);
+		copy_page(d, s);
 
 		kunmap(rbio->bio_pages[i]);
 		kunmap(rbio->stripe_pages[i]);
@@ -1275,7 +1275,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 						pointers);
 		} else {
 			/* raid5 */
-			memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
+			copy_page(pointers[nr_data], pointers[0]);
 			run_xor(pointers + 1, nr_data - 1, PAGE_SIZE);
 		}
 
@@ -1941,9 +1941,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 			BUG_ON(failb != -1);
 pstripe:
 			/* Copy parity block into failed block to start with */
-			memcpy(pointers[faila],
-			       pointers[rbio->nr_data],
-			       PAGE_SIZE);
+			copy_page(pointers[faila], pointers[rbio->nr_data]);
 
 			/* rearrange the pointer array */
 			p = pointers[faila];
@@ -2448,7 +2446,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 						pointers);
 		} else {
 			/* raid5 */
-			memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
+			copy_page(pointers[nr_data], pointers[0]);
 			run_xor(pointers + 1, nr_data - 1, PAGE_SIZE);
 		}
 
@@ -2456,7 +2454,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		p = rbio_stripe_page(rbio, rbio->scrubp, pagenr);
 		parity = kmap(p);
 		if (memcmp(parity, pointers[rbio->scrubp], PAGE_SIZE))
-			memcpy(parity, pointers[rbio->scrubp], PAGE_SIZE);
+			copy_page(parity, pointers[rbio->scrubp]);
 		else
 			/* Parity is right, needn't writeback */
 			bitmap_clear(rbio->dbitmap, pagenr, 1);
-- 
2.17.1

