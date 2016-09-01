Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754179AbcIADzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 23:55:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2473ABEC
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Sep 2016 03:55:36 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: add dynamic debug support
Message-ID: <57C7A6B5.7040409@suse.com>
Date: Wed, 31 Aug 2016 23:55:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can re-use the dynamic debugging descriptor to make use of the dynamic
debugging mechanism but still use our own printk interface.

Defining the DEBUG macro works as it did before.  When it's defined,
all of the messages default to print.  We can also enable all debug
messages at boot or module-load time using the 'dyndbg' and
'btrfs.dyndbg' options.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eff3993..abb274d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -37,6 +37,7 @@
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/sizes.h>
+#include <linux/dynamic_debug.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -3314,7 +3315,35 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	btrfs_printk_ratelimited(fs_info, KERN_NOTICE fmt, ##args)
 #define btrfs_info_rl(fs_info, fmt, args...) \
 	btrfs_printk_ratelimited(fs_info, KERN_INFO fmt, ##args)
-#ifdef DEBUG
+
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define btrfs_debug(fs_info, fmt, args...)				\
+do {									\
+        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
+        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
+		btrfs_printk(fs_info, KERN_DEBUG fmt, ##args);		\
+} while (0)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...) 			\
+do {									\
+        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt); 	        \
+        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT)) 		\
+		btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args);	\
+} while (0)
+#define btrfs_debug_rl_in_rcu(fs_info, fmt, args...)			\
+do {									\
+        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
+        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
+		btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt,		\
+				       ##args);\
+} while (0)
+#define btrfs_debug_rl(fs_info, fmt, args...) 				\
+do {									\
+        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
+        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
+		btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt,	\
+					 ##args);			\
+} while (0)
+#elif defined(DEBUG)
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
-- 
1.8.5.6


-- 
Jeff Mahoney
SUSE Labs
