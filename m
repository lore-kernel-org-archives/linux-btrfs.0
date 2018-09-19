Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:39442 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731938AbeITAUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:24 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/9] btrfs: Move the error logging from find_device() to its caller.
Date: Wed, 19 Sep 2018 20:40:34 +0200
Message-Id: <20180919184040.22540-4-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The caller knows better if this error is fatal or not, i.e. another disk is
available or not.

This is a preparatory patch.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 4f404f4b2..0cdfaf7c0 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -604,9 +604,6 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
     grub_device_iterate (find_device_iter, &ctx);
   if (!ctx.dev_found)
     {
-      grub_error (GRUB_ERR_BAD_FS,
-		  N_("couldn't find a necessary member device "
-		     "of multi-device filesystem"));
       return NULL;
     }
   data->n_devices_attached++;
@@ -898,6 +895,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 		dev = find_device (data, stripe->device_id, j);
 		if (!dev)
 		  {
+		    grub_dprintf ("btrfs",
+				  "couldn't find a necessary member device "
+				  "of multi-device filesystem\n");
 		    err = grub_errno;
 		    grub_errno = GRUB_ERR_NONE;
 		    continue;
-- 
2.19.0
