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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712F7ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E46A2145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="pQpsuX9Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E46A2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbeJSB57 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:57:59 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:52986 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728327AbeJSB57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 21:57:59 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id DCWVgs2H18KmnDCWWgOdUm; Thu, 18 Oct 2018 19:55:52 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539885352; bh=rBCv2aOPJtIw+dlR3woR1f4IXLbCloRw2O+TGV2oeWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=pQpsuX9YOcr39A2TUBS8LGc7hFNdwAeHjP06j2GbpPGLVBOYRp2XAzi7hYxhZrCsr
         84TQ7QNKOMUZjJc2ihzPEx9KyiOBgaFHUDtFWbjlZYklkbT9GZ57Ga78yExFjxUILt
         fmLml5MGwLF3XTJzidfya8iWZ3wGLlF06CIagpP3FIi6cpcZpNQnEqsvMp7NB4WrpQ
         YOEri8ZUjHas2HgIpg2Mbog+GcPmvOU/s8T4YSZiPtingipd93UVHKOGYCpkxoPxuU
         Dfyk9xXWBa8528nSuEgJKD+rwES+8yE6ZaxeThOj/zePVk0mwcRwuVVLHWIwUiEjiW
         sd0vBtqDxxLbA==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=GjNF4_zslFSpHsoFBLgA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/9] btrfs: Add helper to check the btrfs header.
Date:   Thu, 18 Oct 2018 19:55:34 +0200
Message-Id: <20181018175541.9532-3-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018175541.9532-1-kreijack@libero.it>
References: <20181018175541.9532-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNL1fYobHY7OOyWh4B9XlEOJUJi9iSvu/GgQov9RUz9u22NgLKD6V8GsDuzix3QOuQqUIJ6Qj0tPO56+X4WymHJ1yrwcTLXAOfrplRXQ+T/kPu//lsu2
 rtP6E+e0dUfaoFXX4o1UXXKhELGQtsw/877aCpYLZMiEMxXcpSZvILzgS0t8ik4zXKFoJ14bD39O0aJGtqqgvuakzkCDSANWs+Khn3myc3nHzM5yZtPZ3O5G
 28rlFCAY/IA6UUUrFpbnMS8s/2B6Jhn8fkED/xg18vc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

This helper is used in a few places to help the debugging. As
conservative approach the error is only logged.
This does not impact the error handling.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index 9122169aa..0cbf3551a 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -77,7 +77,8 @@ struct btrfs_header
 {
   grub_btrfs_checksum_t checksum;
   grub_btrfs_uuid_t uuid;
-  grub_uint8_t dummy[0x30];
+  grub_uint64_t bytenr;
+  grub_uint8_t dummy[0x28];
   grub_uint32_t nitems;
   grub_uint8_t level;
 } GRUB_PACKED;
@@ -286,6 +287,25 @@ free_iterator (struct grub_btrfs_leaf_descriptor *desc)
   grub_free (desc->data);
 }
 
+static grub_err_t
+check_btrfs_header (struct grub_btrfs_data *data, struct btrfs_header *header,
+                    grub_disk_addr_t addr)
+{
+  if (grub_le_to_cpu64 (header->bytenr) != addr)
+    {
+      grub_dprintf ("btrfs", "btrfs_header.bytenr is not equal node addr\n");
+      return grub_error (GRUB_ERR_BAD_FS,
+			 "header bytenr is not equal node addr");
+    }
+  if (grub_memcmp (data->sblock.uuid, header->uuid, sizeof(grub_btrfs_uuid_t)))
+    {
+      grub_dprintf ("btrfs", "btrfs_header.uuid doesn't match sblock uuid\n");
+      return grub_error (GRUB_ERR_BAD_FS,
+			 "header uuid doesn't match sblock uuid");
+    }
+  return GRUB_ERR_NONE;
+}
+
 static grub_err_t
 save_ref (struct grub_btrfs_leaf_descriptor *desc,
 	  grub_disk_addr_t addr, unsigned i, unsigned m, int l)
@@ -341,6 +361,7 @@ next (struct grub_btrfs_data *data,
 
       err = grub_btrfs_read_logical (data, grub_le_to_cpu64 (node.addr),
 				     &head, sizeof (head), 0);
+      check_btrfs_header (data, &head, grub_le_to_cpu64 (node.addr));
       if (err)
 	return -err;
 
@@ -402,6 +423,7 @@ lower_bound (struct grub_btrfs_data *data,
       /* FIXME: preread few nodes into buffer. */
       err = grub_btrfs_read_logical (data, addr, &head, sizeof (head),
 				     recursion_depth + 1);
+      check_btrfs_header (data, &head, addr);
       if (err)
 	return err;
       addr += sizeof (head);
-- 
2.19.1

