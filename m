Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EA8C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B611D20C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B611D20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbeJAVYh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:42346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbeJAVYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08521AF12
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:26 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/10] btrfs-progs: Add extent buffer bitmap manipulation infrastructure
Date:   Mon,  1 Oct 2018 17:46:13 +0300
Message-Id: <1538405181-25231-3-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Those functions are in preparation for adding the freespace tree
repair code since it needs to be able to deal with bitmap based fsts.
This patch adds extent_buffer_bitmap_set and extent_buffer_bitmap_clear
functions. Since in userspace we don't have to deal with page mappings
their implementation is vastly simplified by simply setting each bit in
the passed range.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent_io.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 extent_io.h |  4 ++++
 2 files changed, 60 insertions(+)

diff --git a/extent_io.c b/extent_io.c
index 198492699438..de47c2c59ae9 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -204,6 +204,62 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	return ret;
 }
 
+/**
+ * extent_buffer_bitmap_set - set an area of a bitmap
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @pos: bit number of the first bit
+ * @len: number of bits to set
+ */
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+                              unsigned long pos, unsigned long len)
+{
+	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
+	const unsigned int size = pos + len;
+	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
+	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
+
+	while (len >= bits_to_set) {
+		*p |= mask_to_set;
+		len -= bits_to_set;
+		bits_to_set = BITS_PER_BYTE;
+		mask_to_set = ~0;
+		p++;
+	}
+	if (len) {
+		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
+		*p |= mask_to_set;
+	}
+}
+
+
+/**
+ * extent_buffer_bitmap_clear - clear an area of a bitmap
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @pos: bit number of the first bit
+ * @len: number of bits to clear
+ */
+void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
+                                unsigned long pos, unsigned long len)
+{
+	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
+	const unsigned int size = pos + len;
+	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
+	u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
+
+	while (len >= bits_to_clear) {
+		*p &= ~mask_to_clear;
+		len -= bits_to_clear;
+		bits_to_clear = BITS_PER_BYTE;
+		mask_to_clear = ~0;
+		p++;
+	}
+	if (len) {
+		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
+		*p &= ~mask_to_clear;
+	}
+}
 /*
  * clear some bits on a range in the tree.
  */
diff --git a/extent_io.h b/extent_io.h
index d407d93d617e..b67c6fc40e89 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -175,4 +175,8 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 			u64 bytes, int mirror);
 int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 		       u64 bytes, int mirror);
+void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
+                                unsigned long pos, unsigned long len);
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+                              unsigned long pos, unsigned long len);
 #endif
-- 
2.7.4

