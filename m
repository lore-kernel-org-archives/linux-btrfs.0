Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:39442 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732127AbeITAVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:21:25 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Date: Wed, 19 Sep 2018 20:40:38 +0200
Message-Id: <20180919184040.22540-8-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Add support for recovery for a RAID 5 btrfs profile. In addition
it is added some code as preparatory work for RAID 6 recovery code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 169 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 164 insertions(+), 5 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 5c1ebae77..55a7eeffc 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -29,6 +29,7 @@
 #include <minilzo.h>
 #include <grub/i18n.h>
 #include <grub/btrfs.h>
+#include <grub/crypto.h>
 
 GRUB_MOD_LICENSE ("GPLv3+");
 
@@ -665,6 +666,148 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
     return err;
 }
 
+struct raid56_buffer {
+  void *buf;
+  int  data_is_valid;
+};
+
+static void
+rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
+	       grub_uint64_t nstripes, grub_uint64_t csize)
+{
+  grub_uint64_t i;
+  int first;
+
+  i = 0;
+  while (buffers[i].data_is_valid && i < nstripes)
+    ++i;
+
+  if (i == nstripes)
+    {
+      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
+      return;
+    }
+
+  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n",
+	        i);
+
+  for (i = 0, first = 1; i < nstripes; i++)
+    {
+      if (!buffers[i].data_is_valid)
+	continue;
+
+      if (first) {
+	grub_memcpy(dest, buffers[i].buf, csize);
+	first = 0;
+      } else
+	grub_crypto_xor (dest, dest, buffers[i].buf, csize);
+
+    }
+}
+
+static grub_err_t
+raid56_read_retry (struct grub_btrfs_data *data,
+		   struct grub_btrfs_chunk_item *chunk,
+		   grub_uint64_t stripe_offset,
+		   grub_uint64_t csize, void *buf)
+{
+  struct raid56_buffer *buffers;
+  grub_uint64_t nstripes = grub_le_to_cpu16 (chunk->nstripes);
+  grub_uint64_t chunk_type = grub_le_to_cpu64 (chunk->type);
+  grub_err_t ret = GRUB_ERR_NONE;
+  grub_uint64_t i, failed_devices;
+
+  buffers = grub_zalloc (sizeof(*buffers) * nstripes);
+  if (!buffers)
+    {
+      ret = GRUB_ERR_OUT_OF_MEMORY;
+      goto cleanup;
+    }
+
+  for (i = 0; i < nstripes; i++)
+    {
+      buffers[i].buf = grub_zalloc (csize);
+      if (!buffers[i].buf)
+	{
+	  ret = GRUB_ERR_OUT_OF_MEMORY;
+	  goto cleanup;
+	}
+    }
+
+  for (failed_devices = 0, i = 0; i < nstripes; i++)
+    {
+      struct grub_btrfs_chunk_stripe *stripe;
+      grub_disk_addr_t paddr;
+      grub_device_t dev;
+      grub_err_t err2;
+
+      stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
+      stripe += i;
+
+      paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
+      grub_dprintf ("btrfs", "reading paddr %" PRIxGRUB_UINT64_T
+                    " from stripe ID %" PRIxGRUB_UINT64_T "\n", paddr,
+                    stripe->device_id);
+
+      dev = find_device (data, stripe->device_id);
+      if (!dev)
+	{
+	  buffers[i].data_is_valid = 0;
+	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T " FAILED (dev ID %"
+			PRIxGRUB_UINT64_T ")\n", i, stripe->device_id);
+	  failed_devices++;
+	  continue;
+	}
+
+      err2 = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
+			     paddr & (GRUB_DISK_SECTOR_SIZE - 1),
+			     csize, buffers[i].buf);
+      if (err2 == GRUB_ERR_NONE)
+	{
+	  buffers[i].data_is_valid = 1;
+	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T " Ok (dev ID %"
+			PRIxGRUB_UINT64_T ")\n", i, stripe->device_id);
+	}
+      else
+	{
+	  buffers[i].data_is_valid = 0;
+	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T
+			" FAILED (dev ID %" PRIxGRUB_UINT64_T ")\n", i,
+			stripe->device_id);
+	  failed_devices++;
+	}
+    }
+
+  if (failed_devices > 1 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5))
+    {
+      grub_dprintf ("btrfs",
+		    "not enough disks for RAID 5: total %" PRIuGRUB_UINT64_T
+		    ", missing %" PRIuGRUB_UINT64_T "\n",
+		    nstripes, failed_devices);
+      ret = GRUB_ERR_READ_ERROR;
+      goto cleanup;
+    }
+  else
+    grub_dprintf ("btrfs",
+		  "enough disks for RAID 5 rebuilding: total %"
+		  PRIuGRUB_UINT64_T ", missing %" PRIuGRUB_UINT64_T "\n",
+		  nstripes, failed_devices);
+
+  /* if these are enough, try to rebuild the data */
+  if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
+    rebuild_raid5 (buf, buffers, nstripes, csize);
+  else
+    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
+
+ cleanup:
+  if (buffers)
+    for (i = 0; i < nstripes; i++)
+	grub_free(buffers[i].buf);
+  grub_free(buffers);
+
+  return ret;
+}
+
 static grub_err_t
 grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			 void *buf, grub_size_t size, int recursion_depth)
@@ -742,6 +885,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	grub_uint16_t nstripes;
 	unsigned redundancy = 1;
 	unsigned i, j;
+	int is_raid56;
+
+	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
+		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
 
 	if (grub_le_to_cpu64 (chunk->size) <= off)
 	  {
@@ -914,17 +1061,29 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	    grub_dprintf ("btrfs", "reading laddr 0x%" PRIxGRUB_UINT64_T "\n",
 			  addr);
 
-	    for (i = 0; i < redundancy; i++)
+	    if (!is_raid56)
+	      for (i = 0; i < redundancy; i++)
+		{
+		  err = btrfs_read_from_chunk (data, chunk, stripen,
+					       stripe_offset,
+					       i,     /* redundancy */
+					       csize, buf);
+		  if (!err)
+		    break;
+		  grub_errno = GRUB_ERR_NONE;
+		}
+	    else
 	      {
 		err = btrfs_read_from_chunk (data, chunk, stripen,
 					     stripe_offset,
-					     i,     /* redundancy */
+					     0,     /* no mirror */
 					     csize, buf);
-		if (!err)
-		  break;
 		grub_errno = GRUB_ERR_NONE;
+		if (err != GRUB_ERR_NONE)
+		  err = raid56_read_retry (data, chunk, stripe_offset,
+					   csize, buf);
 	      }
-	    if (i != redundancy)
+	    if (err == GRUB_ERR_NONE)
 	      break;
 	  }
 	if (err)
-- 
2.19.0
