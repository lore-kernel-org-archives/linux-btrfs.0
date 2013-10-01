Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:43641 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3JAPcM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 11:32:12 -0400
Received: by mail-qc0-f176.google.com with SMTP id t7so4772775qcv.21
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 08:32:12 -0700 (PDT)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Update manpages for btrfs defrag -r
Date: Tue,  1 Oct 2013 11:31:47 -0400
Message-Id: <672d93b5f17a7cbfe9a6fd0940e1ae9599cd1ce0.1380640915.git.fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the -r option to the manpages for btrfs defragment

Signed-off-by: Frank Holton <fholton@gmail.com>
---
 man/btrfs.8.in |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index b6a7edd..8a0a05d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -273,8 +273,9 @@ Force a sync for the filesystem identified by \fI<path>\fR.
 .TP
 
 \fBfilesystem defragment\fP [\fIoptions\fP] \fI<file>\fP|\fI<dir>\fP [\fI<file>\fP|\fI<dir>...\fP]\fP
-Defragment file data and/or directory metadata. To defragment all files in a
-directory you have to specify each one on its own or use your shell wildcards.
+Defragment file data and/or directory metadata. If \fB-r\fP is passed, 
+files in \fIdir\fR will be defragmented recursively.
+
 
 The start position and the number of bytes to defragment can be specified by
 \fIstart\fR and \fIlen\fR. Any extent bigger than threshold will be
@@ -288,6 +289,8 @@ defragment operations.
 be verbose
 .IP "\fB-c\fP" 5
 compress file contents while defragmenting
+.IP "\fB-r\fP" 5
+defragment files recursively
 .IP "\fB-f\fP" 5
 flush filesystem after defragmenting
 .IP "\fB-s \fIstart\fP\fP" 5
-- 
1.7.9.5

