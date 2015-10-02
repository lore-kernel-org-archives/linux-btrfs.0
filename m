Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbJBPuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 11:50:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9A635ACB8
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 15:50:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fix double free during scanning
Date: Fri,  2 Oct 2015 17:49:05 +0200
Message-Id: <1443800945-27882-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there are different devices mounted to the same directory we can run
into double free issue in the scanning code and this can lead to a
crash. The dev_info_arg buffer allocation get_fs_info might be skipped,
eg. if the FS_INFO ioctl fails due to EPERM in older kernels. Reset the
pointer before each loop starts.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-filesystem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b4576ed30360..366373473c56 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -485,6 +485,7 @@ static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 		if (search && !match_search_item_kernel(fs_info_arg.fsid,
 					mnt->mnt_dir, label, search)) {
 			kfree(dev_info_arg);
+			dev_info_arg = NULL;
 			continue;
 		}
 
@@ -500,6 +501,7 @@ static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 		if (fd != -1)
 			close(fd);
 		kfree(dev_info_arg);
+		dev_info_arg = NULL;
 	}
 
 out:
-- 
2.1.3

