Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3AIKcx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 05:32:53 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r09AWpRC020742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 10:32:52 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r09AWpXP018129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 10:32:51 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r09AWpHZ003809
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 04:32:51 -0600
From: Simon Xu <xu.simon@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Simon Xu <xu.simon@oracle.com>
Subject: [PATCH] btrfs-progs: remove '-h' from btrfs man page
Date: Wed,  9 Jan 2013 18:32:44 +0800
Message-Id: <1357727564-2509-1-git-send-email-xu.simon@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove '-h' from btrfs man page as it's not supported by the btrfs utility.
---
 man/btrfs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..bf3ea13 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -52,7 +52,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
 [-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
+\fBbtrfs\fP \fBhelp|\-\-help \fP\fI\fP
 .PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
 .PP
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
