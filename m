Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45163 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3CHPZ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2013 10:25:26 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r28FPPtI016667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:25:26 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r28FPOCT008800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:25:25 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r28FPO7U012272
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 09:25:24 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: update the .gitignore file
Date: Fri,  8 Mar 2013 23:25:45 +0800
Message-Id: <1362756345-30253-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 .gitignore | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/.gitignore b/.gitignore
index 230dfbd..a32b96c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,3 +15,13 @@ find-root
 mkfs.btrfs
 repair
 restore
+btrfs-convert
+btrfs-find-root
+btrfs-image
+btrfs-show-super
+btrfs-zero-log
+btrfstune
+libbtrfs.a
+libbtrfs.so
+libbtrfs.so.0
+libbtrfs.so.0.1
-- 
1.8.1.191.g414c78c

