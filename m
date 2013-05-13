Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59012 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3EMPYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:24:08 -0400
Received: by mail-pd0-f169.google.com with SMTP id bv13so4501071pdb.28
        for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 08:24:08 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] btrfs-progs: update manpage to add filesystem show command in synopsis
Date: Mon, 13 May 2013 23:23:39 +0800
Message-Id: <1368458619-5308-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

filesystem show was missing in SYNOPSIS section.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 man/btrfs.8.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..6603cad 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,6 +31,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
-- 
1.8.1

