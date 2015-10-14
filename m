Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51754 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbbJNRlo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 13:41:44 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 15 Oct 2015 03:41:42 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id D74373578052
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 04:41:40 +1100 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9EHfR4W21102706
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 04:41:36 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9EHf7AF031720
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 04:41:08 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com,
        chandan@mykolab.com
Subject: [PATCH] Btrfs-progs: Prevent creation of filesystem with 'mixed bgs' and having differing sectorsize and nodesize.
Date: Wed, 14 Oct 2015 23:10:38 +0530
Message-Id: <1444844438-20001-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs allows creation of Btrfs filesystem instances with mixed block
group feature enabled and having a sectorsize different from nodesize.
For e.g:

[root@localhost btrfs-progs]# mkfs.btrfs -f -M -s 4096 -n 16384  /dev/loop0
Forcing mixed metadata/data groups
btrfs-progs v3.19-rc2-404-gbbbd18e-dirty
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (4.00GiB) ...
Label:              (null)
UUID:               c82b5720-6d88-4fa1-ac05-d0d4cb797fd5
Node size:          16384
Sector size:        4096
Filesystem size:    4.00GiB
Block group profiles:
  Data+Metadata:    single            8.00MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, skinny-metadata
Number of devices:  1
Devices:
  ID        SIZE  PATH
   1     4.00GiB  /dev/loop6

This commit fixes the issue by setting BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS
feature bit before checking the validity of nodesize that was specified on the
command line.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 mkfs.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index dc70a9a..10016b2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1541,6 +1541,19 @@ int main(int ac, char **av)
 		if (!nodesize_forced)
 			nodesize = best_nodesize;
 	}
+
+	/*
+	 * FS features that can be set by other means than -O
+	 * just set the bit here
+	 */
+	if (mixed)
+		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
+
+	if ((data_profile | metadata_profile) &
+	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
+	}
+
 	if (btrfs_check_nodesize(nodesize, sectorsize,
 				 features))
 		exit(1);
@@ -1648,18 +1661,6 @@ int main(int ac, char **av)
 			"WARNING: metatdata has lower redundancy than data!\n\n");
 	}
 
-	/*
-	 * FS features that can be set by other means than -O
-	 * just set the bit here
-	 */
-	if (mixed)
-		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-
-	if ((data_profile | metadata_profile) &
-	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
-		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
-	}
-
 	mkfs_cfg.label = label;
 	mkfs_cfg.fs_uuid = fs_uuid;
 	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
-- 
2.1.0

