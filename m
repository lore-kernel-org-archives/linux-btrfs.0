Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43208 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387474AbeITDpH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 23:45:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id z27-v6so6147664edb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 15:05:10 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 14/22] btrfs: implement btrfs_debug* in terms of helper macro
Date: Thu, 20 Sep 2018 00:04:36 +0200
Message-Id: <20180919220444.23190-15-linux@rasmusvillemoes.dk>
In-Reply-To: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, the btrfs_debug macros open-code (one possible definition of)
DYNAMIC_DEBUG_BRANCH, so they don't benefit from the HAVE_JUMP_LABEL
optimization.

Second, changes on x86-64 later in this series require that all struct
_ddebug descriptors in a translation unit use distinct identifiers.

Using the new _dynamic_func_call_no_desc helper macro from
dynamic_debug.h takes care of both of these.

Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/btrfs/ctree.h | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..7ae6cdad5b38 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3353,31 +3353,17 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define btrfs_debug(fs_info, fmt, args...)				\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk(fs_info, KERN_DEBUG fmt, ##args);		\
-} while (0)
-#define btrfs_debug_in_rcu(fs_info, fmt, args...) 			\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt); 	        \
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT)) 		\
-		btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args);	\
-} while (0)
+	_dynamic_func_call_no_desc(fmt, btrfs_printk,			\
+				   fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...)			\
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_in_rcu,		\
+				   fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...)			\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt,		\
-				       ##args);\
-} while (0)
-#define btrfs_debug_rl(fs_info, fmt, args...) 				\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt,	\
-					 ##args);			\
-} while (0)
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_rl_in_rcu,		\
+				   fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl(fs_info, fmt, args...)				\
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_ratelimited,	\
+				   fs_info, KERN_DEBUG fmt, ##args)
 #elif defined(DEBUG)
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
-- 
2.16.4
