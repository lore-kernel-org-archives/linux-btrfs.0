Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbcBORea (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:30 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 09/15] btrfs: optimize check for stale device
Date: Mon, 15 Feb 2016 18:34:26 +0100
Message-Id: <1f778216eb80083cc7c105b0fe7aa17e4ba22821.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Optimize check for stale device to only be checked when there is device
added or changed. If there is no update to the device, there is no need
to call btrfs_free_stale_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5e49adb34b2e..20af20b0eaee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -699,7 +699,8 @@ static noinline int device_list_add(const char *path,
 	 * if there is new btrfs on an already registered device,
 	 * then remove the stale device entry.
 	 */
-	btrfs_free_stale_device(device);
+	if (ret > 0)
+		btrfs_free_stale_device(device);
 
 	*fs_devices_ret = fs_devices;
 
-- 
2.7.1

