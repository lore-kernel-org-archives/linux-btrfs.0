Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15922 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751129AbeGJGeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 02:34:02 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4D6744B445CC
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 14:33:55 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: make fs_devices to be a local variable
Date: Tue, 10 Jul 2018 14:33:52 +0800
Message-ID: <1531204433-11570-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since output parameter fs_devices of btrfs_parse_early_options is
not used in the caller, make it be a local variable.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bf546d6c286c..4ee082e96d51 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -886,11 +886,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -918,7 +919,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				goto out;
 			}
 			error = btrfs_scan_one_device(device_name,
-					flags, holder, fs_devices);
+					flags, holder, &fs_devices);
 			kfree(device_name);
 			if (error)
 				goto out;
@@ -1526,8 +1527,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
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



