Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcBMCCP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:15 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/13] btrfs: optimize check for stale device
Date: Sat, 13 Feb 2016 10:01:40 +0800
Message-Id: <1455328900-1476-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Optimize check for stale device to only be checked when there is device
added or changed. If there is no update to the device, there is no need
to call btrfs_free_stale_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 This is good to go. The there were some stale devices while testing
 and now I have confirmed it wasn't due to this. Sorry that I was bit
 jumpy on concluding this patch as bad.

 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f47bd0b..b7cbb31 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -701,7 +701,8 @@ static noinline int device_list_add(const char *path,
 	 * if there is new btrfs on an already registered device,
 	 * then remove the stale device entry.
 	 */
-	btrfs_free_stale_device(device);
+	if (ret > 0)
+		btrfs_free_stale_device(device);
 
 	*fs_devices_ret = fs_devices;
 
-- 
2.7.0

