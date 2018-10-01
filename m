Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4642AC43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1515320C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1515320C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbeJAVYi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:42358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729499AbeJAVYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92C39AF40
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:26 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/10] btrfs-progs: Implement find_*_bit_le operations
Date:   Mon,  1 Oct 2018 17:46:15 +0300
Message-Id: <1538405181-25231-5-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This commit introduces explicit little endian bit operations. The only
difference with the existing bitops implementation is that bswap(32|64)
is called when the _le versions are invoked on a big-endian machine.
This is in preparation for adding free space tree conversion support.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 kernel-lib/bitops.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/kernel-lib/bitops.h b/kernel-lib/bitops.h
index 78256adf55be..5030bfa2815e 100644
--- a/kernel-lib/bitops.h
+++ b/kernel-lib/bitops.h
@@ -2,6 +2,7 @@
 #define _PERF_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
+#include <endian.h>
 #include "internal.h"
 
 #ifndef DIV_ROUND_UP
@@ -170,5 +171,86 @@ static inline unsigned long find_next_zero_bit(const unsigned long *addr,
 }
 
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
+#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+
+static inline unsigned long ext2_swab(const unsigned long y)
+{
+#if BITS_PER_LONG == 64
+	return (unsigned long) bswap64((u64) y);
+#elif BITS_PER_LONG == 32
+	return (unsigned long) bswap32((u32) y);
+#else
+#error BITS_PER_LONG not defined
+#endif
+}
+
+static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
+{
+	unsigned long tmp;
+
+	if (start >= nbits)
+		return nbits;
+
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
+
+	/* Handle 1st word. */
+	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
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
+	}
+
+	return min(start + __ffs(ext2_swab(tmp)), nbits);
+}
+
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, NULL, size, offset, ~0UL);
+}
+
+
+unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, NULL, size, offset, 0UL);
+}
+
+#else
+
+static inline unsigned long find_next_zero_bit_le(const void *addr,
+                unsigned long size, unsigned long offset)
+{
+        return find_next_zero_bit(addr, size, offset);
+}
+
+static inline unsigned long find_next_bit_le(const void *addr,
+                unsigned long size, unsigned long offset)
+{
+        return find_next_bit(addr, size, offset);
+}
+
+static inline unsigned long find_first_zero_bit_le(const void *addr,
+                unsigned long size)
+{
+        return find_first_zero_bit(addr, size);
+}
+
+#endif
 
 #endif
-- 
2.7.4

