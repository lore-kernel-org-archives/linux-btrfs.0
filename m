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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997DAC6780B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6505C2075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="U9jNxnst"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6505C2075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbeJLCTw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:19:52 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:37133 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729786AbeJLCTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:19:45 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3HgbY02; Thu, 11 Oct 2018 20:51:15 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283875; bh=GJkLQdHACkYyoGwEvpgE86CX50jb7ab2XaJVwqcHACg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=U9jNxnstSVn3/91iWPG9sSlOl86FV8y76b/A1uE+AgKRZca0gR4ZcgQQ8qK3Zo+aS
         HRxB1ULiAp6zDGEzWTG6nX/DilO2eDg5r1nE0xR/DWsj0TGSn7X8gif6tRsKc7dP8n
         2P9LZ44dNQ+eSaZAHi+bid6JQ1Bz3D7RmPrxgwrXAJSrOzjXfR/p1ExQcbR/tgrrDJ
         FSnjLHR3+yPJ/VJ+BRfhT5ym60JyLaRCowtGZBBMhbQpf9pEhG2HRIK51lXKg6ClnC
         B0Rf7aybrYFm1GeYAjSji5FW3M0+2C3lvSm1EeCDaahxKPRFNKpbbDUpP/hAHAXgRB
         vIp21WEdrcsCw==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17
 a=wqVqdCQbwCNbCc34xW0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Date:   Thu, 11 Oct 2018 20:50:58 +0200
Message-Id: <20181011185103.23146-5-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011185103.23146-1-kreijack@libero.it>
References: <20181011185103.23146-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAOQ0iifhU0WYY0oY57gOQ1sRzzoHQ1p3kZH9AXynZPcZOAdcW/h8cGf3khroZoLd6ZLhS0ryzGJ90YmzoMDB8r8uRECD8mrjdMlcK/RwmZKWd2fdqla
 CnPlCYBOyq1CMnAImYTdlktNawuIoo+rgTAt9BM6W0SIpB0H9s58S0/N4qukv8GxiZJ3lqFdj5MI6C67eh+qnLawPSluQpwLiSZPz2wskncgBeFk9uyAvdzt
 KekuTSL7J2P3aZe7wD2Edh7Z8QtgtCPGraXHBKb1lfc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Currently read from missing device triggers rescan. However, it is never
recorded that the device is missing. So, each read of a missing device
triggers rescan again and again. This behavior causes a lot of unneeded
rescans leading to huge slowdowns.

This patch fixes above mentioned issue. Information about missing devices
is stored in the data->devices_attached[] array as NULL value in dev
member. Rescan is triggered only if no information is found for a given
device. This means that only first time read triggers rescan.

The patch drops premature return. This way data->devices_attached[] is
filled even when a given device is missing.

Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>
---
 grub-core/fs/btrfs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 2a87eb103..b2be80c33 100644
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
@@ -897,7 +897,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
 			      addr);
 
-		dev = find_device (data, stripe->device_id, j);
+		dev = find_device (data, stripe->device_id);
 		if (!dev)
 		  {
 		    grub_dprintf ("btrfs",
@@ -974,7 +974,8 @@ grub_btrfs_unmount (struct grub_btrfs_data *data)
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
2.19.1

