Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50882 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3KPRJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:17 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so4620016wgg.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:16 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/7] btrfs subvolume snapshot -R: update man page
Date: Sat, 16 Nov 2013 18:09:06 +0100
Message-Id: <1384621747-25441-7-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update man page of "btrfs subvolume snapshot", documenting the
-R switch.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index b620348..aee1f70 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -12,7 +12,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP [-r][-R] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
@@ -227,12 +227,14 @@ for \fB--sort\fP you can combine some items together by ',', just like
 .RE
 .TP
 
-\fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+\fBsubvolume snapshot\fP [-r][-R] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
 Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
 name \fI<name>\fR in the \fI<dest>\fR directory.
 If only \fI<dest>\fR is given, the subvolume will be named the basename of \fI<source>\fR.
 If \fI<source>\fR is not a subvolume, \fBbtrfs\fR returns an error.
 If \fI-r\fR is given, the snapshot will be readonly.
+If \fI-R\fR is given, the snapshot will be made recursively. \fI-R\fR and
+\fI-r\fR cannot be used togheter. The -R switch requires the root capability.
 .TP
 
 \fBsubvolume get-default\fR\fI <path>\fR
-- 
1.8.4.3

