Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2LQLff (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:35:35 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBHBZYVr019564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:35 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBHBZXaa026913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:34 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBHBZXRj009128
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 05:35:33 -0600
Message-ID: <50CF0381.6060301@oracle.com>
Date: Mon, 17 Dec 2012 19:35:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH v5 4/4] Btrfs-progs: fix cmd_label_usage to reflect this change.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50CF0053.4050906@oracle.com>

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
