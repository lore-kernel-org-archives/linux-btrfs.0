Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3FVFdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:04 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 3/5] Btrfs-progs: delete fs_devices itself from fs_uuid list before freeing
Date: Sat, 22 Jun 2013 13:32:43 +0800
Message-Id: <1371879165-4993-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
References: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise we will access illegal addresses while searching on fs_uuid list.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 disk-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 768adda..9cfd003 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1280,6 +1280,7 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 		kfree(device->label);
 		kfree(device);
 	}
+	list_del(&fs_info->fs_devices->list);
 	kfree(fs_info->fs_devices);
 	return 0;
 }
-- 
1.7.7

