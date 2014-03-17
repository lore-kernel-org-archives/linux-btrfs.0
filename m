Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46562 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaCQL7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 07:59:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s2HBxEcM008088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:59:15 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s2HBxEJ2012694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:59:14 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s2HBxDKe023452
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:59:14 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: avoid implicit scan for backup SB
Date: Mon, 17 Mar 2014 19:59:01 +0800
Message-Id: <1395057541-4426-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a disk containing btrfs is overwritten with other FS, ext4
for example it doesn't overwrite 2nd and 3rd copy of the btrfs SB.
And btrfs_read_dev_super() would look for backup SB when primary
SB isn't found. This causes the problem as in the reproducer below.

In kernel we avoid this by _not_ reading backup SB implicitly,
this patch would port the same to btrfs-progs.

reproducer:
mkfs.btrfs /dev/sde
mkfs.ext4 /dev/sde
mount /dev/sde /ext4
btrfs-convert /dev/sde (is successful (bug))

with this patch
::
btrfs-convert /dev/sde
/dev/sde is mounted

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 disk-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 0bd1bb0..19b95a7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1206,7 +1206,14 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		return 0;
 	}
 
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+	/*
+	* we would like to check all the supers, but that would make
+	* a btrfs mount succeed after a mkfs from a different FS.
+	* So, we need to add a special mount option to scan for
+	* later supers, using BTRFS_SUPER_MIRROR_MAX instead
+	*/
+
+	for (i = 0; i < 1; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, &buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
-- 
1.8.5.3

