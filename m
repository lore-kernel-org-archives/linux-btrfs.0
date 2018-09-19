Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:49412 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727804AbeITAUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:24 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/9] btrfs: Add helper to check the btrfs header.
Date: Wed, 19 Sep 2018 20:40:33 +0200
Message-Id: <20180919184040.22540-3-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

This helper is used in a few places to help the debugging. As
conservative approach the error is only logged.
This does not impact the error handling.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 56c42746d..4f404f4b2 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -77,7 +77,8 @@ struct btrfs_header
 {
   grub_btrfs_checksum_t checksum;
   grub_btrfs_uuid_t uuid;
-  grub_uint8_t dummy[0x30];
+  grub_uint64_t bytenr;
+  grub_uint8_t dummy[0x28];
   grub_uint32_t nitems;
   grub_uint8_t level;
 } GRUB_PACKED;
@@ -286,6 +287,25 @@ free_iterator (struct grub_btrfs_leaf_descriptor *desc)
   grub_free (desc->data);
 }
 
+static grub_err_t
+check_btrfs_header (struct grub_btrfs_data *data, struct btrfs_header *header,
+                    grub_disk_addr_t addr)
+{
+  if (grub_le_to_cpu64 (header->bytenr) != addr)
+    {
+      grub_dprintf ("btrfs", "btrfs_header.bytenr is not equal node addr\n");
+      return grub_error (GRUB_ERR_BAD_FS,
+			 "header bytenr is not equal node addr");
+    }
+  if (grub_memcmp (data->sblock.uuid, header->uuid, sizeof(grub_btrfs_uuid_t)))
+    {
+      grub_dprintf ("btrfs", "btrfs_header.uuid doesn't match sblock uuid\n");
+      return grub_error (GRUB_ERR_BAD_FS,
+			 "header uuid doesn't match sblock uuid");
+    }
+  return GRUB_ERR_NONE;
+}
+
 static grub_err_t
 save_ref (struct grub_btrfs_leaf_descriptor *desc,
 	  grub_disk_addr_t addr, unsigned i, unsigned m, int l)
@@ -341,6 +361,7 @@ next (struct grub_btrfs_data *data,
 
       err = grub_btrfs_read_logical (data, grub_le_to_cpu64 (node.addr),
 				     &head, sizeof (head), 0);
+      check_btrfs_header (data, &head, grub_le_to_cpu64 (node.addr));
       if (err)
 	return -err;
 
@@ -402,6 +423,7 @@ lower_bound (struct grub_btrfs_data *data,
       /* FIXME: preread few nodes into buffer. */
       err = grub_btrfs_read_logical (data, addr, &head, sizeof (head),
 				     recursion_depth + 1);
+      check_btrfs_header (data, &head, addr);
       if (err)
 	return err;
       addr += sizeof (head);
-- 
2.19.0
