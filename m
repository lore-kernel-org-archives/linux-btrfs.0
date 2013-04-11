Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934043Ab3DKK2X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 06:28:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r3BASDK8008431
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 18:28:13 +0800
Message-ID: <5166908F.5060909@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:29:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: fix unblocked autodefraggers when remount
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new mount option is set after parsing the remount arguments,
so it is wrong that checking the autodefrag is close or not at
btrfs_remount_prepare(). Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 68a29a1..0f03569 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1202,11 +1202,14 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 			      new_pool_size);
 }
 
-static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info,
-					 unsigned long old_opts, int flags)
+static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
 {
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+}
 
+static inline void btrfs_remount_begin(struct btrfs_fs_info *fs_info,
+				       unsigned long old_opts, int flags)
+{
 	if (btrfs_raw_test_opt(old_opts, AUTO_DEFRAG) &&
 	    (!btrfs_raw_test_opt(fs_info->mount_opt, AUTO_DEFRAG) ||
 	     (flags & MS_RDONLY))) {
@@ -1247,7 +1250,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
 
-	btrfs_remount_prepare(fs_info, old_opts, *flags);
+	btrfs_remount_prepare(fs_info);
 
 	ret = btrfs_parse_options(root, data);
 	if (ret) {
@@ -1255,6 +1258,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		goto restore;
 	}
 
+	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
 
-- 
1.8.0.1
