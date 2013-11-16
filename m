Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3KPRJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:17 -0500
Received: by mail-we0-f174.google.com with SMTP id t61so4688979wes.19
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:16 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/7] Document the -R switch for the "btrfs subvolume delete" command.
Date: Sat, 16 Nov 2013 18:09:07 +0100
Message-Id: <1384621747-25441-8-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index aee1f70..5ed5277 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -8,7 +8,7 @@ btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
 \fBbtrfs\fP \fBsubvolume create\fP [-i \fI<qgroupid>\fP] [\fI<dest>\fP/]\fI<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume delete\fP \fI<subvolume>\fP [\fI<subvolume>...\fP]
+\fBbtrfs\fP \fBsubvolume delete\fP [-R] \fI<subvolume>\fP [\fI<subvolume>...\fP]
 .PP
 \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
 .PP
@@ -168,9 +168,12 @@ times.
 .RE
 .TP
 
-\fBsubvolume delete\fR\fI <subvolume> \fP[\fI<subvolume>...\fP]\fR
+\fBsubvolume delete\fR [-R] \fI <subvolume> \fP[\fI<subvolume>...\fP]\fR
 Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
 subvolume, \fBbtrfs\fR returns an error.
+If \fI-R\fR is given, the subvolumes were removed recursively (otherwise it is
+not possible to remove a subvolume with a nested one); the -R switch requires
+the root capability.
 .TP
 
 \fBsubvolume list\fR [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fR
-- 
1.8.4.3

