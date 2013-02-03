Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3BCReb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 12:34:31 -0500
Message-ID: <510E9FA3.5060600@redhat.com>
Date: Sun, 03 Feb 2013 11:34:27 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: include kerncompat.h in raid6.c, define __attribute_const__
References: <510D7356.4030903@inwind.it> <510E8898.4050606@redhat.com> <20130203170138.GC16594@twin.jikos.cz>
In-Reply-To: <20130203170138.GC16594@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

raid6.c was failing to build for Goffredo and me due to
__attribute_const__ being undefined.

Define it in kerncompat.h and include that; this also makes
sure BITS_PER_LONG is defined for raid6.c, prior to this it 
was not defined, at least in my build.

Finally, redefine BITS_PER_LONG in a way that it can be
tested in the preprocessor macro.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/kerncompat.h b/kerncompat.h
index d60f722..1e7b7d3 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -36,7 +36,7 @@
 #define gfp_t int
 #define get_cpu_var(p) (p)
 #define __get_cpu_var(p) (p)
-#define BITS_PER_LONG (sizeof(long) * 8)
+#define BITS_PER_LONG (__SIZEOF_LONG__ * 8)
 #define __GFP_BITS_SHIFT 20
 #define __GFP_BITS_MASK ((int)((1 << __GFP_BITS_SHIFT) - 1))
 #define GFP_KERNEL 0
@@ -126,6 +126,8 @@ static inline int mutex_is_locked(struct mutex *m)
 #define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
+#define __attribute_const__	__attribute__((__const__))
+
 /**
  * __set_bit - Set a bit in memory
  * @nr: the bit to set
diff --git a/raid6.c b/raid6.c
index 3a42bdf..ce0f655 100644
--- a/raid6.c
+++ b/raid6.c
@@ -19,6 +19,8 @@
  */
 #include <stdint.h>
 #include <unistd.h>
+#include "kerncompat.h"
+
 /*
  * This is the C data type to use
  */


