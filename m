Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:28804 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754183Ab3AaAGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/11] btrfs: fix varargs in __btrfs_std_error
Date: Wed, 30 Jan 2013 18:54:58 -0600
Message-Id: <1359593702-53056-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_std_error didn't always properly call va_end,
and might call va_start even if fmt was NULL.

Move all the varargs handling into the block where we
have fmt.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/super.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1dd2d86..fe3c799 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -141,8 +141,6 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	struct super_block *sb = fs_info->sb;
 	char nbuf[16];
 	const char *errstr;
-	va_list args;
-	va_start(args, fmt);
 
 	/*
 	 * Special case: if the error is EROFS, and we're already
@@ -153,13 +151,16 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 
   	errstr = btrfs_decode_error(errno, nbuf);
 	if (fmt) {
-		struct va_format vaf = {
-			.fmt = fmt,
-			.va = &args,
-		};
+		struct va_format vaf;
+		va_list args;
+
+		va_start(args, fmt);
+		vaf.fmt = fmt;
+		vaf.va = &args;
 
 		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s (%pV)\n",
 			sb->s_id, function, line, errstr, &vaf);
+		va_end(args);
 	} else {
 		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s\n",
 			sb->s_id, function, line, errstr);
@@ -170,7 +171,6 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		save_error_info(fs_info);
 		btrfs_handle_error(fs_info);
 	}
-	va_end(args);
 }
 
 static const char * const logtypes[] = {
-- 
1.7.1

