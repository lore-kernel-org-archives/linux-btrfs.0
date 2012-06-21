Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12794 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760640Ab2FUXxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 19:53:33 -0400
Date: Fri, 22 Jun 2012 01:53:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Mason <chris.mason@fusionio.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: Ensure va_end() is always called in __btrfs_std_error()
 and btrfs_printk()
Message-ID: <alpine.LNX.2.00.1206220151560.7671@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_std_error() neglects to call va_end() when doing early return
after testing "if (errno == -EROFS && (sb->s_flags & MS_RDONLY))" and
btrfs_printk() doesn't call va_end() at all.
This patch makes sure that va_end() is always properly called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0eb9a4d..8566465 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -143,7 +143,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	 * under MS_RDONLY, then it is safe here.
 	 */
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
-  		return;
+  		goto out_va_end;
 
   	errstr = btrfs_decode_error(fs_info, errno, nbuf);
 	if (fmt) {
@@ -164,6 +164,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		save_error_info(fs_info);
 		btrfs_handle_error(fs_info);
 	}
+out_va_end:
 	va_end(args);
 }
 
@@ -199,6 +200,7 @@ void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	printk("%sBTRFS %s (device %s): %pV", lvl, type, sb->s_id, &vaf);
+	va_end(args);
 }
 
 /*
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

