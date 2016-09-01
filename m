Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932383AbcIAMqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 08:46:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD2E7AAF1
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Sep 2016 12:45:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: create example debugfs file only in debugging build
Date: Thu,  1 Sep 2016 14:44:32 +0200
Message-Id: <1472733872-32549-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 804bd1c42e47..31f09564e170 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -836,9 +836,18 @@ static int btrfs_init_debugfs(void)
 	if (!btrfs_debugfs_root_dentry)
 		return -ENOMEM;
 
+	/*
+	 * Example code, how export data through debugfs.
+	 *
+	 * file:        /sys/kernel/debug/btrfs/test
+	 * contents of: btrfs_debugfs_test
+	 */
+#ifdef CONFIG_BTRFS_DEBUG
 	debugfs_create_u64("test", S_IRUGO | S_IWUSR, btrfs_debugfs_root_dentry,
 			&btrfs_debugfs_test);
 #endif
+
+#endif
 	return 0;
 }
 
-- 
2.7.1

