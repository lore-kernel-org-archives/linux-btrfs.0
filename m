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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04679C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0DE32075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="hit0rE7f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0DE32075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbeJLCTq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:19:46 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:33723 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729785AbeJLCTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:19:44 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3GgbXzm; Thu, 11 Oct 2018 20:51:15 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283875; bh=mU0CLGmoxJNDijdmxkWh5T+f++hham1acS2GkejH0IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hit0rE7fHBlBOeCQEeDDjUIcjP3WN4YyXsYKyUrSnf1SvSgbNB2qlXTcmhyG+zMAA
         2A9Si3FzAGCyOrPyMBjP7KohGrwIpXDZCdIGicaF+v4Vd/ZzMWCxp4sG8/+Gb0Nf08
         jEgA+c5ASZsBtsrrDBhv4qM0QTfVaVKKCpnKAKLq05b7aQBwGREbh8P5Q0jopw0qDl
         kOx1j5YZ+Nu/x4H8iTY2wCQ0lX/hJ/1D6XNUNrn+59paMlUDxnb5Co50vaaNRnBFbc
         s9bJqUF8aTODWYrfMVziw2Hi+JAJTY5QlRvIjib+5717GyFKvQ/bMyBZIU/+I01e3v
         R0AIfP/bCzTEw==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17 a=yPCof4ZbAAAA:8
 a=fGidO4j3AiKtNeS3nH0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/9] btrfs: Move the error logging from find_device() to its caller.
Date:   Thu, 11 Oct 2018 20:50:57 +0200
Message-Id: <20181011185103.23146-4-kreijack@libero.it>
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

The caller knows better if this error is fatal or not, i.e. another disk is
available or not.

This is a preparatory patch.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index c9f0c4193..2a87eb103 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -603,12 +603,7 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
   if (do_rescan)
     grub_device_iterate (find_device_iter, &ctx);
   if (!ctx.dev_found)
-    {
-      grub_error (GRUB_ERR_BAD_FS,
-		  N_("couldn't find a necessary member device "
-		     "of multi-device filesystem"));
-      return NULL;
-    }
+    return NULL;
   data->n_devices_attached++;
   if (data->n_devices_attached > data->n_devices_allocated)
     {
@@ -905,6 +900,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
2.19.1

