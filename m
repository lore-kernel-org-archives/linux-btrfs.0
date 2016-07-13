Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35612 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcGMNUH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 09:20:07 -0400
Received: by mail-wm0-f41.google.com with SMTP id f65so28642696wmi.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 06:19:36 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH 2/2] btrfs: Add ratelimit to btrfs printing
Date: Wed, 13 Jul 2016 16:19:15 +0300
Message-Id: <1468415955-30804-2-git-send-email-kernel@kyup.com>
In-Reply-To: <20160713121526.GJ10595@twin.jikos.cz>
References: <20160713121526.GJ10595@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds ratelimiting to all messages which are not
using the _rl version of the various printing APIs in btrf. This
is designed to be used as a safety net, since a flood messages
might cause the softlockup detector to trigger. To reduce
interference between different classes of messages use a separate
ratelimit state for every class of message.
---
 fs/btrfs/super.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4339b6613f19..93d7f4e826ad 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -184,6 +184,21 @@ static const char * const logtypes[] = {
 	"debug",
 };
 
+
+/* Use 1 ratelimit state per log level so that a flood of less important
+ * messages doesn't cause a more important ones to be dropped
+ */
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
@@ -192,6 +207,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	va_list args;
 	const char *type = logtypes[4];
 	int kern_level;
+	struct ratelimit_state *ratelimit;
 
 	va_start(args, fmt);
 
@@ -202,13 +218,18 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
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

