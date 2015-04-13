Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbbDMOhB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:37:01 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t3DEaxL9014111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:37:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t3DEaxJp020627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:36:59 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t3DEaxB8024516
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:36:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] Btrfs: __btrfs_std_error() logic should be consistent w/out CONFIG_PRINTK defined
Date: Mon, 13 Apr 2015 22:49:48 +0800
Message-Id: <1428936588-2550-1-git-send-email-anand.jain@oracle.com>
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
index 7533afb..b0a465f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -130,7 +130,6 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	}
 }
 
-#ifdef CONFIG_PRINTK
 /*
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -139,7 +138,9 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int errno, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
+#ifdef CONFIG_PRINTK
 	const char *errstr;
+#endif
 
 	/*
 	 * Special case: if the error is EROFS, and we're already
@@ -148,6 +149,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
   		return;
 
+#ifdef CONFIG_PRINTK
 	errstr = btrfs_decode_error(errno);
 	if (fmt) {
 		struct va_format vaf;
@@ -165,6 +167,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		printk(KERN_CRIT "BTRFS: error (device %s) in %s:%d: errno=%d %s\n",
 			sb->s_id, function, line, errno, errstr);
 	}
+#endif
 
 	/* Don't go through full error handling during mount */
 	save_error_info(fs_info);
@@ -172,6 +175,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		btrfs_handle_error(fs_info);
 }
 
+#ifdef CONFIG_PRINTK
 static const char * const logtypes[] = {
 	"emergency",
 	"alert",
@@ -211,27 +215,6 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 
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
2.0.0.153.g79dcccc

