Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751534AbcLHN4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 08:56:50 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB8DrX0X084159
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Dec 2016 08:56:49 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 276n7smbmt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 08:56:49 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 8 Dec 2016 06:56:47 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com
Subject: [PATCH 1/2] btrfs-progs: btrfs-convert: Prevent accounting blocks beyond end of device
Date: Thu,  8 Dec 2016 19:26:19 +0530
Message-Id: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When looping across data block bitmap, __ext2_add_one_block() may add
blocks which do not exist on the underlying disk. This commit prevents
this from happening by checking the block index against the maximum
block count that was present in the ext4 filesystem instance that is
being converted.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 convert/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index 4b4cea4..1148a36 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1525,6 +1525,9 @@ static int __ext2_add_one_block(ext2_filsys fs, char *bitmap,
 	offset /= EXT2FS_CLUSTER_RATIO(fs);
 	offset += group_nr * EXT2_CLUSTERS_PER_GROUP(fs->super);
 	for (i = 0; i < EXT2_CLUSTERS_PER_GROUP(fs->super); i++) {
+		if ((i + offset) >= ext2fs_blocks_count(fs->super))
+			break;
+
 		if (ext2fs_test_bit(i, bitmap)) {
 			u64 start;
 
-- 
2.5.5

