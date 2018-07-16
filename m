Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3724 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727594AbeGPJmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 05:42:09 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
Subject: [PATCH v5 1/2] btrfs: make fs_devices to be a local variable
Date: Mon, 16 Jul 2018 17:11:16 +0800
Message-ID: <1531732277-23517-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>

fs_devices is always passed to btrfs_scan_one_device which
overrides it. And in the call stack below fs_devices is passed to
btrfs_scan_one_device from btrfs_mount_root.
And in btrfs_mount_root the output fs_devices of this call stack
is not used.
btrfs_mount_root
        -> btrfs_parse_early_options
                ->btrfs_scan_one_device
So, there is no necessary to pass fs_devices from btrfs_mount_root,
use a local variable in btrfs_parse_early_options is enough.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Anand Jain <Anand.Jain@oracle.com>
---

Changelog:
v5: change a line wrap, and rebase to misc-next.
v4: changed a line warp, and adjusted the order of two rows.
v3: rebase to misc-next.
v2: deal with Nikolay's comment, make changelog more clair.

 fs/btrfs/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 28ab75ebb983..dcab4a0244e5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -884,10 +884,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * only when we need to allocate a new super block.
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
-		void *holder, struct btrfs_fs_devices **fs_devices)
+					void *holder)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
+	struct btrfs_fs_devices *fs_devices = NULL;
 	int error = 0;
 
 	lockdep_assert_held(&uuid_mutex);
@@ -917,8 +918,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
-			error = btrfs_scan_one_device(device_name,
-					flags, holder, fs_devices);
+			error = btrfs_scan_one_device(device_name, flags,
+							holder, &fs_devices);
 			kfree(device_name);
 			if (error)
 				goto out;
@@ -1554,7 +1555,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	}
 
 	mutex_lock(&uuid_mutex);
-	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
+	error = btrfs_parse_early_options(data, mode, fs_type);
 	if (error) {
 		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
-- 
2.17.1



