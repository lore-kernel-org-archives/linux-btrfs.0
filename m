Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C07BC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322C1204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="POriaxR8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 322C1204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbeI1AzE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:55:04 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54811 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1AzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:55:04 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b8GgnnpW; Thu, 27 Sep 2018 20:35:27 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073327; bh=lELwu3exI0wA279zvR3shM861i7nwO/Ax/hobnXAs7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=POriaxR8x4WDvYGAh/vMkyHe2nkonZwYfXXeEud5fYNuMlUEnTh2r5qrjfJKHV72V
         FaM76I0SvSu52UMAVk9p3k275O4IBXagMh3v0w1QVPKGM2YAfDo7ZnS3LQVgNts3sI
         ueOpRjjMKB5sXneELauO2K9jAtYnWTIY82Jny5AMFk7YvjI/BW4m3yM6enP3vv74hW
         8L1G2SX9SdtI9yjXIewojcmgJsc2el//v5fYCbU87MfBxQJmLoUfuhgswGKVFjLNCO
         7l+GhR//Few5M0fvaIol1QJVzAsg2MlhbHruPMGTvztJEBjpwkvAMz4Ntwa9J+6Yhd
         K0lLy5y0w8WRw==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=ljdETIpkDeTQ7q4m-5gA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Date:   Thu, 27 Sep 2018 20:35:02 +0200
Message-Id: <20180927183504.18078-8-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOU8sAlsI3YOYjvIE/s+dDzyovmgO7QgkXAGrr/zv3N8lTzAz3vcZPh+xVuaXY5JsnJm80Rxt1xY370AMDIcS5dAvvN+AiX2LdSQqLFqi72cChpeZoor
 upAjwLC9gSjDXLHUjHPQaMGFJAa5hhkLLSoLofR3/bX1aYDuoTlmd26eoDOmkTYqFPHGvnjPqn0SIpCBLGNskRDV7aabyE0PJr9i+83x35T/Dcx0sVt+xH7/
 Yu6Yu/npMJIu93wZoUFJoxk0QYxl+Qp0H4XyA0kLrVc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Add support for recovery for a RAID 5 btrfs profile. In addition
it is added some code as preparatory work for RAID 6 recovery code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 160 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 155 insertions(+), 5 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 554f350c5..db8df0eea 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -29,6 +29,7 @@
 #include <minilzo.h>
 #include <grub/i18n.h>
 #include <grub/btrfs.h>
+#include <grub/crypto.h>
 
 GRUB_MOD_LICENSE ("GPLv3+");
 
@@ -665,6 +666,139 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
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
+  for(i = 0; buffers[i].data_is_valid && i < nstripes; i++);
+
+  if (i == nstripes)
+    {
+      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
+      return;
+    }
+
+  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n", i);
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
+  grub_err_t ret = GRUB_ERR_OUT_OF_MEMORY;
+  grub_uint64_t i, failed_devices;
+
+  buffers = grub_zalloc (sizeof(*buffers) * nstripes);
+  if (!buffers)
+    goto cleanup;
+
+  for (i = 0; i < nstripes; i++)
+    {
+      buffers[i].buf = grub_zalloc (csize);
+      if (!buffers[i].buf)
+	goto cleanup;
+    }
+
+  for (failed_devices = 0, i = 0; i < nstripes; i++)
+    {
+      struct grub_btrfs_chunk_stripe *stripe;
+      grub_disk_addr_t paddr;
+      grub_device_t dev;
+      grub_err_t err;
+
+      stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1) + i;
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
+      err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
+			    paddr & (GRUB_DISK_SECTOR_SIZE - 1),
+			    csize, buffers[i].buf);
+      if (err == GRUB_ERR_NONE)
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
+  ret = GRUB_ERR_NONE;
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
@@ -742,6 +876,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	grub_uint16_t nstripes;
 	unsigned redundancy = 1;
 	unsigned i, j;
+	int is_raid56;
+
+	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
+		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
 
 	if (grub_le_to_cpu64 (chunk->size) <= off)
 	  {
@@ -922,17 +1060,29 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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

