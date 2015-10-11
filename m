Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbbJKSFe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:05:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C0883ABBF
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 18:05:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: introduce ratelimited variants of message printing functions
Date: Sun, 11 Oct 2015 20:04:25 +0200
Message-Id: <1dd6d7ca9d062721ae37388900a322a4b959e939.1444585955.git.dsterba@suse.com>
In-Reply-To: <cover.1444585955.git.dsterba@suse.com>
References: <cover.1444585955.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9c0fd901edbe..bca42c5733a1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4075,6 +4075,23 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 #define btrfs_info_rl_in_rcu(fs_info, fmt, args...) \
 	btrfs_printk_rl_in_rcu(fs_info, KERN_INFO fmt, ##args)
 
+/*
+ * Wrappers that use a ratelimited printk
+ */
+#define btrfs_emerg_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_EMERG fmt, ##args)
+#define btrfs_alert_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_ALERT fmt, ##args)
+#define btrfs_crit_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_CRIT fmt, ##args)
+#define btrfs_err_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_ERR fmt, ##args)
+#define btrfs_warn_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_WARNING fmt, ##args)
+#define btrfs_notice_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_NOTICE fmt, ##args)
+#define btrfs_info_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_INFO fmt, ##args)
 #ifdef DEBUG
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
@@ -4082,6 +4099,8 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
 	btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl(fs_info, fmt, args...) \
+	btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt, ##args)
 #else
 #define btrfs_debug(fs_info, fmt, args...) \
     no_printk(KERN_DEBUG fmt, ##args)
@@ -4089,6 +4108,8 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	no_printk(KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
 	no_printk(KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl(fs_info, fmt, args...) \
+	no_printk(KERN_DEBUG fmt, ##args)
 #endif
 
 #define btrfs_printk_in_rcu(fs_info, fmt, args...)	\
-- 
2.1.3

