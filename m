Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3F1FPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 01:15:46 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5S59QJd007793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 05:09:27 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S5FjEP025952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 05:15:45 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S5FiFh011985
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 05:15:45 GMT
Message-ID: <51CD1C08.40801@oracle.com>
Date: Fri, 28 Jun 2013 13:15:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix file truncation if FALLOC_FL_KEEP_SIZE is specified
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

Create a small file and fallocate it to a big size with
FALLOC_FL_KEEP_SIZE option, then truncate it back to the
small size again, the disk free space is not changed back
in this case. i.e,

# dd if=/dev/zero of=/mnt/test bs=512 count=1
# ls -l /mnt
total 4
-rw-r--r-- 1 root root 512 Jun 28 11:35 test

# df -h
Filesystem      Size  Used Avail Use% Mounted on
....
/dev/sdb1       8.0G   56K  7.2G   1% /mnt

# xfs_io -c 'falloc -k 512 5G' /mnt/test 
# ls -l /mnt/test
-rw-r--r-- 1 root root 512 Jun 28 11:35 /mnt/test

# sync; df -h
Filesystem      Size  Used Avail Use% Mounted on
....
/dev/sdb1       8.0G  5.1G  2.2G  70% /mnt

# xfs_io -c 'truncate 512' /mnt/test
# sync; df -h
Filesystem      Size  Used Avail Use% Mounted on
....
/dev/sdb1       8.0G  5.1G  2.2G  70% /mnt

With this fix, the truncated up space is back as:
# sync; df -h
Filesystem      Size  Used Avail Use% Mounted on
....
/dev/sdb1       8.0G   56K  7.2G   1% /mnt

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/btrfs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f9d16b..7e1a5ff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4509,9 +4509,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	int mask = attr->ia_valid;
 	int ret;
 
-	if (newsize == oldsize)
-		return 0;
-
 	/*
 	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
 	 * special case where we need to update the times despite not having
-- 
1.7.9.5
