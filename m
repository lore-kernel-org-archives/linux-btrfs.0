Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbaDXNJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 09:09:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6769EACDB
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:09:11 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make DEV_INFO ioctl available to anyone
Date: Thu, 24 Apr 2014 15:09:10 +0200
Message-Id: <1398344950-12206-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This ioctl provides basic info about the devices that can be obtained in
other ways (eg. sysfs), there's no reason to restrict it to
CAP_SYSADMIN.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e79ff6b90cb7..4aef4f2c5b50 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2589,9 +2589,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	int ret = 0;
 	char *s_uuid = NULL;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
 		return PTR_ERR(di_args);
-- 
1.7.9

