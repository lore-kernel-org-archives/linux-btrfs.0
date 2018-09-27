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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F04EC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49B7C204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="FA9fJrt9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49B7C204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbeI1Ayt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:49 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:48601 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1Ays (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:48 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b84gnnmX; Thu, 27 Sep 2018 20:35:13 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073314; bh=RUGGHq/cn673sVQLeDDqm72t/W69qY0VR71ESZAFySg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FA9fJrt9rpyYDhgIRGwnz8/U+qxevKDbAHpFRqKEjZD7wBwJQDqcvrpPMUaoHwhVK
         ETJhPMI/7bAHttTmBQfBb3UHIq67CHAqiO8yGhzLsqJUCxBtaYzVqZNi4nyyCRulqo
         V4aeUfRVdILyhFwWlPMZJh0XMySMB+6TtVp6ocZqLF7IoZh8oIrhislUCViF8bxCP7
         S7+OsIVE0Hh32jcA0dLlrqqTLQnC6wzMkUkRHaQMi9ca9jMmxf6qQw/rkMjkRcJ5xa
         GMkzBKQxmje9xcfHWHg7ZFZ1/2YsvmK7jovkQ+nIBcr+RSSHDZgjKBb4dQq+7VqG5v
         eIZIRCugiyrHA==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17 a=yPCof4ZbAAAA:8
 a=GjNF4_zslFSpHsoFBLgA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/9] btrfs: Add helper to check the btrfs header.
Date:   Thu, 27 Sep 2018 20:34:57 +0200
Message-Id: <20180927183504.18078-3-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOx2v5hhUr1cFG1V6t/Vzq7GetQImNWHBOoJpAzhUiBaEaMBUfRuvpH93C2x6BIM8hQGC2R3s3OkBtR7Ggq51bYsrzh9xMrPvqVp7vB3I4aZYoMRrMmX
 umgu1r4T3YSHM0I8nJGqlFcgwwGdk0IcwjXNftwLVwjZSz2eRf9xc7TpDNcaQvQrmH9pxkUVh8Zz0a1hBfQhU/sQAMri0NV60GP3rGlQP4rP8k/QGhUS9bV5
 tbrHjG54jyfF889KrQ6d96rYAyoRfAU+lZZYWzzB19Y=
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
index 9bc6d399d..bf0dbce21 100644
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
2.19.0

