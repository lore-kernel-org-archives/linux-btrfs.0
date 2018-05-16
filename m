Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeEPKBi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:01:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G9tgso157278
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2hxpvctrvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1bUv006232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:37 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1bK9029673
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: add read_mirror_policy parameter devid
Date: Wed, 16 May 2018 18:03:58 +0800
Message-Id: <20180516100359.7752-3-anand.jain@oracle.com>
In-Reply-To: <20180516100359.7752-1-anand.jain@oracle.com>
References: <20180516100359.7752-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds the mount option:
  mount -o read_mirror_policy=<devid>

To set the devid of the device which should be used for read. That
means all the normal reads will go to that particular device only.

This also helps testing and gives a better control for the test
scripts including mount context reads.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c   | 21 +++++++++++++++++++++
 fs/btrfs/volumes.c | 10 ++++++++++
 fs/btrfs/volumes.h |  2 ++
 3 files changed, 33 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 21eff0ac1e4f..7ddecf4178a6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -852,6 +852,27 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 					BTRFS_READ_MIRROR_BY_PID;
 				break;
 			}
+
+			intarg = 0;
+			if (match_int(&args[0], &intarg) == 0) {
+				struct btrfs_device *device;
+
+				device = btrfs_find_device(info, intarg,
+							   NULL, NULL);
+				if (!device) {
+					btrfs_err(info,
+					  "read_mirror_policy: invalid devid %d",
+					  intarg);
+					ret = -EINVAL;
+					goto out;
+				}
+				info->read_mirror_policy =
+						BTRFS_READ_MIRROR_BY_DEV;
+				set_bit(BTRFS_DEV_STATE_READ_MIRROR,
+					&device->dev_state);
+				break;
+			}
+
 			ret = -EINVAL;
 			goto out;
 		case Opt_err:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 64dba5c4cf33..3a9c3804ff17 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5220,6 +5220,16 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		num_stripes = map->num_stripes;
 
 	switch(fs_info->read_mirror_policy) {
+	case BTRFS_READ_MIRROR_BY_DEV:
+		preferred_mirror = first;
+		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
+			     &map->stripes[preferred_mirror].dev->dev_state))
+			break;
+		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
+			     &map->stripes[++preferred_mirror].dev->dev_state))
+			break;
+		preferred_mirror = first;
+		break;
 	case BTRFS_READ_MIRROR_DEFAULT:
 	case BTRFS_READ_MIRROR_BY_PID:
 	default:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 953df9925832..55b2eebbf183 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -37,6 +37,7 @@ struct btrfs_pending_bios {
 enum btrfs_read_mirror_type {
 	BTRFS_READ_MIRROR_DEFAULT,
 	BTRFS_READ_MIRROR_BY_PID,
+	BTRFS_READ_MIRROR_BY_DEV,
 };
 
 #define BTRFS_DEV_STATE_WRITEABLE	(0)
@@ -44,6 +45,7 @@ enum btrfs_read_mirror_type {
 #define BTRFS_DEV_STATE_MISSING		(2)
 #define BTRFS_DEV_STATE_REPLACE_TGT	(3)
 #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
+#define BTRFS_DEV_STATE_READ_MIRROR	(5)
 
 struct btrfs_device {
 	struct list_head dev_list;
-- 
2.7.0

