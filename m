Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab2IFKut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:50:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86Aom97019825
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:50:48 +0800
Message-ID: <50487FFB.6020103@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:50:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 7/7] Btrfs-progs: update the manpage entries for the btrfs,
 subvolume list
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

This patch adds the introduction of the new option '-r' into the man page of
'btrfs subvolume list' command.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
Changelog v2 -> v3:
- No change.

Changelog v1 -> v2:
- new patch
---
 man/btrfs.8.in |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..0845b4d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-p] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-pr] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -108,7 +108,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-p] <path>\fR
+\fBsubvolume list\fR\fI [-pr] <path>\fR
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
 ID <ID> top level <ID> path <path>
@@ -119,6 +119,7 @@ at mount time via the \fIsubvol=\fR option.
 If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
 and top level. The parent's ID may be used at mount time via the
 \fIsubvolrootid=\fR option.
+If \fI-r\fR is given, only readonly subvolumes in the filesystem will be listed.
 .TP
 
 \fBsubvolume set-default\fR\fI <id> <path>\fR
-- 
1.7.6.5
