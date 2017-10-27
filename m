Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49260 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdJ0Hbk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 03:31:40 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9R7VdOW013309
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 07:31:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9R7VdlH012269
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 07:31:39 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9R7VdXw024350
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 07:31:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: reserve < 0 return value for errnos
Date: Fri, 27 Oct 2017 15:31:33 +0800
Message-Id: <20171027073133.24874-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_dev_super() returns -1 upon not finding a suitable SB,
change that to return 1 instead, so that it can reserve the < 0
values for the errno communications.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
An independent patch, not related to any recent patch sent to ML.

 disk-io.c | 2 +-
 utils.c   | 2 +-
 volumes.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index f5edc4796619..ba87bb4ce6da 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1491,7 +1491,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		}
 	}
 
-	return transid > 0 ? 0 : -1;
+	return transid > 0 ? 0 : 1;
 }
 
 static int write_dev_supers(struct btrfs_fs_info *fs_info,
diff --git a/utils.c b/utils.c
index 524f463d3140..7574cda8151c 100644
--- a/utils.c
+++ b/utils.c
@@ -1678,7 +1678,7 @@ int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		disk_super = (struct btrfs_super_block *)buf;
 		ret = btrfs_read_dev_super(fd, disk_super,
 					   BTRFS_SUPER_INFO_OFFSET, 0);
-		if (ret < 0) {
+		if (ret) {
 			ret = -EIO;
 			goto out;
 		}
diff --git a/volumes.c b/volumes.c
index 2209e5a9100b..87008bfdd586 100644
--- a/volumes.c
+++ b/volumes.c
@@ -268,7 +268,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset, sbflags);
-	if (ret < 0)
+	if (ret)
 		return -EIO;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
-- 
2.13.1

