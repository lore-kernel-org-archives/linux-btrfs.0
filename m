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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385E8C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E1F20658
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="UyVnf8C5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01E1F20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbeJLCUr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:20:47 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:43028 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729054AbeJLCUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:20:46 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3JgbY0f; Thu, 11 Oct 2018 20:51:17 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283877; bh=rRN3WhXbdv8hpdGqHvWXTQsfzlxWcpsHLNi1isTwRYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=UyVnf8C54v5iVbHZrd+BiT4LpacZhuKjhgqa5MWPezEgpxl/VwBfo10A0wEqLtfPz
         qmwT2itXCg+pYb6uLntNUL6i8uEiz5r109T42s6EejeCsJsOQxE4NeCZlkla/zU718
         5pbvWJZviucNn87eBfwjBjyjJ/lpDVy7tx83RnytmBiFMUJqQa5kd4NIY6tzCxOUxM
         YU9yjPUZKqApECaHASwXcHG7bO7UTuFu5O/RrwvmvzsHXUR8evbKK1/MciomOvlLJF
         w/apD0lQzXS5KmQtLbemjnz3d3gkXaGa9d7QjOGtVx0cDK1I9SXygOapMk9jZ3e8qD
         aR59GxPJbeNOg==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17 a=yPCof4ZbAAAA:8
 a=veM9U-ac7Y8X2fC78R8A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 8/9] btrfs: Make more generic the code for RAID 6 rebuilding
Date:   Thu, 11 Oct 2018 20:51:02 +0200
Message-Id: <20181011185103.23146-9-kreijack@libero.it>
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
2.19.1

