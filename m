Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35495 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbcCROEH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 10:04:07 -0400
Received: by mail-qk0-f195.google.com with SMTP id s5so3716391qkd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 07:04:06 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH v2] btrfs-progs: add stat check in open_ctree_fs_info
Date: Fri, 18 Mar 2016 10:03:42 -0400
Message-Id: <1458309822-5550-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, open_ctree_fs_info will open whatever path you pass it and try
to interpret it as a BTRFS filesystem.  While this is not nessecarily
dangerous (except possibly if done on a character device), it does
result in some rather cryptic and non-sensical error messages when
trying to run certain commands in ways they weren't intended to be run.
Add a check using stat(2) to verify that the path we've been passed is
in fact a regular file or a block device, or a symlink pointing to a
regular file or block device.

This causes the following commands to provide a helpful error message
when run on a FIFO, directory, character device, or socket:
    * btrfs check
    * btrfs restore
    * btrfs-image
    * btrfs-find-root
    * btrfs inspect-internal dump-tree

stat(2) is used instead of lstat(2), as stat(2) follows symlinks just
like open(2) does, which means we check the same inode that open(2)
opens, and thus don't need special handling for symlinks.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---

Changes from v1:
    * Updated commit message to use the new name for btrfs-debug-tree
    * Added a bit of clarity to the commit message to explain that stat(2)
      follows symlinks just like open(2) does, so we don't need special
      handling for symlinks..
    * Added the btrfs-progs developers to the recipient list, because
      I somehow forgot to add them on the first version.

This has been both build and runtime tested on an x86-64 system with
glibc.  It has been build but not runtime tested with uClibc on x86-64
and ARMv7.  It has not been tested on Android or with musl, although it
should work there also.

There are other tools that have similarly poor error behavior when
called incorrectly (btrfs rescue immediately comes to mind), but they
don't use open_ctree_fs_info, so this doesn't affect them.  I may do
followup patches to fix those too if I have the time.

open_ctree_fs_info is also used in cmds-filesystem.c, although I'm not
at all sure what exactly is going on there, and btrfs filesystem appears
from my testing to behave exactly the same with this change, so I don't
think this will have any effect on any of the btrfs filesystem commands.

Whitelisting is used instead of blacklisting because I feel it provides
a more concise and more easily readable conditional, and because I
think it's a lot less likely that a new file type will be added that
can contain a filesystem image than it is that one will be added which
can't contain a filesystem image (it's more likely that Solaris doors
get ported to Linux than that we get some new file type).

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

