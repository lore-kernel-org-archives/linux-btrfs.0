Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:35380 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935174AbcCPP0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 11:26:25 -0400
Received: by mail-qg0-f51.google.com with SMTP id y89so46212684qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 08:26:25 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH] btrfs-progs: add stat check in open_ctree_fs_info
Date: Wed, 16 Mar 2016 11:26:11 -0400
Message-Id: <1458141971-56355-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, open_ctree_fs_info will open whatever path you pass it and
try to interpret it as a BTRFS filesystem.  While this is not
nessecarily dangerous (except possibly if done on a character device),
it does result in some rather cryptic and non-sensical error messages
when trying to run certain commands in ways they weren't intended to be
run.  Add a check using stat(2) to verify that the path we've been
passed is in fact a regular file or a block device.

This causes the following commands to provide a helpful error message
when run on a FIFO, directory, character device, or socket:
    * btrfs check
    * btrfs restore
    * btrfs-image
    * btrfs-find-root
    * btrfs-debug-tree

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
This has been build and runtime tested on an x86-64 system with glibc.
It has been build tested on x86-64 with uclibc.
It has not been tested on Android or with musl, although it should work
there also.

There are other tools that have similarly bad behavior when called
incorrectly (btrfs rescue immediately comes to mind), but they don't
use open_ctree_fs_info, so this doesn't affect them.  I may do followup
patches to fix those too if I have the time.

open_ctree_fs_info is also used in cmds-filesystem.c, although I'm not
at all sure what exactly is going on there, and btrfs filesystem appears
from my testing to behave exactly the same with this change, so I don't
think this will have any effect on any of the btrfs filesystem commands.

 disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index e520d80..d35153d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1310,6 +1310,13 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 	int fp;
 	struct btrfs_fs_info *info;
 	int oflags = O_CREAT | O_RDWR;
+	struct stat sb;
+
+	stat(filename, &sb);
+	if (!(((sb.st_mode & S_IFMT) == S_IFREG) || ((sb.st_mode & S_IFMT) == S_IFBLK))) {
+		fprintf (stderr, "%s is not a regular file or block device\n", filename);
+		return NULL;
+	}
 
 	if (!(flags & OPEN_CTREE_WRITES))
 		oflags = O_RDONLY;
-- 
2.7.3

