Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28A1C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728B220658
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="Tm9G5J08"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 728B220658
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbeJLCUq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:20:46 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:54034 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729187AbeJLCUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:20:45 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3IgbY0U; Thu, 11 Oct 2018 20:51:17 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283877; bh=dk1zaVtjiWRLe4SoUGtVdbDdffAha4dP1TJIC39qHQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Tm9G5J08ZsB8kFEDF7UWbadNIWZUjA+b18gPYaI/QupwIY77c1n68Vi8/TVEsEh1y
         XWn2inehh5cC7z/z1m5Y3r2eShtRZkx+a49NhhUY0N21xCJ3MLAvtU3lf/UD58yA5V
         q8xTFOyYykM+KTk30J8BLmvBHwFk+pkCtVnyHUvJ10L5xElUG3mKnRu7EYLblTZ8R1
         XxJX2rlwaAJXowv6HtJJZMxvL7ejV+Ul0+4wMl8mVig5VOe4ijfon6UIkMeCy8Gj36
         ByFArJyxerJmhTWiJHi2p4UTBJe6f9T5ekRUqceoMdxtE4zaM3pmSypUlADusm7WIv
         lM25wLbMplPOQ==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17
 a=G94wEjWLTZ8BO8lEC54A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Date:   Thu, 11 Oct 2018 20:51:01 +0200
Message-Id: <20181011185103.23146-8-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011185103.23146-1-kreijack@libero.it>
References: <20181011185103.23146-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKdBstYaSrjQl3ndoX411e2SAjZ5Ql2IE7F5378I/nI2oTUWnnaX2IIXDRh04zQN++MjPMhyiL+0YFs9rjMKnEYE5NsCBCUa6FCH5OXUsM3FMGw8v04n
 finTKlZRw5JFMI89rZgq3kQy5qZjmolIhr5AxI5X8UaS+Suvqczxxjq+OsA2KvAehCndmQLWNii1/uXRkj/NFIkYxjCRwubNWc6mAjeUzRaAlM8+I1Vwo0Tb
 cgGqTfq8jjaErakQUmsSPAkvW8uU0BYZhxfT1PxyEwI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Add support for recovery for a RAID 5 btrfs profile. In addition
it is added some code as preparatory work for RAID 6 recovery code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 162 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 157 insertions(+), 5 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 899dc32b7..d066d54cc 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -29,6 +29,7 @@
 #include <minilzo.h>
 #include <grub/i18n.h>
 #include <grub/btrfs.h>
+#include <grub/crypto.h>
 
 GRUB_MOD_LICENSE ("GPLv3+");
 
@@ -665,6 +666,141 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
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
+      /* after the struct grub_btrfs_chunk_item, there is an array of
+         struct grub_btrfs_chunk_stripe */
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
@@ -742,6 +878,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	grub_uint16_t nstripes;
 	unsigned redundancy = 1;
 	unsigned i, j;
+	int is_raid56;
+
+	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
+		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
 
 	if (grub_le_to_cpu64 (chunk->size) <= off)
 	  {
@@ -921,17 +1061,29 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
+		if (err)
+		  err = raid56_read_retry (data, chunk, stripe_offset,
+					   csize, buf);
 	      }
-	    if (i != redundancy)
+	    if (!err)
 	      break;
 	  }
 	if (err)
-- 
2.19.1

