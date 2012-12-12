Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab2LLAak (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 19:30:40 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBC0Uc4o009695
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:39 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBC0Ubkp024506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:38 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBC0Ubin013023
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 18:30:37 -0600
Message-ID: <50C7D029.9080802@oracle.com>
Date: Wed, 12 Dec 2012 08:30:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH v4 3/3] Btrfs-progs: fix cmd_label_usage to reflect this change.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50C7CE36.3060603@oracle.com>

Fix the command usage of "btrfs filesystem label" to reflect this change. i.e. so that
we can get/set the label of a mounted filesystem against the mountpoint.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 cmds-filesystem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9c43d35..5770d8b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -517,8 +517,8 @@ static int cmd_resize(int argc, char **argv)
 }
 
 static const char * const cmd_label_usage[] = {
-	"btrfs filesystem label <device> [<newlabel>]",
-	"Get or change the label of an unmounted filesystem",
+	"btrfs filesystem label [<device>|<mountpoint>] [<newlabel>]",
+	"Get or change the label of a filesystem",
 	"With one argument, get the label of filesystem on <device>.",
 	"If <newlabel> is passed, set the filesystem label to <newlabel>.",
 	NULL
-- 
1.7.9.5
