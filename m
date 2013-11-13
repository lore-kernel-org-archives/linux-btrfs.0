Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44834 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3KMAXi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 19:23:38 -0500
Received: by mail-qe0-f52.google.com with SMTP id t9so1958899qeq.11
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 16:23:37 -0800 (PST)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH 2/2] Btrfs: make btrfs_debug match pr_debug handling related to DEBUG
Date: Tue, 12 Nov 2013 19:22:53 -0500
Message-Id: <1384302173-32075-3-git-send-email-fholton@gmail.com>
In-Reply-To: <1384302173-32075-1-git-send-email-fholton@gmail.com>
References: <1384302173-32075-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel macro pr_debug is defined as a empty statement when DEBUG is
not defined. Make btrfs_debug match pr_debug to avoid spamming
the kernel log with debug messages

Signed-off-by: Frank Holton <fholton@gmail.com>
---
 fs/btrfs/ctree.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e319d25..3969133 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3809,8 +3809,14 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	btrfs_printk(fs_info, KERN_NOTICE fmt, ##args)
 #define btrfs_info(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_INFO fmt, ##args)
+
+#ifdef DEBUG
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
+#else
+#define btrfs_debug(fs_info, fmt, args...) \
+    no_printk(KERN_DEBUG fmt, ##args)
+#endif
 
 #ifdef CONFIG_BTRFS_ASSERT
 
-- 
1.7.9.5

