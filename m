Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19493 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754418AbcFPQiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 12:38:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5GGYKKE046630
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 12:38:24 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23kdg5pkhe-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 12:38:24 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 16 Jun 2016 10:38:23 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com,
        bo.li.liu@oracle.com
Subject: [PATCH] Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize
Date: Thu, 16 Jun 2016 22:07:58 +0530
Message-Id: <1466095078-25726-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Older btrfs-progs/mkfs.btrfs sets 4096 as the stripesize. Hence
restricting stripesize to be equal to sectorsize would cause super block
validation to return an error on architectures where PAGE_SIZE is not
equal to 4096.

Hence as a workaround, this commit allows stripesize to be set to 4096
bytes.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1142127..7f92b4f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4139,7 +4139,8 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 	if (!is_power_of_2(btrfs_super_stripesize(sb)) ||
-	    btrfs_super_stripesize(sb) != sectorsize) {
+		((btrfs_super_stripesize(sb) != sectorsize) &&
+			(btrfs_super_stripesize(sb) != 4096))) {
 		btrfs_err(fs_info, "invalid stripesize %u",
 		       btrfs_super_stripesize(sb));
 		ret = -EINVAL;
-- 
2.5.5

