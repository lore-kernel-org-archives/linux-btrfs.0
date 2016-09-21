Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753745AbcIUQQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 12:16:47 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57FB7AAD1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 16:16:45 +0000 (UTC)
Subject: Re: [PATCH] btrfs: silence compiler warning when fs_info is not used
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <1474472599-11278-1-git-send-email-dsterba@suse.com>
 <7a1f023d-d9c4-82ac-88d7-d123118f524a@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <46b76b10-7199-4938-bb78-15eee39e17da@suse.com>
Date: Wed, 21 Sep 2016 12:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <7a1f023d-d9c4-82ac-88d7-d123118f524a@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/21/16 11:47 AM, Jeff Mahoney wrote:
> On 9/21/16 11:43 AM, David Sterba wrote:
>> Some functions introduced a local fs_info pointer for the message
>> helpers. If btrfs_debug results to an empty macro, the fs_info pointer
>> is reported to be unused. Splitting the variable declaration and setting
>> will silence the warning, without any functional change.
> 
> I'm investigating fixing this differently.  I'd like the no-call version
> to silence the warning and let gcc optimize it out behind the seems if
> possible.

The following works for me.  It looks like this problem has existed since
commit 27a0dd61a5 (Btrfs: make btrfs_debug match pr_debug handling related to DEBUG)
but we just haven't hit it.

I'll post it separately for inclusion.

$ size fs/btrfs/extent_io.o*
   text	   data	    bss	    dec	    hex	filename
  44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.btrfs_no_printk
  44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.no_printk

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
Jeff Mahoney
SUSE Labs
