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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF45ECDE44
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C022145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="sA4VQyPr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65C022145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbeJSB6A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:58:00 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:40315 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728333AbeJSB6A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 21:58:00 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id DCWVgs2H18KmnDCWXgOdVG; Thu, 18 Oct 2018 19:55:53 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539885353; bh=JgAMnYNIHiju5Rd63/hYsQIu/hu1AUy86GiQKVcTUZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=sA4VQyPrD/6EN/ECp3t+m2gj/Rtq2rEk1kdXAttSJ6zaraZO6BqaOVuVvyLcu6kep
         HOxe4ex+a8oP+OVslukZtCK/+7X2G0wpHwWorZ39dpCZYasBVYEbrikxyTtoYI3j87
         oqiB/xKL2HK4w0cNQruuYdYzVY7aQTCM5UmKHZLCP616KxqvC21M2nYt6fgsLH5ghe
         vSEMfO0X1f1Qo9XRp7xuGsMT7X9p1wTKr1nntmY633SzD3kJRvN0GB7k9UZCAS6ZAa
         2C8zNkEvtT6zaqg5h9WKlhpD/TfHxtcX4Q2vWQBpZPVcxLqbU21wYVQUXGlr5qqpXu
         /yRsnbAb1mi7g==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=tbGcK1RVRLHxssNcnxoA:9 a=ROPnYPVHyosrfo3k:21 a=LACR2KO_iN7HUbMU:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/9] btrfs: Move logging code in grub_btrfs_read_logical()
Date:   Thu, 18 Oct 2018 19:55:37 +0200
Message-Id: <20181018175541.9532-6-kreijack@libero.it>
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

A portion of the logging code is moved outside of internal for(;;). The part
that is left inside is the one which depends on the internal for(;;) index.

This is a preparatory patch. The next one will refactor the code inside
the for(;;) into an another function.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 81f3bc120..dde0edd03 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -870,6 +870,18 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 	for (j = 0; j < 2; j++)
 	  {
+	    grub_dprintf ("btrfs", "chunk 0x%" PRIxGRUB_UINT64_T
+			  "+0x%" PRIxGRUB_UINT64_T
+			  " (%d stripes (%d substripes) of %"
+			  PRIxGRUB_UINT64_T ")\n",
+			  grub_le_to_cpu64 (key->offset),
+			  grub_le_to_cpu64 (chunk->size),
+			  grub_le_to_cpu16 (chunk->nstripes),
+			  grub_le_to_cpu16 (chunk->nsubstripes),
+			  grub_le_to_cpu64 (chunk->stripe_length));
+	    grub_dprintf ("btrfs", "reading laddr 0x%" PRIxGRUB_UINT64_T "\n",
+			  addr);
+
 	    for (i = 0; i < redundancy; i++)
 	      {
 		struct grub_btrfs_chunk_stripe *stripe;
@@ -882,20 +894,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
 		paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
 
-		grub_dprintf ("btrfs", "chunk 0x%" PRIxGRUB_UINT64_T
-			      "+0x%" PRIxGRUB_UINT64_T
-			      " (%d stripes (%d substripes) of %"
-			      PRIxGRUB_UINT64_T ") stripe %" PRIxGRUB_UINT64_T
+		grub_dprintf ("btrfs", "stripe %" PRIxGRUB_UINT64_T
 			      " maps to 0x%" PRIxGRUB_UINT64_T "\n",
-			      grub_le_to_cpu64 (key->offset),
-			      grub_le_to_cpu64 (chunk->size),
-			      grub_le_to_cpu16 (chunk->nstripes),
-			      grub_le_to_cpu16 (chunk->nsubstripes),
-			      grub_le_to_cpu64 (chunk->stripe_length),
 			      stripen, stripe->offset);
 		grub_dprintf ("btrfs", "reading paddr 0x%" PRIxGRUB_UINT64_T
-			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
-			      addr);
+			      "\n", paddr);
 
 		dev = find_device (data, stripe->device_id);
 		if (!dev)
-- 
2.19.1

