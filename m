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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B909C6780B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 057802085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="VzRgdvwt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 057802085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbeJLCTq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:19:46 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:52800 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729799AbeJLCTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:19:45 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3HgbY0C; Thu, 11 Oct 2018 20:51:16 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283876; bh=5oBI0qGMFDD6zfiFnly1NgYUQ377A4SniXN+v2UHtPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VzRgdvwt6iLWeVESPIZMBRd241siCWIeyU4dJxYaFKbnCWnIu3hSqgou+x7XYAoPO
         bEir4GWKEeH5sHWhFRg0vhev2UECToWv7fvUKUbG1OmNC7UXGVWr2IgntizXCTPShQ
         SQur5+qnEtIR7qmYe4YEtNraEIAfJjdIolZLQwVCi73CQMAbRH3Ny6omLehn/VM9Io
         0VxV3rVKz1V08/oOKJJUciqcUU2hgM8uy8X51WUlLwbwjEqjrMXLc1F5fr2HwiEOD3
         g/iUS5EpIUFqvOytrm9Oo7mUyVTacRjFvWEN0ZOXX+nOfI8H+naujUDtuEXu+VJR/Z
         Xkhjf9xkAZ3QQ==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17 a=yPCof4ZbAAAA:8
 a=tbGcK1RVRLHxssNcnxoA:9 a=ROPnYPVHyosrfo3k:21 a=LACR2KO_iN7HUbMU:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/9] btrfs: Move logging code in grub_btrfs_read_logical()
Date:   Thu, 11 Oct 2018 20:50:59 +0200
Message-Id: <20181011185103.23146-6-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011185103.23146-1-kreijack@libero.it>
References: <20181011185103.23146-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMeBmjCiNA9CZ9pgvDmeFIYY3WeUnL16lyNyCt1jGH12Omfy0EpmL1x9tU8UqVW7TSZs3cCeonhUGMsDt4Y37TLH2+Uugn7gj63cjTg7UlkOsnpi4ceD
 61fitc/Y3QHgO+teqAn8FnoHs1KaiKMn8VW/gWQenS33Vs1+tO94Y60BX0oOcyJpKVxoIp4uvQMbuIUfF8sWTj9T3pgWIqTdiCUNwnVwmlv0cPq8osT8AGoX
 mN+mq+vQzghv9aAFC6CzmV8LoC22a+JrqeEpCQXf48E=
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
index b2be80c33..a82211ccc 100644
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

