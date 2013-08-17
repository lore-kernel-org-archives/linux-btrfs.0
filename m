Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47152 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3HQNQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 09:16:10 -0400
Received: by mail-wi0-f175.google.com with SMTP id hq12so1724276wib.8
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 06:16:08 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: add restore command's -x flag to man page
Date: Sat, 17 Aug 2013 14:16:02 +0100
Message-Id: <1376745362-10604-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a recent flag added to the restore command that allows
to restore xattrs. It was missing in the man page.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

NOTE: this patch is based on top of David Sterba's integration
      branch integration-20130810.

 man/btrfs.8.in |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d493d7e..1993af5 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -521,6 +521,8 @@ Try to restore files from a damaged filesystem(unmounted).
 \fIOptions\fR
 .IP "\fB-s\fP" 5
 get snapshots.
+.IP "\fB-x\fP" 5
+get extended attributes.
 .IP "\fB-v\fP" 5
 verbose.
 .IP "\fB-i\fP" 5
-- 
1.7.9.5

