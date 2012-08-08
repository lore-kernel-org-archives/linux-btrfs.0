Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab2HHIzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 04:55:09 -0400
Message-ID: <5022295E.9050503@cn.fujitsu.com>
Date: Wed, 08 Aug 2012 16:54:54 +0800
From: zhoubo <zhoub-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: btrfs community <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 3/3 V2] Btrfs-progs: update the manpage entries for the btrfs
 subvolume list
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50222948.8030102@cn.fujitsu.com>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

This patch adds the introduction of the new option '-r' into the man page of
'btrfs subvolume list' command.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
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
1.6.0.6
