Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab3LPPrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:47:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4AD3AABC7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 15:47:11 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: update send help strings and manpage
Date: Mon, 16 Dec 2013 16:47:10 +0100
Message-Id: <1387208830-10879-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- send accepts multiple subvolumes
- add missing option -e to man
- minor man formating fix

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-send.c    |  6 +++---
 man/btrfs.8.in | 14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 85461d5b0283..fc9a01ee8892 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -728,9 +728,9 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol>",
-	"Send the subvolume to stdout.",
-	"Sends the subvolume specified by <subvol> to stdout.",
+	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"Send the subvolume(s) to stdout.",
+	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
 	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
 	"any additional local snapshots, use '-c <clone-src>' (multiple times",
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d5515e0af977..72c04df648fa 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -85,7 +85,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal rootid\fP \fI<path>\fP
 .PP
 .PP
-\fBbtrfs\fP \fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
+\fBbtrfs\fP \fBsend\fP [-ve] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP [\fI<subvol>\fP...]
 .PP
 \fBbtrfs\fP \fBreceive\fP [-ve] [-f \fI<infile>\fP] \fI<mount>\fP
 .PP
@@ -610,16 +610,16 @@ subvolume return it's own tree id.
 The result is undefined for the so-called empty subvolumes (identified by inode number 2).
 .TP
 
-\fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
-Send the subvolume to stdout.
-Sends the subvolume specified by \fI<subvol>\fR to stdout.
+\fBsend\fP [-ve] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP [\fI<subvol>...\fP]
+Send the subvolume(s) to stdout.
+Sends the subvolume(s) specified by \fI<subvol>\fR to stdout.
 By default, this will send the whole subvolume. To do an incremental
 send, use '\fI-p <parent>\fR'. If you want to allow btrfs to clone from
 any additional local snapshots, use '\fI-c <clone-src>\fR' (multiple times
 where applicable). You must not specify clone sources unless you
 guarantee that these snapshots are exactly in the same state on both
-sides, the sender and the receiver. It is allowed to omit the
-'\fI-p <parent>\fR' option when '\fI-c <clone-src>\fR' options are given, in
+sides, the sender and the receiver. It is allowed to omit the '\fI-p <parent>\fR'
+option when '\fI-c <clone-src>\fR' options are given, in
 which case '\fBbtrfs send\fP' will determine a suitable parent among the
 clone sources itself.
 .RS
@@ -628,6 +628,8 @@ clone sources itself.
 .IP "\fB-v\fP" 5
 Enable verbose debug output. Each occurrence of this option increases the
 verbose level more.
+.IP "\fB-e\fP" 5
+If sending multiple subvols at once, use the new format and omit the <end cmd> between the subvols.
 .IP "\fB-p \fI<parent>\fP" 5
 Send an incremental stream from \fI<parent>\fR to \fI<subvol>\fR.
 .IP "\fB-c \fI<clone-src>\fP" 5
-- 
1.8.5

