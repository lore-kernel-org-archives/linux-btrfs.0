Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755814AbcIUQRk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 12:17:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3D76AAD1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 16:17:38 +0000 (UTC)
Subject: [PATCH] btrfs: btrfs_debug should consume fs_info when DEBUG is not
 defined
To: linux-btrfs@vger.kernel.org
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Cc: David Sterba <dsterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <44bec1b2-b961-ff13-374d-57b7adf5e3fd@suse.com>
Date: Wed, 21 Sep 2016 12:17:37 -0400
MIME-Version: 1.0
In-Reply-To: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can hit unused variable warnings when btrfs_debug and friends are
just aliases for no_printk.  This is due to the fs_info not getting
consumed by the function call, which can happen if convenenience
variables are used.  This patch adds a new btrfs_no_printk static inline
that consumes the convenience variable and does nothing else.  It
silences the unused variable warning and has no impact on the generated
code:

$ size fs/btrfs/extent_io.o*
   text	   data	    bss	    dec	    hex	filename
  44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.btrfs_no_printk
  44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.no_printk

Fixes: 27a0dd61a5 (Btrfs: make btrfs_debug match pr_debug handling related to DEBUG)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b967af5..e51ee72 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3241,6 +3241,12 @@ int btrfs_sync_fs(struct super_block *sb, int wait);
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
+__printf(2, 3)
+static inline int btrfs_no_printk(const struct btrfs_fs_info *fs_info,
+				   const char *fmt, ...)
+{
+	return 0;
+}
 #else
 static inline __printf(2, 3)
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
@@ -3355,13 +3361,13 @@ do {									\
 	btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt, ##args)
 #else
 #define btrfs_debug(fs_info, fmt, args...) \
-	no_printk(KERN_DEBUG fmt, ##args)
+	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
-	no_printk(KERN_DEBUG fmt, ##args)
+	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
-	no_printk(KERN_DEBUG fmt, ##args)
+	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl(fs_info, fmt, args...) \
-	no_printk(KERN_DEBUG fmt, ##args)
+	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #endif
 
 #define btrfs_printk_in_rcu(fs_info, fmt, args...)	\
-- 
2.7.1


