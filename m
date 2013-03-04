Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:8527 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932564Ab3CDVkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/14] btrfs-progs: tidy up cmd_snapshot() whitespace & returns
Date: Mon,  4 Mar 2013 16:39:57 -0600
Message-Id: <1362436804-16766-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just whitespace fixes, and magical return value removal.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a13a58d..a4d88a1 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -533,57 +533,57 @@ static int cmd_snapshot(int argc, char **argv)
 	dst = argv[optind + 1];
 
 	res = test_issubvolume(subvol);
-	if(res<0){
+	if (res < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		return 12;
+		return 1;
 	}
-	if(!res){
+	if (!res) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		return 13;
+		return 1;
 	}
 
 	res = test_isdir(dst);
-	if(res == 0 ){
+	if (res == 0) {
 		fprintf(stderr, "ERROR: '%s' exists and it is not a directory\n", dst);
-		return 12;
+		return 1;
 	}
 
-	if(res>0){
+	if (res > 0) {
 		newname = strdup(subvol);
 		newname = basename(newname);
 		dstdir = dst;
-	}else{
+	} else {
 		newname = strdup(dst);
 		newname = basename(newname);
 		dstdir = strdup(dst);
 		dstdir = dirname(dstdir);
 	}
 
-	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
+	if (!strcmp(newname,".") || !strcmp(newname,"..") ||
 	     strchr(newname, '/') ){
 		fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
 			newname);
-		return 14;
+		return 1;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
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
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
 		close(fddst);
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
-		return 12;
+		return 1;
 	}
 
 	if (readonly) {
@@ -609,10 +609,10 @@ static int cmd_snapshot(int argc, char **argv)
 	close(fddst);
 	free(inherit);
 
-	if(res < 0 ){
+	if (res < 0) {
 		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
 			subvol, strerror(e));
-		return 11;
+		return 1;
 	}
 
 	return 0;
-- 
1.7.1

