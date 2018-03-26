Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41244 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbeCZI0E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:26:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8JLX3039581
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:03 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2gxw8gg0rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Q21f022249
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:03 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Q25o024025
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: wipe copies of the stale superblock beyond -b size
Date: Mon, 26 Mar 2018 16:27:42 +0800
Message-Id: <20180326082742.9235-10-anand.jain@oracle.com>
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
 utils.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/utils.c b/utils.c
index e9cb3a82fda6..6a9408b06e73 100644
--- a/utils.c
+++ b/utils.c
@@ -365,6 +365,41 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 		return 1;
 	}
 
+	/*
+	 * Check for the BTRFS SB copies up until btrfs_device_size() and zero
+	 * it. So that kernel (or user for the manual recovery) don't have to
+	 * confuse with the stale SB copy during recovery.
+	 */
+	if (block_count != btrfs_device_size(fd, &st)) {
+		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			struct btrfs_super_block *disk_super;
+			char buf[BTRFS_SUPER_INFO_SIZE];
+			disk_super = (struct btrfs_super_block *)buf;
+
+			/* Already zeroed above */
+			if (btrfs_sb_offset(i) < block_count)
+				continue;
+
+			/* Beyond actual disk size */
+			if (btrfs_sb_offset(i) >= btrfs_device_size(fd, &st))
+				continue;
+
+			/* Does not contain any stale SB */
+			if (btrfs_read_dev_super(fd, disk_super,
+						 btrfs_sb_offset(i), 0))
+				continue;
+
+			ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
+						BTRFS_SUPER_INFO_SIZE,
+						btrfs_device_size(fd, &st));
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

