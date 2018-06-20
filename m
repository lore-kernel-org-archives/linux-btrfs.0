Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20873 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932968AbeFTRDw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:03:52 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>,
        Jeff Mahoney <jeffm@suse.com>, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 3/3] btrfs: Fix a C compliance issue
Date: Wed, 20 Jun 2018 10:03:33 -0700
Message-Id: <20180620170333.29182-4-bart.vanassche@wdc.com>
In-Reply-To: <20180620170333.29182-1-bart.vanassche@wdc.com>
References: <20180620170333.29182-1-bart.vanassche@wdc.com>
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
Cc: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3e298f26a383..972d9fbd7e96 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2370,7 +2370,7 @@ static __cold void btrfs_interface_exit(void)
 
 static void __init btrfs_print_mod_info(void)
 {
-	pr_info("Btrfs loaded, crc32c=%s"
+	static const char options[] =
 #ifdef CONFIG_BTRFS_DEBUG
 			", debug=on"
 #endif
@@ -2383,8 +2383,8 @@ static void __init btrfs_print_mod_info(void)
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 			", ref-verify=on"
 #endif
-			"\n",
-			crc32c_impl());
+			;
+	pr_info("Btrfs loaded, crc32c=%s%s\n", crc32c_impl(), options);
 }
 
 static int __init init_btrfs_fs(void)
-- 
2.17.1

