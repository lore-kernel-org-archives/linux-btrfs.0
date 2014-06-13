Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46582 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 17:18:58 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so2519031pbb.27
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 14:18:58 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] Fix undefined behavior in radix-tree.c.
Date: Fri, 13 Jun 2014 14:18:50 -0700
Message-Id: <1402694330-21211-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running with UndefinedBehaviorSanitizer, the tests produce the following
error:

  radix-tree.c:836:30: runtime error: shift exponent 18446744073709551613
  is too large for 64-bit type 'unsigned long'

(That's a negative shift exponent represented as an unsigned long.)

Even though the value is discarded in those cases, it's still undefined
behavior; see the C99 standard, section 6.5.7, paragraph three: "If the
value of the right operand is negative [...] the behavior is undefined."

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 radix-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/radix-tree.c b/radix-tree.c
index 4f295fc..7457944 100644
--- a/radix-tree.c
+++ b/radix-tree.c
@@ -833,10 +833,10 @@ int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
 static unsigned long __maxindex(unsigned int height)
 {
 	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+	unsigned long index = ~0UL;
 
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
+	if (tmp < RADIX_TREE_INDEX_BITS)
+		index = (index >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
 	return index;
 }
 
-- 
2.0.0.526.g5318336

