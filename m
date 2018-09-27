Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B55C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9D7A204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="fHkOrz4F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9D7A204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbeI1Ayu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:50 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54811 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1Ayu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:50 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b87gnnn3; Thu, 27 Sep 2018 20:35:15 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073315; bh=FC70Ohc1AbMC5cIr0xbtcjxhs1/XHdul+SAZ6Z/uJjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fHkOrz4FHldVf+uaomEKJJ2G8E2ilLlmQTX5tCuPEcPZ/yyVVkRpuSDSnSDQcAYrG
         Sol+elVHHRpMAzNy9Ud6qW2v/4c5dkjbofe7bqXp+H7n4kjyoBnumNlK4Iu+B0jxAR
         c513xt5hL4itmowRUVOZxfcDEovOiakxxZctjI6wp42h8ftJFRsRd0+nopEmIlbRac
         xyA6EIKnxCMu5ni8mUexPjxE5Pe9hay7whnn4KTyJigWPvX+W4VlBpWT37LdmHrOMV
         tT7jU1S29U7D5WOSN8EirIXwup8qVMX2nPNqPl6YPVbaznPn30yTCHnLzrGnUg0ltR
         oO8m4zAXlilpw==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17 a=yPCof4ZbAAAA:8
 a=fGidO4j3AiKtNeS3nH0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/9] btrfs: Move the error logging from find_device() to its caller.
Date:   Thu, 27 Sep 2018 20:34:58 +0200
Message-Id: <20180927183504.18078-4-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGy/KcnOcL0sLmqIW14sch+/wM3CAntTFnnS1dn+AFQ+j96w3TLUaeeP1+nAWEfGVEKKoN7oGDO1nPDNWgU6sHjnvuDZ1oK6ocjyKX9WarEFx42Vv/KG
 qjsnyt6r4kyMCgsmkPmzsur6JW4WRxG4R9TG9jUDLf7XHN7z6y76dFOVX1YrLwNsHxIEiSODLWzcl2TWdRJeignIXQlmo+PVN2oqc31GSiKh70fSUg1589qW
 RxyMg9OVbHyBUUZPsQ5xSqGEEal9cMNoeGsM7Cui3dk=
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
index bf0dbce21..2b1dd7dd4 100644
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
@@ -906,6 +901,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
2.19.0

