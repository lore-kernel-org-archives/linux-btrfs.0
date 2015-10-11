Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbbJKSF1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:05:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 141A3ABBF
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 18:05:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/7] btrfs: introduce ratelimited _in_rcu variants of message printing functions
Date: Sun, 11 Oct 2015 20:04:18 +0200
Message-Id: <24aa6b41d4611b14ad0fb89fa0b899ae9ab7005c.1444585955.git.dsterba@suse.com>
In-Reply-To: <cover.1444585955.git.dsterba@suse.com>
References: <cover.1444585955.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 88acdffbe384..9c0fd901edbe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4057,16 +4057,38 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 #define btrfs_info_in_rcu(fs_info, fmt, args...) \
 	btrfs_printk_in_rcu(fs_info, KERN_INFO fmt, ##args)
 
+/*
+ * Wrappers that use a ratelimited printk_in_rcu
+ */
+#define btrfs_emerg_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_EMERG fmt, ##args)
+#define btrfs_alert_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_ALERT fmt, ##args)
+#define btrfs_crit_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_CRIT fmt, ##args)
+#define btrfs_err_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_ERR fmt, ##args)
+#define btrfs_warn_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_WARNING fmt, ##args)
+#define btrfs_notice_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_NOTICE fmt, ##args)
+#define btrfs_info_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_INFO fmt, ##args)
+
 #ifdef DEBUG
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
 	btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
 #else
 #define btrfs_debug(fs_info, fmt, args...) \
     no_printk(KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
 	no_printk(KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
+	no_printk(KERN_DEBUG fmt, ##args)
 #endif
 
 #define btrfs_printk_in_rcu(fs_info, fmt, args...)	\
@@ -4076,6 +4098,22 @@ do {							\
 	rcu_read_unlock();				\
 } while (0)
 
+#define btrfs_printk_ratelimited(fs_info, fmt, args...)		\
+do {								\
+	static DEFINE_RATELIMIT_STATE(_rs,			\
+		DEFAULT_RATELIMIT_INTERVAL,			\
+		DEFAULT_RATELIMIT_BURST);       		\
+	if (__ratelimit(&_rs))					\
+		btrfs_printk(fs_info, fmt, ##args);		\
+} while (0)
+
+#define btrfs_printk_rl_in_rcu(fs_info, fmt, args...)		\
+do {								\
+	rcu_read_lock();					\
+	btrfs_printk_ratelimited(fs_info, fmt, ##args);		\
+	rcu_read_unlock();					\
+} while (0)
+
 #ifdef CONFIG_BTRFS_ASSERT
 
 __cold
-- 
2.1.3

