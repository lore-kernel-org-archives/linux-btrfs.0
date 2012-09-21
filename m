Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51200 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab2IUG5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 02:57:41 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8L6vcXj023998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:57:39 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8L6vcqd018640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:57:38 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8L6vcPl017380
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 01:57:38 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: correct the mkfs.btrfs man page
Date: Fri, 21 Sep 2012 15:00:15 +0800
Message-Id: <1348210815-29719-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/mkfs.btrfs.8.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index fc2e1d2..d425c33 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -1,6 +1,6 @@
 .TH MKFS.BTRFS 8
 .SH NAME
-mkfs.btrfs \- create an btrfs filesystem
+mkfs.btrfs \- create a btrfs filesystem
 .SH SYNOPSIS
 .B mkfs.btrfs
 [ \fB\-A\fP\fI alloc-start\fP ]
@@ -18,7 +18,7 @@ mkfs.btrfs \- create an btrfs filesystem
 \fI device\fP [ \fIdevice ...\fP ]
 .SH DESCRIPTION
 .B mkfs.btrfs
-is used to create an btrfs filesystem (usually in a disk partition, or an array
+is used to create a btrfs filesystem (usually in a disk partition, or an array
 of disk partitions).
 .I device
 is the special file corresponding to the device (e.g \fI/dev/sdXX\fP ).
-- 
1.7.1

