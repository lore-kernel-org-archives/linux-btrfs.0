Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:17714 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754746Ab3CKWN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:13:29 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] btrfs-progs: don't open-code mountpoint discovery in scrub cancel
Date: Mon, 11 Mar 2013 18:13:00 -0500
Message-Id: <1363043581-15812-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmd_scrub_cancel had its own mountpoint discovery routine;
just use open_path_or_dev_mnt() for that now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-scrub.c |   53 +++++++++++++++++------------------------------------
 1 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index b0fcde6..e5fccc7 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1459,56 +1459,37 @@ static int cmd_scrub_cancel(int argc, char **argv)
 {
 	char *path;
 	int ret;
-	int fdmnt;
-	int err;
-	char mp[BTRFS_PATH_NAME_MAX + 1];
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
+	int fdmnt = -1;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_scrub_cancel_usage);
 
 	path = argv[1];
 
-again:
-	fdmnt = open_file_or_dir(path);
-	if (fdmnt < 0) {
-		perror("ERROR: scrub cancel failed:");
-		return 1;
-	}
+	fdmnt = open_path_or_dev_mnt(path);
+ 	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: could not open %s: %s\n",
+			path, strerror(errno));
+		ret = 1;
+		goto out;
+ 	}
 
 	ret = ioctl(fdmnt, BTRFS_IOC_SCRUB_CANCEL, NULL);
-	err = errno;
-
-	if (ret && err == EINVAL) {
-		/* path is not a btrfs mount point.  See if it's a device. */
-		ret = check_mounted_where(fdmnt, path, mp, sizeof(mp),
-					  &fs_devices_mnt);
-		if (ret > 0) {
-			/* It's a mounted btrfs device; retry w/ mountpoint. */
-			close(fdmnt);
-			path = mp;
-			goto again;
-		} else {
-			/* It's not a mounted btrfs device either */
-			fprintf(stderr,
-				"ERROR: %s is not a mounted btrfs device\n",
-				path);
-			ret = 1;
-			err = EINVAL;
-		}
-	}
 
-	close(fdmnt);
-
-	if (ret) {
+	if (ret < 0) {
 		fprintf(stderr, "ERROR: scrub cancel failed on %s: %s\n", path,
-			err == ENOTCONN ? "not running" : strerror(err));
-		return 1;
+			errno == ENOTCONN ? "not running" : strerror(errno));
+		ret = 1;
+		goto out;
 	}
 
+	ret = 0;
 	printf("scrub cancelled\n");
 
-	return 0;
+out:
+	if (fdmnt != -1)
+		close(fdmnt);
+	return ret;
 }
 
 static const char * const cmd_scrub_resume_usage[] = {
-- 
1.7.1

