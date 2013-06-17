Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40152 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3FQVpE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 17:45:04 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5HLj3Ss027245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 21:45:04 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5HLj2Qu005525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 21:45:02 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5HLj2So005501
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 21:45:02 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Guangyu Sun <guangyu.sun@oracle.com>
Subject: [PATCH] btrfs-progs: update man page for btrfs filesystem label
Date: Mon, 17 Jun 2013 14:45:23 -0700
Message-Id: <1371505523-28674-1-git-send-email-guangyu.sun@oracle.com>
In-Reply-To: <y>
References: <y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs filesystem label can work on a mounted filesystem, also on a
multi-devices filesystem. And the restriction of label name is
changed, too. The man page should be updated accordingly.

Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 man/btrfs.8.in |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..1da4ff1 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -263,22 +263,13 @@ it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 .TP
 
-\fBfilesystem label\fP\fI <dev> [newlabel]\fP
-Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
-filesystem. 
+\fBfilesystem label\fP\fI [<device>|<mountpoint>] [newlabel]\fP
+Show or update the label of a filesystem. \fI[<device>|<mountpoint>]\fR is used
+to identify the filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
 following constraints exist for a label:
 .IP
-- the maximum allowable length shall be less or equal than 256 chars
-.IP
-- the label shall not  contain the '/' or '\\' characters.
-
-NOTE: Currently there are the following limitations:
-.IP
-- the filesystem has to be unmounted
-.IP
-- the filesystem should not have more than one device.
-.TP
+- the maximum allowable length shall be less than 256 chars
 
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
-- 
1.7.9.5

