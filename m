Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49366 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3AIGqV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 01:46:21 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r096kKBv012618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 06:46:20 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r096kJLI017617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 06:46:20 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r096kJYZ009275
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 00:46:19 -0600
From: Simon Xu <xu.simon@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Simon Xu <xu.simon@oracle.com>
Subject: [PATCH] remove "device show" from btrfs man page
Date: Wed,  9 Jan 2013 14:46:12 +0800
Message-Id: <1357713972-1581-1-git-send-email-xu.simon@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove "device show" from btrfs man page as it's not supported by the
btrfs utility.
---
 man/btrfs.8.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..e663da2 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -33,8 +33,6 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
-.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
