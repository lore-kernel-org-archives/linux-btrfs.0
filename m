Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45354 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2JECWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 22:22:20 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q952MJYQ025623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Oct 2012 02:22:20 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q952MIrq009724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Oct 2012 02:22:19 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q952MIva022594
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Oct 2012 21:22:18 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: Update btrfs man page for -P option
Date: Fri,  5 Oct 2012 10:25:21 +0800
Message-Id: <1349403922-4583-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1349403922-4583-1-git-send-email-Anand.Jain@oracle.com>
References: <50584E6D.8000602@cn.fujitsu.com>
 <1349403922-4583-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/btrfs.8.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 29f93cf..71af35c 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -132,6 +132,8 @@ and top level. The parent's ID may be used at mount time via the
 
 \fB-u\fP print the uuid of subvolumes (and snapshots).
 
+\fB-P\fP print parent uuid of snapshots.
+
 \fB-p\fP print parent ID.
 
 \fB-g [+|-]value\fP
-- 
1.7.1

