Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAVGKJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 01:10:09 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s0M6A8ur010962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 06:10:09 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0M6A7tt010382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 06:10:08 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0M6A7UY002035
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 06:10:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: update INSTALL file
Date: Wed, 22 Jan 2014 14:19:37 +0800
Message-Id: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

with the changes that has happened since last time it was updated

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 INSTALL |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/INSTALL b/INSTALL
index 8ead607..a86878a 100644
--- a/INSTALL
+++ b/INSTALL
@@ -12,7 +12,8 @@ complete:
 modprobe libcrc32c
 insmod btrfs.ko
 
-The Btrfs utility programs require libuuid to build.  This can be found
+The Btrfs utility programs (btrfs-progs) require libattr zlib libacl
+e2fsprogs libblkid lzo2 to build.  This can be found
 in the e2fsprogs sources, and is usually available as libuuid or
 e2fsprogs-devel from various distros.
 
@@ -49,6 +50,3 @@ btrfsck: do a limited check of the FS extent trees.</li>
 btrfs-debug-tree: print all of the FS metadata in text form.  Example:
 
 	btrfs-debug-tree /dev/sda2 >& big_output_file
-
-
-
-- 
1.7.1

