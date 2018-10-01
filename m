Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7507C0044B
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96BF620C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96BF620C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbeJAVYi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:42352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729496AbeJAVYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D85BAF14
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:26 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/10] btrfs-progs: Replace homegrown bitops related functions with kernel counterparts
Date:   Mon,  1 Oct 2018 17:46:14 +0300
Message-Id: <1538405181-25231-4-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace existing find_*_bit functions with kernel equivalent. This
reduces duplication, simplifies the code (we really have one worker
function _find_next_bit) and is quite likely faster. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 kernel-lib/bitops.h | 142 +++++++++++++++++-----------------------------------
 1 file changed, 46 insertions(+), 96 deletions(-)

diff --git a/kernel-lib/bitops.h b/kernel-lib/bitops.h
index 5b35f9fc5213..78256adf55be 100644
--- a/kernel-lib/bitops.h
+++ b/kernel-lib/bitops.h
@@ -2,6 +2,7 @@
 #define _PERF_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
+#include "internal.h"
 
 #ifndef DIV_ROUND_UP
 #define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
@@ -109,116 +110,65 @@ static __always_inline unsigned long __ffs(unsigned long word)
 
 #define ffz(x) __ffs(~(x))
 
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1))) 
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
+
 /*
- * Find the first set bit in a memory region.
+ * This is a common helper function for find_next_bit, find_next_zero_bit, and
+ * find_next_and_bit. The differences are:
+ *  - The "invert" argument, which is XORed with each fetched word before
+ *    searching it for one bits.
+ *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static inline unsigned long
-find_first_bit(const unsigned long *addr, unsigned long size)
+static inline unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
 	unsigned long tmp;
 
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+	if (start >= nbits)
+		return nbits;
+
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
+
+	/* Handle 1st word. */
+	tmp &= BITMAP_FIRST_WORD_MASK(start);
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
+
+		tmp = addr1[start / BITS_PER_LONG];
+		if (addr2)
+			tmp &= addr2[start / BITS_PER_LONG];
+		tmp ^= invert;
 	}
-	if (!size)
-		return result;
-
-	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found:
-	return result + __ffs(tmp);
+
+	return min(start + __ffs(tmp), nbits);
 }
 
 /*
  * Find the next set bit in a memory region.
  */
-static inline unsigned long
-find_next_bit(const unsigned long *addr, unsigned long size,
-	      unsigned long offset)
+static inline unsigned long find_next_bit(const unsigned long *addr,
+					  unsigned long size,
+					  unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + __ffs(tmp);
+	return _find_next_bit(addr, NULL, size, offset, 0UL);
 }
 
-/*
- * This implementation of find_{first,next}_zero_bit was stolen from
- * Linus' asm-alpha/bitops.h.
- */
-static inline unsigned long
-find_next_zero_bit(const unsigned long *addr, unsigned long size,
-		   unsigned long offset)
+static inline unsigned long find_next_zero_bit(const unsigned long *addr,
+					       unsigned long size,
+					       unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp |= ~0UL >> (BITS_PER_LONG - offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (~tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if (~(tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp |= ~0UL << size;
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + ffz(tmp);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL);
 }
+
+#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
+
 #endif
-- 
2.7.4

