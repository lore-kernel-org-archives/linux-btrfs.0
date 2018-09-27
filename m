Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDB3C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D23204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="m5PLyeb2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66D23204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbeI1Ayy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:54 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:48601 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728251AbeI1Ayy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:54 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b88gnnnR; Thu, 27 Sep 2018 20:35:18 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073318; bh=Zd0XB2/3+InuPzTYI3AT+uOEuSwrcE2wtQ1rXUitQdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=m5PLyeb2wDv3dLSGs4f9dURQ5qZVYHKqKREgKEc3+z/WoydCmQjD21nYhHn2ZT36C
         oM+LphD+rUOeb+nSjXxOslgwOh/T0tT1TR9xCZftZ7smLNII8dnVUXvuFX9lno+m4z
         JCAndx6N/dfP8sBOIlxQw1rGRpJqSqnkqmwGrw+1eo/K7hyCENN9JKZqItd+toNmwT
         h5HDACp5MWawNcVDgNF95NssKQ5lLDNOPNmttNCFfoptDvS9clvXCbbpwXkdHgAtwz
         xWCrJqx6DM07s3xyU/8wJH17oEr2OkWJBadjlqtMlS480wNxbTeOE2FRwslTgEZ6Uo
         s/8Uz3CL3Bf6Q==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=_nex0ghXHqrwvuxp8qYA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Date:   Thu, 27 Sep 2018 20:34:59 +0200
Message-Id: <20180927183504.18078-5-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfH+d8sZZBMVu/nghih0NId1a/SGM9cg3t69OOUnG6cv0rFtC3hWd0bqY5PeMnizamS0Fhi7cCC4ldzoKp5ed4KerxuiDWbPya++lQCFu67S7H5Q+Q1oD
 8xH0YGcbFp+qoVAPu0w22owirLrgW0rKKT3SJadfzPb9ynVsXfRQ+9sO6d/rA+dcFjwaPM2dzkl9QAOrRmEge2+3/wWpd5C44qFdJ8k8VucW6/MtTFbr9Gff
 Bc/GhlNCWb5WrAQqe81eNqpAm4Jc4vj9y1Cawk4h9Fo=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Change the behavior of find_device(): before the patch, a read of a missed
device may trigger a rescan. However, it is never recorded that a device
is missed, so each single read of a missed device may triggers a rescan.
It is the caller who decides if a rescan is performed in case of a missed
device. And it does quite often, without considering if in the past a
devices was already found as "missed"
This behavior causes a lot of unneeded rescan, causing a huge slowdown in
case of a missed device.

After the patch, the "missed device" information is stored in the
data->devices_attached[] array (as a NULL value in the field dev). A rescan
is triggered only if no information at all is found. This means that only
the first time a read of a missed device triggers a rescan.

The change in the code is done removing "return NULL" when the disk is not
found. So it is always executed the code which stores in the
data->devices_attached[] array the value returned by grub_device_iterate():
NULL if the device is missed, or a valid data otherwise.

Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>
---
 grub-core/fs/btrfs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 2b1dd7dd4..c07d91657 100644
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
@@ -600,10 +600,9 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
   for (i = 0; i < data->n_devices_attached; i++)
     if (id == data->devices_attached[i].id)
       return data->devices_attached[i].dev;
-  if (do_rescan)
-    grub_device_iterate (find_device_iter, &ctx);
-  if (!ctx.dev_found)
-    return NULL;
+
+  grub_device_iterate (find_device_iter, &ctx);
+
   data->n_devices_attached++;
   if (data->n_devices_attached > data->n_devices_allocated)
     {
@@ -615,7 +614,8 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
 			* sizeof (data->devices_attached[0]));
       if (!data->devices_attached)
 	{
-	  grub_device_close (ctx.dev_found);
+	  if (ctx.dev_found)
+	    grub_device_close (ctx.dev_found);
 	  data->devices_attached = tmp;
 	  return NULL;
 	}
@@ -898,7 +898,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
 			      addr);
 
-		dev = find_device (data, stripe->device_id, j);
+		dev = find_device (data, stripe->device_id);
 		if (!dev)
 		  {
 		    grub_dprintf ("btrfs",
@@ -975,7 +975,8 @@ grub_btrfs_unmount (struct grub_btrfs_data *data)
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

