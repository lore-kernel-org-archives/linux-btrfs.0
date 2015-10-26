Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753865AbbJZKaF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:05 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATU9S004079
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:30 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/5] btrfs-progs: Remove all btrfs_close_all_devices in sub-command
Date: Mon, 26 Oct 2015 18:28:19 +0800
Message-ID: <100cdd79193c6a61f4e41493281be1d374bae4c0.1445855131.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have btrfs_close_all_devices() in btrfs's main entrance,
it is not necessary to call btrfs_close_all_devices() separately
in each sub-command.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-check.c   | 1 -
 cmds-device.c  | 3 ---
 cmds-replace.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1f8caad..3af6e61 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9738,7 +9738,6 @@ out:
 	free_root_recs_tree(&root_cache);
 close_out:
 	close_ctree(root);
-	btrfs_close_all_devices();
 err_out:
 	if (ctx.progress_enabled)
 		task_deinit(ctx.info);
diff --git a/cmds-device.c b/cmds-device.c
index 5f2b952..620ae8b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -139,7 +139,6 @@ static int cmd_device_add(int argc, char **argv)
 
 error_out:
 	close_file_or_dir(fdmnt, dirstream);
-	btrfs_close_all_devices();
 	return !!ret;
 }
 
@@ -288,7 +287,6 @@ static int cmd_device_scan(int argc, char **argv)
 	}
 
 out:
-	btrfs_close_all_devices();
 	return !!ret;
 }
 
@@ -466,7 +464,6 @@ static int cmd_device_stats(int argc, char **argv)
 out:
 	free(di_args);
 	close_file_or_dir(fdmnt, dirstream);
-	btrfs_close_all_devices();
 
 	return err;
 }
diff --git a/cmds-replace.c b/cmds-replace.c
index 9ab8438..fadd2cd 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -330,7 +330,6 @@ static int cmd_replace_start(int argc, char **argv)
 		}
 	}
 	close_file_or_dir(fdmnt, dirstream);
-	btrfs_close_all_devices();
 	return 0;
 
 leave_with_error:
@@ -340,7 +339,6 @@ leave_with_error:
 		close(fdmnt);
 	if (fddstdev != -1)
 		close(fddstdev);
-	btrfs_close_all_devices();
 	return 1;
 }
 
-- 
1.8.5.1

