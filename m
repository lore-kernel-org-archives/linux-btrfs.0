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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF35DC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80667204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="ZaEzAf+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80667204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbeI1AzG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:55:06 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:48601 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1AzG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:55:06 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b8JgnnqP; Thu, 27 Sep 2018 20:35:30 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073330; bh=BYiWpzcXDH7R4zhuV9SPGwAZEi8ZW+8Agt4evHOZJug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZaEzAf+jV+VSrfv1j6vIAVMYwftz5+uwXfOvw9LHvjyAgzBQBPTXQaqotI+SVK0ET
         GTJ6g2TkjeOJ6XXQ/fAOoYh3WaZtxfb4YXHv42M6vtNMbNFCMo2F7jTLLOYqttjoTR
         f8iGg2JUzVYXN7MX3EGTrLLPR4FDJTb4q9IdX4TmjMaZnJVSnGGyrl/lIbguAyz2pi
         hbmTQI0MiNzrBEqeNQD9PzZehQm0iGpzGB6lFuGxghn6ecZpK1mzNZwBcdz/33ySrF
         kP+op/Jhej/AEPWPRtcEohlRMOB/R3AGg76xE8GTCMVbXFv2Ff40ljQodiyB0nRQuu
         vIFwn9OCYVnYg==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17 a=yPCof4ZbAAAA:8
 a=veM9U-ac7Y8X2fC78R8A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 8/9] btrfs: Make more generic the code for RAID 6 rebuilding
Date:   Thu, 27 Sep 2018 20:35:03 +0200
Message-Id: <20180927183504.18078-9-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDK3V8psKv7mZ7X8W7NV4GqXnN07GQFEWsrJ4ht+lVLolfk3JzIssFcvNQOcDsewgrhYN5P4gWC+PxLnMbkdeo0udSvu4eGXcEPveOQRIY1mpKF8mrRT
 +vA585JT9+1MXPg8CcG5fZcfkVBHgK/30ZtBTUZKwJkn9Q/0pljHZnTziYsP8EZz8OVR89W6aoiP07yn0ajlCINHYZNGs0W3/czi63+TP9r3mOa7FxypcH9Y
 Opxx755bu5J9/B21/Zas/GCqgvCzuv7HyXlc2aO/8U8=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

The original code which handles the recovery of a RAID 6 disks array
assumes that all reads are multiple of 1 << GRUB_DISK_SECTOR_BITS and it
assumes that all the I/O is done via the struct grub_diskfilter_segment.
This is not true for the btrfs code. In order to reuse the native
grub_raid6_recover() code, it is modified to not call
grub_diskfilter_read_node() directly, but to call an handler passed
as an argument.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/disk/raid6_recover.c | 52 ++++++++++++++++++++++------------
 include/grub/diskfilter.h      |  9 ++++++
 2 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/grub-core/disk/raid6_recover.c b/grub-core/disk/raid6_recover.c
index aa674f6ca..0cf691ddf 100644
--- a/grub-core/disk/raid6_recover.c
+++ b/grub-core/disk/raid6_recover.c
@@ -74,14 +74,26 @@ mod_255 (unsigned x)
 }
 
 static grub_err_t
-grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
-                    char *buf, grub_disk_addr_t sector, grub_size_t size)
+raid6_recover_read_node (void *data, int disknr,
+				    grub_uint64_t sector,
+				    void *buf, grub_size_t size)
+{
+    struct grub_diskfilter_segment *array = data;
+
+    return grub_diskfilter_read_node (&array->nodes[disknr],
+				      (grub_disk_addr_t)sector,
+				      size >> GRUB_DISK_SECTOR_BITS, buf);
+}
+
+grub_err_t
+grub_raid6_recover_gen (void *data, grub_uint64_t nstripes, int disknr, int p,
+			    char *buf, grub_uint64_t sector, grub_size_t size,
+			    int layout, raid_recover_read_t read_func)
 {
   int i, q, pos;
   int bad1 = -1, bad2 = -1;
   char *pbuf = 0, *qbuf = 0;
 
-  size <<= GRUB_DISK_SECTOR_BITS;
   pbuf = grub_zalloc (size);
   if (!pbuf)
     goto quit;
@@ -91,17 +103,17 @@ grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
     goto quit;
 
   q = p + 1;
-  if (q == (int) array->node_count)
+  if (q == (int) nstripes)
     q = 0;
 
   pos = q + 1;
-  if (pos == (int) array->node_count)
+  if (pos == (int) nstripes)
     pos = 0;
 
-  for (i = 0; i < (int) array->node_count - 2; i++)
+  for (i = 0; i < (int) nstripes - 2; i++)
     {
       int c;
-      if (array->layout & GRUB_RAID_LAYOUT_MUL_FROM_POS)
+      if (layout & GRUB_RAID_LAYOUT_MUL_FROM_POS)
 	c = pos;
       else
 	c = i;
@@ -109,8 +121,7 @@ grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
         bad1 = c;
       else
         {
-          if (! grub_diskfilter_read_node (&array->nodes[pos], sector,
-					   size >> GRUB_DISK_SECTOR_BITS, buf))
+	  if (!read_func(data, pos, sector, buf, size))
             {
               grub_crypto_xor (pbuf, pbuf, buf, size);
               grub_raid_block_mulx (c, buf, size);
@@ -128,7 +139,7 @@ grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
         }
 
       pos++;
-      if (pos == (int) array->node_count)
+      if (pos == (int) nstripes)
         pos = 0;
     }
 
@@ -139,16 +150,14 @@ grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
   if (bad2 < 0)
     {
       /* One bad device */
-      if ((! grub_diskfilter_read_node (&array->nodes[p], sector,
-					size >> GRUB_DISK_SECTOR_BITS, buf)))
+      if (!read_func(data, p, sector, buf, size))
         {
           grub_crypto_xor (buf, buf, pbuf, size);
           goto quit;
         }
 
       grub_errno = GRUB_ERR_NONE;
-      if (grub_diskfilter_read_node (&array->nodes[q], sector,
-				     size >> GRUB_DISK_SECTOR_BITS, buf))
+      if (read_func(data, q, sector, buf, size))
         goto quit;
 
       grub_crypto_xor (buf, buf, qbuf, size);
@@ -160,14 +169,12 @@ grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
       /* Two bad devices */
       unsigned c;
 
-      if (grub_diskfilter_read_node (&array->nodes[p], sector,
-				     size >> GRUB_DISK_SECTOR_BITS, buf))
+      if (read_func(data, p, sector, buf, size))
         goto quit;
 
       grub_crypto_xor (pbuf, pbuf, buf, size);
 
-      if (grub_diskfilter_read_node (&array->nodes[q], sector,
-				     size >> GRUB_DISK_SECTOR_BITS, buf))
+      if (read_func(data, q, sector, buf, size))
         goto quit;
 
       grub_crypto_xor (qbuf, qbuf, buf, size);
@@ -190,6 +197,15 @@ quit:
   return grub_errno;
 }
 
+static grub_err_t
+grub_raid6_recover (struct grub_diskfilter_segment *array, int disknr, int p,
+                    char *buf, grub_disk_addr_t sector, grub_size_t size)
+{
+  return grub_raid6_recover_gen (array, array->node_count, disknr, p, buf,
+				     sector, size << GRUB_DISK_SECTOR_BITS,
+				     array->layout, raid6_recover_read_node);
+}
+
 GRUB_MOD_INIT(raid6rec)
 {
   grub_raid6_init_table ();
diff --git a/include/grub/diskfilter.h b/include/grub/diskfilter.h
index d89273c1b..8deb1a8c3 100644
--- a/include/grub/diskfilter.h
+++ b/include/grub/diskfilter.h
@@ -189,6 +189,15 @@ typedef grub_err_t (*grub_raid6_recover_func_t) (struct grub_diskfilter_segment
 extern grub_raid5_recover_func_t grub_raid5_recover_func;
 extern grub_raid6_recover_func_t grub_raid6_recover_func;
 
+typedef grub_err_t (* raid_recover_read_t)(void *data, int disk_nr,
+					   grub_uint64_t addr, void *dest,
+					   grub_size_t size);
+
+extern grub_err_t
+grub_raid6_recover_gen (void *data, grub_uint64_t nstripes, int disknr, int p,
+			    char *buf, grub_uint64_t sector, grub_size_t size,
+			    int layout, raid_recover_read_t read_func);
+
 grub_err_t grub_diskfilter_vg_register (struct grub_diskfilter_vg *vg);
 
 grub_err_t
-- 
2.19.0

