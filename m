Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35606 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdJ0H24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 03:28:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com
Subject: [PATCH] btrfs-progs: when unable to find out fsid of a dev just skip
Date: Fri, 27 Oct 2017 15:28:48 +0800
Message-Id: <20171027072848.24702-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%fi_args.num_devices provides number of devices excluding the
seed device. So when looping through the device list for a
given fsid, determine if the given device is a seed device
by reading its superblock and then skip it if its a seed device.
Reading of the superblock is done by the function dev_to_fsid()
which can fail if the user is not root OR if the device has media
errors as well. So skip the seed check altogether if we fail to
know the device superblock and thus the fsid.

With this now we are able to view the btrfs fi usage when the
device is bad.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
cc: misono.tomohiro@jp.fujitsu.com
Fixes:
  btrfs-progs: fi: enable fi usage for filesystem top of seed device
---
 cmds-fi-usage.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 50c7e5170678..e71792c2dfd2 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -584,16 +584,15 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 
 		/*
 		 * Skip seed device by cheking device's fsid (require root).
-		 * Ignore EACCES since if seed is not used this function works
-		 * correctly without root privilege.
+		 * And we will skip only if dev_to_fsid() is successful
+		 * and dev is a seed device.
+		 * Ignore any other error including -EACCES (-EACCES is seen
+		 * when a non root thread calls dev_to_fsid(path)->open(path)
+		 * it will end up with -EACCES)
 		 */
 		ret = dev_to_fsid((const char *)dev_info.path, fsid);
-		if (ret != -EACCES) {
-			if (ret)
-				goto out;
-			if (memcmp(fi_args.fsid, fsid, BTRFS_FSID_SIZE) != 0)
-				continue;
-		}
+		if (!ret && memcmp(fi_args.fsid, fsid, BTRFS_FSID_SIZE) != 0)
+			continue;
 
 		info[ndevs].devid = dev_info.devid;
 		if (!dev_info.path[0]) {
-- 
2.13.1

