Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaI3JnJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 05:43:09 -0400
Date: Tue, 30 Sep 2014 11:43:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, naota@elisp.net
Subject: Re: [PATCH] Btrfs-progs: make BUG*() be more verbose
Message-ID: <20140930094306.GH11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411675630-4109-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411675630-4109-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 25, 2014 at 04:07:10PM -0400, Josef Bacik wrote:
> Currently these macros just tie to assert(), which gives us line number and such
> but no backtrace so no actual context.  This patch adds support for spitting out
> a backtrace so we can see how we got to the given assert.  Thanks,

https://patchwork.kernel.org/patch/4757041/

There are differences and I find Josef's implementation better in some
respects and Naota's in others. Below is what I'm going to apply with
sign-offs from both of you.

Notable change is the use of backtrace_symbols_fd, it does not
malloc/free the memory, though the output is slighly different from
backtrace_symbols, still readable.

--- a/kerncompat.h
+++ b/kerncompat.h
@@ -55,21 +55,17 @@
 #define ULONG_MAX       (~0UL)
 #endif

+#define MAX_BACKTRACE  16
 static inline void print_trace(void)
 {
-       void *array[10];
+       void *array[MAX_BACKTRACE];
        size_t size;
-       char **strings;
-       size_t i;
-
-       size = backtrace(array, 10);
-       strings = backtrace_symbols(array, size);
-       for (i = 0; i < size; i++)
-               fprintf(stderr, "\t%s\n", strings[i]);
-       free(strings);
+
+       size = backtrace(array, MAX_BACKTRACE);
+       backtrace_symbols_fd(array, size, 2);
 }

-static inline void btr_assert(const char *assertion, const char *filename,
+static inline void assert_trace(const char *assertion, const char *filename,
                              const char *func, unsigned line, int val)
 {
        if (val)
@@ -84,7 +80,7 @@ static inline void btr_assert(const char *assertion, const char *filename,
        exit(1);
 }

-#define BUG() btr_assert(NULL, __FILE__, __func__, __LINE__, 0)
+#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 0)

 #ifdef __CHECKER__
 #define __force    __attribute__((force))
@@ -268,10 +264,10 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)

-#define BUG_ON(c) btr_assert(#c, __FILE__, __func__, __LINE__, !(c))
+#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, !(c))

 #define WARN_ON(c) BUG_ON(c)
-#define        ASSERT(c) btr_assert(#c, __FILE__, __func__, __LINE__, (c))
+#define        ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (c))

 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
