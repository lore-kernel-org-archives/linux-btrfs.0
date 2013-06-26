Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40822 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3FZEQu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 00:16:50 -0400
Received: by mail-pb0-f53.google.com with SMTP id xb12so13492285pbc.40
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 21:16:50 -0700 (PDT)
From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH btrfs-progs] kerncompat.h: remove offsetof redefinition
Date: Wed, 26 Jun 2013 00:16:43 -0400
Message-Id: <1372220203-17349-1-git-send-email-crrodriguez@opensuse.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Must use the version provided by the compiler in stddef.h header
---
 kerncompat.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 9c116b4..6b4b4ba 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -26,6 +26,7 @@
 #include <endian.h>
 #include <byteswap.h>
 #include <assert.h>
+#include <stddef.h>
 
 #ifndef READ
 #define READ 0
@@ -234,12 +235,6 @@ static inline long IS_ERR(const void *ptr)
 #define BUG_ON(c) assert(!(c))
 #define WARN_ON(c) assert(!(c))
 
-#undef offsetof
-#ifdef __compiler_offsetof
-#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
-#else
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
 
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
-- 
1.8.3.1

