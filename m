Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50501 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3DOGhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 09/11, RESEND] btrfs-progs: fix btrfs scrub start help
Date: Mon, 15 Apr 2013 14:38:15 +0800
Message-Id: <1366007897-26567-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

a very trivial fix

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-scrub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5922361..c0dc584 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1465,7 +1465,7 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
+	"btrfs scrub start [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
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

