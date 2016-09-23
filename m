Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56586 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030326AbcIWQFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 12:05:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jeff Mahoney <jeffm@suse.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@fb.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix btrfs_no_printk stub helper
Date: Fri, 23 Sep 2016 18:05:21 +0200
Message-Id: <20160923160532.3619432-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The addition of btrfs_no_printk() caused a build failure when
CONFIG_PRINTK is disabled:

fs/btrfs/send.c: In function 'send_rename':
fs/btrfs/ctree.h:3367:2: error: implicit declaration of function 'btrfs_no_printk' [-Werror=implicit-function-declaration]

This moves the helper outside of that #ifdef so it is always
defined, and changes the existing #ifdef to refer to that
helper as well for consistency.

Fixes: 47c57058ff2c ("btrfs: btrfs_debug should consume fs_info when DEBUG is not defined")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/ctree.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e5621268c9fe..63bf4cc34626 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3241,20 +3241,17 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
+static inline __printf(2, 3)
+void btrfs_no_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
+{
+}
+
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
-__printf(2, 3)
-static inline int btrfs_no_printk(const struct btrfs_fs_info *fs_info,
-				   const char *fmt, ...)
-{
-	return 0;
-}
 #else
-static inline __printf(2, 3)
-void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
-{
-}
+#define btrfs_printk(fs_info, fmt, args...) \
+	btrfs_no_printk(fs_info, fmt, ##args)
 #endif
 
 #define btrfs_emerg(fs_info, fmt, args...) \
-- 
2.9.0

