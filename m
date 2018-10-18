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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8FCECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 621D8204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="AyJZqRKF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 621D8204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbeJSB6o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:58:44 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:56338 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727754AbeJSB57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 21:57:59 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id DCWVgs2H18KmnDCWXgOdUv; Thu, 18 Oct 2018 19:55:53 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539885353; bh=R1USxw4Z/+qNRKevXadq2m1pnIUHt6KDSJ0uysAgReQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AyJZqRKFQ3Bt3NJBszJSn9eFeqC0J88nusZMTq6fxnCIXmMtGUjBfPkH3S9p5oEcS
         Makl2qqBZtAkdy+PvzAsiGiyIOwrJsncpWLeILMRX7Ohj2vzsApHgKE9r3roYq3nPs
         21WUem3VMVnRL/A6iMU6jDg9Hx4qEPdsjwQBW7u+G2kMcc+lMWSzfDJfWJ1c8EdkrA
         nRG8lMVySZa0BF1IoQnu9/g3J0A0lvsXwslj++KIYPIXucTbvN2pASul31IfaMPBrv
         DQFWJj1kEd6zt56UFqEJ1ageZ1Ml1l8AJG/JZWx0DmiDCbqRDVv1AqaLLvF9F8oEqS
         0dGDpEAWF2RaA==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=fGidO4j3AiKtNeS3nH0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/9] btrfs: Move the error logging from find_device() to its caller.
Date:   Thu, 18 Oct 2018 19:55:35 +0200
Message-Id: <20181018175541.9532-4-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018175541.9532-1-kreijack@libero.it>
References: <20181018175541.9532-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKA6V6PKlekOD9Xx3BgJQdYoZIsHhxncncqu7jLtqWvEsiVogfu1H92MLiQbTtt9HjZJhtYm4tUgQYEchll6c5BLL+9qYzxNirSzF0KT1ErLgBOh9x38
 5Ir5fpb0ZxA5F8q7FDDzf4Pq4/dPxFTuclskxMOZRmj0fVmHs+cFjjoyObV9uIBEIiFzAjW9WxPtrauquePY6FgUsrZdyxDAu6a4d20GtH4kuLTDZHo/uwnC
 sMBtTZuGEWCZ3UsF24TlbU+01MLtO3hAjSkBaHOoXqQ=
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
index 0cbf3551a..6b6e91cd1 100644
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

