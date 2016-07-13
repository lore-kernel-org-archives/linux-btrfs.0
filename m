Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36180 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcGMHGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 03:06:06 -0400
Received: by mail-wm0-f51.google.com with SMTP id f126so15970328wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 00:05:45 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH] btrfs: Ratelimit message printing 
Date: Wed, 13 Jul 2016 10:05:36 +0300
Message-Id: <1468393536-25798-1-git-send-email-kernel@kyup.com>
In-Reply-To: <20160712160126.GD10595@suse.cz>
References: <20160712160126.GD10595@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently most of the messages btrfs produce are not rate limited.
Recently I came accross a case where due to FS corruption an excessive
amount of printk caused the softlockup detector to trigger and reset
the server. This patch does the following changes:

 * The message which was printed is converted to use the ratelimited
 version of btrfs_info function. This will prevent it from exploding
 in the future.

 * In addition to the above change, also add a sort of a "safet net" to
 all non-ratelimited prints by introducing separate ratelimiting for
 every message class when the "naked" btrfs_info is called.

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
---

Hello David, 

How about something like that?

 fs/btrfs/file-item.c |  2 +-
 fs/btrfs/super.c     | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 62a81ee13a5f..6b58d0620e2f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -250,7 +250,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						offset + root->sectorsize - 1,
 						EXTENT_NODATASUM);
 				} else {
-					btrfs_info(BTRFS_I(inode)->root->fs_info,
+					btrfs_info_rl(BTRFS_I(inode)->root->fs_info,
 						   "no csum found for inode %llu start %llu",
 					       btrfs_ino(inode), offset);
 				}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60e7179ed4b7..01a87dd89732 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -184,6 +184,17 @@ static const char * const logtypes[] = {
 	"debug",
 };
 
+static struct ratelimit_state printk_limits[] = {
+	RATELIMIT_STATE_INIT(printk_limits[0], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[1], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[2], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[3], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[4], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[5], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[6], DEFAULT_RATELIMIT_INTERVAL, 100),
+	RATELIMIT_STATE_INIT(printk_limits[7], DEFAULT_RATELIMIT_INTERVAL, 100),
+};
+
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
@@ -192,6 +203,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	va_list args;
 	const char *type = logtypes[4];
 	int kern_level;
+	struct ratelimit_state *ratelimit;
 
 	va_start(args, fmt);
 
@@ -202,13 +214,18 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 		lvl[size] = '\0';
 		fmt += size;
 		type = logtypes[kern_level - '0'];
-	} else
+		ratelimit = &printk_limits[kern_level - '0'];
+	} else {
 		*lvl = '\0';
+		/* Default to debug output */
+		ratelimit = &printk_limits[7];
+	}
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	if (__ratelimit(ratelimit))
+		printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
 
 	va_end(args);
 }
-- 
2.5.0

