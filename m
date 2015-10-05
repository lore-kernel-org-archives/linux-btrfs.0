Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49400 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbbJEI63 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:58:29 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t958wRuD019663
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:58:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t958wRZg011430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:58:27 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t958wRYh012149
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:58:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: optimize check for stale device
Date: Mon,  5 Oct 2015 16:57:17 +0800
Message-Id: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

optimize check for stale device to only be checked when there
is device added or changed. If there is no update to the
device, there is no need to call btrfs_free_stale_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b8b1171..ec1fcfa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -620,7 +620,8 @@ static noinline int device_list_add(const char *path,
 	 * if there is new btrfs on an already registered device,
 	 * then remove the stale device entry.
 	 */
-	btrfs_free_stale_device(device);
+	if (ret > 0)
+		btrfs_free_stale_device(device);
 
 	*fs_devices_ret = fs_devices;
 
-- 
2.4.1

