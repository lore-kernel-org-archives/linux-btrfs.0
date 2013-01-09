Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51535 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3AIHbU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 02:31:20 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r097VJQt029882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:31:19 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r097VIjI029608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:31:19 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r097VIL9002408
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 01:31:18 -0600
From: Simon Xu <xu.simon@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Simon Xu <xu.simon@oracle.com>
Subject: [PATCH V2] btrfs-progs: remove "device show" from btrfs man page
Date: Wed,  9 Jan 2013 15:31:07 +0800
Message-Id: <1357716667-1673-1-git-send-email-xu.simon@oracle.com>
In-Reply-To: <50ED18C5.8000107@oracle.com>
References: <50ED18C5.8000107@oracle.com>
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

