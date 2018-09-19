Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:53628 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732232AbeITAUZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:25 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Date: Wed, 19 Sep 2018 20:40:35 +0200
Message-Id: <20180919184040.22540-5-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

If a device is not found, do not return immediately but
record this failure by storing NULL in data->devices_attached[].
This way we avoid unnecessary devices rescan, and speedup the
reads in case of a degraded array.

Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>
---
 grub-core/fs/btrfs.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 0cdfaf7c0..6e42c33f6 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -588,7 +588,7 @@ find_device_iter (const char *name, void *data)
 }
 
 static grub_device_t
-find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
+find_device (struct grub_btrfs_data *data, grub_uint64_t id)
 {
   struct find_device_ctx ctx = {
     .data = data,
@@ -600,12 +600,9 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
   for (i = 0; i < data->n_devices_attached; i++)
     if (id == data->devices_attached[i].id)
       return data->devices_attached[i].dev;
-  if (do_rescan)
-    grub_device_iterate (find_device_iter, &ctx);
-  if (!ctx.dev_found)
-    {
-      return NULL;
-    }
+
+  grub_device_iterate (find_device_iter, &ctx);
+
   data->n_devices_attached++;
   if (data->n_devices_attached > data->n_devices_allocated)
     {
@@ -617,7 +614,8 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
 			* sizeof (data->devices_attached[0]));
       if (!data->devices_attached)
 	{
-	  grub_device_close (ctx.dev_found);
+	  if (ctx.dev_found)
+	    grub_device_close (ctx.dev_found);
 	  data->devices_attached = tmp;
 	  return NULL;
 	}
@@ -892,7 +890,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
 			      addr);
 
-		dev = find_device (data, stripe->device_id, j);
+		dev = find_device (data, stripe->device_id);
 		if (!dev)
 		  {
 		    grub_dprintf ("btrfs",
@@ -969,7 +967,8 @@ grub_btrfs_unmount (struct grub_btrfs_data *data)
   unsigned i;
   /* The device 0 is closed one layer upper.  */
   for (i = 1; i < data->n_devices_attached; i++)
-    grub_device_close (data->devices_attached[i].dev);
+    if (data->devices_attached[i].dev)
+        grub_device_close (data->devices_attached[i].dev);
   grub_free (data->devices_attached);
   grub_free (data->extent);
   grub_free (data);
-- 
2.19.0
