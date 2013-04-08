Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37868 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934706Ab3DHCIK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 22:08:10 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r382888o008667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 02:08:09 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r38287aC019084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 02:08:08 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r38287KR026016
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 02:08:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9 v2] btrfs-progs: fix btrfs scrub start help
Date: Mon,  8 Apr 2013 10:09:30 +0800
Message-Id: <1365386970-16435-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-10-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-10-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

a very trivial fix

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-scrub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5922361..32fcc20 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1465,7 +1465,7 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
+	"btrfs scrub start [Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
 	"Start a new scrub",
 	"",
 	"-B     do not background",
@@ -1526,7 +1526,7 @@ out:
 }
 
 static const char * const cmd_scrub_resume_usage[] = {
-	"btrfs scrub resume [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
+	"btrfs scrub resume [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
 	"Resume previously canceled or interrupted scrub",
 	"",
 	"-B     do not background",
-- 
1.8.1.227.g44fe835

