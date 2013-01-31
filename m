Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:21002 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753360Ab3AaABi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:01:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/11] btrfs: remove unused fs_info from btrfs_decode_error()
Date: Wed, 30 Jan 2013 18:54:54 -0600
Message-Id: <1359593702-53056-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/super.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..e933a5f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -63,8 +63,7 @@
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
 
-static const char *btrfs_decode_error(struct btrfs_fs_info *fs_info, int errno,
-				      char nbuf[16])
+static const char *btrfs_decode_error(int errno, char nbuf[16])
 {
 	char *errstr = NULL;
 
@@ -152,7 +151,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
   		return;
 
-  	errstr = btrfs_decode_error(fs_info, errno, nbuf);
+  	errstr = btrfs_decode_error(errno, nbuf);
 	if (fmt) {
 		struct va_format vaf = {
 			.fmt = fmt,
@@ -261,7 +260,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 		char nbuf[16];
 		const char *errstr;
 
-		errstr = btrfs_decode_error(root->fs_info, errno, nbuf);
+		errstr = btrfs_decode_error(errno, nbuf);
 		btrfs_printk(root->fs_info,
 			     "%s:%d: Aborting unused transaction(%s).\n",
 			     function, line, errstr);
@@ -289,7 +288,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 	va_start(args, fmt);
 	vaf.va = &args;
 
-	errstr = btrfs_decode_error(fs_info, errno, nbuf);
+	errstr = btrfs_decode_error(errno, nbuf);
 	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
 		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
 			s_id, function, line, &vaf, errstr);
-- 
1.7.1

