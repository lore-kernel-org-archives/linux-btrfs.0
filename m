Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:45219 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab3CUIer (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 04:34:47 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Thu, 21 Mar 2013 02:34:46 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sensille@gmx.net,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: add missing qgroup synopsis in btrfs
Date: Thu, 21 Mar 2013 16:33:37 +0800
Message-Id: <1363854817-22416-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 man/btrfs.8.in | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..54de60e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -60,6 +60,18 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
 [-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBqgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBqgroup remove\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBqgroup create\fP \fI<qgroupid>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBqgroup destroy\fP \fI<qgroupid>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBqgroup show\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBhelp|\-\-help \fP\fI\fP
 .PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
@@ -434,6 +446,31 @@ verbose mode. print count of returned paths and all ioctl() return values
 set inode container's size. This is used to increase inode container's size in case it is
 not enough to read all the resolved results. The max value one can set is 64k.
 .RE
+.TP
+
+\fBbtrfs qgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+Enable subvolume qgroup support for a filesystem.
+.TP
+
+\fBbtrfs qgroup remove\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+Remove a subvol from a quota group.
+.TP
+
+\fBbtrfs qgroup create\fP \fI<qgroupid>\fP \fI<path>\fP
+Create a subvolume quota group.
+.TP
+
+\fBbtrfs qgroup destroy\fP \fI<qgroupid>\fP \fI<path>\fP
+Destroy a subvolume quota group.
+.TP
+
+\fBbtrfs qgroup show\fP \fI<path>\fP
+Show all subvolume quota groups.
+.TP
+
+\fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
+Limit the size of a subvolume quota group.
+.RE
 
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
-- 
1.7.11.7

