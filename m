Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbeA3G3K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:29:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0U6RDXi119939
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:10 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ftk1xr453-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0U6T9Uo010943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:09 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0U6T9Ae016154
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
Date: Tue, 30 Jan 2018 14:30:20 +0800
Message-Id: <20180130063020.14850-3-anand.jain@oracle.com>
In-Reply-To: <20180130063020.14850-1-anand.jain@oracle.com>
References: <20180130063020.14850-1-anand.jain@oracle.com>
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
index dfe6b3c67df3..d3aad8cccc7e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -847,6 +847,27 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
index 39ba59832f38..478623e6e074 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5270,6 +5270,16 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		num = map->num_stripes;
 
 	switch(fs_info->read_mirror_policy) {
+	case BTRFS_READ_MIRROR_BY_DEV:
+		optimal = first;
+		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
+			     &map->stripes[optimal].dev->dev_state))
+			break;
+		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
+			     &map->stripes[++optimal].dev->dev_state))
+			break;
+		optimal = first;
+		break;
 	case BTRFS_READ_MIRROR_DEFAULT:
 	case BTRFS_READ_MIRROR_BY_PID:
 	default:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 78f35d299a61..7281f55dea05 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -50,6 +50,7 @@ struct btrfs_pending_bios {
 enum btrfs_read_mirror_type {
 	BTRFS_READ_MIRROR_DEFAULT,
 	BTRFS_READ_MIRROR_BY_PID,
+	BTRFS_READ_MIRROR_BY_DEV,
 };
 
 #define BTRFS_DEV_STATE_WRITEABLE	(0)
@@ -57,6 +58,7 @@ enum btrfs_read_mirror_type {
 #define BTRFS_DEV_STATE_MISSING		(2)
 #define BTRFS_DEV_STATE_REPLACE_TGT	(3)
 #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
+#define BTRFS_DEV_STATE_READ_MIRROR	(5)
 
 struct btrfs_device {
 	struct list_head dev_list;
-- 
2.7.0

