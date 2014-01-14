Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60748 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaANVo2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:44:28 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so214816pab.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 13:44:28 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitchel Humpherys <mitch.special@gmail.com>
Subject: [PATCH] btrfs-progs: fix minor grammar issues
Date: Tue, 14 Jan 2014 13:44:03 -0800
Message-Id: <1389735843-11685-2-git-send-email-mitch.special@gmail.com>
In-Reply-To: <1389735843-11685-1-git-send-email-mitch.special@gmail.com>
References: <1389735843-11685-1-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove the extraneous `to' from `Can't access to X'.

Signed-off-by: Mitchel Humpherys <mitch.special@gmail.com>
---
 cmds-balance.c    | 10 +++++-----
 cmds-device.c     |  4 ++--
 cmds-filesystem.c |  6 +++---
 cmds-scrub.c      |  2 +-
 cmds-subvolume.c  | 10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index a151475..8a743ec 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -298,7 +298,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
@@ -497,7 +497,7 @@ static int cmd_balance_pause(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
@@ -538,7 +538,7 @@ static int cmd_balance_cancel(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
@@ -580,7 +580,7 @@ static int cmd_balance_resume(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
@@ -673,7 +673,7 @@ static int cmd_balance_status(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 2;
 	}
 
diff --git a/cmds-device.c b/cmds-device.c
index bc4a8dc..1717294 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -85,7 +85,7 @@ static int cmd_add_dev(int argc, char **argv)
 
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
 		return 1;
 	}
 
@@ -153,7 +153,7 @@ static int cmd_rm_dev(int argc, char **argv)
 
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
 		return 1;
 	}
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1926b..8c5c37f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static int cmd_df(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 	ret = get_df(fd, &sargs);
@@ -579,7 +579,7 @@ static int cmd_sync(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
@@ -840,7 +840,7 @@ static int cmd_resize(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 605af45..d9e47c1 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1643,7 +1643,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f57694a..2645c85 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -142,7 +142,7 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	fddst = open_file_or_dir(dstdir, &dirstream);
 	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
 		goto out;
 	}
 
@@ -266,7 +266,7 @@ again:
 
 	fd = open_file_or_dir(dname, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
+		fprintf(stderr, "ERROR: can't access '%s'\n", dname);
 		ret = 1;
 		goto out;
 	}
@@ -611,13 +611,13 @@ static int cmd_snapshot(int argc, char **argv)
 
 	fddst = open_file_or_dir(dstdir, &dirstream1);
 	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
 		goto out;
 	}
 
 	fd = open_file_or_dir(subvol, &dirstream2);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
 		goto out;
 	}
 
@@ -751,7 +751,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 1;
 	}
 
-- 
Mitch
