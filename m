Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36498 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932924AbdBVW6a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 17:58:30 -0500
Received: by mail-wr0-f194.google.com with SMTP id z61so2119266wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 14:56:41 -0800 (PST)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH 1/2] btrfs-progs: receive: better error reporting for snapshots
Date: Wed, 22 Feb 2017 23:56:36 +0100
Message-Id: <20170222225637.21858-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two fixes:

1)

Check that the parent subvol actually is reachable via our root path.
The previous code wouldn't catch

    parent subvol: foo/bar
    root path:     bar   (i.e. mounted with -o subvol=bar)

where the parent isn't reachable from the root path.
(but the original "strstr(parent, root_path) == NULL" check still doesn't hold)

Also check for the slash after "root_path", i.e. throw an error on

    parent subvol: foobar
    root path:     foo

2)

If the parent subvol is the one that is mounted we obviously can't
receive into it, as it has to be read-only by definition.

We'd get a rather cryptic:

    At subvol /tmp/test/dest.snap
    At snapshot dest.snap
    ERROR: creating snapshot / -> dest.snap failed: Invalid cross-device link

(not sure what it says if "/" isn't even a btrfs)

But with this we get

    At subvol /tmp/test/dest.snap
    At snapshot dest.snap
    ERROR: creating snapshot . -> dest.snap failed: Read-only file system

which is both more helpful and more correct.

Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>
---
 cmds-receive.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 166d37d..790218c 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -314,8 +314,8 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		sub_len = strlen(parent_subvol->path);
 
 		/* First make sure the parent subvol is actually in our path */
-		if (sub_len < root_len ||
-		    strstr(parent_subvol->path, rctx->full_root_path) == NULL) {
+		if (strstr(parent_subvol->path, rctx->full_root_path) != parent_subvol->path ||
+		    sub_len > root_len && parent_subvol->path[root_len] != '/') {
 			error(
 		"parent subvol is not reachable from inside the root subvol");
 			ret = -ENOENT;
@@ -323,7 +323,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		}
 
 		if (sub_len == root_len) {
-			parent_subvol->path[0] = '/';
+			parent_subvol->path[0] = '.';
 			parent_subvol->path[1] = '\0';
 		} else {
 			/*
-- 
2.11.1

