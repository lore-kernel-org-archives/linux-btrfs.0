Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab2IRLMK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 07:12:10 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8IBC87Z017050
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 19:12:08 +0800
Message-ID: <50585707.9010009@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 19:12:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 7/7] Btrfs-progs: update the manpage entries for the btrfs
 subvolume list
References: <50584E6D.8000602@cn.fujitsu.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

This patch adds the introduction of the new option '-r' into the man page of
'btrfs subvolume list' command.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v3 -> v4:
- No change.

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

