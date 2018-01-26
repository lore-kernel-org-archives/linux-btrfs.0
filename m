Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33393 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbeAZSlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:42 -0500
Received: by mail-pg0-f66.google.com with SMTP id u1so794225pgr.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:42 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 20/26] btrfs-progs: use libbtrfsutil for subvol delete
Date: Fri, 26 Jan 2018 10:41:08 -0800
Message-Id: <e51b29c36055bcbbe2b9c8215135290d6a0c48e6.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Most of the interesting part of this command is the commit mode, so this
only saves a little bit of code.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 6b474fe4..c5e03011 100644
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
@@ -314,12 +309,10 @@ again:
 	printf("Delete subvolume (%s): '%s/%s'\n",
 		commit_mode == COMMIT_EACH || (commit_mode == COMMIT_AFTER && cnt + 1 == argc)
 		? "commit" : "no-commit", dname, vname);
-	memset(&args, 0, sizeof(args));
-	strncpy_null(args.name, vname);
-	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
-	if(res < 0 ){
-		error("cannot delete '%s/%s': %s", dname, vname,
-			strerror(errno));
+
+	err = btrfs_util_f_delete_subvolume(fd, vname, 0);
+	if (err) {
+		error_btrfs_util(err);
 		ret = 1;
 		goto out;
 	}
-- 
2.16.1

