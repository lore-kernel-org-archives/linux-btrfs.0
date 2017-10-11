Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18247 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbdJKS7V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 14:59:21 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9BIxKBm031720
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:59:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9BIxK3X030640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:59:20 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9BIxKaQ021712
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:59:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: do not add stale device into fs_devices
Date: Wed, 11 Oct 2017 11:57:16 -0600
Message-Id: <20171011175716.8885-1-bo.li.liu@oracle.com>
In-Reply-To: <20171011002852.2926-1-bo.li.liu@oracle.com>
References: <20171011002852.2926-1-bo.li.liu@oracle.com>
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
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
v2: remove a wrong parameter.

 volumes.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 2f3943d..036c58d 100644
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
+			warning("adding device %s gen %llu but found an existing device %s gen %llu\n",
+				path, found_transid, device->name,
+				device->generation);
+			return -EEXIST;
+		}
+
+		name = strdup(path);
                 if (!name)
                         return -ENOMEM;
                 kfree(device->name);
-- 
2.9.4

