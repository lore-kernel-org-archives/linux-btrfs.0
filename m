Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29530 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab3GKU6O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 16:58:14 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6BKwCcC002307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 20:58:13 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6BKwCKv029597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 20:58:12 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6BKwBQT012605
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 20:58:11 GMT
From: Koen De Wit <koen.de.wit@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH] btrfs-progs: mkfs.btrfs documentation: clarify current restrictions of sectorsize, nodesize and leafsize
Date: Thu, 11 Jul 2013 22:56:17 +0200
Message-Id: <1373576177-9272-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 8d082fb727ac11930ea20bf1612e334ea7c2b697 (Btrfs: do not mount when
we have a sectorsize unequal to PAGE_SIZE) requires the sectorsize to be
equal to the pagesize for the filesystem to be mountable.

The nodesize and leafsize should be equal, and not larger than 65536.

Adding this information to the manpage and usage instructions of mkfs.btrfs.
---
 man/mkfs.btrfs.8.in |   12 +++++++++---
 mkfs.c              |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index a3f1503..b2a4e73 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -46,7 +46,8 @@ there is a filesystem or partition table on the device already.
 .TP
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
 Specify the leaf size, the least data item in which btrfs stores data. The
-default value is the page size.
+default value is the page size. Must be a multiple of the sectorsize, but
+not larger than 65536. Should be equal to the nodesize.
 .TP
 \fB\-L\fR, \fB\-\-label \fIname\fR
 Specify a label for the filesystem.
@@ -66,10 +67,15 @@ larger filesystems.  It is recommended for use with filesystems
 of 1 GiB or smaller.
 .TP
 \fB\-n\fR, \fB\-\-nodesize \fIsize\fR
-Specify the nodesize. By default the value is set to the pagesize.
+Specify the nodesize. By default the value is set to the pagesize. Must be a
+multiple of the sectorsize, but not larger than 65536. Should be equal to the
+leafsize.
 .TP
 \fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
-Specify the sectorsize, the minimum block allocation.
+Specify the sectorsize, the minimum block allocation. The default value is
+the pagesize. If the sectorsize differs from the pagesize, the created
+filesystem cannot be mounted by the current kernel. Therefore it is not
+recommended to use this option.
 .TP
 \fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
 Specify a directory to copy into the newly created fs.
diff --git a/mkfs.c b/mkfs.c
index b412b7e..9f75c58 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -319,7 +319,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
 	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
-	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
+	fprintf(stderr, "\t -s --sectorsize min block allocation (not mountable by current kernel)\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
-- 
1.7.2.5

