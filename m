Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58991 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508Ab3DTCLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 22:11:35 -0400
Received: by mail-ob0-f173.google.com with SMTP id wn14so4089815obc.32
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 19:11:34 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Fri, 19 Apr 2013 21:11:14 -0500
Message-ID: <CAKuK5J3LnB41=qKdDFrpQ2jPU+=fE2jPT-Da+NP3iBy8Xx8hmQ@mail.gmail.com>
Subject: minor patch to cmds-restore.c
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following is a minor patch to cmds-restore.c


diff --git a/cmds-restore.c b/cmds-restore.c
index c75e187..273c813 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -917,14 +917,16 @@ out:
 }

 const char * const cmd_restore_usage[] = {
-       "btrfs restore [options] <device>",
+       "btrfs restore [options] <device> [destination]",
        "Try to restore files from a damaged filesystem (unmounted)",
        "",
+       "-l              list roots",
        "-s              get snapshots",
        "-v              verbose",
        "-i              ignore errors",
        "-o              overwrite",
-       "-t              tree location",
+       "-r <rootid>     root location",
+       "-t <treeid>     tree location",
        "-f <offset>     filesystem location",
        "-u <block>      super mirror",
        "-d              find dir",


--
Jon
Software Blacksmith
