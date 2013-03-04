Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:3573 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932566Ab3CDVkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/14] btrfs-progs: tidy up cmd_subvol_create() whitespace & returns
Date: Mon,  4 Mar 2013 16:39:59 -0600
Message-Id: <1362436804-16766-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just whitespace fixes, and magical return value removal.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 96f7cbd..b7777ee 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -104,9 +104,9 @@ static int cmd_subvol_create(int argc, char **argv)
 	dst = argv[optind];
 
 	res = test_isdir(dst);
-	if(res >= 0 ){
+	if (res >= 0) {
 		fprintf(stderr, "ERROR: '%s' exists\n", dst);
-		return 12;
+		return 1;
 	}
 
 	newname = strdup(dst);
@@ -114,24 +114,24 @@ static int cmd_subvol_create(int argc, char **argv)
 	dstdir = strdup(dst);
 	dstdir = dirname(dstdir);
 
-	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
+	if (!strcmp(newname,".") || !strcmp(newname,"..") ||
 	     strchr(newname, '/') ){
 		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
 			newname);
-		return 14;
+		return 1;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
 			newname);
-		return 14;
+		return 1;
 	}
 
 	fddst = open_file_or_dir(dstdir);
 	if (fddst < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
-		return 12;
+		return 1;
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
@@ -159,10 +159,10 @@ static int cmd_subvol_create(int argc, char **argv)
 	close(fddst);
 	free(inherit);
 
-	if(res < 0 ){
-		fprintf( stderr, "ERROR: cannot create subvolume - %s\n",
+	if (res < 0) {
+		fprintf(stderr, "ERROR: cannot create subvolume - %s\n",
 			strerror(e));
-		return 11;
+		return 1;
 	}
 
 	return 0;
-- 
1.7.1

