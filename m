Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab2JIQ17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 12:27:59 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 02D55A3DDD
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2012 18:27:59 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs-progs: update man pages of subvol list
Date: Tue,  9 Oct 2012 18:27:55 +0200
Message-Id: <1349800075-4888-4-git-send-email-dsterba@suse.cz>
In-Reply-To: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
References: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- rename to match code where applicable
- add missing
- unify the help strings in short and detailed sections
- fix a few typos

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 man/btrfs.8.in |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..4044b08 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-acgprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -108,7 +108,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-aprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
+\fBsubvolume list\fR\fI [-acgprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fR
 .RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -117,7 +117,7 @@ where path is the relative path of the subvolume to the \fItop level\fR
 subvolume.
 
 The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
-at mount time via the \fIsubvol=\fR option.
+at mount time via the \fIsubvolid=\fR option.
 If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
 and top level. The parent's ID may be used at mount time via the
 \fIsubvolrootid=\fR option.
@@ -126,22 +126,28 @@ and top level. The parent's ID may be used at mount time via the
 
 \fB-a\fP print all the subvolumes in the filesystem.
 
-\fB-r\fP only readonly subvolumes in the filesystem wille be listed.
+\fB-c\fP print the ogeneration of the subvolume
 
-\fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
+\fB-g\fP print the ogeneration of the subvolume
 
-\fB-g [+|-]value\fP
+\fB-u\fP print the UUID of the subvolume
+
+\fB-r\fP only readonly subvolumes in the filesystem will be listed.
+
+\fB-s\fP only snapshot subvolumes in the filesystem will be listed.
+
+\fB-G [+|-]value\fP
 list subvolumes in the filesystem that its generation is
 >=, <= or = value. '+' means >= value, '-' means <= value, If there is
 neither '+' nor '-', it means = value.
 
-\fB-c [+|-]value\fP
+\fB-C [+|-]value\fP
 list subvolumes in the filesystem that its ogeneration is
 >=, <= or = value. The usage is the same to '-g' option.
 
-\fB--sort=gen,ogen,path,rootid\fP
+\fB--sort=rootid,gen,ogen,path\fP
 list subvolumes in order by specified items.
-you can add '+' or '-' in front of each items, '+' means ascending,'-'
+you can add '+' or '-' in front of each items, '+' means ascending, '-'
 means descending. The default is ascending.
 
 for \fB--sort\fP you can combine some items together by ',', just like
-- 
1.7.6.233.gd79bc

