Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34226 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2JECWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 22:22:20 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q952MIRM028758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Oct 2012 02:22:19 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q952MHVA015931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Oct 2012 02:22:18 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q952MH67016920
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Oct 2012 21:22:17 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: Corrections and additions to the btrfs man page
Date: Fri,  5 Oct 2012 10:25:20 +0800
Message-Id: <1349403922-4583-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
References: <50584E6D.8000602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/btrfs.8.in |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 6d6c70a..71af35c 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -126,9 +126,15 @@ and top level. The parent's ID may be used at mount time via the
 
 \fB-a\fP print all the subvolumes in the filesystem.
 
-\fB-r\fP only readonly subvolumes in the filesystem wille be listed.
+\fB-r\fP only readonly subvolumes in the filesystem will be listed.
 
-\fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
+\fB-s\fP only snapshot subvolumes in the filesystem will be listed.
+
+\fB-u\fP print the uuid of subvolumes (and snapshots).
+
+\fB-P\fP print parent uuid of snapshots.
+
+\fB-p\fP print parent ID.
 
 \fB-g [+|-]value\fP
 list subvolumes in the filesystem that its generation is
-- 
1.7.1

