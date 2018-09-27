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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AFBC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B7521710
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="kCzss2I0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3B7521710
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbeI1Ay6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:58 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:48601 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1Ay6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:58 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b8Dgnnox; Thu, 27 Sep 2018 20:35:23 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073323; bh=D8/Oa/hiwA9uvsgVgRFsMcOUXabtbTjXMPHDpvSsihE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kCzss2I0XoCdd4ZcPtoqNzjjSKiEuQCmfi9sFshQptes9cC0Q8wXn73o91h8/7a8G
         EgsNFnFTh28UIp63+LJ7/Qji9+ApTO1pFulT9m1nqfIz51PMJTrFnMSu9AdTy4VCMX
         +UAAldGeDeZjJujATw2u8lKHSfNGRvF4C+keWU8Hh+uUMV4UhAzKWlmNKnezH3XYXG
         1CY16L6P6OCgPOMGE5abKEcTzB2AkWtvZ8q1gPenIW/nXDoiu/e2yPRcf5pNrDzMhW
         jGLXa7Bz7fXd5RicPcsZo5SN1a+VIg7Vj8BlalS4e5Dq0cDv/TwrM6fy4kx7rxG9yZ
         4Ubj2uMXvwfbQ==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17 a=yPCof4ZbAAAA:8
 a=54DIDk4bsIWUoIzoLckA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/9] btrfs: Refactor the code that read from disk
Date:   Thu, 27 Sep 2018 20:35:01 +0200
Message-Id: <20180927183504.18078-7-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDu1wfsDH/PlBPoVw677ZdJ6MVoRKvgu1dgWuKRrvG1OUr9AR1vkZmFyvrowjb177op6s1kv/PcYtQY6PaEK1KMRBIf4AVKBNodtE2IHYUAnKYlsXOxJ
 l4dgXmD8cs8TWutN90F8pwRpcMSyI8XmApFv8ogLOmDGhXVxj3FlLuKxuFKY6xGmFv72s4IKk/sZe7XsSrJKGlEMbxrzELABSeSfeUpGW9MOhadvyoVrU7vI
 5vtxtxuCqgCpy5WF76ndgcXbi/DckIxeSEtPUaou1dc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Move the code in charge to read the data from disk into a separate
function. This helps to separate the error handling logic (which depends on
the different raid profiles) from the read from disk logic.
Refactoring this code increases the general readability too.

This is a preparatory patch, to help the adding of the RAID 5/6 recovery
code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 75 ++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 179a2da9d..554f350c5 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -625,6 +625,46 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id)
   return ctx.dev_found;
 }
 
+static grub_err_t
+btrfs_read_from_chunk (struct grub_btrfs_data *data,
+		       struct grub_btrfs_chunk_item *chunk,
+		       grub_uint64_t stripen, grub_uint64_t stripe_offset,
+		       int redundancy, grub_uint64_t csize,
+		       void *buf)
+{
+    struct grub_btrfs_chunk_stripe *stripe;
+    grub_disk_addr_t paddr;
+    grub_device_t dev;
+    grub_err_t err;
+
+    stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
+    /* Right now the redundancy handling is easy.
+       With RAID5-like it will be more difficult.  */
+    stripe += stripen + redundancy;
+
+    paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
+
+    grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
+		  " maps to 0x%" PRIxGRUB_UINT64_T
+		  ". Reading paddr 0x%" PRIxGRUB_UINT64_T "\n",
+		  stripen, stripe->offset, paddr);
+
+    dev = find_device (data, stripe->device_id);
+    if (!dev)
+      {
+	grub_dprintf ("btrfs",
+		      "couldn't find a necessary member device "
+		      "of multi-device filesystem\n");
+	grub_errno = GRUB_ERR_NONE;
+	return GRUB_ERR_READ_ERROR;
+      }
+
+    err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
+			  paddr & (GRUB_DISK_SECTOR_SIZE - 1),
+			  csize, buf);
+    return err;
+}
+
 static grub_err_t
 grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 			 void *buf, grub_size_t size, int recursion_depth)
@@ -638,7 +678,6 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
       grub_err_t err = 0;
       struct grub_btrfs_key key_out;
       int challoc = 0;
-      grub_device_t dev;
       struct grub_btrfs_key key_in;
       grub_size_t chsize;
       grub_disk_addr_t chaddr;
@@ -885,36 +924,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 	    for (i = 0; i < redundancy; i++)
 	      {
-		struct grub_btrfs_chunk_stripe *stripe;
-		grub_disk_addr_t paddr;
-
-		stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
-		/* Right now the redundancy handling is easy.
-		   With RAID5-like it will be more difficult.  */
-		stripe += stripen + i;
-
-		paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
-
-		grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
-			      " maps to 0x%" PRIxGRUB_UINT64_T "\n",
-			      stripen, stripe->offset);
-		grub_dprintf ("btrfs", "reading paddr 0x%" PRIxGRUB_UINT64_T
-			      "\n", paddr);
-
-		dev = find_device (data, stripe->device_id);
-		if (!dev)
-		  {
-		    grub_dprintf ("btrfs",
-				  "couldn't find a necessary member device "
-				  "of multi-device filesystem\n");
-		    err = grub_errno;
-		    grub_errno = GRUB_ERR_NONE;
-		    continue;
-		  }
-
-		err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
-				      paddr & (GRUB_DISK_SECTOR_SIZE - 1),
-				      csize, buf);
+		err = btrfs_read_from_chunk (data, chunk, stripen,
+					     stripe_offset,
+					     i,     /* redundancy */
+					     csize, buf);
 		if (!err)
 		  break;
 		grub_errno = GRUB_ERR_NONE;
-- 
2.19.0

