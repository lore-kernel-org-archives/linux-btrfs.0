Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:59987 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3GIUbo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 16:31:44 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so5078700wes.40
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 13:31:43 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: update usage message for cmds-restore
Date: Tue,  9 Jul 2013 21:31:37 +0100
Message-Id: <1373401897-31850-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mention that a target path argument is mandatory unless
the -l option is supplied. Also mention about the existence
of the -l option, which was previously not announced.

$ btrfs restore -v /dev/sdb3
usage: btrfs restore [options] <device>

    Try to restore files from a damaged filesystem (unmounted)

    -s              get snapshots
    -v              verbose
    -i              ignore errors
    -o              overwrite
    -t              tree location
    -f <offset>     filesystem location
    -u <block>      super mirror
    -d              find dir
$ echo $?
129

After specifying a target path, the command works as expected:

$ btrfs restore -v /dev/sdb3 files2/
Restoring files2/file1
Done searching
$ echo $?
0

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index eca528d..70ebb9f 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -956,7 +956,7 @@ out:
 }
 
 const char * const cmd_restore_usage[] = {
-	"btrfs restore [options] <device>",
+	"btrfs restore [options] <device> <path> | btrfs restore -l <device>",
 	"Try to restore files from a damaged filesystem (unmounted)",
 	"",
 	"-s              get snapshots",
@@ -967,6 +967,7 @@ const char * const cmd_restore_usage[] = {
 	"-f <offset>     filesystem location",
 	"-u <block>      super mirror",
 	"-d              find dir",
+	"-l              list roots",
 	NULL
 };
 
-- 
1.7.9.5

