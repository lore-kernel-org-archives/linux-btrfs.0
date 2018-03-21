Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47012 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeCUKRg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 06:17:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2LA8ItK092743
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:17:36 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2gunch81c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:17:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2LAHY41022031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:17:35 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2LAHY0h027970
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:17:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: wipe all copies of the stale superblock
Date: Wed, 21 Mar 2018 18:19:20 +0800
Message-Id: <20180321101920.9004-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recovering from the other copies of the superblock is fundamental
to BTRFS, which provides resilient against single LBA failure in
the DUP group profile.

Further, in the test case [1] it shows a good but stale superblock
at copy#2. This will lead to confusion during auto/manual recovery.
So strictly speaking if a device has three copies of the superblock
and if we have permission to wipe it (-f option) then we have to wipe
all the copies of the superblock.

If there is any objection to writing beyond mkfs.btrfs -b <size>, then
we could fail the mkfs/dev-add/dev-replace operation and ask the user
the wipe using dd command manually, as anyway there is no use of keeping
only the copy#2 when the new FS has been written.

Test case: Note that copy#2 fsid is different from primary and copy#1
fsid.

mkfs.btrfs -qf /dev/mapper/vg-lv && \
mkfs.btrfs -qf -b1G /dev/mapper/vg-lv && \
btrfs in dump-super -a /dev/mapper/vg-lv | grep '.fsid|superblock:'

superblock: bytenr=65536, device=/dev/mapper/vg-lv
dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
superblock: bytenr=67108864, device=/dev/mapper/vg-lv
dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
superblock: bytenr=274877906944, device=/dev/mapper/vg-lv
dev_item.fsid		b97a9206-593b-4933-a424-c6a6ee23fe7c [match]

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Hope with this we can patch the kernel to auto recover from the
 failed primary SB. In the earlier discussion on that, I think we
 are scrutinizing the wrong side (kernel) of the problem.
 Also, we need to fail the mount if all the copies of the SB do
 not have the same fsid.

 utils.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/utils.c b/utils.c
index 00020e1d6bdf..9c027f77d9c1 100644
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
2.15.0

