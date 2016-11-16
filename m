Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:34453 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbcKPUym (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 15:54:42 -0500
Received: by mail-pg0-f52.google.com with SMTP id x23so80124536pgx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 12:54:41 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] btrfs-progs: check: fix missing newlines
Date: Wed, 16 Nov 2016 12:54:32 -0800
Message-Id: <93c639e51b05a52d8cab650f0c8eb3d5fd0ef5bc.1479328997.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Also, the other progress messages go to stderr, so "checking extents"
probably should, as well.

Fixes: c7a1f66a205f ("btrfs-progs: check: switch some messages to common helpers")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
As a side note, it seems almost completely random whether we print to
stdout or stderr for any given message. That could probably use some
cleaning up for consistency. A quick run of e2fsck indicated that it
prints almost everything on stdout except for usage and administrative
problems. xfs_repair just seems to put everything in stderr. I
personally like the e2fsck approach. Anyone have any preference?

 cmds-check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 57c4300..3fb3bd7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11467,13 +11467,13 @@ int cmd_check(int argc, char **argv)
 	}
 
 	if (!ctx.progress_enabled)
-		printf("checking extents");
+		fprintf(stderr, "checking extents\n");
 	if (check_mode == CHECK_MODE_LOWMEM)
 		ret = check_chunks_and_extents_v2(root);
 	else
 		ret = check_chunks_and_extents(root);
 	if (ret)
-		printf("Errors found in extent allocation tree or chunk allocation");
+		error("errors found in extent allocation tree or chunk allocation");
 
 	ret = repair_root_items(info);
 	if (ret < 0)
-- 
2.10.2

