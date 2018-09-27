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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AF9C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E796D204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="hUlSEsMj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E796D204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbeI1Ay4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:56 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54811 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1Ayz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:55 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b8Agnno7; Thu, 27 Sep 2018 20:35:20 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073320; bh=evlQsV+nL94B+anSlorPT7Gx3TrMpGI2ldLReuK5fIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hUlSEsMj1io54FMNkLxA+0KNYmPd175xrSQbo0f9TiOfe8Jjf9krwLFnU83NHQ0UD
         sQvts14eG3RJ3Lb2LwNG5FD4+fYrrTGeBaGsD5fj8Mrncc4fBBDiYjYLpEJMX/3TGf
         rOJ4FOkawZSd88zSe3OuMGvh2f4lQaKRiBeRFDUoa6xrpJ7okKWjsHwZXzK6VJotn7
         gBhZjmc6z26amfiFvOO3qcdJWSXAXKOjojMbf5h8ZuU0vg1ZgW40fHpPl865ebnmRp
         Dh6EH6/wC56zGz8+Iq3cQevuaX/SDzMSubzZ/zXCtkKgTios3cE9sw0LyMm0rAo/Iv
         N3+uL9E7XMbuw==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17 a=yPCof4ZbAAAA:8
 a=tbGcK1RVRLHxssNcnxoA:9 a=R0ZrlE3BOGKx5Mtq:21 a=LACR2KO_iN7HUbMU:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/9] btrfs: Move logging code in grub_btrfs_read_logical()
Date:   Thu, 27 Sep 2018 20:35:00 +0200
Message-Id: <20180927183504.18078-6-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLnViWsf5K0e1cjr5mtsJFOenyINwWpVSVPx9Vk1vsxYRunXhAfDWj4QFtr2MbUem/qwhF9H5rRncBPUbxAF1JxIzBUqfBu2u9G4YIFILE2s0DCPJaqS
 GPXqGh+jl0TTavg3jh4dZe0N3d6R5YiAfgE8Eeo3D+IZIuZahQV7nPrDiKOz93Wd0L35+oOYSJZMJzBNf+otINpucKcKbY+naC4tPCDoz64epKHCbic0zX91
 SulZhQUKRT6FUPf2m3UvQpvWikSUnRk1EMk2ZgL0HyU=
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
index c07d91657..179a2da9d 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -871,6 +871,18 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
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
@@ -883,20 +895,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 
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
2.19.0

