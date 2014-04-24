Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbaDXNJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 09:09:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8B493ACDB
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:09:19 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make FS_INFO ioctl available to anyone
Date: Thu, 24 Apr 2014 15:09:18 +0200
Message-Id: <1398344958-12256-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This ioctl provides basic info about the filesystem that can be obtained
in other ways (eg. sysfs), there's no reason to restrict it to
CAP_SYSADMIN.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e79ff6b90cb7..f6073375b39e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2557,9 +2557,6 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
 	if (!fi_args)
 		return -ENOMEM;
-- 
1.7.9

