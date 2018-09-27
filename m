Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69214C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279DC204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="oy6tyNMF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279DC204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbeI1AzJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:55:09 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54811 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1AzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:55:09 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b8NgnnrH; Thu, 27 Sep 2018 20:35:33 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073333; bh=lviF3S0VB/cBGXGSZGe44X3W2Cq2PirD2HwnDmslTO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=oy6tyNMFu01e8MduDFCm/R5spcaTd6+maKXWYHmkJMjdWL/ETFl6qAvd/k59QMx31
         k360jXbsgdZycKBHHoK45SDJltL3p/O+soFxzXS6h1DULbbtZJY8LAK3Db3GTw6WDK
         s7ZSplE0chqkjCFjpqGSsUYDe89PfbFpq5lv5tPH057PmZ//Ek0h8Nd9UXtsPYJvze
         rkkOs9i+WEd1Wh+ezksplWAHnaKe606YtR06lNiCwcRlbKCS6YwV6RLIn7OeoPiMsA
         bUZ7tB02RICnhLuc7hryNUycWsDbEVXIX3D3oRMzdxCRK8ACo9X4zHiw4sA3MFqjnX
         i0KSgSOAoYiSQ==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=wuNVyYp8JoBNSc0xyE4A:9 a=0Dz7wqK0u1ibo9Q9:21 a=rErCfyRpZjE95KUB:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Date:   Thu, 27 Sep 2018 20:35:04 +0200
Message-Id: <20180927183504.18078-10-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGndWWBkaSD0QjT8CF3IpZC0T1bW9b+0iXnn09koa4BlPUlzKFH1nyyNzRHNOOO779AMsjmiRtUvxdyMKIDmcR+ALmp4DstKYrdK4yc6spZtuKV27fRM
 GWeecvg16rD514Np077WOtqYC0i4PTQ+E4LZaN6yA+2E/WYN2ybTuXHsuLbBofar7iGWGF1EEzvXlCWp5+stL86tJjk4C9Zc8ZcqxnKfEqHIxjRnQ50y4fR7
 4ZS6fAwu4B7F7Ez6lxqlnkEjN7I+Z+Y/EMjRJIKMUNA=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Add the RAID 6 recovery, in order to use a RAID 6 filesystem even if some
disks (up to two) are missing. This code use the md RAID 6 code already
present in grub.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 63 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index db8df0eea..b49f714ef 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -30,6 +30,7 @@
 #include <grub/i18n.h>
 #include <grub/btrfs.h>
 #include <grub/crypto.h>
+#include <grub/diskfilter.h>
 
 GRUB_MOD_LICENSE ("GPLv3+");
 
@@ -702,11 +703,36 @@ rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
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
@@ -777,6 +803,15 @@ raid56_read_retry (struct grub_btrfs_data *data,
       ret = GRUB_ERR_READ_ERROR;
       goto cleanup;
     }
+  else if (failed_devices > 2 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID6))
+    {
+      grub_dprintf ("btrfs",
+		    "not enough disks for raid6: total %" PRIuGRUB_UINT64_T
+		    ", missing %" PRIuGRUB_UINT64_T "\n",
+		    nstripes, failed_devices);
+      ret = GRUB_ERR_READ_ERROR;
+      goto cleanup;
+    }
   else
     grub_dprintf ("btrfs",
 		  "enough disks for RAID 5 rebuilding: total %"
@@ -787,7 +822,7 @@ raid56_read_retry (struct grub_btrfs_data *data,
   if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
     rebuild_raid5 (buf, buffers, nstripes, csize);
   else
-    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
+    rebuild_raid6 (buffers, nstripes, csize, parities_pos, buf, stripen);
 
   ret = GRUB_ERR_NONE;
  cleanup:
@@ -877,9 +912,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
@@ -1011,6 +1048,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	       *    size if the latter is smaller.
 	       *  - nparities is the number of parities (1 for RAID5, 2 for
 	       *    RAID6); used only in RAID5/6 code.
+	       *    size if the latter is smaller.
+	       *  - parities_pos is the position of the parity in a row (
+	       *    2 for P1, 3 for P2...)
 	       */
 	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
 
@@ -1029,6 +1069,17 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	       */
 	      grub_divmod64 (high + stripen, nstripes, &stripen);
 
+	      /*
+	       * parities_pos is equal to "(high - nparities) % nstripes"
+	       * (see the diagram above).
+	       * However "high - nparities" might be negative (eg when high
+	       * == 0) leading to an incorrect computation.
+	       * Instead "high + nstripes - nparities" is always positive and
+	       * in modulo nstripes is equal to "(high - nparities) % nstripes"
+	       */
+	      grub_divmod64 (high + nstripes - nparities, nstripes,
+			     &parities_pos);
+
 	      stripe_offset = low + chunk_stripe_length * high;
 	      csize = chunk_stripe_length - low;
 
@@ -1080,7 +1131,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 		grub_errno = GRUB_ERR_NONE;
 		if (err != GRUB_ERR_NONE)
 		  err = raid56_read_retry (data, chunk, stripe_offset,
-					   csize, buf);
+					   stripen, csize, buf, parities_pos);
 	      }
 	    if (err == GRUB_ERR_NONE)
 	      break;
-- 
2.19.0

