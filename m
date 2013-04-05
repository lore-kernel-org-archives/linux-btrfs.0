Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25881 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DEFx5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:57 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355ruiH032483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:57 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rtUR012172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:56 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rtvW021592
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:55 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs-progs: fix btrfs scrub start help
Date: Fri,  5 Apr 2013 13:55:03 +0800
Message-Id: <1365141303-10571-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

a very trivial fix

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5922361..ebb0dc9 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1465,7 +1465,7 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
+	"btrfs scrub start [Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
 	"Start a new scrub",
 	"",
 	"-B     do not background",
-- 
1.8.1.227.g44fe835

