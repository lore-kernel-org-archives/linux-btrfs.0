Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32246 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HGI6k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 04:58:40 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q778wcfM009297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:38 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q778wbMR009376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:38 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q778wbsV029641
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 03:58:37 -0500
Message-ID: <5020D892.5070300@oracle.com>
Date: Tue, 07 Aug 2012 16:57:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 4/5] btrfs-progs: teach Makefile aware of the new comer
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5020D84E.4010900@oracle.com>

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 9694444..f8b517d 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o diff-snapshot.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o
 
-- 
1.7.4.1
