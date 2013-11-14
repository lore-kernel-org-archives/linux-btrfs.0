Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3KNNk6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 08:40:58 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5FE7BA7B63
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 14:40:57 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: man: add rescue super-recover bits
Date: Thu, 14 Nov 2013 14:40:43 +0100
Message-Id: <1384436443-9672-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 man/btrfs.8.in | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 6cb3662e28bb..b6203483296e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -71,6 +71,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBrescue chunk-recover\fP [\fIoptions\fP] \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBrescue super-recover\fP [\fIoptions\fP] \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP
 .PP
 .PP
@@ -525,6 +527,18 @@ help.
 .RE
 .TP
 
+\fBrescue super-recover\fR [\fIoptions\fP] <device>\fR
+Recover bad superblocks from good copies.
+.RS
+
+\fIOptions\fR
+.IP "\fB-y\fP" 5
+assume an answer of 'yes' to all questions.
+.IP "\fB-v\fP" 5
+verbose mode.
+.RE
+.TP
+
 \fBrestore\fR [\fIoptions\fP] <device>\fR
 Try to restore files from a damaged filesystem(unmounted).
 .RS
-- 
1.8.4.2

