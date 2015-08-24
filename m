Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5810 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbbHXIqp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 04:46:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7O8kc2I002347
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 16:46:38 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: close all fs_devices before exit in some commands
Date: Mon, 24 Aug 2015 16:45:03 +0800
Message-ID: <d9ee6fee7b49a43f2ff6c24306f4cf69a7c45ae1.1440405874.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
References: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs created more than one fs_devices in fs_uuids.
1: one is for file system been created
2: others are created in test_dev_for_mkfs for check mount point
   test_dev_for_mkfs()-> ... -> btrfs_scan_one_device()

Current code only close above 1, and this patch close above 2.

Similar problem exist in other tools, for ex:
 cmd-check.c: the function is:
 cmd_check()->check_mounted()-> ... -> btrfs_scan_one_device()
 ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-check.c   | 1 +
 cmds-device.c  | 4 ++++
 cmds-replace.c | 2 ++
 mkfs.c         | 1 +
 4 files changed, 8 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 2e6dc68..9828ce2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9589,6 +9589,7 @@ out:
 	free_root_recs_tree(&root_cache);
 close_out:
 	close_ctree(root);
+	btrfs_close_all_devices();
 err_out:
 	return ret;
 }
diff --git a/cmds-device.c b/cmds-device.c
index 458c088..00e362a 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -28,6 +28,7 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
+#include "volumes.h"
 #include "cmds-fi-usage.h"
 
 #include "commands.h"
@@ -140,6 +141,7 @@ static int cmd_device_add(int argc, char **argv)
 
 error_out:
 	close_file_or_dir(fdmnt, dirstream);
+	btrfs_close_all_devices();
 	return !!ret;
 }
 
@@ -290,6 +292,7 @@ static int cmd_device_scan(int argc, char **argv)
 	}
 
 out:
+	btrfs_close_all_devices();
 	return !!ret;
 }
 
@@ -465,6 +468,7 @@ static int cmd_device_stats(int argc, char **argv)
 out:
 	free(di_args);
 	close_file_or_dir(fdmnt, dirstream);
+	btrfs_close_all_devices();
 
 	return err;
 }
diff --git a/cmds-replace.c b/cmds-replace.c
index 2f123cb..ce91787 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -316,6 +316,7 @@ static int cmd_replace_start(int argc, char **argv)
 		}
 	}
 	close_file_or_dir(fdmnt, dirstream);
+	btrfs_close_all_devices();
 	return 0;
 
 leave_with_error:
@@ -325,6 +326,7 @@ leave_with_error:
 		close(fdmnt);
 	if (fddstdev != -1)
 		close(fddstdev);
+	btrfs_close_all_devices();
 	return 1;
 }
 
diff --git a/mkfs.c b/mkfs.c
index 7d635dc..3e60965 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1843,6 +1843,7 @@ raid_groups:
 out:
 	ret = close_ctree(root);
 	BUG_ON(ret);
+	btrfs_close_all_devices();
 	free(label);
 	return 0;
 }
-- 
1.8.5.1

