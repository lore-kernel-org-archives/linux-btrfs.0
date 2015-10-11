Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbbJKSFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:05:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 09624AC66
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 18:05:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: introduce _in_rcu variants of message printing functions
Date: Sun, 11 Oct 2015 20:04:11 +0200
Message-Id: <08a84e25a80566cf3cb1903c2448123efedff132.1444585955.git.dsterba@suse.com>
In-Reply-To: <cover.1444585955.git.dsterba@suse.com>
References: <cover.1444585955.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to the missing variants there are messages that lack the information
printed by btrfs_info etc helpers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe33be80..88acdffbe384 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4039,14 +4039,43 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 #define btrfs_info(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_INFO fmt, ##args)
 
+/*
+ * Wrappers that use printk_in_rcu
+ */
+#define btrfs_emerg_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_EMERG fmt, ##args)
+#define btrfs_alert_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_ALERT fmt, ##args)
+#define btrfs_crit_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_CRIT fmt, ##args)
+#define btrfs_err_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_ERR fmt, ##args)
+#define btrfs_warn_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_WARNING fmt, ##args)
+#define btrfs_notice_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_NOTICE fmt, ##args)
+#define btrfs_info_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_INFO fmt, ##args)
+
 #ifdef DEBUG
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...) \
+	btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
 #else
 #define btrfs_debug(fs_info, fmt, args...) \
     no_printk(KERN_DEBUG fmt, ##args)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...) \
+	no_printk(KERN_DEBUG fmt, ##args)
 #endif
 
+#define btrfs_printk_in_rcu(fs_info, fmt, args...)	\
+do {							\
+	rcu_read_lock();				\
+	btrfs_printk(fs_info, fmt, ##args);		\
+	rcu_read_unlock();				\
+} while (0)
+
 #ifdef CONFIG_BTRFS_ASSERT
 
 __cold
-- 
2.1.3

