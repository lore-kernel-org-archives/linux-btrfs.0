From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 15:58:48 +0100
Message-ID: <1218034728.5111.77.camel@pmac.infradead.org>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218032511.15342.73.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 10:21 -0400, Chris Mason wrote:
> NFS Support

This is basically ready. All you need in btrfs is the two patches from
Balaji Rao, which I've updated to apply to the 0.16 and put in
git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git (along with a
build fix for 2.6.27-rc2, which is also below).

The rest of it is a generic problem with NFSD, for which the (current)
fix is at git.infradead.org/users/dwmw2/nfsexport-2.6.git

You could perhaps copy the readdir hack into btrfs code for use with
obsolete kernels -- but to be honest I'd be inclined to leave that for
the masochists^Wenterprise folks.

>From 6c5f1012ccb1bb8a55dc9e564db3ca15d893763b Mon Sep 17 00:00:00 2001
From: David Woodhouse <David.Woodhouse@intel.com>
Date: Wed, 6 Aug 2008 15:54:51 +0100
Subject: [PATCH] Change TestSetPageLocked() to trylock_page()

Add backwards compatibility in compat.h

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 compat.h    |    3 +++
 extent_io.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/compat.h b/compat.h
index d39a768..b3349a6 100644
--- a/compat.h
+++ b/compat.h
@@ -1,6 +1,9 @@
 #ifndef _COMPAT_H_
 #define _COMPAT_H_
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,26)
+#define trylock_page(page) (!TestSetPageLocked(page))
+#endif
 
 /*
  * Even if AppArmor isn't enabled, it still has different prototypes.
diff --git a/extent_io.c b/extent_io.c
index 1cf4bab..f46f886 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -14,6 +14,7 @@
 #include <linux/pagevec.h>
 #include "extent_io.h"
 #include "extent_map.h"
+#include "compat.h"
 
 /* temporary define until extent_map moves out of btrfs */
 struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
@@ -3055,7 +3056,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!wait) {
-			if (TestSetPageLocked(page))
+			if (!trylock_page(page))
 				goto unlock_exit;
 		} else {
 			lock_page(page);
-- 
1.5.5.1



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



