Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:39448 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdISHmF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 03:42:05 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 71902AC009E
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 16:41:56 +0900 (JST)
Received: from G01JPEXCHYT18.g01.fujitsu.local (G01JPEXCHYT18.g01.fujitsu.local [10.128.194.57])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id C4E0D46E474
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 16:41:55 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: subvolume: outputs message only when operation
 succeeds
Message-ID: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
Date: Tue, 19 Sep 2017 16:41:52 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs subvolume create/delete" outputs the message of "Create/Delete
subvolume ..." even when an operation fails.
Since it is confusing, let's outputs the message only when an operation succeeds.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-subvolume.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 666f6e0..6d4b0fe 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -189,7 +189,6 @@ static int cmd_subvol_create(int argc, char **argv)
 	if (fddst < 0)
 		goto out;
 
-	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	if (inherit) {
 		struct btrfs_ioctl_vol_args_v2	args;
 
@@ -213,6 +212,7 @@ static int cmd_subvol_create(int argc, char **argv)
 		error("cannot create subvolume: %s", strerror(errno));
 		goto out;
 	}
+	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 
 	retval = 0;	/* success */
 out:
@@ -337,9 +337,6 @@ again:
 		goto out;
 	}
 
-	printf("Delete subvolume (%s): '%s/%s'\n",
-		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
-		? "commit" : "no-commit", dname, vname);
 	memset(&args, 0, sizeof(args));
 	strncpy_null(args.name, vname);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
@@ -349,6 +346,9 @@ again:
 		ret = 1;
 		goto out;
 	}
+	printf("Delete subvolume (%s): '%s/%s'\n",
+		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
+		? "commit" : "no-commit", dname, vname);
 
 	if (commit_mode == 1) {
 		res = wait_for_commit(fd);
-- 
2.9.5

