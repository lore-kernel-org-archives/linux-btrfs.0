Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10000 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756583AbeFOWhE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 18:37:04 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: Fix a C compliance issue
Date: Fri, 15 Jun 2018 15:36:59 -0700
Message-Id: <20180615223659.32420-1-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The C programming language does not allow to use preprocessor statements
inside macro arguments (pr_info() is defined as a macro). Hence rework
the pr_info() statement in btrfs_print_mod_info() such that it becomes
compliant. This patch allows tools like sparse to analyze the BTRFS
source code.

Fixes: 62e855771dac ("btrfs: convert printk(KERN_* to use pr_* calls")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..dd4980df5b8e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2369,7 +2369,7 @@ static __cold void btrfs_interface_exit(void)
 
 static void __init btrfs_print_mod_info(void)
 {
-	pr_info("Btrfs loaded, crc32c=%s"
+	static const char fmt[] = KERN_INFO "Btrfs loaded, crc32c=%s"
 #ifdef CONFIG_BTRFS_DEBUG
 			", debug=on"
 #endif
@@ -2382,8 +2382,8 @@ static void __init btrfs_print_mod_info(void)
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 			", ref-verify=on"
 #endif
-			"\n",
-			crc32c_impl());
+			"\n";
+	printk(fmt, crc32c_impl());
 }
 
 static int __init init_btrfs_fs(void)
-- 
2.17.0

