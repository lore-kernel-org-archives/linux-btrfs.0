Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27056C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC46020645
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:30:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="rqzo+IIs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC46020645
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbeJWBtg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 21:49:36 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:50769 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728568AbeJWBtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 21:49:35 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id Ee1mgPeG98KmnEe1ogfjrI; Mon, 22 Oct 2018 19:30:08 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1540229408; bh=R1USxw4Z/+qNRKevXadq2m1pnIUHt6KDSJ0uysAgReQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=rqzo+IIsmJFsCRhH0rUY13Phy2yfHnt613lmwkDEyz0e1maZXICYztwMpmMbDHfji
         hHtxe30IGylurjvR7tG8d3pVEfOcAxQYAQQbE+kPC5hogH36ANhXT+RRqwgA+WPZeN
         KSUi6lc9PUNMqI+vMOKAWTJd62+/OmdUgM8mLA554kl/zhzBTkqLkcDbcE36G9C8Ll
         DOooSNvQ/O/y/uCfy9kL89RE+M/QJteLsWpyZsiMAG7++SKgFkl4XYS2DcfJn9Tfdq
         K+gro5H7hjIwKaZYNnidwfb4vRgI2hJGM1D76PEyULQeO5g1dV6e1gYB/zjNm6QAjU
         DFmRhnRleMBVw==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=fGidO4j3AiKtNeS3nH0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/9] btrfs: Move the error logging from find_device() to its caller.
Date:   Mon, 22 Oct 2018 19:29:33 +0200
Message-Id: <20181022172938.7936-4-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181022172938.7936-1-kreijack@libero.it>
References: <20181022172938.7936-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHqgJISiJS6fR51Hz35O38qAU8jUYCd2mJjZwGQXqLnn0oSVIrdq4xL/N1oHu5RaWXKhBDG2g33WOvfIQhz8nCztBY4TelCEE9R4D4V6NaZZcRC6OiIN
 NHlwiqryoAHta9tk86WAaS12ILtL2HQvqHFcOybCzoK8bPalDOibCl+Gsk4QE+7a/0npPpRJk9Usrq17L792ao2bFEPzvD5IqXn5X67WZ2JbmUhAi+1nztyF
 KvCFs62XgqPcB9H8xIhigY7THSiJd3z1ENgIUiT9Uug=
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

