Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:13282 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932569Ab3CDVkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/14] btrfs-progs: Free resources when returning error from cmd_subvol_create()
Date: Mon,  4 Mar 2013 16:40:00 -0600
Message-Id: <1362436804-16766-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmd_subvol_create() currently returns without freeing resources
in almost every error case.  Switch to a goto arrangement
so all cleanup can be done in one place.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b7777ee..bfea0d9 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -70,7 +70,8 @@ static const char * const cmd_subvol_create_usage[] = {
 
 static int cmd_subvol_create(int argc, char **argv)
 {
-	int	res, fddst, len, e;
+	int	retval, res, len;
+	int	fddst = -1;
 	char	*newname;
 	char	*dstdir;
 	char	*dst;
@@ -103,10 +104,11 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	dst = argv[optind];
 
+	retval = 1;	/* failure */
 	res = test_isdir(dst);
 	if (res >= 0) {
 		fprintf(stderr, "ERROR: '%s' exists\n", dst);
-		return 1;
+		goto out;
 	}
 
 	newname = strdup(dst);
@@ -118,20 +120,20 @@ static int cmd_subvol_create(int argc, char **argv)
 	     strchr(newname, '/') ){
 		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
 			newname);
-		return 1;
+		goto out;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
 			newname);
-		return 1;
+		goto out;
 	}
 
 	fddst = open_file_or_dir(dstdir);
 	if (fddst < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
-		return 1;
+		goto out;
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
@@ -154,18 +156,19 @@ static int cmd_subvol_create(int argc, char **argv)
 		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
 	}
 
-	e = errno;
-
-	close(fddst);
-	free(inherit);
-
 	if (res < 0) {
 		fprintf(stderr, "ERROR: cannot create subvolume - %s\n",
-			strerror(e));
-		return 1;
+			strerror(errno));
+		goto out;
 	}
 
-	return 0;
+	retval = 0;	/* success */
+out:
+	if (fddst != -1)
+		close(fddst);
+	free(inherit);
+
+	return retval;
 }
 
 /*
-- 
1.7.1

