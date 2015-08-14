Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34065 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbbHNKdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:32 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 07/23] Btrfs: __btrfs_std_error() logic should be consistent w/out CONFIG_PRINTK defined
Date: Fri, 14 Aug 2015 18:32:52 +0800
Message-Id: <1439548388-29686-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

error handling logic behaves differently with or without
CONFIG_PRINTK defined, since there are two copies of the same
function which a bit of different logic

One, when CONFIG_PRINTK is defined, code is

__btrfs_std_error(..)
{
::
       save_error_info(fs_info);
       if (sb->s_flags & MS_BORN)
               btrfs_handle_error(fs_info);
}

and two when CONFIG_PRINTK is not defined, the code is

__btrfs_std_error(..)
{
::
       if (sb->s_flags & MS_BORN) {
               save_error_info(fs_info);
               btrfs_handle_error(fs_info);
        }
}

I doubt if this was intentional ? and appear to have caused since
we maintain two copies of the same function and they got diverged
with commits.

Now to decide which logic is correct reviewed changes as below,

 533574c6bc30cf526cc1c41bde050c854a945efb
Commit added two copies of this function

 cf79ffb5b79e8a2b587fbf218809e691bb396c98
Commit made change to only one copy of the function and to the
copy when CONFIG_PRINTK is defined.

To fix this, instead of maintaining two copies of same function
approach, maintain single function, and just put the extra
portion of the code under CONFIG_PRINTK define.

This patch just does that. And keeps code of with CONFIG_PRINTK
defined.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c389c13..56c0174 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -130,7 +130,6 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	}
 }
 
-#ifdef CONFIG_PRINTK
 /*
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -140,7 +139,9 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int errno, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
+#ifdef CONFIG_PRINTK
 	const char *errstr;
+#endif
 
 	/*
 	 * Special case: if the error is EROFS, and we're already
@@ -149,6 +150,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
   		return;
 
+#ifdef CONFIG_PRINTK
 	errstr = btrfs_decode_error(errno);
 	if (fmt) {
 		struct va_format vaf;
@@ -166,6 +168,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		printk(KERN_CRIT "BTRFS: error (device %s) in %s:%d: errno=%d %s\n",
 			sb->s_id, function, line, errno, errstr);
 	}
+#endif
 
 	/* Don't go through full error handling during mount */
 	save_error_info(fs_info);
@@ -173,6 +176,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		btrfs_handle_error(fs_info);
 }
 
+#ifdef CONFIG_PRINTK
 static const char * const logtypes[] = {
 	"emergency",
 	"alert",
@@ -212,27 +216,6 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 
 	va_end(args);
 }
-
-#else
-
-void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
-		       unsigned int line, int errno, const char *fmt, ...)
-{
-	struct super_block *sb = fs_info->sb;
-
-	/*
-	 * Special case: if the error is EROFS, and we're already
-	 * under MS_RDONLY, then it is safe here.
-	 */
-	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
-		return;
-
-	/* Don't go through full error handling during mount */
-	if (sb->s_flags & MS_BORN) {
-		save_error_info(fs_info);
-		btrfs_handle_error(fs_info);
-	}
-}
 #endif
 
 /*
-- 
2.4.1

