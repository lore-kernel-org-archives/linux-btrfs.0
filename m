Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31446 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbcFQFiN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 01:38:13 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5H5Y0Wb060870
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 01:38:13 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23krwcpq54-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 01:38:12 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 16 Jun 2016 23:38:12 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com,
        bo.li.liu@oracle.com, takeuchi_satoru@jp.fujitsu.com
Subject: [PATCH V2] Btrfs-progs: Initialize stripesize to the value of sectorsize
Date: Fri, 17 Jun 2016 11:07:54 +0530
Message-Id: <1466141874-15854-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

stripesize should ideally be set to the value of sectorsize. However
previous versions of btrfs-progs/mkfs.btrfs had set stripesize to a
value of 4096. On machines with PAGE_SIZE other than 4096, This could
lead to the following scenario,

- /dev/loop0, /dev/loop1 and /dev/loop2 are mounted as a single
  filesystem. The filesystem was created by an older version of mkfs.btrfs
  which set stripesize to 4k.
- losetup -a
   /dev/loop0: [0030]:19477 (/root/disk-imgs/file-0.img)
   /dev/loop1: [0030]:16577 (/root/disk-imgs/file-1.img)
   /dev/loop2: [64770]:3423229 (/root/disk-imgs/file-2.img)
- /etc/mtab lists only /dev/loop0
- losetup /dev/loop4 /root/disk-imgs/file-1.img
  The new mkfs.btrfs invoked as 'mkfs.btrfs -f /dev/loop4' succeeds even
  though /dev/loop1 has already been mounted and has
  /root/disk-imgs/file-1.img as its backing file.

The above behaviour occurs because check_super() function returns an
error code (due to stripesize not being set to 4096) and hence
check_mounted_where() function treats /dev/loop1 as a disk containing a
filesystem other than Btrfs.

Hence as a workaround this commit allows 4096 as a valid stripesize.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog:
v1->v2: Use Tabs to indent rather than spaces. Thanks to Satoru Takeuchi for
pointing this out.

disk-io.c | 3 ++-
 mkfs.c    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 77eb0a6..fbce506 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1476,7 +1476,8 @@ static int check_super(struct btrfs_super_block *sb)
 		error("invalid bytes_used %llu", btrfs_super_bytes_used(sb));
 		goto error_out;
 	}
-	if (btrfs_super_stripesize(sb) != 4096) {
+	if ((btrfs_super_stripesize(sb) != 4096)
+		&& (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
 		error("invalid stripesize %u", btrfs_super_stripesize(sb));
 		goto error_out;
 	}
diff --git a/mkfs.c b/mkfs.c
index a3a3c14..697bdc2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1482,6 +1482,7 @@ int main(int argc, char **argv)
 	}
 
 	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
+	stripesize = sectorsize;
 	saved_optind = optind;
 	dev_cnt = argc - optind;
 	if (dev_cnt == 0)
-- 
2.5.5

