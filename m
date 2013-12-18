Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3LRJ5R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 04:57:17 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, mwd@md5i.com, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH v2] Btrfs-progs: receive: fix the case that we can not find the subvolume
Date: Wed, 18 Dec 2013 17:56:33 +0800
Message-Id: <1387360593-8277-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we change our default subvolume, btrfs receive will fail to find
subvolume. To fix this problem, we have three ideas:

 1.make btrfs snapshot ioctl support passing source subvolume's objectid.
 2.when we want to using interval subvolume path, we mount it other place
 that use subvolume 5 as its default subvolume.
 3.tell the user to mount the toplevel subvol by himself and run
 receive

We's better use the third approach because first patch will bother kernel
change and the second approach is not very good for power users. So give this
option to users.

Reported-by: Michael Welsh Duggan <mwd@md5i.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog:
v1->v2:
	addressed david's comments and use the third approach to fix the problem
---
 cmds-receive.c | 11 +++++++++--
 man/btrfs.8.in | 15 ++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index ed44107..cce37a7 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -257,8 +257,15 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 			O_RDONLY | O_NOATIME);
 	if (args_v2.fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: open %s failed. %s\n",
-				parent_subvol->path, strerror(-ret));
+		if (errno != ENOENT)
+			fprintf(stderr, "ERROR: open %s failed. %s\n",
+					parent_subvol->path, strerror(-ret));
+		else
+			fprintf(stderr,
+				"It seems that you have changed your default "
+				"subvolume or you specify other subvolume to\n"
+				"mount btrfs, try to remount this btrfs filesystem "
+				"with fs tree, and run btrfs receive again!\n");
 		goto out;
 	}
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 901caa5..ece6a5a 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -668,11 +668,16 @@ Receive subvolumes from stdin.
 Receives one or more subvolumes that were previously
 sent with btrfs send. The received subvolumes are stored
 into \fI<mount>\fP.
-btrfs receive will fail in case a receiving subvolume
-already exists. It will also fail in case a previously
-received subvolume was changed after it was received.
-After receiving a subvolume, it is immediately set to
-read only.
+btrfs receive will fail with the following case:
+
+1.a receiving subvolume already exists.
+
+2.a previously received subvolume was changed after it was received.
+
+3.default subvolume is changed or you don't mount btrfs filesystem with
+fs tree.
+
+After receiving a subvolume, it is immediately set to read only.
 .RS
 
 \fIOptions\fR
-- 
1.8.3.1

