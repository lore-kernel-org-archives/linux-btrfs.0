Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:48986 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731253AbeITAUZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:25 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/9] btrfs: Refactor the code that read from disk
Date: Wed, 19 Sep 2018 20:40:37 +0200
Message-Id: <20180919184040.22540-7-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Move the code in charge to read the data from disk into a separate
function. This helps to separate the error handling logic (which depends on
the different raid profiles) from the read from disk logic.
Refactoring this code increases the general readability too.

This is a preparatory patch, to help the adding of the RAID 5/6 recovery
code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 75 ++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index ee134c167..5c1ebae77 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -625,6 +625,46 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id)
   return ctx.dev_found;
 }
 
+static grub_err_t
+btrfs_read_from_chunk (struct grub_btrfs_data *data,
+		       struct grub_btrfs_chunk_item *chunk,
+		       grub_uint64_t stripen, grub_uint64_t stripe_offset,
+		       int redundancy, grub_uint64_t csize,
+		       void *buf)
+{
+    struct grub_btrfs_chunk_stripe *stripe;
+    grub_disk_addr_t paddr;
+    grub_device_t dev;
+    grub_err_t err;
+
+    stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
+    /* Right now the redundancy handling is easy.
+       With RAID5-like it will be more difficult.  */
+    stripe += stripen + redundancy;
+
+    paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
+
+    grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
+		  " maps to 0x%" PRIxGRUB_UINT64_T
+		  ". Reading paddr 0x%" PRIxGRUB_UINT64_T "\n",
+		  stripen, stripe->offset, paddr);
+
+    dev = find_device (data, stripe->device_id);
+    if (!dev)
+      {
+	grub_dprintf ("btrfs",
+		      "couldn't find a necessary member device "
+		      "of multi-device filesystem\n");
+	grub_errno = GRUB_ERR_NONE;
+	return GRUB_ERR_READ_ERROR;
+      }
+
+    err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
+			  paddr & (GRUB_DISK_SECTOR_SIZE - 1),
+			  csize, buf);
+    return err;
+}
+
 static grub_err_t
 grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			 void *buf, grub_size_t size, int recursion_depth)
@@ -638,7 +678,6 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
       grub_err_t err = 0;
       struct grub_btrfs_key key_out;
       int challoc = 0;
-      grub_device_t dev;
       struct grub_btrfs_key key_in;
       grub_size_t chsize;
       grub_disk_addr_t chaddr;
@@ -877,36 +916,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 	    for (i = 0; i < redundancy; i++)
 	      {
-		struct grub_btrfs_chunk_stripe *stripe;
-		grub_disk_addr_t paddr;
-
-		stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
-		/* Right now the redundancy handling is easy.
-		   With RAID5-like it will be more difficult.  */
-		stripe += stripen + i;
-
-		paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
-
-		grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
-			      " maps to 0x%" PRIxGRUB_UINT64_T "\n",
-			      stripen, stripe->offset);
-		grub_dprintf ("btrfs", "reading paddr 0x%" PRIxGRUB_UINT64_T
-			      "\n", paddr);
-
-		dev = find_device (data, stripe->device_id);
-		if (!dev)
-		  {
-		    grub_dprintf ("btrfs",
-				  "couldn't find a necessary member device "
-				  "of multi-device filesystem\n");
-		    err = grub_errno;
-		    grub_errno = GRUB_ERR_NONE;
-		    continue;
-		  }
-
-		err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
-				      paddr & (GRUB_DISK_SECTOR_SIZE - 1),
-				      csize, buf);
+		err = btrfs_read_from_chunk (data, chunk, stripen,
+					     stripe_offset,
+					     i,     /* redundancy */
+					     csize, buf);
 		if (!err)
 		  break;
 		grub_errno = GRUB_ERR_NONE;
-- 
2.19.0
