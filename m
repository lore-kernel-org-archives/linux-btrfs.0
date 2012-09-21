Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35279 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2IUGve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 02:51:34 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8L6pWsu007197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:51:33 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8L6pW7w024415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:51:32 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8L6pW9H028525
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 01:51:32 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: btrfs subvolume delete could delete subvolumes
Date: Fri, 21 Sep 2012 14:54:08 +0800
Message-Id: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

With this user will be able to provide more than one subvolume
to delete.
eg: btrfs subvolume delete <subvol1> <subvol2>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   36 ++++++++++++++++++++++++------------
 man/btrfs.8.in   |    4 ++--
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f4aa80f..cfeaa8d 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -188,31 +188,34 @@ int test_issubvolume(char *path)
 }
 
 static const char * const cmd_subvol_delete_usage[] = {
-	"btrfs subvolume delete <name>",
-	"Delete a subvolume",
+	"btrfs subvolume delete <subvolume> [<subvolume>...]",
+	"Delete subvolume(s)",
 	NULL
 };
 
 static int cmd_subvol_delete(int argc, char **argv)
 {
-	int	res, fd, len, e;
+	int	res, fd, len, e, cnt = 1, ret = 0;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*path;
 
-	if (check_argc_exact(argc, 2))
+	if (argc < 2)
 		usage(cmd_subvol_delete_usage);
 
-	path = argv[1];
+again:
+	path = argv[cnt];
 
 	res = test_issubvolume(path);
 	if(res<0){
 		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
-		return 12;
+		ret = 12;
+		goto out;
 	}
 	if(!res){
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
-		return 13;
+		ret = 13;
+		goto out;
 	}
 
 	cpath = realpath(path, 0);
@@ -226,21 +229,24 @@ static int cmd_subvol_delete(int argc, char **argv)
 	     strchr(vname, '/') ){
 		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
 			vname);
-		return 14;
+		ret = 14;
+		goto out;
 	}
 
 	len = strlen(vname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
 			vname);
-		return 14;
+		ret = 14;
+		goto out;
 	}
 
 	fd = open_file_or_dir(dname);
 	if (fd < 0) {
 		close(fd);
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
-		return 12;
+		ret = 12;
+		goto out;
 	}
 
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
@@ -254,10 +260,16 @@ static int cmd_subvol_delete(int argc, char **argv)
 	if(res < 0 ){
 		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
 			dname, vname, strerror(e));
-		return 11;
+		ret = 11;
+		goto out;
 	}
 
-	return 0;
+out:
+	cnt++;
+	if (cnt < argc)
+		goto again;
+
+	return ret;
 }
 
 static const char * const cmd_subvol_list_usage[] = {
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..a1f172e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -7,7 +7,7 @@ btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
 \fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
+\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume> [<subvolume>...]\fP
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
@@ -98,7 +98,7 @@ subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
 will be readonly.
 .TP
 
-\fBsubvolume delete\fR\fI <subvolume>\fR
+\fBsubvolume delete\fR\fI <subvolume> [<subvolume>...]\fR
 Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
 subvolume, \fBbtrfs\fR returns an error.
 .TP
-- 
1.7.1

