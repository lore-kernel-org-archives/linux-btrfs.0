Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:53100 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732270AbeITAUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:24 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/9] btrfs: Move logging code in grub_btrfs_read_logical()
Date: Wed, 19 Sep 2018 20:40:36 +0200
Message-Id: <20180919184040.22540-6-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

A portion of the logging code is moved outside of internal for(;;). The part
that is left inside is the one which depends on the internal for(;;) index.

This is a preparatory patch. The next one will refactor the code inside
the for(;;) into an another function.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 6e42c33f6..ee134c167 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -863,6 +863,18 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 	for (j = 0; j < 2; j++)
 	  {
+	    grub_dprintf ("btrfs", "chunk 0x%" PRIxGRUB_UINT64_T
+			  "+0x%" PRIxGRUB_UINT64_T
+			  " (%d stripes (%d substripes) of %"
+			  PRIxGRUB_UINT64_T ")\n",
+			  grub_le_to_cpu64 (key->offset),
+			  grub_le_to_cpu64 (chunk->size),
+			  grub_le_to_cpu16 (chunk->nstripes),
+			  grub_le_to_cpu16 (chunk->nsubstripes),
+			  grub_le_to_cpu64 (chunk->stripe_length));
+	    grub_dprintf ("btrfs", "reading laddr 0x%" PRIxGRUB_UINT64_T "\n",
+			  addr);
+
 	    for (i = 0; i < redundancy; i++)
 	      {
 		struct grub_btrfs_chunk_stripe *stripe;
@@ -875,20 +887,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 		paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
 
-		grub_dprintf ("btrfs", "chunk 0x%" PRIxGRUB_UINT64_T
-			      "+0x%" PRIxGRUB_UINT64_T
-			      " (%d stripes (%d substripes) of %"
-			      PRIxGRUB_UINT64_T ") stripe %" PRIxGRUB_UINT64_T
+		grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
 			      " maps to 0x%" PRIxGRUB_UINT64_T "\n",
-			      grub_le_to_cpu64 (key->offset),
-			      grub_le_to_cpu64 (chunk->size),
-			      grub_le_to_cpu16 (chunk->nstripes),
-			      grub_le_to_cpu16 (chunk->nsubstripes),
-			      grub_le_to_cpu64 (chunk->stripe_length),
 			      stripen, stripe->offset);
 		grub_dprintf ("btrfs", "reading paddr 0x%" PRIxGRUB_UINT64_T
-			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
-			      addr);
+			      "\n", paddr);
 
 		dev = find_device (data, stripe->device_id);
 		if (!dev)
-- 
2.19.0
