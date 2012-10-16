Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35779 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2JPG5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 02:57:43 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9G6vNDA027459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:57:24 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9G6vMFu001173
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:57:23 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9G6vMN0002206
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 01:57:22 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] Btrfs-progs: update man page for -u and -q option in subvol list
Date: Tue, 16 Oct 2012 15:00:47 +0800
Message-Id: <1350370847-20262-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350370847-20262-1-git-send-email-Anand.Jain@oracle.com>
References: <20121009154418.GV4405@twin.jikos.cz>
 <1350370847-20262-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/btrfs.8.in |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 57c25b0..91f2af2 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-apruqts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -110,7 +110,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-aprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
+\fBsubvolume list\fR\fI [-apruqts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
 .RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -132,6 +132,10 @@ and top level. The parent's ID may be used at mount time via the
 
 \fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
 
+\fB-u\fP print UUID of the subvolume.
+
+\fB-q\fP print parent UUID of the subvolume.
+
 \fB-g [+|-]value\fP
 list subvolumes in the filesystem that its generation is
 >=, <= or = value. '+' means >= value, '-' means <= value, If there is
-- 
1.7.1

