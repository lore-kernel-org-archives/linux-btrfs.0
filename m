Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36249 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbcCUMXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 08:23:17 -0400
Received: by mail-qg0-f50.google.com with SMTP id u110so150197977qge.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 05:23:17 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH] btrfs-progs: fix fi du so it works in more cases
Date: Mon, 21 Mar 2016 08:23:11 -0400
Message-Id: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrfs fi du uses open_file_or_dir(), which tries to open
it's argument with o_RDWR.  Because of POSIX semantics, this fails for
non-root users when the file is read-only or is an executable that
is being run currently, or for all users (including root) when the
filesystem is read-only.  THis results in a somewhat confusing 'Unknown
error -1' message when trying to check such files.  Switch to using
open_file_or_dir3() with O_RDONLY passed in the flags, as this avoids
the limitations listed above, and we have no need to write to the files
anyway (and thus shouldn't be opening them writable).

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
Build and runtime tested on x86-64 with glibc.

I intend to take the time at some point this week to audit all users of
open_file_or_dir() and similarly change any that don't need to write
to what they're opening, possibly adding a helper function to do a
read-only open.

 cmds-fi-du.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 2ffd917..168fc72 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -438,7 +438,7 @@ static int du_add_file(const char *filename, int dirfd,
 		ret = sprintf(pathp, "/%s", filename);
 	pathp += ret;
 
-	fd = open_file_or_dir(path, &dirstream);
+	fd = open_file_or_dir3(path, &dirstream, O_RDONLY);
 	if (fd < 0) {
 		ret = fd;
 		goto out;
-- 
2.7.4

