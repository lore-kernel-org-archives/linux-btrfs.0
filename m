Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:43845 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161962AbeBOTFv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:51 -0500
Received: by mail-pl0-f65.google.com with SMTP id f4so343073plr.10
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:51 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 21/27] btrfs-progs: use libbtrfsutil for subvol delete
Date: Thu, 15 Feb 2018 11:05:06 -0800
Message-Id: <849123d7f52564b88cafe1582cdd227a4e18e3a7.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Most of the interesting part of this command is the commit mode, so this
only saves a little bit of code.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ea436ba0..68768914 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -225,7 +225,6 @@ static int cmd_subvol_delete(int argc, char **argv)
 	int res, ret = 0;
 	int cnt;
 	int fd = -1;
-	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*dupdname = NULL;
 	char	*dupvname = NULL;
@@ -237,6 +236,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = { NULL, };
 	enum { COMMIT_AFTER = 1, COMMIT_EACH = 2 };
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c;
@@ -280,14 +280,9 @@ static int cmd_subvol_delete(int argc, char **argv)
 again:
 	path = argv[cnt];
 
-	res = test_issubvolume(path);
-	if (res < 0) {
-		error("cannot access subvolume %s: %s", path, strerror(-res));
-		ret = 1;
-		goto out;
-	}
-	if (!res) {
-		error("not a subvolume: %s", path);
+	err = btrfs_util_is_subvolume(path);
+	if (err) {
+		error_btrfs_util(err);
 		ret = 1;
 		goto out;
 	}
@@ -313,11 +308,10 @@ again:
 	printf("Delete subvolume (%s): '%s/%s'\n",
 		commit_mode == COMMIT_EACH || (commit_mode == COMMIT_AFTER && cnt + 1 == argc)
 		? "commit" : "no-commit", dname, vname);
-	memset(&args, 0, sizeof(args));
-	strncpy_null(args.name, vname);
-	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
-	if(res < 0 ){
-		error("cannot delete '%s/%s': %m", dname, vname);
+
+	err = btrfs_util_delete_subvolume_fd(fd, vname, 0);
+	if (err) {
+		error_btrfs_util(err);
 		ret = 1;
 		goto out;
 	}
-- 
2.16.1

