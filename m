Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761251Ab3D3QwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 12:52:18 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1C9F2A535B
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 18:52:17 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs: show compiled-in config features at module load time
Date: Tue, 30 Apr 2013 18:51:59 +0200
Message-Id: <c94d79928f0ce5089cb62bfce089e33bcf9c649d.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to know if there are debugging features compiled in, this may
affect performance. The message is printed before the sanity checks.
Also kill version.h file that serves no purpose, we don't use any
version tag for kernel module.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c   |   15 +++++++++++++--
 fs/btrfs/version.h |    4 ----
 2 files changed, 13 insertions(+), 6 deletions(-)
 delete mode 100644 fs/btrfs/version.h

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a51ed3..c02c59a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -51,7 +51,6 @@
 #include "print-tree.h"
 #include "xattr.h"
 #include "volumes.h"
-#include "version.h"
 #include "export.h"
 #include "compression.h"
 #include "rcu-string.h"
@@ -1684,6 +1683,18 @@ static void btrfs_interface_exit(void)
 		printk(KERN_INFO "btrfs: misc_deregister failed for control device\n");
 }
 
+static void btrfs_print_info(void)
+{
+	printk(KERN_INFO "Btrfs loaded"
+#ifdef CONFIG_BTRFS_DEBUG
+			", debug=on"
+#endif
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+			", integrity-checker=on"
+#endif
+			"\n");
+}
+
 static int __init init_btrfs_fs(void)
 {
 	int err;
@@ -1732,9 +1743,9 @@ static int __init init_btrfs_fs(void)
 
 	btrfs_init_lockdep();
 
+	btrfs_print_info();
 	btrfs_test_free_space_cache();
 
-	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
 	return 0;
 
 unregister_ioctl:
diff --git a/fs/btrfs/version.h b/fs/btrfs/version.h
deleted file mode 100644
index 9bf3946..0000000
--- a/fs/btrfs/version.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __BTRFS_VERSION_H
-#define __BTRFS_VERSION_H
-#define BTRFS_BUILD_VERSION "Btrfs"
-#endif
-- 
1.7.9

