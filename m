Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbeC0XiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 19:38:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2RNU4Rg022695
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:21 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2gyyp7g0yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2RNcKnt003252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:20 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2RNcKAh019312
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/8] btrfs: verify superblock checksum during scan
Date: Wed, 28 Mar 2018 07:39:57 +0800
Message-Id: <20180327234000.23656-7-anand.jain@oracle.com>
In-Reply-To: <20180327234000.23656-1-anand.jain@oracle.com>
References: <20180327234000.23656-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the scan context, we aren't verifying the superblock-
checksum when read.
This patch fixes it by adding the checksum verification function
btrfs_check_super_csum() in the function btrfs_read_disk_super().
And makes device scan to error fail if the primary superblock csum
is wrong, whereas if the copy-superblock csum is wrong it will just
just report mismatch and continue mount/scan as usual. When the
mount is successful We anyway overwrite all superblocks upon unmount.

The context in which this will be called is - device scan, device ready,
and mount -o device option.

Test script:

 Corrupt primary superblock and check if device scan and mount
 fails:
  mkfs.btrfs -fq /dev/sdc
  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
  btrfs dev scan /dev/sdc
  mount /dev/sdc /btrfs

 Corrupt secondary superblock and check if device scan and mount
 is succcessful, check for the dmesg for errors.
  mkfs.btrfs -fq /dev/sdc
  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=67108864
  btrfs dev scan /dev/sdc
  mount /dev/sdc /btrfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
 changed title.
 use explicit (< 0) check for %errr.
 Un-split pr_err() string.
 Fix typo in the git commit log.
 Move the csum check after bytenr and btrfs magic verified.

 fs/btrfs/volumes.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b099823f60d1..eda86ba258fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1149,6 +1149,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 				 struct page **page,
 				 struct btrfs_super_block **disk_super)
 {
+	int err;
 	void *p;
 	pgoff_t index;
 
@@ -1183,6 +1184,18 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 		return -EINVAL;
 	}
 
+	err = btrfs_check_super_csum((char *) *disk_super);
+	if (err < 0) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): unsupported checksum type, bytenr=%llu",
+				bdev, bytenr);
+		else
+			pr_err("BTRFS error (device %pg): superblock checksum failed, bytenr=%llu",
+				bdev, bytenr);
+		btrfs_release_disk_super(*page);
+		return err;
+	}
+
 	if ((*disk_super)->label[0] &&
 		(*disk_super)->label[BTRFS_LABEL_SIZE - 1])
 		(*disk_super)->label[BTRFS_LABEL_SIZE - 1] = '\0';
-- 
2.7.0

