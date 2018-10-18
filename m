Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EECC5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1F872145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="cTJN827b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1F872145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbeJSB6A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:58:00 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:52986 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726507AbeJSB6A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 21:58:00 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id DCWVgs2H18KmnDCWZgOdVo; Thu, 18 Oct 2018 19:55:55 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539885355; bh=ewgUHr+/sryYtmIv/Spf+tbaSc0Y9WxAYkFfGWWD9hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cTJN827b7SpF9bWxgJFMGkqOGSHgDCUfw6uWjUroHvkOANxHl2rl+6LeNdO75zoMV
         EvNqEhpoWM5mXJD3I7dLELDo3pDES2lkAdClHLQ/OmybvCzO4pGGIMTdndtk+BGVQO
         XxI712/81O0fvRJbz0Zimqbpa7HB8TE5oZmj2FR0uBEMdf47THQZ2P6eT/7L77g0DH
         FEr5nSNEi4gVEg18mnRqVywze/IDGykgWMwh74McpJm8BMUIrAF887y0LI4t8dH7a4
         5IVRwFfQXmOvv3klM30f77iHfr9JxopdxXfSJyI7tneTJENoOQ8k8P/z0w2jD4mxQJ
         3kSWB3/Ta6uuw==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=X3SSP0U7tytczLKPzpUA:9 a=jz4e0QIFRHllRBIp:21 a=OcE7XaoNLwjyrDjE:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Date:   Thu, 18 Oct 2018 19:55:41 +0200
Message-Id: <20181018175541.9532-10-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018175541.9532-1-kreijack@libero.it>
References: <20181018175541.9532-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfP5/51Tfhwi/29ZzrnTJIZGBic5tmpkSS/d/bH098qIF1N7xAf5yvsWHVCXSsKNN51ymYlPeusWeadoca3wFPlYeK4ayHbeuy380x1qcreUbySOSHhJA
 ezuxl98UbUN6IMMxeArDiiOxc1MAUFPO26MqOWW9FNFK8msmM0fek/xt8/02ehbn4CP7ZZzeAkw8o17BuzTyo89YGkMLQGfy9O50AEWYlG8UFRrUos3/xuMW
 UidwpjMm4c74ydEmdfeUSvzFQF0Ht5KZXeQ9cFa9guo=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Add the RAID 6 recovery, in order to use a RAID 6 filesystem even if some
disks (up to two) are missing. This code use the md RAID 6 code already
present in grub.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 60 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 6 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index b277f2904..9419d313d 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -30,6 +30,7 @@
 #include <grub/i18n.h>
 #include <grub/btrfs.h>
 #include <grub/crypto.h>
+#include <grub/diskfilter.h>
 
 GRUB_MOD_LICENSE ("GPLv3+");
 
@@ -701,11 +702,36 @@ rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
     }
 }
 
+static grub_err_t
+raid6_recover_read_buffer (void *data, int disk_nr,
+			   grub_uint64_t addr __attribute__ ((unused)),
+			   void *dest, grub_size_t size)
+{
+    struct raid56_buffer *buffers = data;
+
+    if (!buffers[disk_nr].data_is_valid)
+	return grub_errno = GRUB_ERR_READ_ERROR;
+
+    grub_memcpy(dest, buffers[disk_nr].buf, size);
+
+    return grub_errno = GRUB_ERR_NONE;
+}
+
+static void
+rebuild_raid6 (struct raid56_buffer *buffers, grub_uint64_t nstripes,
+               grub_uint64_t csize, grub_uint64_t parities_pos, void *dest,
+               grub_uint64_t stripen)
+
+{
+  grub_raid6_recover_gen (buffers, nstripes, stripen, parities_pos,
+                          dest, 0, csize, 0, raid6_recover_read_buffer);
+}
+
 static grub_err_t
 raid56_read_retry (struct grub_btrfs_data *data,
 		   struct grub_btrfs_chunk_item *chunk,
-		   grub_uint64_t stripe_offset,
-		   grub_uint64_t csize, void *buf)
+		   grub_uint64_t stripe_offset, grub_uint64_t stripen,
+		   grub_uint64_t csize, void *buf, grub_uint64_t parities_pos)
 {
   struct raid56_buffer *buffers;
   grub_uint64_t nstripes = grub_le_to_cpu16 (chunk->nstripes);
@@ -778,6 +804,15 @@ raid56_read_retry (struct grub_btrfs_data *data,
       ret = GRUB_ERR_READ_ERROR;
       goto cleanup;
     }
+  else if (failed_devices > 2 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID6))
+    {
+      grub_dprintf ("btrfs",
+		    "not enough disks for RAID 6: total %" PRIuGRUB_UINT64_T
+		    ", missing %" PRIuGRUB_UINT64_T "\n",
+		    nstripes, failed_devices);
+      ret = GRUB_ERR_READ_ERROR;
+      goto cleanup;
+    }
   else
     grub_dprintf ("btrfs",
 		  "enough disks for RAID 5: total %"
@@ -788,7 +823,7 @@ raid56_read_retry (struct grub_btrfs_data *data,
   if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
     rebuild_raid5 (buf, buffers, nstripes, csize);
   else
-    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
+    rebuild_raid6 (buffers, nstripes, csize, parities_pos, buf, stripen);
 
   ret = GRUB_ERR_NONE;
  cleanup:
@@ -878,9 +913,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	unsigned redundancy = 1;
 	unsigned i, j;
 	int is_raid56;
+	grub_uint64_t parities_pos = 0;
 
-	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
-		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
+        is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
+		       (GRUB_BTRFS_CHUNK_TYPE_RAID5 |
+		        GRUB_BTRFS_CHUNK_TYPE_RAID6));
 
 	if (grub_le_to_cpu64 (chunk->size) <= off)
 	  {
@@ -1029,6 +1066,17 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	       */
 	      grub_divmod64 (high + stripen, nstripes, &stripen);
 
+	      /*
+	       * parities_pos is equal to "(high - nparities) % nstripes"
+	       * (see the diagram above).
+	       * However "high - nparities" can be negative, eg. when high
+	       * == 0 leading to an incorrect computation.
+	       * "high + nstripes - nparities" is always positive and in
+	       * modulo nstripes is equal to "(high - nparities) % nstripes"
+	       */
+	      grub_divmod64 (high + nstripes - nparities, nstripes,
+			     &parities_pos);
+
 	      stripe_offset = low + chunk_stripe_length * high;
 	      csize = chunk_stripe_length - low;
 
@@ -1069,7 +1117,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 		grub_errno = GRUB_ERR_NONE;
 		if (err)
 		  err = raid56_read_retry (data, chunk, stripe_offset,
-					   csize, buf);
+					   stripen, csize, buf, parities_pos);
 	      }
 	    else
 	      for (i = 0; i < redundancy; i++)
-- 
2.19.1

