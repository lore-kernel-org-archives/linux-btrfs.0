Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbeEPKBk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:01:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G9ttM1088394
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hx29w446n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1dQa024347
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:39 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4GA1cdO029010
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: read_mirror_policy ability to reset
Date: Wed, 16 May 2018 18:03:59 +0800
Message-Id: <20180516100359.7752-4-anand.jain@oracle.com>
In-Reply-To: <20180516100359.7752-1-anand.jain@oracle.com>
References: <20180516100359.7752-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds an ability to change the read_mirror_policy at remount.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7ddecf4178a6..e70592036b95 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -856,6 +856,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			intarg = 0;
 			if (match_int(&args[0], &intarg) == 0) {
 				struct btrfs_device *device;
+				int clear = 0;
+
+				if (intarg < 0) {
+					clear = 1;
+					intarg = -intarg;
+				}
 
 				device = btrfs_find_device(info, intarg,
 							   NULL, NULL);
@@ -866,10 +872,17 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 					ret = -EINVAL;
 					goto out;
 				}
-				info->read_mirror_policy =
+
+				if (clear) {
+					info->read_mirror_policy = 0;
+					clear_bit(BTRFS_DEV_STATE_READ_MIRROR,
+						&device->dev_state);
+				} else {
+					info->read_mirror_policy =
 						BTRFS_READ_MIRROR_BY_DEV;
-				set_bit(BTRFS_DEV_STATE_READ_MIRROR,
-					&device->dev_state);
+					set_bit(BTRFS_DEV_STATE_READ_MIRROR,
+						  &device->dev_state);
+				}
 				break;
 			}
 
-- 
2.7.0

