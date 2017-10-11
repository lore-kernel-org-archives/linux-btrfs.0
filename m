Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36137 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdJKBa6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 21:30:58 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B1UuwV025413
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 01:30:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9B1UuDq014221
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 01:30:56 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9B1Uugp030777
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 01:30:56 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: do not add stale device into fs_devices
Date: Tue, 10 Oct 2017 18:28:52 -0600
Message-Id: <20171011002852.2926-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If one of btrfs's devices was pulled out and we've replaced it with a
new one, then they have the same uuid.

If that device gets reconnected, 'btrfs filesystem show' will show the
stale one instead of the new one, but on kernel side btrfs has a fix
to not include the stale one, this could confuse users as people may
monitor btrfs by running that cli.

This does the similar thing to what kernel side has done.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 volumes.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 2f3943d..c7b7a41 100644
--- a/volumes.c
+++ b/volumes.c
@@ -138,7 +138,20 @@ static int device_list_add(const char *path,
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name, path)) {
-		char *name = strdup(path);
+		char *name;
+
+		/*
+		 * The existing device has newer generation, so this
+		 * one could be a stale one, don't add it.
+		 */
+		if (found_transid < device->generation) {
+			warning("adding device %s gen %llu but found a existing device %s gen %llu\n",
+				path, found_transid, device->name,
+				device->generation, found_transid);
+			return -EEXIST;
+		}
+
+		name = strdup(path);
                 if (!name)
                         return -ENOMEM;
                 kfree(device->name);
-- 
2.9.4

