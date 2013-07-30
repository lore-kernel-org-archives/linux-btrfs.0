Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53749 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777Ab3G3VFs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 17:05:48 -0400
Message-ID: <1375218347.2075.133.camel@joe-AO722>
Subject: Re: btrfs zero divide
From: Joe Perches <joe@perches.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Thorsten Glaser <tg@mirbsd.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 14:05:47 -0700
In-Reply-To: <20130730204001.GG24583@localhost.localdomain>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	 <20130730171329.GF24583@localhost.localdomain>
	 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	 <20130730204001.GG24583@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-07-30 at 16:40 -0400, Josef Bacik wrote:
> So stripe_len shouldn't be 0, if it is you have bigger problems :).  Is this a
> corrupt fs or something?  If there was some sort of corruption that occured then
> I suppose stripe_len could be 0 and we'd need to catch that somewhere higher up
> the stack and error out.  Is there a way you could check and see if that's the
> case?  Thanks,

Maybe use a temporary check in do_div
Something like this maybe. (uncompiled/untested)
---
 include/asm-generic/div64.h | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index 8f4e319..cce75fe 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -19,16 +19,25 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/bug.h>
+#include <linux/printk.h>
 
 #if BITS_PER_LONG == 64
 
-# define do_div(n,base) ({					\
+# define do_div(n, base)					\
+({								\
 	uint32_t __base = (base);				\
 	uint32_t __rem;						\
-	__rem = ((uint64_t)(n)) % __base;			\
-	(n) = ((uint64_t)(n)) / __base;				\
+	if (__base == 0) {					\
+		WARN(1, "Attempted division by 0\n");		\
+		dump_stack();					\
+		__rem = 0;					\
+	} else {						\
+		__rem = ((uint64_t)(n)) % __base;		\
+		(n) = ((uint64_t)(n)) / __base;			\
+	}							\
 	__rem;							\
- })
+})
 
 #elif BITS_PER_LONG == 32
 
@@ -37,16 +46,22 @@ extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
 /* The unnecessary pointer compare is there
  * to check for type safety (n must be 64bit)
  */
-# define do_div(n,base) ({				\
-	uint32_t __base = (base);			\
-	uint32_t __rem;					\
-	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
-	if (likely(((n) >> 32) == 0)) {			\
-		__rem = (uint32_t)(n) % __base;		\
-		(n) = (uint32_t)(n) / __base;		\
-	} else 						\
-		__rem = __div64_32(&(n), __base);	\
-	__rem;						\
+# define do_div(n, base)					\
+({								\
+	uint32_t __base = (base);				\
+	uint32_t __rem;						\
+	(void)(((typeof((n)) *)0) == ((uint64_t *)0));		\
+	if (__base == 0) {					\
+		WARN(1, "Attempted division by 0\n");		\
+		dump_stack();					\
+		__rem = 0;					\
+	} else if (likely(((n) >> 32) == 0)) {			\
+		__rem = (uint32_t)(n) % __base;			\
+		(n) = (uint32_t)(n) / __base;			\
+	} else {						\
+		__rem = __div64_32(&(n), __base);		\
+	}							\
+	__rem;							\
  })
 
 #else /* BITS_PER_LONG == ?? */


