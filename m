Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59256 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbeDLINJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 04:13:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C8B2Rn068423
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 08:13:08 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2h6pn4tmjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 08:13:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C8D78G018432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 08:13:07 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C8D6mZ016464
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 08:13:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: wipe copies of the stale superblock beyond -b size
Date: Thu, 12 Apr 2018 16:15:06 +0800
Message-Id: <20180412081506.28409-1-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-9-anand.jain@oracle.com>
References: <20180330000924.11148-9-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the mkfs.btrfs -b <blockcount> btrfs_prepare_device() zeros all
the superblock bytenr locations only if the bytenr is below the
blockcount. The problem with this is that if the BTRFS is recreated
with a smaller size then we will leave the stale superblock in the disk
which shall confuse the recovery. As shown in the test case below.

 mkfs.btrfs -qf /dev/mapper/vg-lv
 mkfs.btrfs -qf -b1G /dev/mapper/vg-lv
 btrfs in dump-super -a /dev/mapper/vg-lv | grep '.fsid|superblock:'

 superblock: bytenr=65536, device=/dev/mapper/vg-lv
 dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
 superblock: bytenr=67108864, device=/dev/mapper/vg-lv
 dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
 superblock: bytenr=274877906944, device=/dev/mapper/vg-lv
 dev_item.fsid		b97a9206-593b-4933-a424-c6a6ee23fe7c [match]

So if we find a valid superblock zero it even if it's beyond the
blockcount.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: zero only the magic of the alien superblock, instead of whole of
        superblock. And comments updated. Thanks.

 utils.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/utils.c b/utils.c
index 715bab0ebfb5..4e7964962d0e 100644
--- a/utils.c
+++ b/utils.c
@@ -367,6 +367,42 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 		return 1;
 	}
 
+	/*
+	 * Check and wipe alien superblock at bytenr beyond the block_count.
+	 */
+	if (block_count != btrfs_device_size(fd, &st)) {
+		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			struct btrfs_super_block *disk_super;
+			char buf[BTRFS_SUPER_INFO_SIZE];
+			disk_super = (struct btrfs_super_block *)buf;
+
+			if (btrfs_sb_offset(i) < block_count)
+				continue;
+
+			/* Beyond actual disk size */
+			if (btrfs_sb_offset(i) >= btrfs_device_size(fd, &st))
+				continue;
+
+			/*
+			 * We are reading sperblock at bytenr > block_count, and
+			 * if there is a valid superblock then its an alien
+			 * superblock which should be wiped.
+			 */
+			if (btrfs_read_dev_super(fd, disk_super,
+						 btrfs_sb_offset(i), 0))
+				continue;
+
+			ret = zero_blocks(fd, btrfs_sb_offset(i) +
+				      offsetof(struct btrfs_super_block, magic),
+				      sizeof(u64));
+			if (ret < 0) {
+				error("failed to zero device '%s' bytenr %llu: %s",
+					file, btrfs_sb_offset(i), strerror(-ret));
+				return 1;
+			}
+		}
+	}
+
 	*block_count_ret = block_count;
 	return 0;
 }
-- 
2.7.0

