Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36508 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGLUFF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 16:05:05 -0400
Received: by mail-pg0-f48.google.com with SMTP id u62so18009264pgb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 13:05:05 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] btrfs-progs: Enable ThreadSanitizer, using D=tsan.
Date: Wed, 12 Jul 2017 13:04:49 -0700
Message-Id: <20170712200449.18638-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tested with clang-3.9.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index 81598df..8948301 100644
--- a/Makefile
+++ b/Makefile
@@ -17,6 +17,7 @@
 #                  abort   - call abort() on first error (dumps core)
 #                  all     - shortcut for all of the above
 #                  asan    - enable address sanitizer compiler feature
+#                  tsan    - enable thread sanitizer compiler feature
 #                  ubsan   - undefined behaviour sanitizer compiler feature
 #                  bcheck  - extended build checks
 #   W=123          build with warnings (default: off)
@@ -157,6 +158,11 @@ ifneq (,$(findstring asan,$(D)))
   DEBUG_CFLAGS_INTERNAL += -fsanitize=address
 endif
 
+ifneq (,$(findstring tsan,$(D)))
+  DEBUG_CFLAGS_INTERNAL += -fsanitize=thread -fPIE
+  LD_FLAGS += -fsanitize=thread -ltsan -pie
+endif
+
 ifneq (,$(findstring ubsan,$(D)))
   DEBUG_CFLAGS_INTERNAL += -fsanitize=undefined
 endif
-- 
2.13.2.932.g7449e964c-goog

