Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50987 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732278AbeGKBYs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 21:24:48 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
Subject: [PATCH v3 1/2] btrfs: make fs_devices to be a local variable
Date: Wed, 11 Jul 2018 09:22:57 +0800
Message-ID: <1531272178-17471-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
---

Changelog:
v3: rebase to misc-next.
v2: deal with Nikolay's comment, make changelog more clair.

 fs/btrfs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e04bcf0b0ed4..78b5d51c7bc7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -884,11 +884,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * only when we need to allocate a new super block.
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
-		void *holder, struct btrfs_fs_devices **fs_devices)
+		void *holder)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
 	int error = 0;
+	struct btrfs_fs_devices *fs_devices = NULL;
 
 	if (!options)
 		return 0;
@@ -916,7 +917,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				goto out;
 			}
 			error = btrfs_scan_one_device(device_name,
-					flags, holder, fs_devices);
+					flags, holder, &fs_devices);
 			kfree(device_name);
 			if (error)
 				goto out;
@@ -1524,8 +1525,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
-	error = btrfs_parse_early_options(data, mode, fs_type,
-					  &fs_devices);
+	error = btrfs_parse_early_options(data, mode, fs_type);
 	if (error) {
 		return ERR_PTR(error);
 	}
-- 
2.17.1



