Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752187AbcITOFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 10:05:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C927AC4B
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 14:05:05 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/5] btrfs: add dynamic debug support
Date: Tue, 20 Sep 2016 10:04:59 -0400
Message-Id: <1474380303-25995-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1474380303-25995-1-git-send-email-jeffm@suse.com>
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We can re-use the dynamic debugging descriptor to make use of the dynamic
debugging mechanism but still use our own printk interface.

Defining the DEBUG macro works as it did before.  When it's defined,
all of the messages default to print.  We can also enable all debug
messages at boot or module-load time using the 'dyndbg' and
'btrfs.dyndbg' options.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 33fe035..9267436 100644
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
@@ -3315,7 +3316,35 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	btrfs_printk_ratelimited(fs_info, KERN_NOTICE fmt, ##args)
 #define btrfs_info_rl(fs_info, fmt, args...) \
 	btrfs_printk_ratelimited(fs_info, KERN_INFO fmt, ##args)
-#ifdef DEBUG
+
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define btrfs_debug(fs_info, fmt, args...)				\
+do {									\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))		\
+		btrfs_printk(fs_info, KERN_DEBUG fmt, ##args);		\
+} while (0)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...)			\
+do {									\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))		\
+		btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args);	\
+} while (0)
+#define btrfs_debug_rl_in_rcu(fs_info, fmt, args...)			\
+do {									\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))		\
+		btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt,		\
+					##args);\
+} while (0)
+#define btrfs_debug_rl(fs_info, fmt, args...)				\
+do {									\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))		\
+		btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt,	\
+					 ##args);			\
+} while (0)
+#elif defined(DEBUG)
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
-- 
2.7.1

